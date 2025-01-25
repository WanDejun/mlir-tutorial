module {
  func.func @main() {
    %cst = arith.constant 9.000000e+00 : f64
    %cst_0 = arith.constant 8.000000e+00 : f64
    %cst_1 = arith.constant 7.000000e+00 : f64
    %cst_2 = arith.constant 6.000000e+00 : f64
    %cst_3 = arith.constant 5.000000e+00 : f64
    %cst_4 = arith.constant 4.000000e+00 : f64
    %cst_5 = arith.constant 3.000000e+00 : f64
    %cst_6 = arith.constant 2.000000e+00 : f64
    %cst_7 = arith.constant 1.000000e+00 : f64
    %alloca = memref.alloca() : memref<2x3xf64>
    %alloca_8 = memref.alloca() : memref<3x2xf64>
    %alloca_9 = memref.alloca() : memref<3x2xf64>
    %alloca_10 = memref.alloca() : memref<3x2xf64>
    %alloca_11 = memref.alloca() : memref<3x2xf64>
    %alloca_12 = memref.alloca() : memref<2x3xf64>
    affine.store %cst_7, %alloca[0, 0] : memref<2x3xf64>
    affine.store %cst_6, %alloca[0, 1] : memref<2x3xf64>
    affine.store %cst_5, %alloca[0, 2] : memref<2x3xf64>
    affine.store %cst_4, %alloca[1, 0] : memref<2x3xf64>
    affine.store %cst_3, %alloca[1, 1] : memref<2x3xf64>
    affine.store %cst_2, %alloca[1, 2] : memref<2x3xf64>
    affine.store %cst_7, %alloca_12[0, 0] : memref<2x3xf64>
    affine.store %cst_6, %alloca_12[0, 1] : memref<2x3xf64>
    affine.store %cst_5, %alloca_12[0, 2] : memref<2x3xf64>
    affine.store %cst_1, %alloca_12[1, 0] : memref<2x3xf64>
    affine.store %cst_0, %alloca_12[1, 1] : memref<2x3xf64>
    affine.store %cst, %alloca_12[1, 2] : memref<2x3xf64>
    affine.for %arg0 = 0 to 3 {
      affine.for %arg1 = 0 to 2 {
        %0 = affine.load %alloca[%arg1, %arg0] : memref<2x3xf64>
        affine.store %0, %alloca_11[%arg0, %arg1] : memref<3x2xf64>
      }
    }
    affine.for %arg0 = 0 to 3 {
      affine.for %arg1 = 0 to 2 {
        %0 = affine.load %alloca_12[%arg1, %arg0] : memref<2x3xf64>
        affine.store %0, %alloca_10[%arg0, %arg1] : memref<3x2xf64>
      }
    }
    affine.for %arg0 = 0 to 3 {
      affine.for %arg1 = 0 to 2 {
        %0 = affine.load %alloca_11[%arg0, %arg1] : memref<3x2xf64>
        %1 = affine.load %alloca_10[%arg0, %arg1] : memref<3x2xf64>
        %2 = arith.mulf %0, %1 : f64
        affine.store %2, %alloca_9[%arg0, %arg1] : memref<3x2xf64>
      }
    }
    affine.for %arg0 = 0 to 3 {
      affine.for %arg1 = 0 to 2 {
        %0 = affine.load %alloca_9[%arg0, %arg1] : memref<3x2xf64>
        %1 = affine.load %alloca[%arg0, %arg1] : memref<2x3xf64>
        %2 = arith.addf %0, %1 : f64
        affine.store %2, %alloca_8[%arg0, %arg1] : memref<3x2xf64>
      }
    }
    toy.print %alloca_8 : memref<3x2xf64>
    memref.dealloc %alloca : memref<2x3xf64>
    memref.dealloc %alloca_12 : memref<2x3xf64>
    memref.dealloc %alloca_11 : memref<3x2xf64>
    memref.dealloc %alloca_10 : memref<3x2xf64>
    memref.dealloc %alloca_9 : memref<3x2xf64>
    memref.dealloc %alloca_8 : memref<3x2xf64>
    return
  }
}