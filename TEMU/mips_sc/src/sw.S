#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
    li $t1, 0x14908300
    li $t0, 0x00004ae8            
    sw $t1, 0x00005bd8($t0)
    lw $s0, 0x00005bd8($t0)
    li $s2, 0x14908300
    bne $s0, $s2, inst_error
    nop

   
    li $t1, 0x5753dd01
    li $t0, 0x00002ca0            
    sw $t1, 0x00002780($t0)
    lw $s0, 0x00002780($t0)
    li $s2, 0x5753dd01
    bne $s0, $s2, inst_error
    nop

   
    li $t1, 0x5ca0fd00
    li $t0, 0x00009834            
    sw $t1, 0x00005070($t0)
    lw $s0, 0x00005070($t0)
    li $s2, 0x5ca0fd00
    bne $s0, $s2, inst_error
    nop

    # 地址错误异常
    li $s0, 0xeb54b87c
    li $t1, 0x4dac8b78
    li $t0, 0x0000a256            
    li $t2, 0xed3cc1d0
    sw $t2, 0x000000c0($t0)
    sw $t1, 0x000000c0($t0)
    lw $s0, 0x000000c0($t0)
    li $s2, 0xeb54b87c
    bne $s0, $s2, inst_error
    nop

    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
