## Run Time Type Identifation (RTTI)  
- `llvm` 实现了一套独立与 `cpp std` 的 `rtti` 机制.
- 由于 `cpp std` 的 `rtti` 会对所有类型添加 `typeid` 信息, 如果有的类型不需要 `rtti` 机制, 多余的这些信息会造成时间和空间的浪费, 因此 `llvm` 提供了一个范式和一些操作接口, 由用户决定并实现哪些类型需要 `rtti`.
- **注意:** 只有 **向下/侧向** 的类型转换需要 `rtti`.

### cast<T>

### dyn_cast<T>

### isa<T>


### T::classof (核心)
- 以 `Operation` 的继承关系为例子.

#### 1. `Op` 继承自 `OpState` 和各种 `Trait`s.
#### 2. `Op` 中定义了 `static bool classof(Operation *op)` 方法:
``` cpp
  static bool classof(Operation *op) {
    if (auto info = op->getRegisteredInfo())
      return TypeID::get<ConcreteType>() == info->getTypeID();
    return false;
  }
```
#### llvm::getTypeName<T>()  
返回 `T` 的类型名, 该函数可以通过模版特化对 `T` 注册单独的 `TypeName`, `llvm` 也提供了默认的函数实现.
```cpp
template <typename DesiredTypeName>
inline StringRef getTypeName() {
#if defined(__clang__) || defined(__GNUC__)
  StringRef Name = __PRETTY_FUNCTION__;

  StringRef Key = "DesiredTypeName = ";
  Name = Name.substr(Name.find(Key));
  assert(!Name.empty() && "Unable to find the template parameter!");
  Name = Name.drop_front(Key.size());

  assert(Name.ends_with("]") && "Name doesn't end in the substitution key!");
  return Name.drop_back(1);
}
```
通过 `__PRETTY_FUNCTION__` 和泛型返回 `T` 在代码中的完整名字(包含 `namespace`)
