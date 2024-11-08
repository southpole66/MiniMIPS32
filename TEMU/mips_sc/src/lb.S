#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
    nop
    li $t0, 0x00106760     
    li $t1, 0x12345678
    sw $t1, 0x000037a0($t0) 
    nop
    li $t1, 0xc83b0be0
    li $t0, 0x00106760     
    sw $t1, 0x000037a0($t0)
    lb $s0, 0x000037a1($t0)
    li $s2, 0x0000000b
    bne $s0, $s2, inst_error
    
    li $t1, 0x12345678
    li $t0, 0x00000000     
    sw $t1, 0x000037a0($t0)
    lb $s0, 0x000037a1($t0)
    li $s2, 0x00000056
    bne $s0, $s2, inst_error

    # 测试结果的有符号扩展
    li $t1, 0x12348678
    li $t0, 0x00000000     
    sw $t1, 0x000037a0($t0)
    lb $s0, 0x000037a1($t0)
    li $s2, 0xffffff86
    bne $s0, $s2, inst_error

    li $t1, 0x12345678
    li $t0, 0x00000000     
    sw $t1, 0x000037a0($t0)
    lb $s0, 0x000037a3($t0)
    li $s2, 0x00000012
    bne $s0, $s2, inst_error
    # 测试
    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
