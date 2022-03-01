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
   stp x29, x30, [sp, -96]!
   stp x19, x20, [sp, 16]
   stp x21, x22, [sp, 32]
   stp x23, x24, [sp, 48]
   stp x25, x26, [sp, 64]
   stp x27, x28, [sp, 80]

   // save copy of args
   mov x19, x0
   mov x20, x1
   mov x21, x2
   mov x22, x3
   mov x23, x4
   mov x24, x5

   mov x26, #0 //init loop variables to 0

iloop:
   cmp x26, x22 //compare i and hA
   b.ge end //when i >= hA, go to end
   mov x27, #0

jloop:
   cmp x27, x24  //compare j and wB
   b.ge addi //increment i once j loop has finished iterating
   mov x25, #0
   mov x28, #0

kloop:
   cmp x28, x23 
   b.ge setres // once k == wA, branch
   mul x18, x26, x23
   add x18, x18, x28
   mov x0, #4
   mul x18, x18, x0

   ldr x20, [sp, 24]
   ldr w20, [x20, x19]
   mul x18, x28, x24
   add x19, x19, x28
   mov x0, #4
   mul x18, x18, x0

   

   add x28, x28, #1
   b kloop
setres:
   //C[i * wB + j] = sum;
    
   add x27, x27, #1
   b jloop

addi:
   add x26, x26, #1
   b iloop

end:
   ldp x19, x20, [sp, 16]
   ldp x21, x22, [sp, 32]
   ldp x23, x24, [sp, 48]
   ldp x25, x26, [sp, 64]
   ldp x27, x28, [sp, 80]
   ldp x29, x30, [sp], 96
   ret
