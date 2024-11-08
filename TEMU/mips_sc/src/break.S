#include "trap.h"
    .set noreorder
    .set noat 
    .global main 
    .text 

main:
    break
    mfc0 $t0, $13
    li $s0, 0x24
    bne $t0, $s0, inst_error
    nop

    HIT_GOOD_TRAP

inst_error: 
    HIT_BAD_TRAP
    