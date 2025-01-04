module {
  toy.func private @multiply_transpose(%arg0: tensor<*xf64>, %arg1: tensor<*xf64>) -> tensor<*xf64> {
    %0 = toy.transpose(%arg0 : tensor<*xf64>) to tensor<*xf64>
    %1 = toy.transpose(%arg1 : tensor<*xf64>) to tensor<*xf64>
    %2 = toy.mul %0, %1 : tensor<*xf64>
    toy.return %2 : tensor<*xf64>
  }
  toy.func @main() {
    %0 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %1 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %2 = toy.generic_call @multiply_transpose(%0, %1) : (tensor<2x3xf64>, tensor<2x3xf64>) -> tensor<*xf64>
    %3 = toy.generic_call @multiply_transpose(%1, %0) : (tensor<2x3xf64>, tensor<2x3xf64>) -> tensor<*xf64>
    %4 = toy.generic_call @multiply_transpose(%2, %3) : (tensor<*xf64>, tensor<*xf64>) -> tensor<*xf64>
    %5 = toy.generic_call @multiply_transpose(%0, %2) : (tensor<2x3xf64>, tensor<*xf64>) -> tensor<*xf64>
    %6 = toy.mul %4, %5 : tensor<*xf64>
    toy.print %6 : tensor<*xf64>
    toy.return
  }
}