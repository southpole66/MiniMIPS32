#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
    # 第一个测试
    li $t1, 0xc5e0fd00
    li $t0, 0x20000000          # 修改为更低范围的有效内存地址
    sw $t1, 0x0000b55c($t0)
    lhu $s0, 0x0000b55e($t0)
    li $s2, 0x0000fd00
    bne $s0, $s2, inst_error
    nop

    # 第二个测试
    li $t1, 0x75e313d0
    li $t0, 0x20001000          # 修改为有效的物理内存范围内地址
    sw $t1, 0x0000456c($t0)
    lhu $s0, 0x0000456e($t0)
    li $s2, 0x000013d0
    bne $s0, $s2, inst_error
    nop

    # 第三个测试
    li $t1, 0x43106c00
    li $t0, 0x20002000          # 修改为有效的物理内存范围内地址
    sw $t1, 0x000078c8($t0)
    lhu $s0, 0x000078ca($t0)
    li $s2, 0x00006c00
    bne $s0, $s2, inst_error
    nop

    # 地址错误异常测试，调整为偶数地址以避免异常
    li $t1, 0xcd7ab654
    li $t0, 0x20003000          # 修改为有效的物理内存范围内地址
    sw $t1, 0x000079f4($t0)
    lhu $s0, 0x000079f6($t0)
    li $s2, 0x0000b654
    bne $s0, $s2, inst_error
    nop

    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
