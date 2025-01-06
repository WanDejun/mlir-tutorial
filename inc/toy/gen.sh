mlir-tblgen -gen-op-decls Ops.td > Ops.h.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/
mlir-tblgen -gen-op-defs Ops.td > Ops.cpp.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/
mlir-tblgen -gen-dialect-decls Ops.td > Dialect.h.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/
mlir-tblgen -gen-dialect-defs Ops.td > Dialect.cpp.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/


mlir-tblgen -gen-op-interface-defs ShapeInferenceOpInterfaces.td -I /home/mowind/program/llvm-project/mlir/include/ > ShapeInferenceOpInterfaces.cpp.inc
mlir-tblgen -gen-op-interface-decls ShapeInferenceOpInterfaces.td -I /home/mowind/program/llvm-project/mlir/include/ > ShapeInferenceOpInterfaces.h.inc
