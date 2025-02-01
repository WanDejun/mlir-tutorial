#include "mlir/Conversion/AffineToStandard/AffineToStandard.h"
#include "mlir/Conversion/ArithToLLVM/ArithToLLVM.h"
#include "mlir/Conversion/ControlFlowToLLVM/ControlFlowToLLVM.h"
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVM.h"
#include "mlir/Conversion/LLVMCommon/ConversionTarget.h"
#include "mlir/Conversion/LLVMCommon/TypeConverter.h"
#include "mlir/Conversion/MemRefToLLVM/MemRefToLLVM.h"
#include "mlir/Conversion/SCFToControlFlow/SCFToControlFlow.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/LLVMIR/LLVMTypes.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Value.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/TypeID.h"
#include "mlir/Transforms/DialectConversion.h"

#include "llvm/ADT/ArrayRef.h"
#include <memory>

#include "Passes.h"
#include "toy/Dialect.h"

using namespace mlir;

class PrintOpLowering : public ConversionPattern {
public:
    explicit PrintOpLowering(MLIRContext* ctx)
        : ConversionPattern(toy::PrintOp::getOperationName(), 1, ctx) {}

    LogicalResult matchAndRewrite(
        Operation*                 op,
        ArrayRef<Value>            operands,
        ConversionPatternRewriter& rewriter) const override {
        auto context = rewriter.getContext();
        auto memRefType = llvm::cast<MemRefType>(*op->getOperandTypes().begin());
        auto memRefShape = memRefType.getShape();
        auto loc = op->getLoc();

        auto module = op->getParentOfType<ModuleOp>();


        auto printfRef = getOrInsertPrintf(rewriter, module);
        auto formatSpecifierCst =
            getOrCreateGlobalString(loc, rewriter, "frmt_spec", "%f \0", module);
        auto newLineCst = getOrCreateGlobalString(loc, rewriter, "nl", "\n\0", module);

        SmallVector<Value, 4> loopIvs;
        for (unsigned i = 0, e = memRefShape.size(); i != e; i++) {
            auto lowerBound = rewriter.create<arith::ConstantIndexOp>(loc, 0);
            auto upperBound =
                rewriter.create<arith::ConstantIndexOp>(loc, memRefShape[i]);
            auto step = rewriter.create<arith::ConstantIndexOp>(loc, 1);

            auto loop = rewriter.create<scf::ForOp>(loc, lowerBound, upperBound, step);
            for (auto& nested : *loop.getBody()) {
                rewriter.eraseOp(&nested);
            }
            loopIvs.push_back(loop.getInductionVar());

            rewriter.setInsertionPointToEnd(loop.getBody());

            if (i != e - 1) {
                rewriter.create<LLVM::CallOp>(
                    loc, getPrintfType(context), printfRef, newLineCst);
            }

            // End this layer of loop and set insertPoint to inlayer loop.
            rewriter.create<scf::YieldOp>(loc);
            rewriter.setInsertionPointToStart(loop.getBody());
        }

        // In innermost layer, create CallOp(printf).
        auto printOp = cast<toy::PrintOp>(op);
        auto elementLoad =
            rewriter.create<memref::LoadOp>(loc, printOp.getInput(), loopIvs);
        rewriter.create<LLVM::CallOp>(
            loc, getPrintfType(context), printfRef,
            ArrayRef<Value>({ formatSpecifierCst, elementLoad }));

        rewriter.eraseOp(op);

        return success();
    }

private:
    // return a printf function type.
    static LLVM::LLVMFunctionType getPrintfType(MLIRContext* context) {
        auto llvmI32Type = IntegerType::get(context, 32);
        auto llvmPtrType = LLVM::LLVMPointerType::get(context);
        auto llvmFuncType = LLVM::LLVMFunctionType::get(llvmI32Type, llvmPtrType, true);
        return llvmFuncType;
    }

    static FlatSymbolRefAttr
    getOrInsertPrintf(PatternRewriter& rewriter, ModuleOp module) {
        auto* context = module.getContext();
        if (module.lookupSymbol<LLVM::LLVMFuncOp>("printf")) {
            return SymbolRefAttr::get(context, "printf");
        }

        // insert the printf function.
        OpBuilder::InsertionGuard insertGuard(rewriter);
        rewriter.setInsertionPointToStart(module.getBody());
        rewriter.create<LLVM::LLVMFuncOp>(
            module->getLoc(), "printf", getPrintfType(context));
        return SymbolRefAttr::get(context, "printf");
    }

    static Value getOrCreateGlobalString(
        Location   loc,
        OpBuilder& builder,
        StringRef  name,
        StringRef  value,
        ModuleOp   module) {
        LLVM::GlobalOp global;

        // can't find GlobalOp named 'name', create it.
        if (!(global = module.lookupSymbol<LLVM::GlobalOp>(name))) {
            OpBuilder::InsertionGuard insertGuard(builder);
            builder.setInsertionPointToStart(module.getBody());

            // Target global string is an array with int8 for elementType and value.size
            // as size.
            auto type = LLVM::LLVMArrayType::get(
                IntegerType::get(builder.getContext(), 8), value.size());

            // build the global string.
            global = builder.create<LLVM::GlobalOp>(
                loc, type, true, LLVM::Linkage::Internal, name,
                builder.getStringAttr(value), 0);
        }

        auto globalPtr = builder.create<LLVM::AddressOfOp>(loc, global);
        auto cst0 = builder.create<LLVM::ConstantOp>(
            loc, builder.getI64Type(), builder.getIndexAttr(0));

        return builder.create<LLVM::GEPOp>(
            loc, LLVM::LLVMPointerType::get(builder.getContext()), global.getType(),
            globalPtr, ArrayRef<Value>({ cst0, cst0 }));
    }
};


//===----------------------------------------------------------------------===//
// ToyToLLVMLoweringPass
//===----------------------------------------------------------------------===//
struct ToyToLLVMLoweringPass
    : public PassWrapper<ToyToLLVMLoweringPass, OperationPass<ModuleOp>> {
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(ToyToLLVMLoweringPass)

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<LLVM::LLVMDialect, scf::SCFDialect>();
    }
    void runOnOperation() final;
};

void ToyToLLVMLoweringPass::runOnOperation() {
    LLVMConversionTarget target(getContext());
    target.addLegalOp<ModuleOp>();

    LLVMTypeConverter typeConverter(&getContext());

    // lowering affine, arith, memref, func directly to llvm ir, and low scf to cf, then
    // low cf to llvm ir. Aslo we add PrintOpLowering to pattern set to lower the
    // toy::PrintOp.
    RewritePatternSet patterns(&getContext());
    populateAffineToStdConversionPatterns(patterns);
    populateSCFToControlFlowConversionPatterns(patterns);
    mlir::arith::populateArithToLLVMConversionPatterns(typeConverter, patterns);
    populateFinalizeMemRefToLLVMConversionPatterns(typeConverter, patterns);
    cf::populateControlFlowToLLVMConversionPatterns(typeConverter, patterns);
    populateFuncToLLVMConversionPatterns(typeConverter, patterns);

    patterns.add<PrintOpLowering>(&getContext());

    auto module = getOperation();
    if (failed(applyFullConversion(module, target, std::move(patterns))))
        signalPassFailure();
}


std::unique_ptr<mlir::Pass> mlir::toy::createLowerToLLVMPass() {
    return std::make_unique<ToyToLLVMLoweringPass>();
}