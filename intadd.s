// intadd function in this file

    .arch armv8-a
    .global intadd

/*

SEE FLOWCHART INCLUDED IN GIT REPO

x9: mask
x10: sum
x11: carry
X12,x13: intermediate registers
x14,x15: temp, temp2
x7: temp3
x4: comparison register for when done adding 

x0: arg1
x1: arg2

*/

intadd:
        stp x29, x30, [sp, -16]!
        mov x29, sp
        mov x10, #0 
        mov x11, #0
        mov x9, #1

        mov x4, #1 
        lsl x4, x4, #63

nextb:  
        and x12, x9, x0
        and x13, x9, x1
        eor x14, x12, x13
        eor x15, x14, x11
        and x14, x11, x14
        orr x10, x15, x10
        and x7, x12, x13
        orr x11, x7, x14
        lsl x11, x11, #1
        cmp x9, x4
        b.eq done
        lsl x9, x9, #1
        b nextb
done:
        mov x0, x10 
        ldp x29, x30, [sp], 16
        ret