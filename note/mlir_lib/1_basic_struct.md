## 基础结构  
- `Operation` 包含 `Region` 包含 `Block` 包含 `Operation`.
### 1. Operation
包含 `Region` 数组, `Operand` 数组, `Value(result)` 数组, `location`, `StringRef OperationName` 等信息, 和对这些数据的操作接口.

### 2. Region  


### 3. Block  


### 4. OpState  
是一个 Operation 指针

#### 5. Op  
继承 `Opstate`, 用于创建 `Dialect` 的 `Op`, 除了继承 `OpState` 外, 还会多继承各种 `Traits`s, 用于表征每个 `Op` 的特殊属性(由 `mlir-tblgen` 自动生成).