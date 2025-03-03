//===- Dialect.h - Dialect definition for the Toy IR ----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the IR Dialect for the Toy language.
// See docs/Tutorials/Toy/Ch-2.md for more information.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_TUTORIAL_TOY_DIALECT_H_
#define MLIR_TUTORIAL_TOY_DIALECT_H_

#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/IR/Types.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/CastInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"


namespace mlir {
namespace toy {
namespace detail {
struct StructTypeStorage;
}  // namespace detail
}  // namespace toy
}  // namespace mlir

/// Include the auto-generated header file containing the declaration of the toy
/// dialect.
#include "toy/Dialect.h.inc"
#include "toy/ShapeInferenceInterfaces.h"
#include "llvm/ADT/ArrayRef.h"
#include <cstddef>


/// Include the auto-generated header file containing the declarations of the
/// toy operations.
#define GET_OP_CLASSES
#include "toy/Ops.h.inc"

//===----------------------------------------------------------------------===//
// Toy Struct Type
//===----------------------------------------------------------------------===//
namespace mlir {
namespace toy {
class StructType
    : public mlir::Type::TypeBase<StructType, mlir::Type, detail::StructTypeStorage> {
public:
    using Base::Base;
    // construct a StructType with the given elementTypes.
    static StructType get(llvm::ArrayRef<Type> elementTypes);

    llvm::ArrayRef<Type> getElementTypes();

    size_t getNumElementTypes() {
        return getElementTypes().size();
    }

    static constexpr StringLiteral name = "toy.struct";
};
}  // namespace toy
}  // namespace mlir

#endif  // MLIR_TUTORIAL_TOY_DIALECT_H_
