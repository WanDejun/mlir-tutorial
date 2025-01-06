## 形状推断

- 为了方便函数编写, 我们函数类型均定义为形状无关的张量(对于张量形状的泛型).
- 但是在生成的 `mlir` 中我们希望知道具体的张量形状, 因为每个基本运算的形状是可以推断的.

### InlinerPasser
#### InlinerPasser
`mlir` 提供了一个 `InlinerPass` 用于更加便利的实现内联, 只需要
``` cpp
passManager.addPass(mlir::createInlinerPass());
```
即可向 `passManage` 添加 `InlinerPass`.

#### InlinerInterface
- 用于给 `InlinerPass` 提供必要信息, 例如:
- 1. 是否将 a 内联至 b 内.
- 2. 将 a 内联至 b 后, 如何处理 **原先a操作** 的返回值(`results`)
- 3. 由于函数参数均为 *无类型张量*, 而 `InlinerPass` 要求类型相同, 此时需要通过 `materializeCallConversion` 接口提供隐式类型转换.
- 4. etc..

#### 给 `CallOp` 添加 `CallOpInterface` 属性
用于告知 `InlinerPasser` 该 `Operation` 是函数调用.
向 `CallOp` 提供几个接口:
```cpp
CallInterfaceCallable GenericCallOp::getCallableForCallee();
void GenericCallOp::setCalleeFromCallable(CallInterfaceCallable callee);

Operation::operand_range GenericCallOp::getArgOperands();
MutableOperandRange GenericCallOp::getArgOperandsMutable();
```

获取, 设置调用函数的名字, 获取操作数(函数实参, 拷贝/引用形式).
