module {
  toy.func @main() {
    %0 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %1 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [7.000000e+00, 8.000000e+00, 9.000000e+00]]> : tensor<2x3xf64>
    %2 = toy.cast %0 : tensor<2x3xf64> to tensor<2x3xf64>
    %3 = toy.cast %1 : tensor<2x3xf64> to tensor<2x3xf64>
    %4 = toy.transpose(%2 : tensor<2x3xf64>) to tensor<3x2xf64>
    %5 = toy.transpose(%3 : tensor<2x3xf64>) to tensor<3x2xf64>
    %6 = toy.mul %4, %5 : tensor<3x2xf64>
    %7 = toy.mul %5, %4 : tensor<3x2xf64>
    %8 = toy.transpose(%6 : tensor<3x2xf64>) to tensor<2x3xf64>
    %9 = toy.transpose(%7 : tensor<3x2xf64>) to tensor<2x3xf64>
    %10 = toy.mul %8, %9 : tensor<2x3xf64>
    %11 = toy.mul %4, %8 : (tensor<3x2xf64>, tensor<2x3xf64>) -> tensor<3x2xf64>
    %12 = toy.mul %10, %11 : (tensor<2x3xf64>, tensor<3x2xf64>) -> tensor<2x3xf64>
    toy.print %12 : tensor<2x3xf64>
    toy.return
  }
}