module {
  llvm.func @free(!llvm.ptr)
  llvm.mlir.global internal constant @nl("\0A") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @frmt_spec("%f ") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  llvm.func @main() {
    %0 = llvm.mlir.constant(9.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(8.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(7.000000e+00 : f64) : f64
    %3 = llvm.mlir.constant(6.000000e+00 : f64) : f64
    %4 = llvm.mlir.constant(5.000000e+00 : f64) : f64
    %5 = llvm.mlir.constant(4.000000e+00 : f64) : f64
    %6 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %7 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %8 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %9 = llvm.mlir.constant(2 : index) : i64
    %10 = llvm.mlir.constant(3 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(6 : index) : i64
    %13 = llvm.alloca %12 x f64 : (i64) -> !llvm.ptr
    %14 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %15 = llvm.insertvalue %13, %14[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %13, %15[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.mlir.constant(0 : index) : i64
    %18 = llvm.insertvalue %17, %16[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %9, %18[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %10, %19[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %10, %20[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %11, %21[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.mlir.constant(2 : index) : i64
    %24 = llvm.mlir.constant(3 : index) : i64
    %25 = llvm.mlir.constant(1 : index) : i64
    %26 = llvm.mlir.constant(6 : index) : i64
    %27 = llvm.alloca %26 x f64 : (i64) -> !llvm.ptr
    %28 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %29 = llvm.insertvalue %27, %28[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.insertvalue %27, %29[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.mlir.constant(0 : index) : i64
    %32 = llvm.insertvalue %31, %30[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %23, %32[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.insertvalue %24, %33[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.insertvalue %24, %34[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.insertvalue %25, %35[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.mlir.constant(3 : index) : i64
    %38 = llvm.mlir.constant(2 : index) : i64
    %39 = llvm.mlir.constant(1 : index) : i64
    %40 = llvm.mlir.constant(6 : index) : i64
    %41 = llvm.alloca %40 x f64 : (i64) -> !llvm.ptr
    %42 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %43 = llvm.insertvalue %41, %42[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.insertvalue %41, %43[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = llvm.mlir.constant(0 : index) : i64
    %46 = llvm.insertvalue %45, %44[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.insertvalue %37, %46[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.insertvalue %38, %47[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %49 = llvm.insertvalue %38, %48[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.insertvalue %39, %49[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %51 = llvm.mlir.constant(2 : index) : i64
    %52 = llvm.mlir.constant(3 : index) : i64
    %53 = llvm.mlir.constant(1 : index) : i64
    %54 = llvm.mlir.constant(6 : index) : i64
    %55 = llvm.alloca %54 x f64 : (i64) -> !llvm.ptr
    %56 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %57 = llvm.insertvalue %55, %56[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.insertvalue %55, %57[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %59 = llvm.mlir.constant(0 : index) : i64
    %60 = llvm.insertvalue %59, %58[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %61 = llvm.insertvalue %51, %60[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.insertvalue %52, %61[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.insertvalue %52, %62[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %64 = llvm.insertvalue %53, %63[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %65 = llvm.mlir.constant(2 : index) : i64
    %66 = llvm.mlir.constant(3 : index) : i64
    %67 = llvm.mlir.constant(1 : index) : i64
    %68 = llvm.mlir.constant(6 : index) : i64
    %69 = llvm.alloca %68 x f64 : (i64) -> !llvm.ptr
    %70 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %71 = llvm.insertvalue %69, %70[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %72 = llvm.insertvalue %69, %71[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %73 = llvm.mlir.constant(0 : index) : i64
    %74 = llvm.insertvalue %73, %72[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.insertvalue %65, %74[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %76 = llvm.insertvalue %66, %75[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %77 = llvm.insertvalue %66, %76[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %78 = llvm.insertvalue %67, %77[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %79 = llvm.mlir.constant(2 : index) : i64
    %80 = llvm.mlir.constant(3 : index) : i64
    %81 = llvm.mlir.constant(1 : index) : i64
    %82 = llvm.mlir.constant(6 : index) : i64
    %83 = llvm.alloca %82 x f64 : (i64) -> !llvm.ptr
    %84 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %85 = llvm.insertvalue %83, %84[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %86 = llvm.insertvalue %83, %85[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.mlir.constant(0 : index) : i64
    %88 = llvm.insertvalue %87, %86[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %89 = llvm.insertvalue %79, %88[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.insertvalue %80, %89[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %91 = llvm.insertvalue %80, %90[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.insertvalue %81, %91[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %93 = llvm.mlir.constant(3 : index) : i64
    %94 = llvm.mlir.constant(2 : index) : i64
    %95 = llvm.mlir.constant(1 : index) : i64
    %96 = llvm.mlir.constant(6 : index) : i64
    %97 = llvm.alloca %96 x f64 : (i64) -> !llvm.ptr
    %98 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %99 = llvm.insertvalue %97, %98[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %100 = llvm.insertvalue %97, %99[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %101 = llvm.mlir.constant(0 : index) : i64
    %102 = llvm.insertvalue %101, %100[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %103 = llvm.insertvalue %93, %102[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %104 = llvm.insertvalue %94, %103[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %105 = llvm.insertvalue %94, %104[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %106 = llvm.insertvalue %95, %105[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %107 = llvm.mlir.constant(3 : index) : i64
    %108 = llvm.mlir.constant(2 : index) : i64
    %109 = llvm.mlir.constant(1 : index) : i64
    %110 = llvm.mlir.constant(6 : index) : i64
    %111 = llvm.alloca %110 x f64 : (i64) -> !llvm.ptr
    %112 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %113 = llvm.insertvalue %111, %112[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %114 = llvm.insertvalue %111, %113[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %115 = llvm.mlir.constant(0 : index) : i64
    %116 = llvm.insertvalue %115, %114[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %117 = llvm.insertvalue %107, %116[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %118 = llvm.insertvalue %108, %117[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %119 = llvm.insertvalue %108, %118[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %120 = llvm.insertvalue %109, %119[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %121 = llvm.mlir.constant(3 : index) : i64
    %122 = llvm.mlir.constant(2 : index) : i64
    %123 = llvm.mlir.constant(1 : index) : i64
    %124 = llvm.mlir.constant(6 : index) : i64
    %125 = llvm.alloca %124 x f64 : (i64) -> !llvm.ptr
    %126 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %127 = llvm.insertvalue %125, %126[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %128 = llvm.insertvalue %125, %127[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %129 = llvm.mlir.constant(0 : index) : i64
    %130 = llvm.insertvalue %129, %128[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %131 = llvm.insertvalue %121, %130[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %132 = llvm.insertvalue %122, %131[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %133 = llvm.insertvalue %122, %132[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %134 = llvm.insertvalue %123, %133[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %135 = llvm.mlir.constant(3 : index) : i64
    %136 = llvm.mlir.constant(2 : index) : i64
    %137 = llvm.mlir.constant(1 : index) : i64
    %138 = llvm.mlir.constant(6 : index) : i64
    %139 = llvm.alloca %138 x f64 : (i64) -> !llvm.ptr
    %140 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %141 = llvm.insertvalue %139, %140[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %142 = llvm.insertvalue %139, %141[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %143 = llvm.mlir.constant(0 : index) : i64
    %144 = llvm.insertvalue %143, %142[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %145 = llvm.insertvalue %135, %144[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %146 = llvm.insertvalue %136, %145[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %147 = llvm.insertvalue %136, %146[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %148 = llvm.insertvalue %137, %147[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %149 = llvm.mlir.constant(2 : index) : i64
    %150 = llvm.mlir.constant(3 : index) : i64
    %151 = llvm.mlir.constant(1 : index) : i64
    %152 = llvm.mlir.constant(6 : index) : i64
    %153 = llvm.alloca %152 x f64 : (i64) -> !llvm.ptr
    %154 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %155 = llvm.insertvalue %153, %154[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %156 = llvm.insertvalue %153, %155[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %157 = llvm.mlir.constant(0 : index) : i64
    %158 = llvm.insertvalue %157, %156[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %159 = llvm.insertvalue %149, %158[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %160 = llvm.insertvalue %150, %159[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %161 = llvm.insertvalue %150, %160[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %162 = llvm.insertvalue %151, %161[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %163 = llvm.mlir.constant(0 : index) : i64
    %164 = llvm.mlir.constant(0 : index) : i64
    %165 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %166 = llvm.mlir.constant(3 : index) : i64
    %167 = llvm.mul %163, %166 : i64
    %168 = llvm.add %167, %164 : i64
    %169 = llvm.getelementptr %165[%168] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %169 : f64, !llvm.ptr
    %170 = llvm.mlir.constant(0 : index) : i64
    %171 = llvm.mlir.constant(1 : index) : i64
    %172 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %173 = llvm.mlir.constant(3 : index) : i64
    %174 = llvm.mul %170, %173 : i64
    %175 = llvm.add %174, %171 : i64
    %176 = llvm.getelementptr %172[%175] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %7, %176 : f64, !llvm.ptr
    %177 = llvm.mlir.constant(0 : index) : i64
    %178 = llvm.mlir.constant(2 : index) : i64
    %179 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %180 = llvm.mlir.constant(3 : index) : i64
    %181 = llvm.mul %177, %180 : i64
    %182 = llvm.add %181, %178 : i64
    %183 = llvm.getelementptr %179[%182] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %183 : f64, !llvm.ptr
    %184 = llvm.mlir.constant(1 : index) : i64
    %185 = llvm.mlir.constant(0 : index) : i64
    %186 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %187 = llvm.mlir.constant(3 : index) : i64
    %188 = llvm.mul %184, %187 : i64
    %189 = llvm.add %188, %185 : i64
    %190 = llvm.getelementptr %186[%189] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %190 : f64, !llvm.ptr
    %191 = llvm.mlir.constant(1 : index) : i64
    %192 = llvm.mlir.constant(1 : index) : i64
    %193 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %194 = llvm.mlir.constant(3 : index) : i64
    %195 = llvm.mul %191, %194 : i64
    %196 = llvm.add %195, %192 : i64
    %197 = llvm.getelementptr %193[%196] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %4, %197 : f64, !llvm.ptr
    %198 = llvm.mlir.constant(1 : index) : i64
    %199 = llvm.mlir.constant(2 : index) : i64
    %200 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %201 = llvm.mlir.constant(3 : index) : i64
    %202 = llvm.mul %198, %201 : i64
    %203 = llvm.add %202, %199 : i64
    %204 = llvm.getelementptr %200[%203] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %204 : f64, !llvm.ptr
    %205 = llvm.mlir.constant(0 : index) : i64
    %206 = llvm.mlir.constant(0 : index) : i64
    %207 = llvm.extractvalue %162[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %208 = llvm.mlir.constant(3 : index) : i64
    %209 = llvm.mul %205, %208 : i64
    %210 = llvm.add %209, %206 : i64
    %211 = llvm.getelementptr %207[%210] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %8, %211 : f64, !llvm.ptr
    %212 = llvm.mlir.constant(0 : index) : i64
    %213 = llvm.mlir.constant(1 : index) : i64
    %214 = llvm.extractvalue %162[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %215 = llvm.mlir.constant(3 : index) : i64
    %216 = llvm.mul %212, %215 : i64
    %217 = llvm.add %216, %213 : i64
    %218 = llvm.getelementptr %214[%217] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %7, %218 : f64, !llvm.ptr
    %219 = llvm.mlir.constant(0 : index) : i64
    %220 = llvm.mlir.constant(2 : index) : i64
    %221 = llvm.extractvalue %162[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %222 = llvm.mlir.constant(3 : index) : i64
    %223 = llvm.mul %219, %222 : i64
    %224 = llvm.add %223, %220 : i64
    %225 = llvm.getelementptr %221[%224] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %225 : f64, !llvm.ptr
    %226 = llvm.mlir.constant(1 : index) : i64
    %227 = llvm.mlir.constant(0 : index) : i64
    %228 = llvm.extractvalue %162[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %229 = llvm.mlir.constant(3 : index) : i64
    %230 = llvm.mul %226, %229 : i64
    %231 = llvm.add %230, %227 : i64
    %232 = llvm.getelementptr %228[%231] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %2, %232 : f64, !llvm.ptr
    %233 = llvm.mlir.constant(1 : index) : i64
    %234 = llvm.mlir.constant(1 : index) : i64
    %235 = llvm.extractvalue %162[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %236 = llvm.mlir.constant(3 : index) : i64
    %237 = llvm.mul %233, %236 : i64
    %238 = llvm.add %237, %234 : i64
    %239 = llvm.getelementptr %235[%238] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %1, %239 : f64, !llvm.ptr
    %240 = llvm.mlir.constant(1 : index) : i64
    %241 = llvm.mlir.constant(2 : index) : i64
    %242 = llvm.extractvalue %162[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %243 = llvm.mlir.constant(3 : index) : i64
    %244 = llvm.mul %240, %243 : i64
    %245 = llvm.add %244, %241 : i64
    %246 = llvm.getelementptr %242[%245] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %0, %246 : f64, !llvm.ptr
    %247 = llvm.mlir.constant(0 : index) : i64
    %248 = llvm.mlir.constant(3 : index) : i64
    %249 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb1(%247 : i64)
  ^bb1(%250: i64):  // 2 preds: ^bb0, ^bb5
    %251 = llvm.icmp "slt" %250, %248 : i64
    llvm.cond_br %251, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    %252 = llvm.mlir.constant(0 : index) : i64
    %253 = llvm.mlir.constant(2 : index) : i64
    %254 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb3(%252 : i64)
  ^bb3(%255: i64):  // 2 preds: ^bb2, ^bb4
    %256 = llvm.icmp "slt" %255, %253 : i64
    llvm.cond_br %256, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %257 = llvm.extractvalue %22[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %258 = llvm.mlir.constant(3 : index) : i64
    %259 = llvm.mul %255, %258 : i64
    %260 = llvm.add %259, %250 : i64
    %261 = llvm.getelementptr %257[%260] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %262 = llvm.load %261 : !llvm.ptr -> f64
    %263 = llvm.extractvalue %148[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %264 = llvm.mlir.constant(2 : index) : i64
    %265 = llvm.mul %250, %264 : i64
    %266 = llvm.add %265, %255 : i64
    %267 = llvm.getelementptr %263[%266] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %262, %267 : f64, !llvm.ptr
    %268 = llvm.add %255, %254 : i64
    llvm.br ^bb3(%268 : i64)
  ^bb5:  // pred: ^bb3
    %269 = llvm.add %250, %249 : i64
    llvm.br ^bb1(%269 : i64)
  ^bb6:  // pred: ^bb1
    %270 = llvm.mlir.constant(0 : index) : i64
    %271 = llvm.mlir.constant(3 : index) : i64
    %272 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb7(%270 : i64)
  ^bb7(%273: i64):  // 2 preds: ^bb6, ^bb11
    %274 = llvm.icmp "slt" %273, %271 : i64
    llvm.cond_br %274, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    %275 = llvm.mlir.constant(0 : index) : i64
    %276 = llvm.mlir.constant(2 : index) : i64
    %277 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb9(%275 : i64)
  ^bb9(%278: i64):  // 2 preds: ^bb8, ^bb10
    %279 = llvm.icmp "slt" %278, %276 : i64
    llvm.cond_br %279, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %280 = llvm.extractvalue %162[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %281 = llvm.mlir.constant(3 : index) : i64
    %282 = llvm.mul %278, %281 : i64
    %283 = llvm.add %282, %273 : i64
    %284 = llvm.getelementptr %280[%283] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %285 = llvm.load %284 : !llvm.ptr -> f64
    %286 = llvm.extractvalue %134[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %287 = llvm.mlir.constant(2 : index) : i64
    %288 = llvm.mul %273, %287 : i64
    %289 = llvm.add %288, %278 : i64
    %290 = llvm.getelementptr %286[%289] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %285, %290 : f64, !llvm.ptr
    %291 = llvm.add %278, %277 : i64
    llvm.br ^bb9(%291 : i64)
  ^bb11:  // pred: ^bb9
    %292 = llvm.add %273, %272 : i64
    llvm.br ^bb7(%292 : i64)
  ^bb12:  // pred: ^bb7
    %293 = llvm.mlir.constant(0 : index) : i64
    %294 = llvm.mlir.constant(3 : index) : i64
    %295 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb13(%293 : i64)
  ^bb13(%296: i64):  // 2 preds: ^bb12, ^bb17
    %297 = llvm.icmp "slt" %296, %294 : i64
    llvm.cond_br %297, ^bb14, ^bb18
  ^bb14:  // pred: ^bb13
    %298 = llvm.mlir.constant(0 : index) : i64
    %299 = llvm.mlir.constant(2 : index) : i64
    %300 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb15(%298 : i64)
  ^bb15(%301: i64):  // 2 preds: ^bb14, ^bb16
    %302 = llvm.icmp "slt" %301, %299 : i64
    llvm.cond_br %302, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %303 = llvm.extractvalue %148[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %304 = llvm.mlir.constant(2 : index) : i64
    %305 = llvm.mul %296, %304 : i64
    %306 = llvm.add %305, %301 : i64
    %307 = llvm.getelementptr %303[%306] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %308 = llvm.load %307 : !llvm.ptr -> f64
    %309 = llvm.extractvalue %134[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %310 = llvm.mlir.constant(2 : index) : i64
    %311 = llvm.mul %296, %310 : i64
    %312 = llvm.add %311, %301 : i64
    %313 = llvm.getelementptr %309[%312] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %314 = llvm.load %313 : !llvm.ptr -> f64
    %315 = llvm.fmul %308, %314  : f64
    %316 = llvm.extractvalue %120[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %317 = llvm.mlir.constant(2 : index) : i64
    %318 = llvm.mul %296, %317 : i64
    %319 = llvm.add %318, %301 : i64
    %320 = llvm.getelementptr %316[%319] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %315, %320 : f64, !llvm.ptr
    %321 = llvm.add %301, %300 : i64
    llvm.br ^bb15(%321 : i64)
  ^bb17:  // pred: ^bb15
    %322 = llvm.add %296, %295 : i64
    llvm.br ^bb13(%322 : i64)
  ^bb18:  // pred: ^bb13
    %323 = llvm.mlir.constant(0 : index) : i64
    %324 = llvm.mlir.constant(3 : index) : i64
    %325 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb19(%323 : i64)
  ^bb19(%326: i64):  // 2 preds: ^bb18, ^bb23
    %327 = llvm.icmp "slt" %326, %324 : i64
    llvm.cond_br %327, ^bb20, ^bb24
  ^bb20:  // pred: ^bb19
    %328 = llvm.mlir.constant(0 : index) : i64
    %329 = llvm.mlir.constant(2 : index) : i64
    %330 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb21(%328 : i64)
  ^bb21(%331: i64):  // 2 preds: ^bb20, ^bb22
    %332 = llvm.icmp "slt" %331, %329 : i64
    llvm.cond_br %332, ^bb22, ^bb23
  ^bb22:  // pred: ^bb21
    %333 = llvm.extractvalue %134[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %334 = llvm.mlir.constant(2 : index) : i64
    %335 = llvm.mul %326, %334 : i64
    %336 = llvm.add %335, %331 : i64
    %337 = llvm.getelementptr %333[%336] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %338 = llvm.load %337 : !llvm.ptr -> f64
    %339 = llvm.extractvalue %148[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %340 = llvm.mlir.constant(2 : index) : i64
    %341 = llvm.mul %326, %340 : i64
    %342 = llvm.add %341, %331 : i64
    %343 = llvm.getelementptr %339[%342] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %344 = llvm.load %343 : !llvm.ptr -> f64
    %345 = llvm.fmul %338, %344  : f64
    %346 = llvm.extractvalue %106[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %347 = llvm.mlir.constant(2 : index) : i64
    %348 = llvm.mul %326, %347 : i64
    %349 = llvm.add %348, %331 : i64
    %350 = llvm.getelementptr %346[%349] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %345, %350 : f64, !llvm.ptr
    %351 = llvm.add %331, %330 : i64
    llvm.br ^bb21(%351 : i64)
  ^bb23:  // pred: ^bb21
    %352 = llvm.add %326, %325 : i64
    llvm.br ^bb19(%352 : i64)
  ^bb24:  // pred: ^bb19
    %353 = llvm.mlir.constant(0 : index) : i64
    %354 = llvm.mlir.constant(2 : index) : i64
    %355 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb25(%353 : i64)
  ^bb25(%356: i64):  // 2 preds: ^bb24, ^bb29
    %357 = llvm.icmp "slt" %356, %354 : i64
    llvm.cond_br %357, ^bb26, ^bb30
  ^bb26:  // pred: ^bb25
    %358 = llvm.mlir.constant(0 : index) : i64
    %359 = llvm.mlir.constant(3 : index) : i64
    %360 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb27(%358 : i64)
  ^bb27(%361: i64):  // 2 preds: ^bb26, ^bb28
    %362 = llvm.icmp "slt" %361, %359 : i64
    llvm.cond_br %362, ^bb28, ^bb29
  ^bb28:  // pred: ^bb27
    %363 = llvm.extractvalue %120[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %364 = llvm.mlir.constant(2 : index) : i64
    %365 = llvm.mul %361, %364 : i64
    %366 = llvm.add %365, %356 : i64
    %367 = llvm.getelementptr %363[%366] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %368 = llvm.load %367 : !llvm.ptr -> f64
    %369 = llvm.extractvalue %92[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %370 = llvm.mlir.constant(3 : index) : i64
    %371 = llvm.mul %356, %370 : i64
    %372 = llvm.add %371, %361 : i64
    %373 = llvm.getelementptr %369[%372] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %368, %373 : f64, !llvm.ptr
    %374 = llvm.add %361, %360 : i64
    llvm.br ^bb27(%374 : i64)
  ^bb29:  // pred: ^bb27
    %375 = llvm.add %356, %355 : i64
    llvm.br ^bb25(%375 : i64)
  ^bb30:  // pred: ^bb25
    %376 = llvm.mlir.constant(0 : index) : i64
    %377 = llvm.mlir.constant(2 : index) : i64
    %378 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb31(%376 : i64)
  ^bb31(%379: i64):  // 2 preds: ^bb30, ^bb35
    %380 = llvm.icmp "slt" %379, %377 : i64
    llvm.cond_br %380, ^bb32, ^bb36
  ^bb32:  // pred: ^bb31
    %381 = llvm.mlir.constant(0 : index) : i64
    %382 = llvm.mlir.constant(3 : index) : i64
    %383 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb33(%381 : i64)
  ^bb33(%384: i64):  // 2 preds: ^bb32, ^bb34
    %385 = llvm.icmp "slt" %384, %382 : i64
    llvm.cond_br %385, ^bb34, ^bb35
  ^bb34:  // pred: ^bb33
    %386 = llvm.extractvalue %106[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %387 = llvm.mlir.constant(2 : index) : i64
    %388 = llvm.mul %384, %387 : i64
    %389 = llvm.add %388, %379 : i64
    %390 = llvm.getelementptr %386[%389] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %391 = llvm.load %390 : !llvm.ptr -> f64
    %392 = llvm.extractvalue %78[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %393 = llvm.mlir.constant(3 : index) : i64
    %394 = llvm.mul %379, %393 : i64
    %395 = llvm.add %394, %384 : i64
    %396 = llvm.getelementptr %392[%395] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %391, %396 : f64, !llvm.ptr
    %397 = llvm.add %384, %383 : i64
    llvm.br ^bb33(%397 : i64)
  ^bb35:  // pred: ^bb33
    %398 = llvm.add %379, %378 : i64
    llvm.br ^bb31(%398 : i64)
  ^bb36:  // pred: ^bb31
    %399 = llvm.mlir.constant(0 : index) : i64
    %400 = llvm.mlir.constant(2 : index) : i64
    %401 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb37(%399 : i64)
  ^bb37(%402: i64):  // 2 preds: ^bb36, ^bb41
    %403 = llvm.icmp "slt" %402, %400 : i64
    llvm.cond_br %403, ^bb38, ^bb42
  ^bb38:  // pred: ^bb37
    %404 = llvm.mlir.constant(0 : index) : i64
    %405 = llvm.mlir.constant(3 : index) : i64
    %406 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb39(%404 : i64)
  ^bb39(%407: i64):  // 2 preds: ^bb38, ^bb40
    %408 = llvm.icmp "slt" %407, %405 : i64
    llvm.cond_br %408, ^bb40, ^bb41
  ^bb40:  // pred: ^bb39
    %409 = llvm.extractvalue %92[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %410 = llvm.mlir.constant(3 : index) : i64
    %411 = llvm.mul %402, %410 : i64
    %412 = llvm.add %411, %407 : i64
    %413 = llvm.getelementptr %409[%412] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %414 = llvm.load %413 : !llvm.ptr -> f64
    %415 = llvm.extractvalue %78[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %416 = llvm.mlir.constant(3 : index) : i64
    %417 = llvm.mul %402, %416 : i64
    %418 = llvm.add %417, %407 : i64
    %419 = llvm.getelementptr %415[%418] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %420 = llvm.load %419 : !llvm.ptr -> f64
    %421 = llvm.fmul %414, %420  : f64
    %422 = llvm.extractvalue %64[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %423 = llvm.mlir.constant(3 : index) : i64
    %424 = llvm.mul %402, %423 : i64
    %425 = llvm.add %424, %407 : i64
    %426 = llvm.getelementptr %422[%425] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %421, %426 : f64, !llvm.ptr
    %427 = llvm.add %407, %406 : i64
    llvm.br ^bb39(%427 : i64)
  ^bb41:  // pred: ^bb39
    %428 = llvm.add %402, %401 : i64
    llvm.br ^bb37(%428 : i64)
  ^bb42:  // pred: ^bb37
    %429 = llvm.mlir.constant(0 : index) : i64
    %430 = llvm.mlir.constant(3 : index) : i64
    %431 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb43(%429 : i64)
  ^bb43(%432: i64):  // 2 preds: ^bb42, ^bb47
    %433 = llvm.icmp "slt" %432, %430 : i64
    llvm.cond_br %433, ^bb44, ^bb48
  ^bb44:  // pred: ^bb43
    %434 = llvm.mlir.constant(0 : index) : i64
    %435 = llvm.mlir.constant(2 : index) : i64
    %436 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb45(%434 : i64)
  ^bb45(%437: i64):  // 2 preds: ^bb44, ^bb46
    %438 = llvm.icmp "slt" %437, %435 : i64
    llvm.cond_br %438, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %439 = llvm.extractvalue %148[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %440 = llvm.mlir.constant(2 : index) : i64
    %441 = llvm.mul %432, %440 : i64
    %442 = llvm.add %441, %437 : i64
    %443 = llvm.getelementptr %439[%442] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %444 = llvm.load %443 : !llvm.ptr -> f64
    %445 = llvm.extractvalue %92[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %446 = llvm.mlir.constant(3 : index) : i64
    %447 = llvm.mul %432, %446 : i64
    %448 = llvm.add %447, %437 : i64
    %449 = llvm.getelementptr %445[%448] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %450 = llvm.load %449 : !llvm.ptr -> f64
    %451 = llvm.fmul %444, %450  : f64
    %452 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %453 = llvm.mlir.constant(2 : index) : i64
    %454 = llvm.mul %432, %453 : i64
    %455 = llvm.add %454, %437 : i64
    %456 = llvm.getelementptr %452[%455] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %451, %456 : f64, !llvm.ptr
    %457 = llvm.add %437, %436 : i64
    llvm.br ^bb45(%457 : i64)
  ^bb47:  // pred: ^bb45
    %458 = llvm.add %432, %431 : i64
    llvm.br ^bb43(%458 : i64)
  ^bb48:  // pred: ^bb43
    %459 = llvm.mlir.constant(0 : index) : i64
    %460 = llvm.mlir.constant(2 : index) : i64
    %461 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb49(%459 : i64)
  ^bb49(%462: i64):  // 2 preds: ^bb48, ^bb53
    %463 = llvm.icmp "slt" %462, %460 : i64
    llvm.cond_br %463, ^bb50, ^bb54
  ^bb50:  // pred: ^bb49
    %464 = llvm.mlir.constant(0 : index) : i64
    %465 = llvm.mlir.constant(3 : index) : i64
    %466 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb51(%464 : i64)
  ^bb51(%467: i64):  // 2 preds: ^bb50, ^bb52
    %468 = llvm.icmp "slt" %467, %465 : i64
    llvm.cond_br %468, ^bb52, ^bb53
  ^bb52:  // pred: ^bb51
    %469 = llvm.extractvalue %64[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %470 = llvm.mlir.constant(3 : index) : i64
    %471 = llvm.mul %462, %470 : i64
    %472 = llvm.add %471, %467 : i64
    %473 = llvm.getelementptr %469[%472] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %474 = llvm.load %473 : !llvm.ptr -> f64
    %475 = llvm.extractvalue %50[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %476 = llvm.mlir.constant(2 : index) : i64
    %477 = llvm.mul %462, %476 : i64
    %478 = llvm.add %477, %467 : i64
    %479 = llvm.getelementptr %475[%478] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %480 = llvm.load %479 : !llvm.ptr -> f64
    %481 = llvm.fadd %474, %480  : f64
    %482 = llvm.extractvalue %36[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %483 = llvm.mlir.constant(3 : index) : i64
    %484 = llvm.mul %462, %483 : i64
    %485 = llvm.add %484, %467 : i64
    %486 = llvm.getelementptr %482[%485] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %481, %486 : f64, !llvm.ptr
    %487 = llvm.add %467, %466 : i64
    llvm.br ^bb51(%487 : i64)
  ^bb53:  // pred: ^bb51
    %488 = llvm.add %462, %461 : i64
    llvm.br ^bb49(%488 : i64)
  ^bb54:  // pred: ^bb49
    %489 = llvm.mlir.addressof @frmt_spec : !llvm.ptr
    %490 = llvm.mlir.constant(0 : index) : i64
    %491 = llvm.getelementptr %489[%490, %490] : (!llvm.ptr, i64, i64) -> !llvm.ptr, !llvm.array<3 x i8>
    %492 = llvm.mlir.addressof @nl : !llvm.ptr
    %493 = llvm.mlir.constant(0 : index) : i64
    %494 = llvm.getelementptr %492[%493, %493] : (!llvm.ptr, i64, i64) -> !llvm.ptr, !llvm.array<1 x i8>
    %495 = llvm.mlir.constant(0 : index) : i64
    %496 = llvm.mlir.constant(2 : index) : i64
    %497 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb55(%495 : i64)
  ^bb55(%498: i64):  // 2 preds: ^bb54, ^bb59
    %499 = llvm.icmp "slt" %498, %496 : i64
    llvm.cond_br %499, ^bb56, ^bb60
  ^bb56:  // pred: ^bb55
    %500 = llvm.mlir.constant(0 : index) : i64
    %501 = llvm.mlir.constant(3 : index) : i64
    %502 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb57(%500 : i64)
  ^bb57(%503: i64):  // 2 preds: ^bb56, ^bb58
    %504 = llvm.icmp "slt" %503, %501 : i64
    llvm.cond_br %504, ^bb58, ^bb59
  ^bb58:  // pred: ^bb57
    %505 = llvm.extractvalue %36[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %506 = llvm.mlir.constant(3 : index) : i64
    %507 = llvm.mul %498, %506 : i64
    %508 = llvm.add %507, %503 : i64
    %509 = llvm.getelementptr %505[%508] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %510 = llvm.load %509 : !llvm.ptr -> f64
    %511 = llvm.call @printf(%491, %510) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, f64) -> i32
    %512 = llvm.add %503, %502 : i64
    llvm.br ^bb57(%512 : i64)
  ^bb59:  // pred: ^bb57
    %513 = llvm.call @printf(%494) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr) -> i32
    %514 = llvm.add %498, %497 : i64
    llvm.br ^bb55(%514 : i64)
  ^bb60:  // pred: ^bb55
    %515 = llvm.extractvalue %22[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%515) : (!llvm.ptr) -> ()
    %516 = llvm.extractvalue %162[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%516) : (!llvm.ptr) -> ()
    %517 = llvm.extractvalue %148[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%517) : (!llvm.ptr) -> ()
    %518 = llvm.extractvalue %134[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%518) : (!llvm.ptr) -> ()
    %519 = llvm.extractvalue %120[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%519) : (!llvm.ptr) -> ()
    %520 = llvm.extractvalue %106[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%520) : (!llvm.ptr) -> ()
    %521 = llvm.extractvalue %92[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%521) : (!llvm.ptr) -> ()
    %522 = llvm.extractvalue %78[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%522) : (!llvm.ptr) -> ()
    %523 = llvm.extractvalue %64[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%523) : (!llvm.ptr) -> ()
    %524 = llvm.extractvalue %50[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%524) : (!llvm.ptr) -> ()
    %525 = llvm.extractvalue %36[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%525) : (!llvm.ptr) -> ()
    llvm.return
  }
}
