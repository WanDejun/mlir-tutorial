#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Types.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/TypeID.h"

#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"

#include "Passes.h"
#include "toy/Dialect.h"
#include "toy/ShapeInferenceInterfaces.h"

#include <memory>

using namespace mlir;
using namespace toy;

#include "toy/ShapeInferenceOpInterfaces.cpp.inc"


// passer to do the Shape inference.
// walk in the toy::FuncOp find the operation with dynamic shape result but static shape
// input. Reshape this operation' result.
namespace {
struct ShapeInferencePass
    : public PassWrapper<ShapeInferencePass, OperationPass<toy::FuncOp>> {
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(ShapeInferencePass)

    void runOnOperation() override final {
        Operation* function = getOperation();
        // Populate the worklist with the operations that need shape inference:
        // these are operations that return a dynamic shape.
        llvm::SmallPtrSet<Operation*, 16> opWorklist;
        function->walk([&](Operation* Op) {
            if (returnsDynamicShape(Op)) {
                opWorklist.insert(Op);
            }
        });

        // Iterate on the operations in the worklist until all operations have been
        // inferred or no change happened (fix point).
        while (!opWorklist.empty()) {
            auto nextOpIter = llvm::find_if(opWorklist, allOperandsInferred);

            if (nextOpIter == opWorklist.end())
                break;

            Operation* nextOp = *nextOpIter;
            opWorklist.erase(nextOp);

            // LLVM_DEBUG(llvm::dbgs() << "Inferring shape for: " << *nextOp << "\n");
            if (auto shapeOp = llvm::dyn_cast<toy::ShapeInference>(nextOp)) {
                shapeOp.inferShapes();
            }
            else {
                nextOp->emitError(
                    "unable to infer shape of operation without shape "
                    "inference interface");
                return signalPassFailure();
            }
        }

        if (!opWorklist.empty()) {
            function->emitError("Shape inference failed, ")
                << opWorklist.size() << " operations couldn't be inferred\n";

            return signalPassFailure();
        }
    }

    static bool returnsDynamicShape(Operation* Op) {
        return llvm::any_of(Op->getResultTypes(), [](Type resultType) {
            return !llvm::isa<RankedTensorType>(resultType);
        });
    }

    static bool allOperandsInferred(Operation* Op) {
        return llvm::all_of(Op->getOperandTypes(), [](Type operandType) {
            return llvm::isa<RankedTensorType>(operandType);
        });
    }
};
}  // namespace


/// Create a Shape Inference pass.
std::unique_ptr<mlir::Pass> mlir::toy::createShapeInferencePass() {
    return std::make_unique<ShapeInferencePass>();
}
