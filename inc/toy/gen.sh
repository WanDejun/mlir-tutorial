mlir-tblgen -gen-op-decls Ops.td > Ops.h.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/
mlir-tblgen -gen-op-defs Ops.td > Ops.cpp.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/
mlir-tblgen -gen-dialect-decls Ops.td > Dialect.h.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/
mlir-tblgen -gen-dialect-defs Ops.td > Dialect.cpp.inc -I /home/mowind/program/llvm-project/mlir/include -I /home/mowind/dev/mlir/tutorial/inc/


mlir-tblgen -gen-op-interface-defs ShapeInferenceOpInterface.td -I /home/mowind/program/llvm-project/mlir/include/ > ShapeInferenceOpInterface.cpp.inc
mlir-tblgen -gen-op-interface-decls ShapeInferenceOpInterface.td -I /home/mowind/program/llvm-project/mlir/include/ > ShapeInferenceOpInterface.h.inc

mlir-tblgen -gen-rewriters ToyCombine.td -I /home/mowind/program/llvm-project/mlir/include/ -I /home/mowind/dev/mlir/tutorial/inc/ > ToyCombine.inc