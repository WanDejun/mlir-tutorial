module {
  toy.func @main() {
    %0 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %1 = toy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %2 = toy.cast %0 : tensor<2x3xf64> to tensor<*xf64>
    %3 = toy.cast %1 : tensor<2x3xf64> to tensor<*xf64>
    %4 = toy.transpose(%2 : tensor<*xf64>) to tensor<*xf64>
    %5 = toy.transpose(%3 : tensor<*xf64>) to tensor<*xf64>
    %6 = toy.mul %4, %5 : tensor<*xf64>
    %7 = toy.cast %1 : tensor<2x3xf64> to tensor<*xf64>
    %8 = toy.cast %0 : tensor<2x3xf64> to tensor<*xf64>
    %9 = toy.transpose(%7 : tensor<*xf64>) to tensor<*xf64>
    %10 = toy.transpose(%8 : tensor<*xf64>) to tensor<*xf64>
    %11 = toy.mul %9, %10 : tensor<*xf64>
    %12 = toy.transpose(%6 : tensor<*xf64>) to tensor<*xf64>
    %13 = toy.transpose(%11 : tensor<*xf64>) to tensor<*xf64>
    %14 = toy.mul %12, %13 : tensor<*xf64>
    %15 = toy.cast %0 : tensor<2x3xf64> to tensor<*xf64>
    %16 = toy.transpose(%15 : tensor<*xf64>) to tensor<*xf64>
    %17 = toy.transpose(%6 : tensor<*xf64>) to tensor<*xf64>
    %18 = toy.mul %16, %17 : tensor<*xf64>
    %19 = toy.mul %14, %18 : tensor<*xf64>
    toy.print %19 : tensor<*xf64>
    toy.return
  }
}