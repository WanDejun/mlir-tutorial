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

#### 3. `TypeID::get<ConcreteType>` 用于获取 `ConcreteType` 类型的 `TypeID`
``` cpp
template <typename T>
TypeID TypeID::get() {
  return detail::TypeIDResolver<T>::resolveTypeID();
}
```
``` cpp
class TypeIDResolver : public FallbackTypeIDResolver {
  ...
   {
    static_assert(is_fully_resolved<T>::value,
                  "TypeID::get<> requires the complete definition of `T`");
    static TypeID id = registerImplicitTypeID(llvm::getTypeName<T>());
    return id;
  }
}
```
同时注意 `static ::mlir::TypeID resolveTypeID()` 可以被特化以允许由类型实现者自定义 `resolveTypeID` 的实现. 例如 `Operation` 就在类声明时自定义 `getTypeID` 和 `resolveTypeID`, 并注册 `TypeID`.

`llvm::getTypeName<T>()` 用于获取 `T` 类型的类型名.

最终调用 `FallbackTypeIDResolver` 的 `registerImplicitTypeID` 方法. `FallbackTypeIDResolver` 方法内定义了一个静态 `registry` 用于保存 `StringRef` 到 `TypeID` 的映射. 若 `name` 已经被注册则返回 `TypeID`, 否则将 `name` 加入 `map` 并分配一个 `TypeID`.

``` cpp
TypeID detail::FallbackTypeIDResolver::registerImplicitTypeID(StringRef name) {
  static ImplicitTypeIDRegistry registry;
  return registry.lookupOrInsert(name);
}
```

#### 4. `TypeID` 的分配
`TypeID` 本质是个 `struct alignas(8) Storage {};` 类型的指针. 因此分配 `TypeID` 即分配一个唯一的地址, 这一工作由 `TypeIDAllocator` 完成, 所有的 `Allocator` 继承于 `BumpPtrAllocatorImpl` 由其负责在进程退出的时候对分配的内存进行释放.
``` cpp
/// This class provides a way to define new TypeIDs at runtime.
/// When the allocator is destructed, all allocated TypeIDs become invalid and
/// therefore should not be used.
class TypeIDAllocator {
public:
  /// Allocate a new TypeID, that is ensured to be unique for the lifetime
  /// of the TypeIDAllocator.
  TypeID allocate() { return TypeID(ids.Allocate()); }

private:
  /// The TypeIDs allocated are the addresses of the different storages.
  /// Keeping those in memory ensure uniqueness of the TypeIDs.
  llvm::SpecificBumpPtrAllocator<TypeID::Storage> ids;
};
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
