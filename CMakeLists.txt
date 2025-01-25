cmake_minimum_required(VERSION 3.20)
project(MLIRTutorial LANGUAGES CXX)

# Compiler and Flags
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options(-g -Wall -fno-rtti)

# Specify Clang/Clang++
set(CMAKE_C_COMPILER "/home/mowind/program/llvm-project/build/bin/clang")
set(CMAKE_CXX_COMPILER "/home/mowind/program/llvm-project/build/bin/clang++")

# Enable compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# LLVM and MLIR Paths
set(LLVM_DIR "/home/mowind/program/llvm-project/build/lib/cmake/llvm")
set(MLIR_DIR "/home/mowind/program/llvm-project/build/lib/cmake/mlir")

# Locate LLVM and MLIR
find_package(LLVM REQUIRED CONFIG)
find_package(MLIR REQUIRED CONFIG)

# Include MLIR and LLVM CMake Modules
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
include(TableGen)
include(AddLLVM)
include(AddMLIR)

# Paths for outputs
set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/../bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/../bin)

# Include and Link Directories
include_directories(${LLVM_INCLUDE_DIRS} ${MLIR_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS} ${MLIR_LIBRARY_DIRS})

# Set TableGen output include directory
include_directories(${CMAKE_BINARY_DIR}/../inc)
include_directories(${CMAKE_BINARY_DIR}/inc)
include_directories(${CMAKE_BINARY_DIR}/)

# TableGen: Generate ToyCombine.inc
set(LLVM_TARGET_DEFINITIONS src/toy/ToyCombine.td)
mlir_tablegen(ToyCombine.inc -gen-rewriters)
add_public_tablegen_target(ToyCombineIncGen)

# add_subdirectory()
add_subdirectory(${CMAKE_BINARY_DIR}/../inc)

# Add Toy Dialect
add_mlir_dialect(ToyOps toy)

# Add Executable
add_executable(Toy
  src/main.cpp
  src/AST.cpp
  src/MLIRGen.cpp
  src/toy/Dialect.cpp
  src/toy/ShapeInferencePasser.cpp
  src/toy/ToyCombine.cpp
  src/LowerToAffineLoops.cpp
)

# Add Dependencies on TableGen Targets
add_dependencies(Toy
  ToyCombineIncGen
  ToyOpsIncGen
  ToyShapeInferenceInterfaceIncGen
)

# Link Libraries
get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(extension_libs GLOBAL PROPERTY MLIR_EXTENSION_LIBS)

target_link_libraries(Toy
  PRIVATE
    ${dialect_libs}
    ${extension_libs}
    MLIRAnalysis
    MLIRCallInterfaces
    MLIRCastInterfaces
    MLIRFunctionInterfaces
    MLIRIR
    MLIRParser
    MLIRPass
    MLIRSideEffectInterfaces
    MLIRSupport
    MLIRTransforms
)

add_custom_target(run
  COMMAND ninja -j6
  COMMAND cd ${CMAKE_BINARY_DIR}/../bin 
  COMMAND ./Toy
)
