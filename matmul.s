////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////


/*

SEE FLOWCHART IN GIT REPO

x19: C & t1
x20: A
x21: B
x22: hA & t2
x23: wA
x24: wB
x25: sum
x26: i
x27: j
x28: k

 */



	.arch armv8-a
	.global matmul
matmul:
	stp x29, x30, [sp, -96]! //save required registers
	stp x19, x20, [sp, 16]
	stp x21, x22, [sp, 32]
	stp x23, x24, [sp, 48]
	stp x25, x26, [sp, 64]
	stp x27, x28, [sp, 80]

	mov x19, x0 //save copy of all args
	mov x20, x1
	mov x21, x2
	mov x22, x3 
	mov x23, x4 
	mov x24, x5

	mov x26, #0 //init loop variables to 0
	mov x27, #0
	mov x28, #0
iloop:
	cmp x26, x22
	b.ge end
jloop:
	cmp x27, x24
	b.ge addi
	mov x25, #0
kloop:
	cmp x28, x23
	b.ge setres
	stp x19, x22, [sp, -16]! //need more space so pushing these to stack for now
	mov x0, x26
	mov x1, x23
	bl intmul
	mov x1, x28
	bl intadd
	mov x19, x0
	mov x0, x28
	mov x1, x24
	bl intmul
	mov x1, x27
	bl intadd
	mov x22, x0
cval:
	ldr x19, [x20, x19]
	ldr x22, [x21, x22]
	mov x0, x19
	mov x1, x22
	bl intmul
	mov x1, x25
	bl intadd
	mov x25, x0
	ldp x19, x22, [sp], 16
	mov x0, x28
	mov x1, #1
	bl intadd
	mov x28, x0
	b kloop
setres:
	mov x0, x24
	mov x1, x26
	bl intmul
	mov x1, x27
	bl intadd
	str x25, [x19, x0]
	mov x0, x27
	mov x1, #1
	bl intadd
	mov x27, x0
	b jloop
addi:
	mov x0, x26
	mov x1, #1
	bl intadd
	mov x26, x0
	b iloop
end:
	ldp x19, x20, [sp, 16]
	ldp x21, x22, [sp, 32]
	ldp x23, x24, [sp, 48]
	ldp x25, x26, [sp, 64]
	ldp x27, x28, [sp, 80]
	ldp x29, x30, [sp], 96
	ret
