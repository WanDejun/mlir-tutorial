module {
  llvm.func @free(!llvm.ptr)
  llvm.mlir.global internal constant @nl("\0A") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @frmt_spec("%f ") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  llvm.func @main() {
    %0 = llvm.mlir.constant(6.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(5.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(4.000000e+00 : f64) : f64
    %3 = llvm.mlir.constant(1.000000e+01 : f64) : f64
    %4 = llvm.mlir.constant(1.100000e+01 : f64) : f64
    %5 = llvm.mlir.constant(1.200000e+01 : f64) : f64
    %6 = llvm.mlir.constant(9.000000e+00 : f64) : f64
    %7 = llvm.mlir.constant(8.000000e+00 : f64) : f64
    %8 = llvm.mlir.constant(7.000000e+00 : f64) : f64
    %9 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %10 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %11 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %12 = llvm.mlir.constant(2 : index) : i64
    %13 = llvm.mlir.constant(3 : index) : i64
    %14 = llvm.mlir.constant(1 : index) : i64
    %15 = llvm.mlir.constant(6 : index) : i64
    %16 = llvm.alloca %15 x f64 : (i64) -> !llvm.ptr
    %17 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %18 = llvm.insertvalue %16, %17[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %16, %18[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.mlir.constant(0 : index) : i64
    %21 = llvm.insertvalue %20, %19[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %12, %21[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %13, %22[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %13, %23[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %14, %24[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.mlir.constant(3 : index) : i64
    %27 = llvm.mlir.constant(2 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.constant(6 : index) : i64
    %30 = llvm.alloca %29 x f64 : (i64) -> !llvm.ptr
    %31 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %32 = llvm.insertvalue %30, %31[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %30, %32[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.mlir.constant(0 : index) : i64
    %35 = llvm.insertvalue %34, %33[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.insertvalue %26, %35[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.insertvalue %27, %36[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.insertvalue %27, %37[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %28, %38[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mlir.constant(3 : index) : i64
    %41 = llvm.mlir.constant(2 : index) : i64
    %42 = llvm.mlir.constant(1 : index) : i64
    %43 = llvm.mlir.constant(6 : index) : i64
    %44 = llvm.alloca %43 x f64 : (i64) -> !llvm.ptr
    %45 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %46 = llvm.insertvalue %44, %45[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.insertvalue %44, %46[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.mlir.constant(0 : index) : i64
    %49 = llvm.insertvalue %48, %47[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.insertvalue %40, %49[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %51 = llvm.insertvalue %41, %50[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.insertvalue %41, %51[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.insertvalue %42, %52[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.mlir.constant(2 : index) : i64
    %55 = llvm.mlir.constant(3 : index) : i64
    %56 = llvm.mlir.constant(1 : index) : i64
    %57 = llvm.mlir.constant(6 : index) : i64
    %58 = llvm.alloca %57 x f64 : (i64) -> !llvm.ptr
    %59 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %60 = llvm.insertvalue %58, %59[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %61 = llvm.insertvalue %58, %60[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.mlir.constant(0 : index) : i64
    %63 = llvm.insertvalue %62, %61[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %64 = llvm.insertvalue %54, %63[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %65 = llvm.insertvalue %55, %64[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %66 = llvm.insertvalue %55, %65[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.insertvalue %56, %66[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.mlir.constant(3 : index) : i64
    %69 = llvm.mlir.constant(2 : index) : i64
    %70 = llvm.mlir.constant(1 : index) : i64
    %71 = llvm.mlir.constant(6 : index) : i64
    %72 = llvm.alloca %71 x f64 : (i64) -> !llvm.ptr
    %73 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %74 = llvm.insertvalue %72, %73[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.insertvalue %72, %74[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %76 = llvm.mlir.constant(0 : index) : i64
    %77 = llvm.insertvalue %76, %75[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %78 = llvm.insertvalue %68, %77[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %79 = llvm.insertvalue %69, %78[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %80 = llvm.insertvalue %69, %79[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %81 = llvm.insertvalue %70, %80[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %82 = llvm.mlir.constant(2 : index) : i64
    %83 = llvm.mlir.constant(3 : index) : i64
    %84 = llvm.mlir.constant(1 : index) : i64
    %85 = llvm.mlir.constant(6 : index) : i64
    %86 = llvm.alloca %85 x f64 : (i64) -> !llvm.ptr
    %87 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %88 = llvm.insertvalue %86, %87[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %89 = llvm.insertvalue %86, %88[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.mlir.constant(0 : index) : i64
    %91 = llvm.insertvalue %90, %89[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.insertvalue %82, %91[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %93 = llvm.insertvalue %83, %92[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %94 = llvm.insertvalue %83, %93[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %95 = llvm.insertvalue %84, %94[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %96 = llvm.mlir.constant(2 : index) : i64
    %97 = llvm.mlir.constant(3 : index) : i64
    %98 = llvm.mlir.constant(1 : index) : i64
    %99 = llvm.mlir.constant(6 : index) : i64
    %100 = llvm.alloca %99 x f64 : (i64) -> !llvm.ptr
    %101 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %102 = llvm.insertvalue %100, %101[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %103 = llvm.insertvalue %100, %102[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %104 = llvm.mlir.constant(0 : index) : i64
    %105 = llvm.insertvalue %104, %103[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %106 = llvm.insertvalue %96, %105[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %107 = llvm.insertvalue %97, %106[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %108 = llvm.insertvalue %97, %107[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %109 = llvm.insertvalue %98, %108[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %110 = llvm.mlir.constant(2 : index) : i64
    %111 = llvm.mlir.constant(3 : index) : i64
    %112 = llvm.mlir.constant(1 : index) : i64
    %113 = llvm.mlir.constant(6 : index) : i64
    %114 = llvm.alloca %113 x f64 : (i64) -> !llvm.ptr
    %115 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %116 = llvm.insertvalue %114, %115[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %117 = llvm.insertvalue %114, %116[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %118 = llvm.mlir.constant(0 : index) : i64
    %119 = llvm.insertvalue %118, %117[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %120 = llvm.insertvalue %110, %119[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %121 = llvm.insertvalue %111, %120[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %122 = llvm.insertvalue %111, %121[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %123 = llvm.insertvalue %112, %122[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %124 = llvm.mlir.constant(2 : index) : i64
    %125 = llvm.mlir.constant(3 : index) : i64
    %126 = llvm.mlir.constant(1 : index) : i64
    %127 = llvm.mlir.constant(6 : index) : i64
    %128 = llvm.alloca %127 x f64 : (i64) -> !llvm.ptr
    %129 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %130 = llvm.insertvalue %128, %129[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %131 = llvm.insertvalue %128, %130[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %132 = llvm.mlir.constant(0 : index) : i64
    %133 = llvm.insertvalue %132, %131[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %134 = llvm.insertvalue %124, %133[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %135 = llvm.insertvalue %125, %134[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %136 = llvm.insertvalue %125, %135[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %137 = llvm.insertvalue %126, %136[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %138 = llvm.mlir.constant(0 : index) : i64
    %139 = llvm.mlir.constant(0 : index) : i64
    %140 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %141 = llvm.mlir.constant(3 : index) : i64
    %142 = llvm.mul %138, %141 : i64
    %143 = llvm.add %142, %139 : i64
    %144 = llvm.getelementptr %140[%143] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %11, %144 : f64, !llvm.ptr
    %145 = llvm.mlir.constant(0 : index) : i64
    %146 = llvm.mlir.constant(1 : index) : i64
    %147 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %148 = llvm.mlir.constant(3 : index) : i64
    %149 = llvm.mul %145, %148 : i64
    %150 = llvm.add %149, %146 : i64
    %151 = llvm.getelementptr %147[%150] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %10, %151 : f64, !llvm.ptr
    %152 = llvm.mlir.constant(0 : index) : i64
    %153 = llvm.mlir.constant(2 : index) : i64
    %154 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %155 = llvm.mlir.constant(3 : index) : i64
    %156 = llvm.mul %152, %155 : i64
    %157 = llvm.add %156, %153 : i64
    %158 = llvm.getelementptr %154[%157] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %9, %158 : f64, !llvm.ptr
    %159 = llvm.mlir.constant(1 : index) : i64
    %160 = llvm.mlir.constant(0 : index) : i64
    %161 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %162 = llvm.mlir.constant(3 : index) : i64
    %163 = llvm.mul %159, %162 : i64
    %164 = llvm.add %163, %160 : i64
    %165 = llvm.getelementptr %161[%164] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %165 : f64, !llvm.ptr
    %166 = llvm.mlir.constant(1 : index) : i64
    %167 = llvm.mlir.constant(1 : index) : i64
    %168 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %169 = llvm.mlir.constant(3 : index) : i64
    %170 = llvm.mul %166, %169 : i64
    %171 = llvm.add %170, %167 : i64
    %172 = llvm.getelementptr %168[%171] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %7, %172 : f64, !llvm.ptr
    %173 = llvm.mlir.constant(1 : index) : i64
    %174 = llvm.mlir.constant(2 : index) : i64
    %175 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %176 = llvm.mlir.constant(3 : index) : i64
    %177 = llvm.mul %173, %176 : i64
    %178 = llvm.add %177, %174 : i64
    %179 = llvm.getelementptr %175[%178] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %179 : f64, !llvm.ptr
    %180 = llvm.mlir.constant(0 : index) : i64
    %181 = llvm.mlir.constant(0 : index) : i64
    %182 = llvm.extractvalue %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %183 = llvm.mlir.constant(3 : index) : i64
    %184 = llvm.mul %180, %183 : i64
    %185 = llvm.add %184, %181 : i64
    %186 = llvm.getelementptr %182[%185] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %186 : f64, !llvm.ptr
    %187 = llvm.mlir.constant(0 : index) : i64
    %188 = llvm.mlir.constant(1 : index) : i64
    %189 = llvm.extractvalue %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %190 = llvm.mlir.constant(3 : index) : i64
    %191 = llvm.mul %187, %190 : i64
    %192 = llvm.add %191, %188 : i64
    %193 = llvm.getelementptr %189[%192] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %7, %193 : f64, !llvm.ptr
    %194 = llvm.mlir.constant(0 : index) : i64
    %195 = llvm.mlir.constant(2 : index) : i64
    %196 = llvm.extractvalue %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %197 = llvm.mlir.constant(3 : index) : i64
    %198 = llvm.mul %194, %197 : i64
    %199 = llvm.add %198, %195 : i64
    %200 = llvm.getelementptr %196[%199] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %200 : f64, !llvm.ptr
    %201 = llvm.mlir.constant(1 : index) : i64
    %202 = llvm.mlir.constant(0 : index) : i64
    %203 = llvm.extractvalue %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %204 = llvm.mlir.constant(3 : index) : i64
    %205 = llvm.mul %201, %204 : i64
    %206 = llvm.add %205, %202 : i64
    %207 = llvm.getelementptr %203[%206] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %207 : f64, !llvm.ptr
    %208 = llvm.mlir.constant(1 : index) : i64
    %209 = llvm.mlir.constant(1 : index) : i64
    %210 = llvm.extractvalue %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %211 = llvm.mlir.constant(3 : index) : i64
    %212 = llvm.mul %208, %211 : i64
    %213 = llvm.add %212, %209 : i64
    %214 = llvm.getelementptr %210[%213] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %4, %214 : f64, !llvm.ptr
    %215 = llvm.mlir.constant(1 : index) : i64
    %216 = llvm.mlir.constant(2 : index) : i64
    %217 = llvm.extractvalue %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %218 = llvm.mlir.constant(3 : index) : i64
    %219 = llvm.mul %215, %218 : i64
    %220 = llvm.add %219, %216 : i64
    %221 = llvm.getelementptr %217[%220] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %221 : f64, !llvm.ptr
    %222 = llvm.mlir.constant(0 : index) : i64
    %223 = llvm.mlir.constant(0 : index) : i64
    %224 = llvm.extractvalue %123[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %225 = llvm.mlir.constant(3 : index) : i64
    %226 = llvm.mul %222, %225 : i64
    %227 = llvm.add %226, %223 : i64
    %228 = llvm.getelementptr %224[%227] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %11, %228 : f64, !llvm.ptr
    %229 = llvm.mlir.constant(0 : index) : i64
    %230 = llvm.mlir.constant(1 : index) : i64
    %231 = llvm.extractvalue %123[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %232 = llvm.mlir.constant(3 : index) : i64
    %233 = llvm.mul %229, %232 : i64
    %234 = llvm.add %233, %230 : i64
    %235 = llvm.getelementptr %231[%234] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %10, %235 : f64, !llvm.ptr
    %236 = llvm.mlir.constant(0 : index) : i64
    %237 = llvm.mlir.constant(2 : index) : i64
    %238 = llvm.extractvalue %123[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %239 = llvm.mlir.constant(3 : index) : i64
    %240 = llvm.mul %236, %239 : i64
    %241 = llvm.add %240, %237 : i64
    %242 = llvm.getelementptr %238[%241] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %9, %242 : f64, !llvm.ptr
    %243 = llvm.mlir.constant(1 : index) : i64
    %244 = llvm.mlir.constant(0 : index) : i64
    %245 = llvm.extractvalue %123[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %246 = llvm.mlir.constant(3 : index) : i64
    %247 = llvm.mul %243, %246 : i64
    %248 = llvm.add %247, %244 : i64
    %249 = llvm.getelementptr %245[%248] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %2, %249 : f64, !llvm.ptr
    %250 = llvm.mlir.constant(1 : index) : i64
    %251 = llvm.mlir.constant(1 : index) : i64
    %252 = llvm.extractvalue %123[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %253 = llvm.mlir.constant(3 : index) : i64
    %254 = llvm.mul %250, %253 : i64
    %255 = llvm.add %254, %251 : i64
    %256 = llvm.getelementptr %252[%255] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %1, %256 : f64, !llvm.ptr
    %257 = llvm.mlir.constant(1 : index) : i64
    %258 = llvm.mlir.constant(2 : index) : i64
    %259 = llvm.extractvalue %123[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %260 = llvm.mlir.constant(3 : index) : i64
    %261 = llvm.mul %257, %260 : i64
    %262 = llvm.add %261, %258 : i64
    %263 = llvm.getelementptr %259[%262] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %263 : f64, !llvm.ptr
    %264 = llvm.mlir.constant(0 : index) : i64
    %265 = llvm.mlir.constant(0 : index) : i64
    %266 = llvm.extractvalue %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %267 = llvm.mlir.constant(3 : index) : i64
    %268 = llvm.mul %264, %267 : i64
    %269 = llvm.add %268, %265 : i64
    %270 = llvm.getelementptr %266[%269] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %270 : f64, !llvm.ptr
    %271 = llvm.mlir.constant(0 : index) : i64
    %272 = llvm.mlir.constant(1 : index) : i64
    %273 = llvm.extractvalue %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %274 = llvm.mlir.constant(3 : index) : i64
    %275 = llvm.mul %271, %274 : i64
    %276 = llvm.add %275, %272 : i64
    %277 = llvm.getelementptr %273[%276] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %1, %277 : f64, !llvm.ptr
    %278 = llvm.mlir.constant(0 : index) : i64
    %279 = llvm.mlir.constant(2 : index) : i64
    %280 = llvm.extractvalue %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %281 = llvm.mlir.constant(3 : index) : i64
    %282 = llvm.mul %278, %281 : i64
    %283 = llvm.add %282, %279 : i64
    %284 = llvm.getelementptr %280[%283] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %2, %284 : f64, !llvm.ptr
    %285 = llvm.mlir.constant(1 : index) : i64
    %286 = llvm.mlir.constant(0 : index) : i64
    %287 = llvm.extractvalue %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %288 = llvm.mlir.constant(3 : index) : i64
    %289 = llvm.mul %285, %288 : i64
    %290 = llvm.add %289, %286 : i64
    %291 = llvm.getelementptr %287[%290] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %9, %291 : f64, !llvm.ptr
    %292 = llvm.mlir.constant(1 : index) : i64
    %293 = llvm.mlir.constant(1 : index) : i64
    %294 = llvm.extractvalue %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %295 = llvm.mlir.constant(3 : index) : i64
    %296 = llvm.mul %292, %295 : i64
    %297 = llvm.add %296, %293 : i64
    %298 = llvm.getelementptr %294[%297] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %10, %298 : f64, !llvm.ptr
    %299 = llvm.mlir.constant(1 : index) : i64
    %300 = llvm.mlir.constant(2 : index) : i64
    %301 = llvm.extractvalue %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %302 = llvm.mlir.constant(3 : index) : i64
    %303 = llvm.mul %299, %302 : i64
    %304 = llvm.add %303, %300 : i64
    %305 = llvm.getelementptr %301[%304] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %11, %305 : f64, !llvm.ptr
    %306 = llvm.mlir.constant(0 : index) : i64
    %307 = llvm.mlir.constant(2 : index) : i64
    %308 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb1(%306 : i64)
  ^bb1(%309: i64):  // 2 preds: ^bb0, ^bb5
    %310 = llvm.icmp "slt" %309, %307 : i64
    llvm.cond_br %310, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    %311 = llvm.mlir.constant(0 : index) : i64
    %312 = llvm.mlir.constant(3 : index) : i64
    %313 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb3(%311 : i64)
  ^bb3(%314: i64):  // 2 preds: ^bb2, ^bb4
    %315 = llvm.icmp "slt" %314, %312 : i64
    llvm.cond_br %315, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %316 = llvm.extractvalue %123[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %317 = llvm.mlir.constant(3 : index) : i64
    %318 = llvm.mul %309, %317 : i64
    %319 = llvm.add %318, %314 : i64
    %320 = llvm.getelementptr %316[%319] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %321 = llvm.load %320 : !llvm.ptr -> f64
    %322 = llvm.extractvalue %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %323 = llvm.mlir.constant(3 : index) : i64
    %324 = llvm.mul %309, %323 : i64
    %325 = llvm.add %324, %314 : i64
    %326 = llvm.getelementptr %322[%325] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %327 = llvm.load %326 : !llvm.ptr -> f64
    %328 = llvm.fmul %321, %327 : f64
    %329 = llvm.extractvalue %95[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %330 = llvm.mlir.constant(3 : index) : i64
    %331 = llvm.mul %309, %330 : i64
    %332 = llvm.add %331, %314 : i64
    %333 = llvm.getelementptr %329[%332] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %328, %333 : f64, !llvm.ptr
    %334 = llvm.add %314, %313 : i64
    llvm.br ^bb3(%334 : i64)
  ^bb5:  // pred: ^bb3
    %335 = llvm.add %309, %308 : i64
    llvm.br ^bb1(%335 : i64)
  ^bb6:  // pred: ^bb1
    %336 = llvm.mlir.constant(0 : index) : i64
    %337 = llvm.mlir.constant(3 : index) : i64
    %338 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb7(%336 : i64)
  ^bb7(%339: i64):  // 2 preds: ^bb6, ^bb11
    %340 = llvm.icmp "slt" %339, %337 : i64
    llvm.cond_br %340, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    %341 = llvm.mlir.constant(0 : index) : i64
    %342 = llvm.mlir.constant(2 : index) : i64
    %343 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb9(%341 : i64)
  ^bb9(%344: i64):  // 2 preds: ^bb8, ^bb10
    %345 = llvm.icmp "slt" %344, %342 : i64
    llvm.cond_br %345, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %346 = llvm.extractvalue %95[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %347 = llvm.mlir.constant(3 : index) : i64
    %348 = llvm.mul %344, %347 : i64
    %349 = llvm.add %348, %339 : i64
    %350 = llvm.getelementptr %346[%349] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %351 = llvm.load %350 : !llvm.ptr -> f64
    %352 = llvm.extractvalue %81[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %353 = llvm.mlir.constant(2 : index) : i64
    %354 = llvm.mul %339, %353 : i64
    %355 = llvm.add %354, %344 : i64
    %356 = llvm.getelementptr %352[%355] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %351, %356 : f64, !llvm.ptr
    %357 = llvm.add %344, %343 : i64
    llvm.br ^bb9(%357 : i64)
  ^bb11:  // pred: ^bb9
    %358 = llvm.add %339, %338 : i64
    llvm.br ^bb7(%358 : i64)
  ^bb12:  // pred: ^bb7
    %359 = llvm.mlir.constant(0 : index) : i64
    %360 = llvm.mlir.constant(2 : index) : i64
    %361 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb13(%359 : i64)
  ^bb13(%362: i64):  // 2 preds: ^bb12, ^bb17
    %363 = llvm.icmp "slt" %362, %360 : i64
    llvm.cond_br %363, ^bb14, ^bb18
  ^bb14:  // pred: ^bb13
    %364 = llvm.mlir.constant(0 : index) : i64
    %365 = llvm.mlir.constant(3 : index) : i64
    %366 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb15(%364 : i64)
  ^bb15(%367: i64):  // 2 preds: ^bb14, ^bb16
    %368 = llvm.icmp "slt" %367, %365 : i64
    llvm.cond_br %368, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %369 = llvm.extractvalue %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %370 = llvm.mlir.constant(3 : index) : i64
    %371 = llvm.mul %362, %370 : i64
    %372 = llvm.add %371, %367 : i64
    %373 = llvm.getelementptr %369[%372] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %374 = llvm.load %373 : !llvm.ptr -> f64
    %375 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %376 = llvm.mlir.constant(3 : index) : i64
    %377 = llvm.mul %362, %376 : i64
    %378 = llvm.add %377, %367 : i64
    %379 = llvm.getelementptr %375[%378] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %380 = llvm.load %379 : !llvm.ptr -> f64
    %381 = llvm.fmul %374, %380 : f64
    %382 = llvm.extractvalue %67[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %383 = llvm.mlir.constant(3 : index) : i64
    %384 = llvm.mul %362, %383 : i64
    %385 = llvm.add %384, %367 : i64
    %386 = llvm.getelementptr %382[%385] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %381, %386 : f64, !llvm.ptr
    %387 = llvm.add %367, %366 : i64
    llvm.br ^bb15(%387 : i64)
  ^bb17:  // pred: ^bb15
    %388 = llvm.add %362, %361 : i64
    llvm.br ^bb13(%388 : i64)
  ^bb18:  // pred: ^bb13
    %389 = llvm.mlir.constant(0 : index) : i64
    %390 = llvm.mlir.constant(3 : index) : i64
    %391 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb19(%389 : i64)
  ^bb19(%392: i64):  // 2 preds: ^bb18, ^bb23
    %393 = llvm.icmp "slt" %392, %390 : i64
    llvm.cond_br %393, ^bb20, ^bb24
  ^bb20:  // pred: ^bb19
    %394 = llvm.mlir.constant(0 : index) : i64
    %395 = llvm.mlir.constant(2 : index) : i64
    %396 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb21(%394 : i64)
  ^bb21(%397: i64):  // 2 preds: ^bb20, ^bb22
    %398 = llvm.icmp "slt" %397, %395 : i64
    llvm.cond_br %398, ^bb22, ^bb23
  ^bb22:  // pred: ^bb21
    %399 = llvm.extractvalue %67[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %400 = llvm.mlir.constant(3 : index) : i64
    %401 = llvm.mul %397, %400 : i64
    %402 = llvm.add %401, %392 : i64
    %403 = llvm.getelementptr %399[%402] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %404 = llvm.load %403 : !llvm.ptr -> f64
    %405 = llvm.extractvalue %53[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %406 = llvm.mlir.constant(2 : index) : i64
    %407 = llvm.mul %392, %406 : i64
    %408 = llvm.add %407, %397 : i64
    %409 = llvm.getelementptr %405[%408] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %404, %409 : f64, !llvm.ptr
    %410 = llvm.add %397, %396 : i64
    llvm.br ^bb21(%410 : i64)
  ^bb23:  // pred: ^bb21
    %411 = llvm.add %392, %391 : i64
    llvm.br ^bb19(%411 : i64)
  ^bb24:  // pred: ^bb19
    %412 = llvm.mlir.constant(0 : index) : i64
    %413 = llvm.mlir.constant(3 : index) : i64
    %414 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb25(%412 : i64)
  ^bb25(%415: i64):  // 2 preds: ^bb24, ^bb29
    %416 = llvm.icmp "slt" %415, %413 : i64
    llvm.cond_br %416, ^bb26, ^bb30
  ^bb26:  // pred: ^bb25
    %417 = llvm.mlir.constant(0 : index) : i64
    %418 = llvm.mlir.constant(2 : index) : i64
    %419 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb27(%417 : i64)
  ^bb27(%420: i64):  // 2 preds: ^bb26, ^bb28
    %421 = llvm.icmp "slt" %420, %418 : i64
    llvm.cond_br %421, ^bb28, ^bb29
  ^bb28:  // pred: ^bb27
    %422 = llvm.extractvalue %81[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %423 = llvm.mlir.constant(2 : index) : i64
    %424 = llvm.mul %415, %423 : i64
    %425 = llvm.add %424, %420 : i64
    %426 = llvm.getelementptr %422[%425] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %427 = llvm.load %426 : !llvm.ptr -> f64
    %428 = llvm.extractvalue %53[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %429 = llvm.mlir.constant(2 : index) : i64
    %430 = llvm.mul %415, %429 : i64
    %431 = llvm.add %430, %420 : i64
    %432 = llvm.getelementptr %428[%431] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %433 = llvm.load %432 : !llvm.ptr -> f64
    %434 = llvm.fmul %427, %433 : f64
    %435 = llvm.extractvalue %39[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %436 = llvm.mlir.constant(2 : index) : i64
    %437 = llvm.mul %415, %436 : i64
    %438 = llvm.add %437, %420 : i64
    %439 = llvm.getelementptr %435[%438] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %434, %439 : f64, !llvm.ptr
    %440 = llvm.add %420, %419 : i64
    llvm.br ^bb27(%440 : i64)
  ^bb29:  // pred: ^bb27
    %441 = llvm.add %415, %414 : i64
    llvm.br ^bb25(%441 : i64)
  ^bb30:  // pred: ^bb25
    %442 = llvm.mlir.addressof @frmt_spec : !llvm.ptr
    %443 = llvm.mlir.constant(0 : index) : i64
    %444 = llvm.getelementptr %442[%443, %443] : (!llvm.ptr, i64, i64) -> !llvm.ptr, !llvm.array<3 x i8>
    %445 = llvm.mlir.addressof @nl : !llvm.ptr
    %446 = llvm.mlir.constant(0 : index) : i64
    %447 = llvm.getelementptr %445[%446, %446] : (!llvm.ptr, i64, i64) -> !llvm.ptr, !llvm.array<1 x i8>
    %448 = llvm.mlir.constant(0 : index) : i64
    %449 = llvm.mlir.constant(3 : index) : i64
    %450 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb31(%448 : i64)
  ^bb31(%451: i64):  // 2 preds: ^bb30, ^bb35
    %452 = llvm.icmp "slt" %451, %449 : i64
    llvm.cond_br %452, ^bb32, ^bb36
  ^bb32:  // pred: ^bb31
    %453 = llvm.mlir.constant(0 : index) : i64
    %454 = llvm.mlir.constant(2 : index) : i64
    %455 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb33(%453 : i64)
  ^bb33(%456: i64):  // 2 preds: ^bb32, ^bb34
    %457 = llvm.icmp "slt" %456, %454 : i64
    llvm.cond_br %457, ^bb34, ^bb35
  ^bb34:  // pred: ^bb33
    %458 = llvm.extractvalue %39[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %459 = llvm.mlir.constant(2 : index) : i64
    %460 = llvm.mul %451, %459 : i64
    %461 = llvm.add %460, %456 : i64
    %462 = llvm.getelementptr %458[%461] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %463 = llvm.load %462 : !llvm.ptr -> f64
    %464 = llvm.call @printf(%444, %463) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, f64) -> i32
    %465 = llvm.add %456, %455 : i64
    llvm.br ^bb33(%465 : i64)
  ^bb35:  // pred: ^bb33
    %466 = llvm.call @printf(%447) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr) -> i32
    %467 = llvm.add %451, %450 : i64
    llvm.br ^bb31(%467 : i64)
  ^bb36:  // pred: ^bb31
    %468 = llvm.extractvalue %25[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%468) : (!llvm.ptr) -> ()
    %469 = llvm.extractvalue %137[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%469) : (!llvm.ptr) -> ()
    %470 = llvm.extractvalue %123[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%470) : (!llvm.ptr) -> ()
    %471 = llvm.extractvalue %109[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%471) : (!llvm.ptr) -> ()
    %472 = llvm.extractvalue %95[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%472) : (!llvm.ptr) -> ()
    %473 = llvm.extractvalue %81[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%473) : (!llvm.ptr) -> ()
    %474 = llvm.extractvalue %67[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%474) : (!llvm.ptr) -> ()
    %475 = llvm.extractvalue %53[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%475) : (!llvm.ptr) -> ()
    %476 = llvm.extractvalue %39[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%476) : (!llvm.ptr) -> ()
    llvm.return
  }
}
