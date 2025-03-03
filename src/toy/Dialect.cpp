//===- Dialect.cpp - Toy IR Dialect registration in MLIR ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the dialect for the Toy IR: custom type parsing and
// operation verification.
//
//===----------------------------------------------------------------------===//

#include "toy/Dialect.h"

#include "mlir/IR/Attributes.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/DialectInterface.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/OperationSupport.h"
#include "mlir/IR/TypeSupport.h"
#include "mlir/IR/Types.h"
#include "mlir/IR/Value.h"
#include "mlir/IR/ValueRange.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/FunctionImplementation.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Transforms/InliningUtils.h"

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/LogicalResult.h"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <string>

using namespace mlir;
using namespace mlir::toy;

#include "toy/Dialect.cpp.inc"

//===----------------------------------------------------------------------===//
// ToyInlinerInterface
//===----------------------------------------------------------------------===//
/// This class defines the interface for handling inlining with Toy
/// operations.
struct ToyInlinerInterface : public DialectInlinerInterface {
    using DialectInlinerInterface::DialectInlinerInterface;

    //===--------------------------------------------------------------------===//
    // Analysis Hooks
    //===--------------------------------------------------------------------===//

    /// All call operations within toy can be inlined.
    bool isLegalToInline(Operation* call, Operation* callable, bool wouldBeCloned)
        const final {
        return true;
    }

    /// All operations within toy can be inlined.
    bool isLegalToInline(Operation*, Region*, bool, IRMapping&) const final {
        return true;
    }

    // All functions within toy can be inlined.
    bool isLegalToInline(Region*, Region*, bool, IRMapping&) const final {
        return true;
    }

    //===--------------------------------------------------------------------===//
    // Transformation Hooks
    //===--------------------------------------------------------------------===//

    /// Handle the given inlined terminator(toy.return) by replacing it with a new
    /// operation as necessary.
    void handleTerminator(Operation* op, ValueRange valuesToRepl) const final {
        // Only "toy.return" needs to be handled here.
        auto returnOp = cast<ReturnOp>(op);

        // Replace the values directly with the return operands.
        assert(returnOp.getNumOperands() == valuesToRepl.size());
        for (const auto& it : llvm::enumerate(returnOp.getOperands()))
            valuesToRepl[it.index()].replaceAllUsesWith(it.value());
    }

    /// Attempts to materialize a conversion for a type mismatch between a call
    /// from this dialect, and a callable region. This method should generate an
    /// operation that takes 'input' as the only operand, and produces a single
    /// result of 'resultType'. If a conversion can not be generated, nullptr
    /// should be returned.
    Operation* materializeCallConversion(
        OpBuilder& builder,
        Value      input,
        Type       resultType,
        Location   conversionLoc) const final {
        return builder.create<CastOp>(conversionLoc, resultType, input);
    }
};


//===----------------------------------------------------------------------===//
// ToyDialect
//===----------------------------------------------------------------------===//

/// Dialect initialization, the instance will be owned by the context. This is
/// the point of registration of types and operations for the dialect.
void ToyDialect::initialize() {
    addOperations<
#define GET_OP_LIST
#include "toy/Ops.cpp.inc"
        >();
    addInterface<ToyInlinerInterface>();
    addTypes<StructType>();
}


Operation* mlir::toy::ToyDialect::materializeConstant(
    mlir::OpBuilder& builder,
    mlir::Attribute  value,
    mlir::Type       type,
    mlir::Location   loc) {
    if (llvm::isa<StructType>(type))
        return builder.create<StructConstantOp>(
            loc, type, llvm::cast<mlir::ArrayAttr>(value));

    return builder.create<ConstantOp>(
        loc, type, llvm::cast<mlir::DenseElementsAttr>(value));
}


// parse Type in .mlir files. Include [Struct, Tensor].
Type ToyDialect::parseType(mlir::DialectAsmParser& parser) const {
    // parser a struct type in the following form:
    //      struct-type ::= `struct` `< ` type ( `,` type)* `>`

    if (parser.parseKeyword("struct") || parser.parseLess())
        return Type();

    SmallVector<Type, 1> elementTypes;
    do {
        SMLoc      typeLoc = parser.getCurrentLocation();
        mlir::Type elementType;
        if (parser.parseType(elementType))
            return nullptr;

        if (!llvm::isa<TensorType, StructType>(elementType)) {
            parser.emitError(
                typeLoc, "element type for a struct must either "
                         "be a TensorType or a StructType, got: ")
                << elementType;
            return Type();
        }

        elementTypes.push_back(elementType);
    } while (succeeded(parser.parseOptionalComma()));

    if (parser.parseGreater())
        return Type();

    return StructType::get(elementTypes);
}


// Print Type to .mlir file.
void ToyDialect::printType(Type type, DialectAsmPrinter& printer) const {
    StructType structType = llvm::cast<StructType>(type);

    printer << "struct<";
    llvm::interleaveComma(structType.getElementTypes(), printer);
    printer << '>';
}

//===----------------------------------------------------------------------===//
// Toy Operations
//===----------------------------------------------------------------------===//

/// A generalized parser for binary operations. This parses the different forms
/// of 'printBinaryOp' below.
static mlir::ParseResult
parseBinaryOp(mlir::OpAsmParser& parser, mlir::OperationState& result) {
    SmallVector<mlir::OpAsmParser::UnresolvedOperand, 2> operands;
    SMLoc operandsLoc = parser.getCurrentLocation();
    Type  type;
    if (parser.parseOperandList(operands, /*requiredOperandCount=*/2) ||
        parser.parseOptionalAttrDict(result.attributes) || parser.parseColonType(type))
        return mlir::failure();

    // If the type is a function type, it contains the input and result types of
    // this operation.
    if (FunctionType funcType = llvm::dyn_cast<FunctionType>(type)) {
        if (parser.resolveOperands(
                operands, funcType.getInputs(), operandsLoc, result.operands))
            return mlir::failure();
        result.addTypes(funcType.getResults());
        return mlir::success();
    }

    // Otherwise, the parsed type is the type of both operands and results.
    if (parser.resolveOperands(operands, type, result.operands))
        return mlir::failure();
    result.addTypes(type);
    return mlir::success();
}

/// A generalized printer for binary operations. It prints in two different
/// forms depending on if all of the types match.
static void printBinaryOp(mlir::OpAsmPrinter& printer, mlir::Operation* op) {
    printer << " " << op->getOperands();
    printer.printOptionalAttrDict(op->getAttrs());
    printer << " : ";

    // If all of the types are the same, print the type directly.
    Type resultType = *op->result_type_begin();
    if (llvm::all_of(
            op->getOperandTypes(), [=](Type type) { return type == resultType; })) {
        printer << resultType;
        return;
    }

    // Otherwise, print a functional type.
    printer.printFunctionalType(op->getOperandTypes(), op->getResultTypes());
}

//===----------------------------------------------------------------------===//
// ConstantOp
//===----------------------------------------------------------------------===//
llvm::LogicalResult
verifyConstantForType(mlir::Type type, mlir::Attribute opaqueValue, mlir::Operation* op) {
    if (llvm::isa<mlir::TensorType>(type)) {
        auto attrValue = llvm::dyn_cast<mlir::DenseFPElementsAttr>(opaqueValue);
        if (!attrValue) {
            return op->emitError(
                       "constant of TensorType must be initialized by "
                       "a DenseFPElementsAttr, got: ")
                   << opaqueValue;
        }

        auto resultType = llvm::dyn_cast<mlir::RankedTensorType>(type);
        if (!resultType)
            return llvm::success();

        auto attrType = llvm::cast<mlir::RankedTensorType>(attrValue.getType());
        if (attrType.getRank() != resultType.getRank()) {
            return op->emitError(
                       "return type must match the one of the attached "
                       "value attribute: ")
                   << attrType.getRank() << resultType.getRank();
        }

        for (int dim = 0, dimE = attrType.getRank(); dim < dimE; dim++) {
            if (attrType.getShape()[dim] != resultType.getShape()[dim]) {
                return op->emitOpError(
                           "return type shape mismatches its attribute at dimension ")
                       << dim << ":" << attrType.getShape()[dim]
                       << "!= " << resultType.getShape()[dim];
            }
        }
        return llvm::success();
    }
    else {
        auto resultType = llvm::cast<StructType>(type);
        auto resultElementTypes = resultType.getElementTypes();
        auto attrValues = llvm::dyn_cast<ArrayAttr>(opaqueValue);

        if (!attrValues || attrValues.size() != resultElementTypes.size()) {
            return op->emitError(
                       "constant of StructType must be initialized by an "
                       "ArrayAttr with the same number of elements, got: ")
                   << opaqueValue;
        }

        llvm::ArrayRef<Attribute> attrElementValues = attrValues.getValue();
        for (const auto it : llvm::zip(resultElementTypes, attrElementValues)) {
            if (llvm::failed(
                    verifyConstantForType(std::get<0>(it), std::get<1>(it), op))) {
                return llvm::failure();
            }
        }

        return llvm::success();
    }
    return llvm::failure();
}

/// Build a constant operation.
/// The builder is passed as an argument, so is the state that this method is
/// expected to fill in order to build the operation.
void ConstantOp::build(
    mlir::OpBuilder&      builder,
    mlir::OperationState& state,
    double                value) {
    auto dataType = RankedTensorType::get({}, builder.getF64Type());
    auto dataAttribute = DenseElementsAttr::get(dataType, value);
    ConstantOp::build(builder, state, dataType, dataAttribute);
}

/// The 'OpAsmParser' class provides a collection of methods for parsing
/// various punctuation, as well as attributes, operands, types, etc. Each of
/// these methods returns a `ParseResult`. This class is a wrapper around
/// `LogicalResult` that can be converted to a boolean `true` value on failure,
/// or `false` on success. This allows for easily chaining together a set of
/// parser rules. These rules are used to populate an `mlir::OperationState`
/// similarly to the `build` methods described above.
mlir::ParseResult
ConstantOp::parse(mlir::OpAsmParser& parser, mlir::OperationState& result) {
    mlir::DenseElementsAttr value;
    if (parser.parseOptionalAttrDict(result.attributes) ||
        parser.parseAttribute(value, "value", result.attributes))
        return failure();

    result.addTypes(value.getType());
    return success();
}

/// The 'OpAsmPrinter' class is a stream that allows for formatting
/// strings, attributes, operands, types, etc.
void ConstantOp::print(mlir::OpAsmPrinter& printer) {
    printer << " ";
    printer.printOptionalAttrDict((*this)->getAttrs(), /*elidedAttrs=*/{ "value" });
    printer << getValue();
}

/// Verifier for the constant operation. This corresponds to the
/// `let hasVerifier = 1` in the op definition.
llvm::LogicalResult ConstantOp::verify() {
    // If the return type of the constant is not an unranked tensor, the shape
    // must match the shape of the attribute holding the data.
    auto resultType = llvm::dyn_cast<mlir::RankedTensorType>(getResult().getType());
    if (!resultType)
        return success();

    // Check that the rank of the attribute type matches the rank of the constant
    // result type.
    auto attrType = llvm::cast<mlir::RankedTensorType>(getValue().getType());
    if (attrType.getRank() != resultType.getRank()) {
        return emitOpError(
                   "return type must match the one of the attached value "
                   "attribute: ")
               << attrType.getRank() << " != " << resultType.getRank();
    }

    // Check that each of the dimensions match between the two types.
    for (int dim = 0, dimE = attrType.getRank(); dim < dimE; ++dim) {
        if (attrType.getShape()[dim] != resultType.getShape()[dim]) {
            return emitOpError("return type shape mismatches its attribute at dimension ")
                   << dim << ": " << attrType.getShape()[dim]
                   << " != " << resultType.getShape()[dim];
        }
    }
    return mlir::success();
}

void ConstantOp::inferShapes() {
    getResult().setType(cast<TensorType>(getValue().getType()));
}
//===----------------------------------------------------------------------===//
// AddOp
//===----------------------------------------------------------------------===//

void AddOp::build(
    mlir::OpBuilder&      builder,
    mlir::OperationState& state,
    mlir::Value           lhs,
    mlir::Value           rhs) {
    state.addTypes(UnrankedTensorType::get(builder.getF64Type()));
    state.addOperands({ lhs, rhs });
}

mlir::ParseResult AddOp::parse(mlir::OpAsmParser& parser, mlir::OperationState& result) {
    return parseBinaryOp(parser, result);
}

void AddOp::print(mlir::OpAsmPrinter& p) {
    printBinaryOp(p, *this);
}

void AddOp::inferShapes() {
    getResult().setType(getLhs().getType());
}

//===----------------------------------------------------------------------===//
// FuncOp
//===----------------------------------------------------------------------===//

void FuncOp::build(
    mlir::OpBuilder&                     builder,
    mlir::OperationState&                state,
    llvm::StringRef                      name,
    mlir::FunctionType                   type,
    llvm::ArrayRef<mlir::NamedAttribute> attrs) {
    // FunctionOpInterface provides a convenient `build` method that will populate
    // the state of our FuncOp, and create an entry block.
    buildWithEntryBlock(builder, state, name, type, attrs, type.getInputs());
}

mlir::ParseResult FuncOp::parse(mlir::OpAsmParser& parser, mlir::OperationState& result) {
    // Dispatch to the FunctionOpInterface provided utility method that parses the
    // function operation.
    auto buildFuncType = [](mlir::Builder& builder, llvm::ArrayRef<mlir::Type> argTypes,
                            llvm::ArrayRef<mlir::Type> results,
                            mlir::function_interface_impl::VariadicFlag, std::string&) {
        return builder.getFunctionType(argTypes, results);
    };

    return mlir::function_interface_impl::parseFunctionOp(
        parser, result, /*allowVariadic=*/false, getFunctionTypeAttrName(result.name),
        buildFuncType, getArgAttrsAttrName(result.name),
        getResAttrsAttrName(result.name));
}

void FuncOp::print(mlir::OpAsmPrinter& p) {
    // Dispatch to the FunctionOpInterface provided utility method that prints the
    // function operation.
    mlir::function_interface_impl::printFunctionOp(
        p, *this, /*isVariadic=*/false, getFunctionTypeAttrName(), getArgAttrsAttrName(),
        getResAttrsAttrName());
}


//===----------------------------------------------------------------------===//
// GenericCallOp
//===----------------------------------------------------------------------===//

void GenericCallOp::build(
    mlir::OpBuilder&      builder,
    mlir::OperationState& state,
    StringRef             callee,
    ArrayRef<mlir::Value> arguments) {
    // Generic call always returns an unranked Tensor initially.
    state.addTypes(UnrankedTensorType::get(builder.getF64Type()));
    state.addOperands(arguments);
    state.addAttribute("callee", mlir::SymbolRefAttr::get(builder.getContext(), callee));
}

/// Return the callee of the generic call operation, this is required by the
/// call interface.
CallInterfaceCallable GenericCallOp::getCallableForCallee() {
    return (*this)->getAttrOfType<SymbolRefAttr>("callee");
}

/// Set the callee for the generic call operation, this is required by the call
/// interface.
void GenericCallOp::setCalleeFromCallable(CallInterfaceCallable callee) {
    (*this)->setAttr("callee", cast<SymbolRefAttr>(callee));
}

/// Get the argument operands to the called function, this is required by the
/// call interface.
Operation::operand_range GenericCallOp::getArgOperands() {
    return getInputs();
}

/// Get the argument operands to the called function as a mutable range, this is
/// required by the call interface.
MutableOperandRange GenericCallOp::getArgOperandsMutable() {
    return getInputsMutable();
}

//===----------------------------------------------------------------------===//
// MulOp
//===----------------------------------------------------------------------===//

void MulOp::build(
    mlir::OpBuilder&      builder,
    mlir::OperationState& state,
    mlir::Value           lhs,
    mlir::Value           rhs) {
    state.addTypes(UnrankedTensorType::get(builder.getF64Type()));
    state.addOperands({ lhs, rhs });
}

mlir::ParseResult MulOp::parse(mlir::OpAsmParser& parser, mlir::OperationState& result) {
    return parseBinaryOp(parser, result);
}

void MulOp::print(mlir::OpAsmPrinter& p) {
    printBinaryOp(p, *this);
}

void MulOp::inferShapes() {
    getResult().setType(getLhs().getType());
}


//===----------------------------------------------------------------------===//
// ReturnOp
//===----------------------------------------------------------------------===//
llvm::LogicalResult ReturnOp::verify() {
    // We know that the parent operation is a function, because of the 'HasParent'
    // trait attached to the operation definition.
    auto function = cast<FuncOp>((*this)->getParentOp());

    /// ReturnOps can only have a single optional operand.
    if (getNumOperands() > 1)
        return emitOpError() << "expects at most 1 return operand";

    // The operand number and types must match the function signature.
    const auto& results = function.getFunctionType().getResults();
    if (getNumOperands() != results.size())
        return emitOpError() << "does not return the same number of values ("
                             << getNumOperands() << ") as the enclosing function ("
                             << results.size() << ")";

    // If the operation does not have an input, we are done.
    if (!hasOperand())
        return mlir::success();

    auto inputType = *operand_type_begin();
    auto resultType = results.front();

    // Check that the result type of the function matches the operand type.
    if (inputType == resultType || llvm::isa<mlir::UnrankedTensorType>(inputType) ||
        llvm::isa<mlir::UnrankedTensorType>(resultType))
        return mlir::success();

    return emitError() << "type of return operand (" << inputType
                       << ") doesn't match function result type (" << resultType << ")";
}

//===----------------------------------------------------------------------===//
// TransposeOp
//===----------------------------------------------------------------------===//
void TransposeOp::build(
    mlir::OpBuilder&      builder,
    mlir::OperationState& state,
    mlir::Value           value) {
    state.addTypes(UnrankedTensorType::get(builder.getF64Type()));
    state.addOperands(value);
}

llvm::LogicalResult TransposeOp::verify() {
    auto inputType = llvm::dyn_cast<RankedTensorType>(getOperand().getType());
    auto resultType = llvm::dyn_cast<RankedTensorType>(getType());
    if (!inputType || !resultType)
        return mlir::success();

    auto inputShape = inputType.getShape();
    if (!std::equal(
            inputShape.begin(), inputShape.end(), resultType.getShape().rbegin())) {
        return emitError() << "expected result shape to be a transpose of the input";
    }
    return mlir::success();
}

void TransposeOp::inferShapes() {
    auto                          inputType = getInput().getType();
    llvm::SmallVector<int64_t, 2> resultType(llvm::reverse(inputType.getShape()));
    getResult().setType(RankedTensorType::get(resultType, inputType.getElementType()));
}

//===----------------------------------------------------------------------===//
// CastOp
//===----------------------------------------------------------------------===//
bool CastOp::areCastCompatible(::mlir::TypeRange inputs, ::mlir::TypeRange outputs) {
    if (inputs.size() != 1 || outputs.size() != 1)
        return false;

    TensorType input = dyn_cast<TensorType>(inputs.front());
    TensorType output = dyn_cast<TensorType>(outputs.front());
    if (!input || !output || input.getElementType() != output.getElementType())
        return false;

    return !input.hasRank() || !output.hasRank() || input == output;
}

void CastOp::inferShapes() {
    getResult().setType(getInput().getType());
}

//===----------------------------------------------------------------------===//
// StructAccessOp
//===----------------------------------------------------------------------===//
void StructAccessOp::build(
    mlir::OpBuilder&      builder,
    mlir::OperationState& state,
    Value                 input,
    size_t                index) {
    auto structTy = llvm::cast<StructType>(input.getType());
    assert(index < structTy.getNumElementTypes() && "Index out of range.");
    mlir::Type resultTy = structTy.getElementTypes()[index];
    build(builder, state, resultTy, input, builder.getI64IntegerAttr(index));
}

llvm::LogicalResult StructAccessOp::verify() {
    auto   structTy = llvm::cast<StructType>(getInput().getType());
    size_t indexValue = getIndex();
    if (indexValue >= structTy.getNumElementTypes()) {
        return emitOpError()
               << "index should be within the range of the input struct type";
    }

    mlir::Type resultTy = getResult().getType();
    if (resultTy != structTy.getElementTypes()[indexValue]) {
        return emitOpError() << "must have the same result type as the struct "
                                "element referred to by the index";
    }

    return llvm::success();
}


//===----------------------------------------------------------------------===//
// Toy Struct Type
//===----------------------------------------------------------------------===//
llvm::LogicalResult StructConstantOp::verify() {
    return verifyConstantForType(getResult().getType(), getValue(), *this);
}


//===----------------------------------------------------------------------===//
// Toy Struct Type
//===----------------------------------------------------------------------===//

namespace mlir {
namespace toy {
namespace detail {
struct StructTypeStorage : public mlir::TypeStorage {
    using KeyTy = ArrayRef<Type>;
    StructTypeStorage(ArrayRef<Type> elementTypes) : elementTypes(elementTypes) {}

    bool operator==(const KeyTy& key) const {
        return key == elementTypes;
    }

    static llvm::hash_code hashKey(const KeyTy& key) {
        return llvm::hash_value(key);
    }

    static StructTypeStorage*
    construct(mlir::TypeStorageAllocator& allocator, const KeyTy& key) {
        llvm::ArrayRef<Type> elementTypes = allocator.copyInto(key);
        return new (allocator.allocate<StructTypeStorage>())
            StructTypeStorage(elementTypes);
    }


    ArrayRef<Type> elementTypes;
};
}  // namespace detail
}  // namespace toy
}  // namespace mlir

StructType StructType::get(llvm::ArrayRef<Type> elementTypes) {
    assert(!elementTypes.empty() && "expected at least 1 element type");

    mlir::MLIRContext* ctx = elementTypes.front().getContext();
    return Base::get(ctx, elementTypes);
}

ArrayRef<Type> StructType::getElementTypes() {
    return getImpl()->elementTypes;
}


//===----------------------------------------------------------------------===//
// TableGen'd op method definitions
//===----------------------------------------------------------------------===//

#define GET_OP_CLASSES
#include "toy/Ops.cpp.inc"
