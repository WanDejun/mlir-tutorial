## 降低到 `llvm`

在 _Ch5_ 中我们已经将 `Toy.Dialect` 部分降低到 `affine IR` 了. 接下来, 我们希望得到 `llvm IR`, 以便能复用 `llvm` 后端.

### 将 `affine IR` 降低到 `llvm`
`affine IR` 作为 `mlir` 框架的一个中间层次, `mlir` 提供了降低到 `llvm` 的一套 `pass`, 因此我们只需要调用这一系列 `pass` 即可.
```cpp
    // Affine IR
    populateAffineToStdConversionPatterns(patterns);
    // SCF IR (for loop...) to CF IR
    populateSCFToControlFlowConversionPatterns(patterns);
    // arith IR
    mlir::arith::populateArithToLLVMConversionPatterns(typeConverter, patterns);
    // memref IR
    populateFinalizeMemRefToLLVMConversionPatterns(typeConverter, patterns);
    // cf IR to llvm
    cf::populateControlFlowToLLVMConversionPatterns(typeConverter, patterns);
    // Func IR
    populateFuncToLLVMConversionPatterns(typeConverter, patterns);
```

### 将 `toy.print` 降低到 `llvm`
#### 1. 创建 `print` 函数声明
构造 `PrintType` 类型, `LLVM::LLVMFunctionType::get(llvmI32Type, llvmPtrType, true)`, 其中返回值为 `I32Type`, 唯一不可变参数为 `PtrType`, `true` 表示可变参数.
在 `module` 起始处创建 `printf`, 若已经创建, 直接引用.
```cpp
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
```
#### 2. 将 `print` 降低到 `llvm IR`
`toy.print` 的参数为 `memref`, 通过获取 `memref.shape().size()`, 构建嵌套 `scf::ForOp`, 在最内层 `for` 输出 `memref` 在 `loopIvs` 处的值.

```cpp
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
```