## Partial Lowering to Lower-Level Dialects for Optimization

- In this chapter, we want to lowering down toy dialect to affine dialect.
- Toy Dialect accecpt Tensor type. But tensor can not be presented by computer. So we have to lowering it down to memery.

### 0.TODO
- [x] 1. different between `OpConversionPattern` and `ConversionPattern`;
- [x] 2. what is `OpAdaptor` and how does `adaptor.getOperands()` works;
- [x] 3. what is `mlir::func::registerAllExtensions(registry)` mean;


### 1. Passer
整体框架上 我们需要一个 `Pass` 去遍历我们的 `toy::Dialect` 中间代码, 并完成 `lowering` 操作. 而对于不同的 `Operation` 我们需要一个对应的操作.  
`mlir` 提供了 `ConversionTarget`, `applyPartialConversion` 等操作帮助我们完成这一目标. 我们需要将需要 `lowering down` 的 `operation` 设置为 `Illegal`, 并将目标 `Dialect` 的 `operation` 设置为 `Legal`.
`ConversionTarget` 对象用于管理每个 `operation` 是否合法. `applyPartialConversion` 会调用注册的 `RewritePattern` 将非法的 `operation` `lowering down`.
#### 1.1 


### 2. Dialect
#### 2.1 FuncDialect  
需要以下代码将 `FuncDialect` 相关的内存注册到 `Dialect` 中. ~~(被坑了好久)~~. 否则会报错如下:
- LLVM ERROR: checking for an interface (mlir::DialectInlinerInterface) that was promised by dialect 'func' but never implemented. This is generally an indication that the dialect extension implementing the interface was never registered.

``` cpp
    mlir::DialectRegistry registry;
    mlir::func::registerAllExtensions(registry);

    mlir::MLIRContext context(registry);
```
##### `mlir::func::registerAllExtensions`
`mlir::DialectRegistry` 用于管理需要被注册到 `context` 中的的内容, 可以用于初始化 `MLIRContext`. 这些内容可以是 `Dialect`, `Interface`, `Operation` 等.
实现如下:
``` cpp
void mlir::func::registerAllExtensions(DialectRegistry &registry) {
  registerInlinerExtension(registry);
  registerShardingInterfaceExternalModels(registry);
}
``` 
管理了两个 `Extension`.
``` cpp
void mlir::func::registerInlinerExtension(DialectRegistry &registry) {
  registry.addExtension(+[](MLIRContext *ctx, func::FuncDialect *dialect) {
    dialect->addInterfaces<FuncInlinerInterface>();

    // The inliner extension relies on the ControlFlow dialect.
    ctx->getOrLoadDialect<cf::ControlFlowDialect>();
  });
}

void registerShardingInterfaceExternalModels(DialectRegistry &registry) {
  registry.addExtension(+[](MLIRContext *ctx, FuncDialect *dialect) {
    ReturnOp::attachInterface<
        mesh::IndependentParallelIteratorDomainShardingInterface<ReturnOp>>(
        *ctx);
  });
}
```

`registerInlinerExtension` 注册了内联接口和控制流方言, `registerShardingInterfaceExternalModels` 添加了一个有关 `func::ReturnOp` 的接口.


### 3. 关于 `Op::Adapter`.
这是一个辅助 `Op` 的通用容器, 由于 `Op` 的 `Operands, Results` 等 `Value` 都有固定类型, 例如 `RankedTensorType (tensor<2x3xf64>)`, 如 `toy::AddOp` 的 `::mlir::TypedValue<::mlir::TensorType> getLhs()` 方法, 就将返回值转换为了 `::mlir::TensorType` 因为这样更容易避免在非类型转换的情况下产生类型错误. 然而在执行类型转换时, `toy::AddOp` 的 `operands` 可能已经被转换, 即 `getLhs` 获取到的 `value` 已经从 `tensor` 被转换为了 `memref`. 此时使用 `Op.getLhs()` 会产生动态类型转换错误. 因此 `mlir` 提供了 `Op::Adapter` 用于在类型转换的过程中获取 `Operands`. 以下是 `AddOp::Adaptor` 的 `getLhs()` 方法.
```cpp
template <typename RangeT>
class AddOpGenericAdaptor : public detail::AddOpGenericAdaptorBase {
  ...
  ValueT getLhs() {
    return (*getODSOperands(0).begin());
  }
};
```
不难发现 `ValueT getLhs()` 返回了一个基类 `ValueT`, 这样可以在转化的过程中产生类型错误. 同时 `AddOp::Adaptor` 也是由 `Tablegen` 产生, 保留了高层次的访问方法, 可以通过诸如 `lhs`, `input` 等 在`ODS` 中定义的 `input`, `results` 等形参名访问 `operands`.


### 4. RewritePattern.
- `pass` 通过 `RewritePattern` 来进行匹配和重写. `RewritePattern` 提供了 `matchAndRewrite` 接口供 `pass` 中的 `applyPartialConversion` 调用.
``` cpp
class RewritePattern : public Pattern {
public:
  ...
  /// Attempt to match against code rooted at the specified operation,
  /// which is the same operation code as getRootKind(). If successful, this
  /// function will automatically perform the rewrite.
  virtual LogicalResult matchAndRewrite(Operation *op,
                                        PatternRewriter &rewriter) const {
    if (succeeded(match(op))) {
      rewrite(op, rewriter);
      return success();
    }
    return failure();
  }
};
```
而在实际使用中, `mlir` 提供了多种 `RewritePattern` 的派生类, 用于更加方便地完成 `matchAndRewrite` 任务. 在介绍完这些派生类之后, 我们也将讨论它们分别适合在何时使用.

- **下文提到需要重写 `matchAndRewrite` 之处, 均可以分别重写 `match` 和 `Rewrite`等效**

#### 4.1 `OpRewritePattern`
`OpRewritePattern` 继承于 :
```cpp
template <typename SourceOp>
struct OpOrInterfaceRewritePatternBase : public RewritePattern
```
其中重写了 `matchAndRewrite` 方法:
```cpp
    LogicalResult matchAndRewrite(Operation *op,
                                  PatternRewriter &rewriter) const final {
        return matchAndRewrite(cast<SourceOp>(op), rewriter);
    }

    virtual LogicalResult matchAndRewrite(SourceOp op,
                                          PatternRewriter &rewriter) const {
        if (succeeded(match(op))) {
            rewrite(op, rewriter);
            return success();
        }
        return failure();
    }
```
上面的 `matchAndRewrite` 方法重写的 `RewritePattern` 的基方法, 并将其定义为 `final` 属性. 该方法将调用下面的 `matchAndRewrite` 方法. 即保证基类接口可用的同时, 改变了接口格式.
新的虚接口格式通过指定的 `Operation` 实现, 默认实现返回 `failure`. 而要使用该接口, 我们只需要继承后重写该方法, 并返回 `success` 即可. 例如:
```cpp
struct ConstantOpLowering : public OpRewritePattern<toy::ConstantOp> {
    using OpRewritePattern<toy::ConstantOp>::OpRewritePattern;

    llvm::LogicalResult
    matchAndRewrite(toy::ConstantOp op, PatternRewriter& rewriter) const override {
        DenseElementsAttr constantValue = op.getValue();
        // ConstantOp has a attribute argument named value, So tblgen a getValue method.
        auto loc = op->getLoc();
        ...
        
        return success();
    }
};
```

#### 4.2 `ConversionPattern`
- 继承关系: `class ConversionPattern : public RewritePattern`.
`ConversionPattern` 也重写为 `final` 方法, 并将具体
``` cpp
class ConversionPattern : public RewritePattern {
  /// Attempt to match and rewrite the IR root at the specified operation.
  LogicalResult matchAndRewrite(Operation *op,
                                PatternRewriter &rewriter) const final;
  
  virtual LogicalResult
  matchAndRewrite(Operation *op, ArrayRef<Value> operands,
                  ConversionPatternRewriter &rewriter) const {
    if (failed(match(op)))
      return failure();
    rewrite(op, operands, rewriter);
    return success();
  }
};

// In .../llvm-project/mlir/lib/Transforms/Utils/DialectConversion.cpp
LogicalResult
ConversionPattern::matchAndRewrite(Operation *op,
                                PatternRewriter &rewriter) const {
    auto &dialectRewriter = static_cast<ConversionPatternRewriter &>(rewriter);
    auto &rewriterImpl = dialectRewriter.getImpl();

    // Track the current conversion pattern type converter in the rewriter.
    llvm::SaveAndRestore currentConverterGuard(rewriterImpl.currentTypeConverter,
                                                getTypeConverter());

    // Remap the operands of the operation.
    SmallVector<Value, 4> operands;
    if (failed(rewriterImpl.remapValues("operand", op->getLoc(), rewriter,
                                        op->getOperands(), operands))) {
        return failure();
    }
    return matchAndRewrite(op, operands, dialectRewriter);
}
```
`rewriterImpl.remapValues()` 的作用: 在转换的过程中, 被转换的方言会被保存在 `rewriterImpl` 中, 形成一个 高级方言 -> 目标方言 的映射关系. 转换过程中, 为了保证当前方言获取到转换后 最新版本的方言, 通过该方法 将 `op->getOperands()` 映射到 `operand`.
随后调用一个新的 `matchAndRewrite` 方法. 该方法默认返回值为 `failure()`. 需要使用该派生类时, 我们需要重写 
``` cpp
LogicalResult 
matchAndRewrite(Operation *op, ArrayRef<Value> operands, ConversionPatternRewriter &rewriter) const
```
方法.

#### 4.3 `OpConversionPattern`
- `OpConversionPattern` 继承于 `ConversionPattern`

`OpConversionPattern` 与 `ConversionPattern` 的关系和 `OpRewritePattern` 与 `RewritePattern` 关系类似, 用于在编译期指定单个 `Op`, 针对该 `Op` 进行转换操作.

``` cpp
template <typename SourceOp>
class OpConversionPattern : public ConversionPattern {
    OpConversionPattern(MLIRContext *context, PatternBenefit benefit = 1)
      : ConversionPattern(SourceOp::getOperationName(), benefit, context) {}
    
    ...

    LogicalResult
    matchAndRewrite(Operation *op, ArrayRef<Value> operands,
                  ConversionPatternRewriter &rewriter) const final {
        auto sourceOp = cast<SourceOp>(op);
        return matchAndRewrite(sourceOp, OpAdaptor(operands, sourceOp), rewriter);
    }

    virtual LogicalResult
    matchAndRewrite(SourceOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const {
        if (failed(match(op)))
        return failure();
        rewrite(op, adaptor, rewriter);
        return success();
    }
};
```
也是将 `ConversionPattern` 的 `matchAndRewrite` 方法的接口进一步转换为更加可用的接口, `OpAdaptor` 有更高层次的访问方法. 更容易使用.

#### 4.4 如何选用三种 `RewritePattern`.

1. 如果该 `RewritePattern` 面向的 `Op` 含有可能被转换的 `operand`, 避免使用 `OpRewritePattern`, 因为通过 `Op` 访问 `operand`, 获取到的值可能是转换前的值, `rewriter.replaceOp()` 会修改 `operand` 但是 `ConversionPatternRewriter` 还允许预先添加一些映射关系, 将 `Value` 转换到预设的值上.
2. 如果该 `RewritePattern` 只针对一个 `Op` 则选用 `OpConversionPattern`, 而如果通过一个 `RewritePattern` 转换多个 `Op` 则可以通过 `ConversionPattern`, 可以重写 `match` 方法匹配多个 `Op`.

### 5. `RewriterBase::replaceOp`
#### TODO
- [ ] rewriteListener->notifyOperationReplaced(from, to)
#### `replaceOp`

- 原型: `void RewriterBase::replaceOp(Operation *op, ValueRange newValues)`.
- 该方法用于将原 `op` 的 `results` 全部替换为 `newValues`, 将 `results` 作为 `operands` 的其他 `operations` 也会将对应的 `operand` 修改为 `newValues`.
- 以下源码中 `RewriterBase::xxx` 方法定义在 `.../llvm-project/mlir/lib/IR/PatternMatch.cpp`.

```cpp
void RewriterBase::replaceOp(Operation *op, ValueRange newValues) {
    assert(op->getNumResults() == newValues.size() &&
            "incorrect # of replacement values");

    // Replace all result uses. Also notifies the listener of modifications.
    replaceAllOpUsesWith(op, newValues);

    // Erase op and notify listener.
    eraseOp(op);
}
```
`replace` 调用 `replaceAllOpUsesWith` 后, 释放原 `op`.

```cpp
void RewriterBase::replaceAllOpUsesWith(Operation *from, ValueRange to) {
    // Notify the listener that we're about to replace this op.
    if (auto *rewriteListener = dyn_cast_if_present<Listener>(listener))
        rewriteListener->notifyOperationReplaced(from, to);

    replaceAllUsesWith(from->getResults(), to);
}
```
`replaceAllOpUsesWith` 调用 `replaceAllUsesWith`. 并将 `replace` 过程记录到 `listener` (应该是? 但实现好像是一个空函数, 不过这个也没有实际用到)
```cpp
  void replaceAllUsesWith(ValueRange from, ValueRange to) {
    assert(from.size() == to.size() && "incorrect number of replacements");
    for (auto it : llvm::zip(from, to))
      replaceAllUsesWith(std::get<0>(it), std::get<1>(it));
  }

  void replaceAllUsesWith(Value from, Value to) {
    for (OpOperand &operand : llvm::make_early_inc_range(from.getUses())) {
      Operation *op = operand.getOwner();
      modifyOpInPlace(op, [&]() { operand.set(to); });
    }
  }
```
`operand` 同时是一个链表和树中的节点, 向上获取 `operation`, 横向获取前驱和后继 `operand`.
通过原 `Value from` 获取指向 `Value` 的 `operand` 和 `operand` 的父 `op`. 进一步调用 `modifyOpInPlace` 执行回调函数修改 `operand` 引用的 `Value`.

```cpp
    template <typename CallableT>
    void modifyOpInPlace(Operation *root, CallableT &&callable) {
        startOpModification(root);
        callable();
        finalizeOpModification(root);
    }
```
`startOpModification(root)` 用于通知 `builder` 执行就地操作, 避免多余的空间操作(分配内存后又立即释放). 调用完回调函数后, 执行 `finalizeOpModification(root)` 将 `builder` 恢复.
