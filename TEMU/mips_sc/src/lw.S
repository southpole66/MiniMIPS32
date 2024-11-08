#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
   
    li $t1, 0x6f59f5d3
    li $t0, 0x00000bdc             
    sw $t1, 0x00000000($t0)
    lw $s0, 0x00000000($t0)         # 4 字节对齐读取地址
    li $s2, 0x6f59f5d3
    bne $s0, $s2, inst_error
    nop

  
    li $t1, 0x383e8970
    li $t0, 0x00008ae4             
    sw $t1, 0x00000000($t0)
    lw $s0, 0x00000000($t0)         # 4 字节对齐读取地址
    li $s2, 0x383e8970
    bne $s0, $s2, inst_error
    nop

   
    li $t1, 0xe4a9ee00
    li $t0, 0x00010000             
    sw $t1, 0x00000000($t0)
    lw $s0, 0x00000000($t0)         # 4 字节对齐读取地址
    li $s2, 0xe4a9ee00
    bne $s0, $s2, inst_error
    nop

    # 地址错误异常
    li $t1, 0xdd064458
    li $t0, 0x00005bac              # 使用低地址范围
    sw $t1, 0x00000000($t0)         # 写入 4 字节对齐地址
    lw $s0, 0x00000000($t0)         # 读取 4 字节对齐地址
    li $s2, 0xdd064458              # 与写入值比较
    bne $s0, $s2, inst_error
    nop

    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
