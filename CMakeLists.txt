cmake_minimum_required(VERSION 3.20)
project(MLIRTutorial LANGUAGES CXX)

add_compile_options(-g -Wall -fno-rtti)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # 生成 compile_commands.json 便于代码高亮
set(CMAKE_C_COMPILER "/home/mowind/program/llvm-project/build/bin//clang")
set(CMAKE_CXX_COMPILER "/home/mowind/program/llvm-project/build/bin/clang++")

# 设置C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# 找到LLVM和MLIR
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
find_package(LLVM REQUIRED CONFIG)
find_package(MLIR REQUIRED CONFIG)


# 设置LLVM/MLIR相关变量
set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})

link_directories(${LLVM_LIBRARY_DIRS})
link_directories(${MLIR_LIBRARY_DIRS})

add_definitions(${MLIR_LIBRARY_DIRS})


include_directories(${CMAKE_CURRENT_BINARY_DIR}/../inc)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/../bin)

add_executable(toy
  src/main.cpp
  src/AST.cpp
  src/MLIRGen.cpp
  src/toy/ToyCombine.cpp
  src/toy/Dialect.cpp
  )

target_link_libraries(toy
  MLIRAnalysis
  MLIRCallInterfaces
  MLIRCastInterfaces
  MLIRSupport
  LLVMSupport
  MLIRFunctionInterfaces
  MLIRIR
  MLIRParser
  MLIRPass
  MLIRSideEffectInterfaces
  MLIRTransforms
  )
  
  