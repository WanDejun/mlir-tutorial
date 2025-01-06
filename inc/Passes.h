#include "mlir/Pass/Pass.h"
#include <memory>

namespace mlir {
namespace toy {
/// Create a Shape Inference pass.
std::unique_ptr<mlir::Pass> createShapeInferencePass();
}  // namespace toy
}  // namespace mlir