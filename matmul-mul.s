# matmul function that uses the ARM mul instruction

/*

SEE FlOWCHART IN GIT REPO 

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
   // save registers
   stp x29, x30, [sp, -16]!

   // save copy of args

   mov x7, #0 //init loop variables to 0
//x6, x7: sum, i
//x13, x14: j, k

iloop:
   cmp x7, x3 //compare i and hA
   b.ge end //when i >= hA, go to end
   mov x13, #0

jloop:
   cmp x13, x5  //compare j and wB
   b.ge addi //increment i once j loop has finished iterating
   mov x6, #0
   mov x14, #0

kloop:
   cmp x14, x4 
   b.ge setres // once k == wA, branch
   //sum += A[i * wA + k] * B[k * wB + 
   mul x9, x7, x4
   add x9, x9, x14
   mov x10, #4
   mul x9, x9, x10
   ldr x11, [x1, x9]
   mul x9, x14, x5
   add x9, x9, x14
   mov x10, #4
   mul x9, x9, x10
   ldr x12, [x2, x9]
   mul x9, x12, x11
   add x6, x6, x9
   add x14, x14, #1
   b kloop

setres:
   //C[i * wB + j] = sum;
   //i * wB + j
   mul x9, x7, x5 //i * wB
   add x9, x9, x13 //i * wB + j
   mov x10, #4
   mul x9, x9, x10
   str w6, [x0, x9]
   add x13, x13, #1
   b jloop

addi:
   add x7, x7, #1
   b iloop

end:
   ldp x29, x30, [sp], 16
   ret
