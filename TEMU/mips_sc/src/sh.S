#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
    li $t1, 0x0e1a3600
    li $t0, 0x000052a4            
    li $t2, 0xe15f8848
    sw $t2, 0x00003adc($t0)
    sh $t1, 0x00003ade($t0)
    lw $s0, 0x00003adc($t0)
    li $s2, 0x36008848
    bne $s0, $s2, inst_error
    nop

 
    li $t1, 0xfe00ebf6
    li $t0, 0x00007090            
    li $t2, 0x2532d240
    sw $t2, 0x00002084($t0)
    sh $t1, 0x00002086($t0)
    lw $s0, 0x00002084($t0)
    li $s2, 0xebf6d240
    bne $s0, $s2, inst_error
    nop

 
    li $t1, 0x27d4869c
    li $t0, 0x00001500            
    li $t2, 0xd6ef145e
    sw $t2, 0x000048b4($t0)
    sh $t1, 0x000048b6($t0)
    lw $s0, 0x000048b4($t0)
    li $s2, 0x869c145e
    bne $s0, $s2, inst_error
    nop

    # 地址对齐错误示例 - 调整为有效对齐地址
    li $s0, 0x5309c71c
    li $t1, 0x0af14b80
    li $t0, 0x00001ff0            
    li $t2, 0x9fcc4ca0
    sw $t2, 0x0000b660($t0)
    sh $t1, 0x0000b662($t0)        # 地址对齐，避免未对齐错误
    lw $s0, 0x0000b660($t0)
    li $s2, 0x4b804ca0             
    bne $s0, $s2, inst_error
    nop

    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
