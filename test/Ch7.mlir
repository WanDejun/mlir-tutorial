module {
  toy.func @main() {
    %0 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [7.000000e+00, 8.000000e+00, 9.000000e+00]]> : tensor<2x3xf64>
    %1 = toy.constant dense<[[9.000000e+00, 8.000000e+00, 7.000000e+00], [1.200000e+01, 1.100000e+01, 1.000000e+01]]> : tensor<2x3xf64>
    %2 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %3 = toy.constant dense<[[6.000000e+00, 5.000000e+00, 4.000000e+00], [3.000000e+00, 2.000000e+00, 1.000000e+00]]> : tensor<2x3xf64>
    %4 = toy.mul %2, %3 : tensor<2x3xf64>
    %5 = toy.transpose(%4 : tensor<2x3xf64>) to tensor<3x2xf64>
    %6 = toy.mul %1, %0 : tensor<2x3xf64>
    %7 = toy.transpose(%6 : tensor<2x3xf64>) to tensor<3x2xf64>
    %8 = toy.mul %5, %7 : tensor<3x2xf64>
    toy.print %8 : tensor<3x2xf64>
    toy.return
  }
}