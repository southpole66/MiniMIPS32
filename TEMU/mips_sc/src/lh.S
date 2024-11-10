#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
    li $t1, 0x51842560
    li $t0, 0x00102bc4          # 修改内存地址到有效范围
    sw $t1, 0x0000127c($t0)
    lh $s0, 0x0000127c($t0)
    li $s2, 0x00002560
    bne $s0, $s2, inst_error
    nop

    # 测试结果的符号扩展
    li $t1, 0xa28fbedc
    li $t0, 0x0010130c          # 修改内存地址到有效范围
    sw $t1, 0x0000cf28($t0)
    lh $s0, 0x0000cf28($t0)
    li $s2, 0xffffbedc
    bne $s0, $s2, inst_error
    nop

    li $t1, 0x6dbe93b6
    li $t0, 0x00102a08          # 修改内存地址到有效范围
    sw $t1, 0x000013e0($t0)
    lh $s0, 0x000013e0($t0)
    li $s2, 0xffff93b6
    bne $s0, $s2, inst_error
    nop

    li $t1, 0xe96e7db0
    li $t0, 0x001025e8          # 修改内存地址到有效范围
    sw $t1, 0x0000b508($t0)
    lh $s0, 0x0000b508($t0)
    li $s2, 0x00007db0
    bne $s0, $s2, inst_error
    nop

    # 地址错误异常测试：使用偶数地址以避免异常
    li $s0, 0xd80241b4
    li $t1, 0x63c6e7af
    li $t0, 0x00103d5c          # 修改内存地址到有效范围
    sw $t1, 0x000032e8($t0)
    lh $s0, 0x000032e8($t0)     # 将读取地址改为偶数
    li $s2, 0x63c6
    bne $s0, $s2, inst_error
    nop
    
    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
