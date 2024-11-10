#include "trap.h"
    .set noreorder
    .set noat 
    .global main 
    .text 

main:
    li $t0, 0x7fffffff
    addi $t0, $t0, 0x7fff # 溢出
    mfc0 $t1, $12 # 验证eret返回后，status置为0
    li $s0, 0x0
    bne $t1, $s0, inst_error
    nop

    HIT_GOOD_TRAP

inst_error: 
    HIT_BAD_TRAP