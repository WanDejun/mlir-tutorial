#include "mlir/Pass/Pass.h"
#include <memory>

namespace mlir {
namespace toy {
/// Create a Shape Inference pass.
std::unique_ptr<mlir::Pass> createShapeInferencePass();

std::unique_ptr<mlir::Pass> createLowerToAffinePass();

std::unique_ptr<mlir::Pass> createLowerToLLVMPass();
}  // namespace toy
}  // namespace mlir