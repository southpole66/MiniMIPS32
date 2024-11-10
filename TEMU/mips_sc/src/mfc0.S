#include "trap.h"
    .set noreorder
    .set noat 
    .global main 
    .text 

main:
    li $t0, 0xbfc0ffff
    li $t1, 0xdd064458
    sw $t1, 0x0000003c($t0) # 触发地址错误异常

#检查异常发生时的地址
    mfc0 $t2, $8
    nop

#检查状态寄存器的值
    mfc0 $t3, $12
    nop

#检查异常原因 
    mfc0 $t4, $13
    nop

#检查异常程序计数器的值
    mfc0 $t5, $14
    nop

    HIT_GOOD_TRAP
inst_error:
    HIT_BAD_TRAP