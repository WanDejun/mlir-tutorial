mlir-tblgen -gen-op-decls Ops.td > Ops.h.inc -I /home/mowind/program/llvm-project/mlir/include
mlir-tblgen -gen-op-defs Ops.td > Ops.cpp.inc -I /home/mowind/program/llvm-project/mlir/include
mlir-tblgen -gen-dialect-decls Ops.td > Dialect.h.inc -I /home/mowind/program/llvm-project/mlir/include
mlir-tblgen -gen-dialect-defs Ops.td > Dialect.cpp.inc -I /home/mowind/program/llvm-project/mlir/include
