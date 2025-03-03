# 添加组合类型(类型系统)

mlir 的数据流中最重要的组件包括 `mlir::Type`, `mlir::Value`, 其中 `Value` 由 `Op::builder` 产生, 而 `Type` 是本节的重点.

在前几节内容中, 唯一出现的 `Type` 是 `mlir::TensorType`, 而本节中, 我们想要向 `ToyDialect` 中添加一个 `Struct` 的用户定义类型.

## 前端
### lexer
需要添加 `Struct` 关键字, 将 `Struct` 解析为一个 `tok_Struct`. 添加 `.` 成员运算符, 用于获取 `Struct` 的成员变量.

### AST
`Struct` 相关的功能包括: **定义, 和访问**. 对应 `StructAST` 和 `BinaryOperation`. 由于 `StructAST` 可以被定义在全局 `module` 下, 不产生返回值. 因此为了方便, 将其和 `FunctionAST` 划分为 `RecordAST` 便于管理.

### Parser
要考虑将 `StructConstant` 和 `StructAccess` 对应到 `ToyDialect` 上.

## IR
### 添加类型
为了与 `Parser` 对应, 需要新增 `StructConstantOp` 和 `StructAccessOp`, 前者用于表示初始化列表, 后者表示访问结构体成员. 新增 `Toy_StructType`:

``` Tablegen
def Toy_StructType :
    DialectType<Toy_Dialect, CPred<"$_self.isa<StructType>()">,
                "Toy struct type">;

def Toy_Type : AnyTypeOf<[F64Tensor, Toy_StructType]>;
```

将 `ReturnOp`, `CallOp`等 的参数换成 `Toy_Type`.

编写与 `Dialect` 对应的 `StructType` cpp类型用于保存类型信息, `mlir` 提供了 `TypeBase` 用于辅助构造:
```cpp
class StructType : public mlir::Type::TypeBase<StructType, mlir::Type,
                                               StructTypeStorage> {
    ...
};
```

- 在构建 `StructConstantOp` 时, 通过将 `Type` 设置为 `tensor<*x64>` 可以避免函数内联时的隐式类型转换. 在内联之后, 再由 `constantOp::InferShape` 推断.

定义 `Struct` 类型的 `print` 和 `parser`.

### 优化
**常量折叠**. `mlir::Operation *ToyDialect::materializeConstant` 用于创建常量, 可以在常量创建时检查是否可折叠(避免二次创建). 需要对应的方法包含 `ConstantLike Trait` 和 `fold` 方法. 在 `Tablegen` 中向 `Operation` 添加 `hasFold` 位标记, 声明 `fold` 方法, 需要用户实现, 该方法返回 `Value` 值, `materializeConstant` 会更具值进行比较.

**内联**, 函数内联之后, 所有结构体定义和使用均在 `main` 函数中, 此时执行 `CSE` 优化, 会将对结构体成员的调用直接对应到定义时的 `Value` 上, 从而消除所有的结构体操作. 到此可以接着复用已有的管线编译到 `llvm`.