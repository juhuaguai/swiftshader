; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx512f,avx512vl,avx512dq | FileCheck %s --check-prefixes=CHECK

; PR37751 - https://bugs.llvm.org/show_bug.cgi?id=37751
; We can't combine into 'round' instructions because the behavior is different for out-of-range values.

declare <16 x i32> @llvm.x86.avx512.mask.cvttps2dq.512(<16 x float>, <16 x i32>, i16, i32)
declare <4 x i32> @llvm.x86.avx512.mask.cvttps2udq.128(<4 x float>, <4 x i32>, i8)
declare <8 x i32> @llvm.x86.avx512.mask.cvttps2udq.256(<8 x float>, <8 x i32>, i8)
declare <16 x i32> @llvm.x86.avx512.mask.cvttps2udq.512(<16 x float>, <16 x i32>, i16, i32)
declare <4 x i32> @llvm.x86.avx512.mask.cvttpd2udq.256(<4 x double>, <4 x i32>, i8)
declare <8 x i32> @llvm.x86.avx512.mask.cvttpd2dq.512(<8 x double>, <8 x i32>, i8, i32)
declare <8 x i32> @llvm.x86.avx512.mask.cvttpd2udq.512(<8 x double>, <8 x i32>, i8, i32)
declare <4 x i64> @llvm.x86.avx512.mask.cvttps2qq.256(<4 x float>, <4 x i64>, i8)
declare <8 x i64> @llvm.x86.avx512.mask.cvttps2qq.512(<8 x float>, <8 x i64>, i8, i32)
declare <4 x i64> @llvm.x86.avx512.mask.cvttps2uqq.256(<4 x float>, <4 x i64>, i8)
declare <8 x i64> @llvm.x86.avx512.mask.cvttps2uqq.512(<8 x float>, <8 x i64>, i8, i32)
declare <2 x i64> @llvm.x86.avx512.mask.cvttpd2qq.128(<2 x double>, <2 x i64>, i8)
declare <4 x i64> @llvm.x86.avx512.mask.cvttpd2qq.256(<4 x double>, <4 x i64>, i8)
declare <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double>, <8 x i64>, i8, i32)
declare <2 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.128(<2 x double>, <2 x i64>, i8)
declare <4 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.256(<4 x double>, <4 x i64>, i8)
declare <8 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.512(<8 x double>, <8 x i64>, i8, i32)

define <16 x float> @float_to_sint_to_float_mem_v16f32(<16 x float>* %p) {
; CHECK-LABEL: float_to_sint_to_float_mem_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq (%rdi), %zmm0
; CHECK-NEXT:    vcvtdq2ps %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = load <16 x float>, <16 x float>* %p
  %fptosi = tail call <16 x i32> @llvm.x86.avx512.mask.cvttps2dq.512(<16 x float> %x, <16 x i32> undef, i16 -1, i32 4)
  %sitofp = sitofp <16 x i32> %fptosi to <16 x float>
  ret <16 x float> %sitofp
}

define <16 x float> @float_to_sint_to_float_reg_v16f32(<16 x float> %x) {
; CHECK-LABEL: float_to_sint_to_float_reg_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2dq %zmm0, %zmm0
; CHECK-NEXT:    vcvtdq2ps %zmm0, %zmm0
; CHECK-NEXT:    retq
  %fptosi = tail call <16 x i32> @llvm.x86.avx512.mask.cvttps2dq.512(<16 x float> %x, <16 x i32> undef, i16 -1, i32 4)
  %sitofp = sitofp <16 x i32> %fptosi to <16 x float>
  ret <16 x float> %sitofp
}

define <16 x float> @float_to_uint_to_float_mem_v16f32(<16 x float>* %p) {
; CHECK-LABEL: float_to_uint_to_float_mem_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2udq (%rdi), %zmm0
; CHECK-NEXT:    vcvtudq2ps %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = load <16 x float>, <16 x float>* %p
  %fptoui = tail call <16 x i32> @llvm.x86.avx512.mask.cvttps2udq.512(<16 x float> %x, <16 x i32> undef, i16 -1, i32 4)
  %uitofp = uitofp <16 x i32> %fptoui to <16 x float>
  ret <16 x float> %uitofp
}

define <16 x float> @float_to_uint_to_float_reg_v16f32(<16 x float> %x) {
; CHECK-LABEL: float_to_uint_to_float_reg_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2udq %zmm0, %zmm0
; CHECK-NEXT:    vcvtudq2ps %zmm0, %zmm0
; CHECK-NEXT:    retq
  %fptoui = tail call <16 x i32> @llvm.x86.avx512.mask.cvttps2udq.512(<16 x float> %x, <16 x i32> undef, i16 -1, i32 4)
  %uitofp = uitofp <16 x i32> %fptoui to <16 x float>
  ret <16 x float> %uitofp
}

define <4 x float> @float_to_uint_to_float_mem_v4f32(<4 x float>* %p) {
; CHECK-LABEL: float_to_uint_to_float_mem_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2udq (%rdi), %xmm0
; CHECK-NEXT:    vcvtudq2ps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x = load <4 x float>, <4 x float>* %p
  %fptoui = tail call <4 x i32> @llvm.x86.avx512.mask.cvttps2udq.128(<4 x float> %x, <4 x i32> undef, i8 -1)
  %uitofp = uitofp <4 x i32> %fptoui to <4 x float>
  ret <4 x float> %uitofp
}

define <4 x float> @float_to_uint_to_float_reg_v4f32(<4 x float> %x) {
; CHECK-LABEL: float_to_uint_to_float_reg_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2udq %xmm0, %xmm0
; CHECK-NEXT:    vcvtudq2ps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %fptoui = tail call <4 x i32> @llvm.x86.avx512.mask.cvttps2udq.128(<4 x float> %x, <4 x i32> undef, i8 -1)
  %uitofp = uitofp <4 x i32> %fptoui to <4 x float>
  ret <4 x float> %uitofp
}

define <8 x float> @float_to_uint_to_float_mem_v8f32(<8 x float>* %p) {
; CHECK-LABEL: float_to_uint_to_float_mem_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2udq (%rdi), %ymm0
; CHECK-NEXT:    vcvtudq2ps %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = load <8 x float>, <8 x float>* %p
  %fptoui = tail call <8 x i32> @llvm.x86.avx512.mask.cvttps2udq.256(<8 x float> %x, <8 x i32> undef, i8 -1)
  %uitofp = uitofp <8 x i32> %fptoui to <8 x float>
  ret <8 x float> %uitofp
}

define <8 x float> @float_to_uint_to_float_reg_v8f32(<8 x float> %x) {
; CHECK-LABEL: float_to_uint_to_float_reg_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2udq %ymm0, %ymm0
; CHECK-NEXT:    vcvtudq2ps %ymm0, %ymm0
; CHECK-NEXT:    retq
  %fptoui = tail call <8 x i32> @llvm.x86.avx512.mask.cvttps2udq.256(<8 x float> %x, <8 x i32> undef, i8 -1)
  %uitofp = uitofp <8 x i32> %fptoui to <8 x float>
  ret <8 x float> %uitofp
}

define <4 x double> @double_to_uint_to_double_mem_v4f64(<4 x double>* %p) {
; CHECK-LABEL: double_to_uint_to_double_mem_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2udqy (%rdi), %xmm0
; CHECK-NEXT:    vcvtudq2pd %xmm0, %ymm0
; CHECK-NEXT:    retq
  %x = load <4 x double>, <4 x double>* %p
  %fptoui = tail call <4 x i32> @llvm.x86.avx512.mask.cvttpd2udq.256(<4 x double> %x, <4 x i32> undef, i8 -1)
  %uitofp = uitofp <4 x i32> %fptoui to <4 x double>
  ret <4 x double> %uitofp
}

define <4 x double> @double_to_uint_to_double_reg_v4f64(<4 x double> %x) {
; CHECK-LABEL: double_to_uint_to_double_reg_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2udq %ymm0, %xmm0
; CHECK-NEXT:    vcvtudq2pd %xmm0, %ymm0
; CHECK-NEXT:    retq
  %fptoui = tail call <4 x i32> @llvm.x86.avx512.mask.cvttpd2udq.256(<4 x double> %x, <4 x i32> undef, i8 -1)
  %uitofp = uitofp <4 x i32> %fptoui to <4 x double>
  ret <4 x double> %uitofp
}

define <8 x double> @double_to_sint_to_double_mem_v8f64(<8 x double>* %p) {
; CHECK-LABEL: double_to_sint_to_double_mem_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2dq (%rdi), %ymm0
; CHECK-NEXT:    vcvtdq2pd %ymm0, %zmm0
; CHECK-NEXT:    retq
  %x = load <8 x double>, <8 x double>* %p
  %fptosi = tail call <8 x i32> @llvm.x86.avx512.mask.cvttpd2dq.512(<8 x double> %x, <8 x i32> undef, i8 -1, i32 4)
  %sitofp = sitofp <8 x i32> %fptosi to <8 x double>
  ret <8 x double> %sitofp
}

define <8 x double> @double_to_sint_to_double_reg_v8f64(<8 x double> %x) {
; CHECK-LABEL: double_to_sint_to_double_reg_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2dq %zmm0, %ymm0
; CHECK-NEXT:    vcvtdq2pd %ymm0, %zmm0
; CHECK-NEXT:    retq
  %fptosi = tail call <8 x i32> @llvm.x86.avx512.mask.cvttpd2dq.512(<8 x double> %x, <8 x i32> undef, i8 -1, i32 4)
  %sitofp = sitofp <8 x i32> %fptosi to <8 x double>
  ret <8 x double> %sitofp
}

define <8 x double> @double_to_uint_to_double_mem_v8f64(<8 x double>* %p) {
; CHECK-LABEL: double_to_uint_to_double_mem_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2udq (%rdi), %ymm0
; CHECK-NEXT:    vcvtudq2pd %ymm0, %zmm0
; CHECK-NEXT:    retq
  %x = load <8 x double>, <8 x double>* %p
  %fptoui = tail call <8 x i32> @llvm.x86.avx512.mask.cvttpd2udq.512(<8 x double> %x, <8 x i32> undef, i8 -1, i32 4)
  %uitofp = uitofp <8 x i32> %fptoui to <8 x double>
  ret <8 x double> %uitofp
}

define <8 x double> @double_to_uint_to_double_reg_v8f64(<8 x double> %x) {
; CHECK-LABEL: double_to_uint_to_double_reg_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2udq %zmm0, %ymm0
; CHECK-NEXT:    vcvtudq2pd %ymm0, %zmm0
; CHECK-NEXT:    retq
  %fptoui = tail call <8 x i32> @llvm.x86.avx512.mask.cvttpd2udq.512(<8 x double> %x, <8 x i32> undef, i8 -1, i32 4)
  %uitofp = uitofp <8 x i32> %fptoui to <8 x double>
  ret <8 x double> %uitofp
}

define <4 x float> @float_to_sint64_to_float_mem_v4f32(<4 x float>* %p) {
; CHECK-LABEL: float_to_sint64_to_float_mem_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2qq (%rdi), %ymm0
; CHECK-NEXT:    vcvtqq2ps %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %x = load <4 x float>, <4 x float>* %p
  %fptosi = tail call <4 x i64> @llvm.x86.avx512.mask.cvttps2qq.256(<4 x float> %x, <4 x i64> undef, i8 -1)
  %sitofp = sitofp <4 x i64> %fptosi to <4 x float>
  ret <4 x float> %sitofp
}

define <4 x float> @float_to_sint64_to_float_reg_v4f32(<4 x float> %x) {
; CHECK-LABEL: float_to_sint64_to_float_reg_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2qq %xmm0, %ymm0
; CHECK-NEXT:    vcvtqq2ps %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %fptosi = tail call <4 x i64> @llvm.x86.avx512.mask.cvttps2qq.256(<4 x float> %x, <4 x i64> undef, i8 -1)
  %sitofp = sitofp <4 x i64> %fptosi to <4 x float>
  ret <4 x float> %sitofp
}

define <4 x float> @float_to_uint64_to_float_mem_v4f32(<4 x float>* %p) {
; CHECK-LABEL: float_to_uint64_to_float_mem_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2uqq (%rdi), %ymm0
; CHECK-NEXT:    vcvtuqq2ps %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %x = load <4 x float>, <4 x float>* %p
  %fptoui = tail call <4 x i64> @llvm.x86.avx512.mask.cvttps2uqq.256(<4 x float> %x, <4 x i64> undef, i8 -1)
  %uitofp = uitofp <4 x i64> %fptoui to <4 x float>
  ret <4 x float> %uitofp
}

define <4 x float> @float_to_uint64_to_float_reg_v4f32(<4 x float> %x) {
; CHECK-LABEL: float_to_uint64_to_float_reg_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2uqq %xmm0, %ymm0
; CHECK-NEXT:    vcvtuqq2ps %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %fptoui = tail call <4 x i64> @llvm.x86.avx512.mask.cvttps2uqq.256(<4 x float> %x, <4 x i64> undef, i8 -1)
  %uitofp = uitofp <4 x i64> %fptoui to <4 x float>
  ret <4 x float> %uitofp
}

define <8 x float> @float_to_sint64_to_float_mem_v8f32(<8 x float>* %p) {
; CHECK-LABEL: float_to_sint64_to_float_mem_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2qq (%rdi), %zmm0
; CHECK-NEXT:    vcvtqq2ps %zmm0, %ymm0
; CHECK-NEXT:    retq
  %x = load <8 x float>, <8 x float>* %p
  %fptosi = tail call <8 x i64> @llvm.x86.avx512.mask.cvttps2qq.512(<8 x float> %x, <8 x i64> undef, i8 -1, i32 4)
  %sitofp = sitofp <8 x i64> %fptosi to <8 x float>
  ret <8 x float> %sitofp
}

define <8 x float> @float_to_sint64_to_float_reg_v8f32(<8 x float> %x) {
; CHECK-LABEL: float_to_sint64_to_float_reg_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2qq %ymm0, %zmm0
; CHECK-NEXT:    vcvtqq2ps %zmm0, %ymm0
; CHECK-NEXT:    retq
  %fptosi = tail call <8 x i64> @llvm.x86.avx512.mask.cvttps2qq.512(<8 x float> %x, <8 x i64> undef, i8 -1, i32 4)
  %sitofp = sitofp <8 x i64> %fptosi to <8 x float>
  ret <8 x float> %sitofp
}

define <8 x float> @float_to_uint64_to_float_mem_v8f32(<8 x float>* %p) {
; CHECK-LABEL: float_to_uint64_to_float_mem_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2uqq (%rdi), %zmm0
; CHECK-NEXT:    vcvtuqq2ps %zmm0, %ymm0
; CHECK-NEXT:    retq
  %x = load <8 x float>, <8 x float>* %p
  %fptoui = tail call <8 x i64> @llvm.x86.avx512.mask.cvttps2uqq.512(<8 x float> %x, <8 x i64> undef, i8 -1, i32 4)
  %uitofp = uitofp <8 x i64> %fptoui to <8 x float>
  ret <8 x float> %uitofp
}

define <8 x float> @float_to_uint64_to_float_reg_v8f32(<8 x float> %x) {
; CHECK-LABEL: float_to_uint64_to_float_reg_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttps2uqq %ymm0, %zmm0
; CHECK-NEXT:    vcvtuqq2ps %zmm0, %ymm0
; CHECK-NEXT:    retq
  %fptoui = tail call <8 x i64> @llvm.x86.avx512.mask.cvttps2uqq.512(<8 x float> %x, <8 x i64> undef, i8 -1, i32 4)
  %uitofp = uitofp <8 x i64> %fptoui to <8 x float>
  ret <8 x float> %uitofp
}

define <2 x double> @double_to_sint64_to_double_mem_v2f64(<2 x double>* %p) {
; CHECK-LABEL: double_to_sint64_to_double_mem_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2qq (%rdi), %xmm0
; CHECK-NEXT:    vcvtqq2pd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x = load <2 x double>, <2 x double>* %p
  %fptosi = tail call <2 x i64> @llvm.x86.avx512.mask.cvttpd2qq.128(<2 x double> %x, <2 x i64> undef, i8 -1)
  %sitofp = sitofp <2 x i64> %fptosi to <2 x double>
  ret <2 x double> %sitofp
}

define <2 x double> @double_to_sint64_to_double_reg_v2f64(<2 x double> %x) {
; CHECK-LABEL: double_to_sint64_to_double_reg_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2qq %xmm0, %xmm0
; CHECK-NEXT:    vcvtqq2pd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %fptosi = tail call <2 x i64> @llvm.x86.avx512.mask.cvttpd2qq.128(<2 x double> %x, <2 x i64> undef, i8 -1)
  %sitofp = sitofp <2 x i64> %fptosi to <2 x double>
  ret <2 x double> %sitofp
}

define <2 x double> @double_to_uint64_to_double_mem_v2f64(<2 x double>* %p) {
; CHECK-LABEL: double_to_uint64_to_double_mem_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2uqq (%rdi), %xmm0
; CHECK-NEXT:    vcvtuqq2pd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x = load <2 x double>, <2 x double>* %p
  %fptoui = tail call <2 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.128(<2 x double> %x, <2 x i64> undef, i8 -1)
  %uitofp = uitofp <2 x i64> %fptoui to <2 x double>
  ret <2 x double> %uitofp
}

define <2 x double> @double_to_uint64_to_double_reg_v2f64(<2 x double> %x) {
; CHECK-LABEL: double_to_uint64_to_double_reg_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2uqq %xmm0, %xmm0
; CHECK-NEXT:    vcvtuqq2pd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %fptoui = tail call <2 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.128(<2 x double> %x, <2 x i64> undef, i8 -1)
  %uitofp = uitofp <2 x i64> %fptoui to <2 x double>
  ret <2 x double> %uitofp
}

define <4 x double> @double_to_sint64_to_double_mem_v4f64(<4 x double>* %p) {
; CHECK-LABEL: double_to_sint64_to_double_mem_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2qq (%rdi), %ymm0
; CHECK-NEXT:    vcvtqq2pd %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = load <4 x double>, <4 x double>* %p
  %fptosi = tail call <4 x i64> @llvm.x86.avx512.mask.cvttpd2qq.256(<4 x double> %x, <4 x i64> undef, i8 -1)
  %sitofp = sitofp <4 x i64> %fptosi to <4 x double>
  ret <4 x double> %sitofp
}

define <4 x double> @double_to_sint64_to_double_reg_v4f64(<4 x double> %x) {
; CHECK-LABEL: double_to_sint64_to_double_reg_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2qq %ymm0, %ymm0
; CHECK-NEXT:    vcvtqq2pd %ymm0, %ymm0
; CHECK-NEXT:    retq
  %fptosi = tail call <4 x i64> @llvm.x86.avx512.mask.cvttpd2qq.256(<4 x double> %x, <4 x i64> undef, i8 -1)
  %sitofp = sitofp <4 x i64> %fptosi to <4 x double>
  ret <4 x double> %sitofp
}

define <4 x double> @double_to_uint64_to_double_mem_v4f64(<4 x double>* %p) {
; CHECK-LABEL: double_to_uint64_to_double_mem_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2uqq (%rdi), %ymm0
; CHECK-NEXT:    vcvtuqq2pd %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = load <4 x double>, <4 x double>* %p
  %fptoui = tail call <4 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.256(<4 x double> %x, <4 x i64> undef, i8 -1)
  %uitofp = uitofp <4 x i64> %fptoui to <4 x double>
  ret <4 x double> %uitofp
}

define <4 x double> @double_to_uint64_to_double_reg_v4f64(<4 x double> %x) {
; CHECK-LABEL: double_to_uint64_to_double_reg_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2uqq %ymm0, %ymm0
; CHECK-NEXT:    vcvtuqq2pd %ymm0, %ymm0
; CHECK-NEXT:    retq
  %fptoui = tail call <4 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.256(<4 x double> %x, <4 x i64> undef, i8 -1)
  %uitofp = uitofp <4 x i64> %fptoui to <4 x double>
  ret <4 x double> %uitofp
}

define <8 x double> @double_to_sint64_to_double_mem_v8f64(<8 x double>* %p) {
; CHECK-LABEL: double_to_sint64_to_double_mem_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2qq (%rdi), %zmm0
; CHECK-NEXT:    vcvtqq2pd %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = load <8 x double>, <8 x double>* %p
  %fptosi = tail call <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double> %x, <8 x i64> undef, i8 -1, i32 4)
  %sitofp = sitofp <8 x i64> %fptosi to <8 x double>
  ret <8 x double> %sitofp
}

define <8 x double> @double_to_sint64_to_double_reg_v8f64(<8 x double> %x) {
; CHECK-LABEL: double_to_sint64_to_double_reg_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2qq %zmm0, %zmm0
; CHECK-NEXT:    vcvtqq2pd %zmm0, %zmm0
; CHECK-NEXT:    retq
  %fptosi = tail call <8 x i64> @llvm.x86.avx512.mask.cvttpd2qq.512(<8 x double> %x, <8 x i64> undef, i8 -1, i32 4)
  %sitofp = sitofp <8 x i64> %fptosi to <8 x double>
  ret <8 x double> %sitofp
}

define <8 x double> @double_to_uint64_to_double_mem_v8f64(<8 x double>* %p) {
; CHECK-LABEL: double_to_uint64_to_double_mem_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2uqq (%rdi), %zmm0
; CHECK-NEXT:    vcvtuqq2pd %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = load <8 x double>, <8 x double>* %p
  %fptoui = tail call <8 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.512(<8 x double> %x, <8 x i64> undef, i8 -1, i32 4)
  %uitofp = uitofp <8 x i64> %fptoui to <8 x double>
  ret <8 x double> %uitofp
}

define <8 x double> @double_to_uint64_to_double_reg_v8f64(<8 x double> %x) {
; CHECK-LABEL: double_to_uint64_to_double_reg_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttpd2uqq %zmm0, %zmm0
; CHECK-NEXT:    vcvtuqq2pd %zmm0, %zmm0
; CHECK-NEXT:    retq
  %fptoui = tail call <8 x i64> @llvm.x86.avx512.mask.cvttpd2uqq.512(<8 x double> %x, <8 x i64> undef, i8 -1, i32 4)
  %uitofp = uitofp <8 x i64> %fptoui to <8 x double>
  ret <8 x double> %uitofp
}