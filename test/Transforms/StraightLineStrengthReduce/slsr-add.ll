; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slsr -gvn -S | FileCheck %s

target datalayout = "e-i64:64-v16:16-v32:32-n16:32:64"

define void @shl(i32 %b, i32 %s) {
; CHECK-LABEL: @shl(
; CHECK-NEXT:    [[T1:%.*]] = add i32 [[B:%.*]], [[S:%.*]]
; CHECK-NEXT:    call void @foo(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[T1]], [[S]]
; CHECK-NEXT:    call void @foo(i32 [[T2]])
; CHECK-NEXT:    ret void
;
  %t1 = add i32 %b, %s
  call void @foo(i32 %t1)
  %s2 = shl i32 %s, 1
  %t2 = add i32 %b, %s2
  call void @foo(i32 %t2)
  ret void
}

define void @stride_is_2s(i32 %b, i32 %s) {
; CHECK-LABEL: @stride_is_2s(
; CHECK-NEXT:    [[S2:%.*]] = shl i32 [[S:%.*]], 1
; CHECK-NEXT:    [[T1:%.*]] = add i32 [[B:%.*]], [[S2]]
; CHECK-NEXT:    call void @foo(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[T1]], [[S2]]
; CHECK-NEXT:    call void @foo(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[T2]], [[S2]]
; CHECK-NEXT:    call void @foo(i32 [[T3]])
; CHECK-NEXT:    ret void
;
  %s2 = shl i32 %s, 1
  %t1 = add i32 %b, %s2
  call void @foo(i32 %t1)
  %s4 = shl i32 %s, 2
  %t2 = add i32 %b, %s4
  call void @foo(i32 %t2)
  %s6 = mul i32 %s, 6
  %t3 = add i32 %b, %s6
  call void @foo(i32 %t3)
  ret void
}

define void @stride_is_3s(i32 %b, i32 %s) {
; CHECK-LABEL: @stride_is_3s(
; CHECK-NEXT:    [[T1:%.*]] = add i32 [[S:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @foo(i32 [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[S]], 3
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[T1]], [[TMP1]]
; CHECK-NEXT:    call void @foo(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[T2]], [[TMP1]]
; CHECK-NEXT:    call void @foo(i32 [[T3]])
; CHECK-NEXT:    ret void
;
  %t1 = add i32 %s, %b
  call void @foo(i32 %t1)
  %s4 = shl i32 %s, 2
  %t2 = add i32 %s4, %b
  call void @foo(i32 %t2)
  %s7 = mul i32 %s, 7
  %t3 = add i32 %s7, %b
  call void @foo(i32 %t3)
  ret void
}

; foo(b + 6 * s);
; foo(b + 4 * s);
; foo(b + 2 * s);
;   =>
; t1 = b + 6 * s;
; foo(t1);
; s2 = 2 * s;
; t2 = t1 - s2;
; foo(t2);
; t3 = t2 - s2;
; foo(t3);
define void @stride_is_minus_2s(i32 %b, i32 %s) {
; CHECK-LABEL: @stride_is_minus_2s(
; CHECK-NEXT:    [[S6:%.*]] = mul i32 [[S:%.*]], 6
; CHECK-NEXT:    [[T1:%.*]] = add i32 [[B:%.*]], [[S6]]
; CHECK-NEXT:    call void @foo(i32 [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[S]], 1
; CHECK-NEXT:    [[T2:%.*]] = sub i32 [[T1]], [[TMP1]]
; CHECK-NEXT:    call void @foo(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = sub i32 [[T2]], [[TMP1]]
; CHECK-NEXT:    call void @foo(i32 [[T3]])
; CHECK-NEXT:    ret void
;
  %s6 = mul i32 %s, 6
  %t1 = add i32 %b, %s6
  call void @foo(i32 %t1)
  %s4 = shl i32 %s, 2
  %t2 = add i32 %b, %s4
  call void @foo(i32 %t2)
  %s2 = shl i32 %s, 1
  %t3 = add i32 %b, %s2
  call void @foo(i32 %t3)
  ret void
}

; TODO: This pass is targeted at simple address-calcs, so it is artificially limited to
; match scalar values. The code could be modified to handle vector types too.

define void @stride_is_minus_2s_vec(<2 x i32> %b, <2 x i32> %s) {
; CHECK-LABEL: @stride_is_minus_2s_vec(
; CHECK-NEXT:    [[S6:%.*]] = mul <2 x i32> [[S:%.*]], <i32 6, i32 6>
; CHECK-NEXT:    [[T1:%.*]] = add <2 x i32> [[B:%.*]], [[S6]]
; CHECK-NEXT:    call void @voo(<2 x i32> [[T1]])
; CHECK-NEXT:    [[S4:%.*]] = shl <2 x i32> [[S]], <i32 2, i32 2>
; CHECK-NEXT:    [[T2:%.*]] = add <2 x i32> [[B]], [[S4]]
; CHECK-NEXT:    call void @voo(<2 x i32> [[T2]])
; CHECK-NEXT:    [[S2:%.*]] = shl <2 x i32> [[S]], <i32 1, i32 1>
; CHECK-NEXT:    [[T3:%.*]] = add <2 x i32> [[B]], [[S2]]
; CHECK-NEXT:    call void @voo(<2 x i32> [[T3]])
; CHECK-NEXT:    ret void
;
  %s6 = mul <2 x i32> %s, <i32 6, i32 6>
  %t1 = add <2 x i32> %b, %s6
  call void @voo(<2 x i32> %t1)
  %s4 = shl <2 x i32> %s, <i32 2, i32 2>
  %t2 = add <2 x i32> %b, %s4
  call void @voo(<2 x i32> %t2)
  %s2 = shl <2 x i32> %s, <i32 1, i32 1>
  %t3 = add <2 x i32> %b, %s2
  call void @voo(<2 x i32> %t3)
  ret void
}

; t = b + (s << 3);
; foo(t);
; foo(b + s);
;
; do not rewrite b + s to t - 7 * s because the latter is more complicated.
define void @simple_enough(i32 %b, i32 %s) {
; CHECK-LABEL: @simple_enough(
; CHECK-NEXT:    [[S8:%.*]] = shl i32 [[S:%.*]], 3
; CHECK-NEXT:    [[T1:%.*]] = add i32 [[B:%.*]], [[S8]]
; CHECK-NEXT:    call void @foo(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[B]], [[S]]
; CHECK-NEXT:    call void @foo(i32 [[T2]])
; CHECK-NEXT:    ret void
;
  %s8 = shl i32 %s, 3
  %t1 = add i32 %b, %s8
  call void @foo(i32 %t1)
  %t2 = add i32 %b, %s
  call void @foo(i32 %t2)
  ret void
}

define void @slsr_strided_add_128bit(i128 %b, i128 %s) {
; CHECK-LABEL: @slsr_strided_add_128bit(
; CHECK-NEXT:    [[S125:%.*]] = shl i128 [[S:%.*]], 125
; CHECK-NEXT:    [[T1:%.*]] = add i128 [[B:%.*]], [[S125]]
; CHECK-NEXT:    call void @bar(i128 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i128 [[T1]], [[S125]]
; CHECK-NEXT:    call void @bar(i128 [[T2]])
; CHECK-NEXT:    ret void
;
  %s125 = shl i128 %s, 125
  %s126 = shl i128 %s, 126
  %t1 = add i128 %b, %s125
  call void @bar(i128 %t1)
  %t2 = add i128 %b, %s126
  call void @bar(i128 %t2)
  ret void
}

declare void @foo(i32)
declare void @voo(<2 x i32>)
declare void @bar(i128)
