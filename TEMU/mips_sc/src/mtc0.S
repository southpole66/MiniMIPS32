#include "trap.h"
    .set noreorder
    .set noat 
    .global main 
    .text 

main:
    li $t0, 0x1
#检查发生异常时的地址
    mtc0 $t0, $8
    mfc0 $t2, $8
    nop

#检查 cp0 状态寄存器的值
    mtc0 $t0, $12
    mfc0 $t3, $12
    nop

#检查异常原因
    mtc0 $t0, $13
    mfc0 $t4, $13
    nop

#检查异常时的程序计数器
    mtc0 $t0, $14
    mfc0 $t5, $14
    nop

    HIT_GOOD_TRAP
