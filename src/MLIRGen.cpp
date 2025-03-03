//===- MLIRGen.cpp - MLIR Generation from a Toy AST -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a simple IR generation targeting MLIR from a Module AST
// for the Toy language.
//
//===----------------------------------------------------------------------===//

#include "AST.h"
#include "Lexer.h"
#include "MLIRGen.h"
#include "mlir/IR/Attributes.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Types.h"
#include "mlir/Support/LLVM.h"
#include "toy/Dialect.h"

#include "mlir/IR/Block.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Value.h"
#include "mlir/IR/Verifier.h"

#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/ScopedHashTable.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/LogicalResult.h"

#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <numeric>
#include <optional>
#include <utility>
#include <vector>

using namespace mlir::toy;
using namespace toy;

using llvm::ArrayRef;
using llvm::cast;
using llvm::dyn_cast;
using llvm::isa;
using llvm::ScopedHashTableScope;
using llvm::SmallVector;
using llvm::StringRef;
using llvm::Twine;

namespace {

/// Implementation of a simple MLIR emission from the Toy AST.
///
/// This will emit operations that are specific to the Toy language, preserving
/// the semantics of the language and (hopefully) allow to perform accurate
/// analysis and transformation based on these high level semantics.
class MLIRGenImpl {
public:
    MLIRGenImpl(mlir::MLIRContext& context) : builder(&context) {}

    /// Public API: convert the AST for a Toy module (source file) to an MLIR
    /// Module operation.
    mlir::ModuleOp mlirGen(ModuleAST& moduleAST) {
        // We create an empty MLIR module and codegen functions one at a time and
        // add them to the module.
        theModule = mlir::ModuleOp::create(builder.getUnknownLoc());

        for (auto& f : moduleAST) {
            if (auto function = llvm::dyn_cast<FunctionAST>(f.get())) {
                mlir::toy::FuncOp func = mlirGen(*function);
                if (!func)
                    return nullptr;
                functionMap.insert({ func.getName(), func });
            }
            else if (auto structDecl = llvm::dyn_cast<StructAST>(f.get())) {
                if (llvm::failed(mlirGen(*structDecl))) {
                    return nullptr;
                }
            }
            else {
                llvm_unreachable("unknown record type");
            }
        }

        // Verify the module after we have finished constructing it, this will check
        // the structural properties of the IR and invoke any specific verifiers we
        // have on the Toy operations.
        if (failed(mlir::verify(theModule))) {
            theModule.emitError("module verification error");
            return nullptr;
        }

        return theModule;
    }

private:
    /// A "module" matches a Toy source file: containing a list of functions.
    mlir::ModuleOp theModule;

    /// The builder is a helper class to create IR inside a function. The builder
    /// is stateful, in particular it keeps an "insertion point": this is where
    /// the next operations will be introduced.
    mlir::OpBuilder builder;

    /// The symbol table maps a variable name to a value in the current scope.
    /// Entering a function creates a new scope, and the function arguments are
    /// added to the mapping. When the processing of a function is terminated, the
    /// scope is destroyed and the mappings created in this scope are dropped.
    using SimbleTable_t =
        llvm::ScopedHashTable<StringRef, std::pair<VarDeclExprAST*, mlir::Value>>;
    using ScopedTable_t =
        ScopedHashTableScope<StringRef, std::pair<VarDeclExprAST*, mlir::Value>>;
    SimbleTable_t symbolTable;

    /// A mapping for the functions that have been code generated to MLIR.
    llvm::StringMap<mlir::toy::FuncOp> functionMap;

    /// A mapping for named struct types to the underlying MLIR type and the
    /// original AST node.
    llvm::StringMap<std::pair<mlir::Type, StructAST*>> structMap;

    /// Helper conversion for a Toy AST location to an MLIR location.
    mlir::Location loc(const Location& loc) {
        return mlir::FileLineColLoc::get(
            builder.getStringAttr(*loc.file), loc.line, loc.col);
    }

    /// Declare a variable in the current scope, return success if the variable
    /// wasn't declared yet.
    llvm::LogicalResult declare(VarDeclExprAST* type, mlir::Value value) {
        if (symbolTable.count(type->getName()))
            return mlir::failure();
        symbolTable.insert(type->getName(), { type, value });
        return mlir::success();
    }

    mlir::DenseElementsAttr getConstantAttr(LiteralExprAST& literalAST) {
        // The attribute is a vector with a floating point value per element
        // (number) in the array, see `collectData()` below for more details.
        std::vector<double> data;
        data.reserve(
            std::accumulate(
                literalAST.getDims().begin(), literalAST.getDims().end(), 1,
                std::multiplies<int>()));
        collectData(literalAST, data);

        // The type of this attribute is tensor of 64-bit floating-point with the
        // shape of the literal.
        mlir::Type elementType = builder.getF64Type();
        auto dataType = mlir::RankedTensorType::get(literalAST.getDims(), elementType);

        // This is the actual attribute that holds the list of values for this
        // tensor literal.
        return mlir::DenseElementsAttr::get(dataType, llvm::ArrayRef(data));
    }

    mlir::DenseElementsAttr getConstantAttr(NumberExprAST& numberAST) {
        mlir::Type elementType = builder.getF64Type();
        auto       dataType = mlir::RankedTensorType::get({}, elementType);

        return mlir::DenseElementsAttr::get(
            dataType, llvm::ArrayRef<double>(numberAST.getValue()));
    }

    // Emit a constant struct literal. It will emit an array of other type of attribute.
    std::pair<mlir::ArrayAttr, mlir::Type>
    getConstantAttr(StructLiteralExprAST& structLiteral) {
        std::vector<mlir::Attribute> attrs;
        std::vector<mlir::Type>      types;

        for (auto& var : structLiteral.getValues()) {
            if (auto* memberStruct = llvm::dyn_cast<StructLiteralExprAST>(var.get())) {
                auto attrPair = getConstantAttr(*memberStruct);
                attrs.push_back(attrPair.first);
                types.push_back(attrPair.second);
            }
            else if (auto* memberTensor = llvm::dyn_cast<LiteralExprAST>(var.get())) {
                attrs.push_back(getConstantAttr(*memberTensor));
                types.push_back(getType({}));
            }
            else if (auto* memberNumer = llvm::dyn_cast<NumberExprAST>(var.get())) {
                attrs.push_back(getConstantAttr(*memberNumer));
                types.push_back(getType({}));
            }
        }

        mlir::ArrayAttr dataAttr = builder.getArrayAttr(attrs);
        mlir::Type      dataType = StructType::get(types);
        return std::make_pair(dataAttr, dataType);
    }

    /// Create the prototype for an MLIR function with as many arguments as the
    /// provided Toy AST prototype.
    mlir::toy::FuncOp mlirGen(PrototypeAST& proto) {
        auto location = loc(proto.loc());

        // This is a generic function, the return type will be inferred later.
        // Arguments type are uniformly unranked tensors.
        llvm::SmallVector<mlir::Type, 4> argTypes;
        for (auto& arg : proto.getArgs()) {
            argTypes.push_back(getType(arg->getType(), arg->loc()));
        }
        auto funcType = builder.getFunctionType(argTypes, std::nullopt);
        return builder.create<mlir::toy::FuncOp>(location, proto.getName(), funcType);
    }

    /// Emit a new function and add it to the MLIR module.
    mlir::toy::FuncOp mlirGen(FunctionAST& funcAST) {
        // Create a scope in the symbol table to hold variable declarations.
        ScopedTable_t varScope(symbolTable);

        // Create an MLIR function for the given prototype.
        builder.setInsertionPointToEnd(theModule.getBody());
        mlir::toy::FuncOp function = mlirGen(*funcAST.getProto());
        if (!function)
            return nullptr;

        // Let's start the body of the function now!
        mlir::Block& entryBlock = function.front();
        auto         protoArgs = funcAST.getProto()->getArgs();

        // Declare all the function arguments in the symbol table.
        for (const auto nameValue : llvm::zip(protoArgs, entryBlock.getArguments())) {
            if (failed(declare(std::get<0>(nameValue).get(), std::get<1>(nameValue))))
                return nullptr;
        }

        // Set the insertion point in the builder to the beginning of the function
        // body, it will be used throughout the codegen to create operations in this
        // function.
        builder.setInsertionPointToStart(&entryBlock);

        // Emit the body of the function.
        if (mlir::failed(mlirGen(*funcAST.getBody()))) {
            function.erase();
            return nullptr;
        }

        // Implicitly return void if no return statement was emitted.
        // FIXME: we may fix the parser instead to always return the last expression
        // (this would possibly help the REPL case later)
        ReturnOp returnOp;
        if (!entryBlock.empty())
            returnOp = dyn_cast<ReturnOp>(entryBlock.back());
        if (!returnOp) {
            builder.create<ReturnOp>(loc(funcAST.getProto()->loc()));
        }
        else if (returnOp.hasOperand()) {
            // Otherwise, if this return operation has an operand then add a result to
            // the function.
            function.setType(builder.getFunctionType(
                function.getFunctionType().getInputs(),
                getType(VarType{}, funcAST.getBody()->back()->loc())));
        }

        if (funcAST.getProto()->getName() != "main")
            function.setPrivate();
        return function;
    }

    // get a struct type name from a ExprAST.
    StructAST* getStructType(ExprAST* expr) {
        llvm::StringRef structName;
        if (auto* var = llvm::dyn_cast<VariableExprAST>(expr)) {
            // was VariableExprAST. look up symbolTable to find var's type.
            auto varIt = symbolTable.lookup(var->getName());
            if (!varIt.second)
                return nullptr;
            structName = varIt.first->getType().typeName;
        }
        else if (auto* accessOp = llvm::dyn_cast<BinaryExprAST>(expr)) {
            if (accessOp->getOp() != '.')
                return nullptr;
            auto name = llvm::dyn_cast<VariableExprAST>(accessOp->getRHS());
            if (!name)
                return nullptr;

            StructAST* parentStruct = getStructType(accessOp->getLHS());
            if (!parentStruct)
                return nullptr;

            // loopup parent Struct number list.
            VarDeclExprAST* decl = nullptr;
            for (auto& var : parentStruct->getMembers()) {
                if (var->getName() == name->getName()) {
                    decl = var.get();
                    break;
                }
            }

            if (!decl)
                return nullptr;
            structName = decl->getType().typeName;
        }
        auto structIt = structMap.find(structName);
        if (structIt == structMap.end())
            return nullptr;

        return structIt->second.second;
    }


    std::optional<size_t> getMemberIndex(BinaryExprAST& accessOp) {
        assert(accessOp.getOp() == '.' && "excepted access operation.");

        auto structAST = getStructType(accessOp.getLHS());
        if (!structAST)
            return std::nullopt;

        auto numberName = llvm::dyn_cast<VariableExprAST>(accessOp.getRHS());
        if (!numberName)
            return std::nullopt;

        auto        structVars = structAST->getMembers();
        const auto* it =
            llvm::find_if(structVars, [&](const std::unique_ptr<VarDeclExprAST>& var) {
                return var->getName() == numberName->getName();
            });
        return it - structVars.begin();
    }

    /// Emit a binary operation
    mlir::Value mlirGen(BinaryExprAST& binOp) {
        // First emit the operations for each side of the operation before emitting
        // the operation itself. For example if the expression is `a + foo(a)`
        // 1) First it will visiting the LHS, which will return a reference to the
        //    value holding `a`. This value should have been emitted at declaration
        //    time and registered in the symbol table, so nothing would be
        //    codegen'd. If the value is not in the symbol table, an error has been
        //    emitted and nullptr is returned.
        // 2) Then the RHS is visited (recursively) and a call to `foo` is emitted
        //    and the result value is returned. If an error occurs we get a nullptr
        //    and propagate.
        //
        auto        location = loc(binOp.loc());
        mlir::Value lhs = mlirGen(*binOp.getLHS());
        if (!lhs)
            return nullptr;

        // If this is an access operation, handle it immediately.
        if (binOp.getOp() == '.') {
            std::optional<size_t> accessIndex = getMemberIndex(binOp);
            if (!accessIndex) {
                emitError(location, "invalid access into struct expression");
                return nullptr;
            }
            assert(dyn_cast<StructType>(lhs.getType()) != nullptr);

            return builder.create<StructAccessOp>(location, lhs, *accessIndex);
        }

        mlir::Value rhs = mlirGen(*binOp.getRHS());
        if (!rhs)
            return nullptr;

        // Derive the operation name from the binary operator. At the moment we only
        // support '+' and '*'.
        switch (binOp.getOp()) {
        case '+':
            return builder.create<AddOp>(location, lhs, rhs);
        case '*':
            return builder.create<MulOp>(location, lhs, rhs);
        }

        emitError(location, "invalid binary operator '") << binOp.getOp() << "'";
        return nullptr;
    }

    /// This is a reference to a variable in an expression. The variable is
    /// expected to have been declared and so should have a value in the symbol
    /// table, otherwise emit an error and return nullptr.
    mlir::Value mlirGen(VariableExprAST& expr) {
        if (auto variable = symbolTable.lookup(expr.getName()).second)
            return variable;

        emitError(loc(expr.loc()), "error: unknown variable '") << expr.getName() << "'";
        return nullptr;
    }

    /// Emit a return operation. This will return failure if any generation fails.
    llvm::LogicalResult mlirGen(ReturnExprAST& ret) {
        auto location = loc(ret.loc());

        // 'return' takes an optional expression, handle that case here.
        mlir::Value expr = nullptr;
        if (ret.getExpr().has_value()) {
            if (!(expr = mlirGen(**ret.getExpr())))
                return mlir::failure();
        }

        // Otherwise, this return operation has zero operands.
        builder.create<ReturnOp>(
            location, expr ? ArrayRef(expr) : ArrayRef<mlir::Value>());
        return mlir::success();
    }

    /// Emit a literal/constant array. It will be emitted as a flattened array of
    /// data in an Attribute attached to a `toy.constant` operation.
    /// See documentation on [Attributes](LangRef.md#attributes) for more details.
    /// Here is an excerpt:
    ///
    ///   Attributes are the mechanism for specifying constant data in MLIR in
    ///   places where a variable is never allowed [...]. They consist of a name
    ///   and a concrete attribute value. The set of expected attributes, their
    ///   structure, and their interpretation are all contextually dependent on
    ///   what they are attached to.
    ///
    /// Example, the source level statement:
    ///   var a<2, 3> = [[1, 2, 3], [4, 5, 6]];
    /// will be converted to:
    ///   %0 = "toy.constant"() {value: dense<tensor<2x3xf64>,
    ///     [[1.000000e+00, 2.000000e+00, 3.000000e+00],
    ///      [4.000000e+00, 5.000000e+00, 6.000000e+00]]>} : () -> tensor<2x3xf64>
    ///
    mlir::Value mlirGen(LiteralExprAST& lit) {
        auto type = getType(lit.getDims());

        auto dataAttribute = getConstantAttr(lit);
        // Build the MLIR op `toy.constant`. This invokes the `ConstantOp::build`
        // method.
        return builder.create<ConstantOp>(loc(lit.loc()), type, dataAttribute);
    }

    /// Emit a struct literal array.
    /// Example, the source level statement:
    ///     struct a = {[[1, 2], [3, 4]], [1]};
    mlir::Value mlirGen(StructLiteralExprAST& structLiteral) {
        mlir::ArrayAttr dataAttr;
        mlir::Type      dataType;
        std::tie(dataAttr, dataType) = getConstantAttr(structLiteral);

        return builder.create<StructConstantOp>(
            loc(structLiteral.loc()), dataType, dataAttr);
    }

    /// Recursive helper function to accumulate the data that compose an array
    /// literal. It flattens the nested structure in the supplied vector. For
    /// example with this array:
    ///  [[1, 2], [3, 4]]
    /// we will generate:
    ///  [ 1, 2, 3, 4 ]
    /// Individual numbers are represented as doubles.
    /// Attributes are the way MLIR attaches constant to operations.
    void collectData(ExprAST& expr, std::vector<double>& data) {
        if (auto* lit = dyn_cast<LiteralExprAST>(&expr)) {
            for (auto& value : lit->getValues())
                collectData(*value, data);
            return;
        }

        assert(isa<NumberExprAST>(expr) && "expected literal or number expr");
        data.push_back(cast<NumberExprAST>(expr).getValue());
    }

    /// Emit a call expression. It emits specific operations for the `transpose`
    /// builtin. Other identifiers are assumed to be user-defined functions.
    mlir::Value mlirGen(CallExprAST& call) {
        llvm::StringRef callee = call.getCallee();
        auto            location = loc(call.loc());

        // Codegen the operands first.
        SmallVector<mlir::Value, 4> operands;
        for (auto& expr : call.getArgs()) {
            auto arg = mlirGen(*expr);
            if (!arg)
                return nullptr;
            operands.push_back(arg);
        }

        // Builtin calls have their custom operation, meaning this is a
        // straightforward emission.
        if (callee == "transpose") {
            if (call.getArgs().size() != 1) {
                emitError(
                    location, "MLIR codegen encountered an error: toy.transpose "
                              "does not accept multiple arguments");
                return nullptr;
            }
            return builder.create<TransposeOp>(location, operands[0]);
        }

        // Otherwise this is a call to a user-defined function. Calls to
        // user-defined functions are mapped to a custom call that takes the callee
        // name as an attribute.
        return builder.create<GenericCallOp>(location, callee, operands);
    }

    /// Emit a print expression. It emits specific operations for two builtins:
    /// transpose(x) and print(x).
    llvm::LogicalResult mlirGen(PrintExprAST& call) {
        auto arg = mlirGen(*call.getArg());
        if (!arg)
            return mlir::failure();

        builder.create<PrintOp>(loc(call.loc()), arg);
        return mlir::success();
    }

    /// Emit a constant for a single number (FIXME: semantic? broadcast?)
    mlir::Value mlirGen(NumberExprAST& num) {
        return builder.create<ConstantOp>(loc(num.loc()), num.getValue());
    }

    /// Dispatch codegen for the right expression subclass using RTTI.
    mlir::Value mlirGen(ExprAST& expr) {
        switch (expr.getKind()) {
        case toy::ExprAST::Expr_BinOp:
            return mlirGen(cast<BinaryExprAST>(expr));
        case toy::ExprAST::Expr_Var:
            return mlirGen(cast<VariableExprAST>(expr));
        case toy::ExprAST::Expr_Literal:
            return mlirGen(cast<LiteralExprAST>(expr));
        case toy::ExprAST::Expr_Call:
            return mlirGen(cast<CallExprAST>(expr));
        case toy::ExprAST::Expr_Num:
            return mlirGen(cast<NumberExprAST>(expr));
        case toy::ExprAST::Expr_StructLiteral:
            return mlirGen(cast<StructLiteralExprAST>(expr));
        default:
            emitError(loc(expr.loc()))
                << "MLIR codegen encountered an unhandled expr kind '"
                << Twine(expr.getKind()) << "'";
            return nullptr;
        }
    }

    llvm::LogicalResult mlirGen(StructAST& structDecl) {
        if (structMap.count(structDecl.getTypeName()))
            mlir::emitError(loc(structDecl.loc()))
                << "error: struct type with name `" << structDecl.getTypeName()
                << "` already exist.";

        auto                    variables = structDecl.getMembers();
        std::vector<mlir::Type> elements;
        elements.reserve(variables.size());
        for (auto& variable : variables) {
            mlir::Type type = getType(variable->getType(), variable->loc());
            if (!type)
                return llvm::failure();
            elements.push_back(type);
        }

        structMap.try_emplace(
            structDecl.getTypeName(), StructType::get(elements), &structDecl);
        return mlir::success();
    }

    /// Handle a variable declaration, we'll codegen the expression that forms the
    /// initializer and record the value in the symbol table before returning it.
    /// Future expressions will be able to reference this variable through symbol
    /// table lookup.
    mlir::Value mlirGen(VarDeclExprAST& vardecl) {
        auto* init = vardecl.getInitVal();
        if (!init) {
            emitError(loc(vardecl.loc()), "missing initializer in variable declaration");
            return nullptr;
        }

        mlir::Value value = mlirGen(*init);
        if (!value)
            return nullptr;

        // We have the initializer value, but in case the variable was declared
        // with specific shape, we emit a "reshape" operation. It will get
        // optimized out later as needed.
        if (!vardecl.getType().shape.empty()) {
            value = builder.create<ReshapeOp>(
                loc(vardecl.loc()), getType(vardecl.getType(), vardecl.loc()), value);
        }

        // Register the value in the symbol table.
        if (failed(declare(&vardecl, value)))
            return nullptr;
        return value;
    }

    /// Codegen a list of expression, return failure if one of them hit an error.
    llvm::LogicalResult mlirGen(ExprASTList& blockAST) {
        ScopedTable_t varScope(symbolTable);
        for (auto& expr : blockAST) {
            // Specific handling for variable declarations, return statement, and
            // print. These can only appear in block list and not in nested
            // expressions.
            if (auto* vardecl = dyn_cast<VarDeclExprAST>(expr.get())) {
                if (!mlirGen(*vardecl))
                    return mlir::failure();
                continue;
            }
            if (auto* ret = dyn_cast<ReturnExprAST>(expr.get()))
                return mlirGen(*ret);
            if (auto* print = dyn_cast<PrintExprAST>(expr.get())) {
                if (mlir::failed(mlirGen(*print)))
                    return mlir::success();
                continue;
            }

            // Generic expression dispatch codegen.
            if (!mlirGen(*expr))
                return mlir::failure();
        }
        return mlir::success();
    }

    /// Build a tensor type from a list of shape dimensions.
    mlir::Type getType(ArrayRef<int64_t> shape) {
        // If the shape is empty, then this type is unranked.
        if (shape.empty())
            return mlir::UnrankedTensorType::get(builder.getF64Type());

        // Otherwise, we use the given shape.
        return mlir::RankedTensorType::get(shape, builder.getF64Type());
    }

    /// Build an MLIR type from a Toy AST variable type (forward to the generic
    /// getType above).
    mlir::Type getType(const VarType& type, const Location& location) {
        if (type.typeName == "tensor" || type.typeName == "")
            return getType(type.shape);

        auto it = structMap.find(type.typeName);
        if (it == structMap.end()) {
            mlir::emitError(loc(location))
                << "error: unknown struct type `" << type.typeName << "`.";
        }
        return it->second.first;
    }
};

}  // namespace

namespace toy {

// The public API for codegen.
mlir::OwningOpRef<mlir::ModuleOp>
mlirGen(mlir::MLIRContext& context, ModuleAST& moduleAST) {
    return MLIRGenImpl(context).mlirGen(moduleAST);
}

}  // namespace toy
