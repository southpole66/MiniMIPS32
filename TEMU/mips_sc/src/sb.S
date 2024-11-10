#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
    li $t1, 0x33e94a7c
    li $t0, 0x000054b4            
    li $t2, 0x2a18bf86
    sw $t2, 0x00005210($t0)
    sb $t1, 0x00005210($t0)
    lw $s0, 0x00005210($t0)
    li $s2, 0x2a18bf7c
    bne $s0, $s2, inst_error
    nop

    li $t1, 0x294337c4
    li $t0, 0x00003a28             
    li $t2, 0xc9df3d10
    sw $t2, 0x0000a530($t0)
    sb $t1, 0x0000a532($t0)
    lw $s0, 0x0000a530($t0)
    li $s2, 0xc9c43d10
    bne $s0, $s2, inst_error
    nop

    li $t1, 0x12043778
    li $t0, 0x00009718             
    li $t2, 0x9a9163f0
    sw $t2, 0x00000120($t0)
    sb $t1, 0x00000121($t0)
    lw $s0, 0x00000120($t0)
    li $s2, 0x9a9178f0
    bne $s0, $s2, inst_error
    nop

    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP
