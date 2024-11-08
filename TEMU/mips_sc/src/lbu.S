#include "trap.h"
    .set noreorder
    .global main 
    .text 

main:
    li $t1, 0x79dbf0ff
    li $t0, 0x00105498  
    sw $t1, 0x00001408($t0)
    lbu $s0, 0x00001408($t0)
    li $s2, 0x000000ff
    bne $s0, $s2, inst_error

    li $t1, 0x13f91e58
    li $t0, 0x00101f30   
    sw $t1, 0x0000b600($t0)
    lbu $s0, 0x0000b600($t0)
    li $s2, 0x00000058
    bne $s0, $s2, inst_error
   
    li $t1, 0xee33dcd0
    li $t0, 0x0010bc2c   
    sw $t1, 0x00001868($t0)
    lbu $s0, 0x00001869($t0)
    li $s2, 0x000000dc
    bne $s0, $s2, inst_error
    
    HIT_GOOD_TRAP

inst_error:
    HIT_BAD_TRAP

