// intmul function in this file

    .arch armv8-a
    .global intmul
/*
SEE FLOWCHART INCLUDED IN GIT REPO
x19: sum
x20: mask
x21: temp
x22: temp2
x23: temp3
x24: comparison register
x0: arg1
x1: arg2
 */

intmul:
        stp x29, x30, [sp, -64]! 
        mov x29, sp
        stp x19, x20, [sp, 16]
        stp x21, x22, [sp, 32]
        stp x23, x24, [sp, 48]

        mov x24, #1
        lsl x24, x24, #63

        mov x19, #0
        mov x21, x0
        mov x23, x1
        mov x20, #1
nextb:
        and x22, x23, x20
        cmp x22, x20
        b.ne skipadd
        mov x0, x19
        mov x1, x21
        bl intadd
        mov x19, x0
skipadd:
        lsl x21, x21, #1
        cmp x20, x24
        b.eq done
        lsl x20, x20, #1
        b nextb
done:
        mov x0, x19
        ldp x19, x20, [sp, 16]
        ldp x21, x22, [sp, 32]
        ldp x23, x24, [sp, 48]
        ldp x29, x30, [sp], 64
        ret