#include "helper.h"
#include "monitor.h"
#include "reg.h"

extern uint32_t instr;
extern char assembly[80];

make_helper(eret) {
    cpu.pc = cpu.cp0.EPC;
    cpu.cp0.status.EXL = 0;
    sprintf(assembly, "eret");
}

static void decode_mfc0(uint32_t instr) {
    op_dest->type = OP_TYPE_REG;
    op_dest->reg = (instr & 0x001F0000) >> 16;

    op_src1->type = OP_TYPE_REG;
    op_src1->reg = (instr & 0x0000F800) >> 11;

    op_src2->type = OP_TYPE_IMM;
    op_src2->imm = (instr & 0x00000007);
}

// 向协处理器0的寄存器取值
make_helper(mfc0) {
    decode_mfc0(instr);
    if(op_src1->reg == R_BadVAddr && op_src2->imm == 0) {
        reg_w(op_dest->reg) = cpu.cp0.BadVAddr;
        sprintf(assembly, "MFC0 %s, BadVAddr, 0x%04x", REG_NAME(op_dest->reg), op_src2->imm);
    }else if(op_src1->reg == R_Cause && op_src2->imm == 0) {
        reg_w(op_dest->reg) = cpu.cp0.cause.val;
        sprintf(assembly, "MFC0 %s, Casue, 0x%04x", REG_NAME(op_dest->reg), op_src2->imm);
    }else if(op_src1->reg == R_EPC && op_src2->imm == 0) {
        reg_w(op_dest->reg) = cpu.cp0.EPC;
        sprintf(assembly, "MFC0 %s, EPC, 0x%04x", REG_NAME(op_dest->reg), op_src2->imm);
    }else if(op_src1->reg == R_Status && op_src2->imm == 0) {
        reg_w(op_dest->reg) = cpu.cp0.status.val;
        sprintf(assembly, "MFC0 %s, Status, 0x%04x", REG_NAME(op_dest->reg), op_src2->imm);
    }else {
        panic("[MFC0] Invalid cp0 register.\n");
    }
}

static void decode_mtc0(uint32_t instr) {
    op_dest->type = OP_TYPE_REG;
    op_dest->reg = (instr & 0x0000F800) >> 11;

    op_src1->type = OP_TYPE_REG;
    op_src1->reg = (instr & 0x001F0000) >> 16;

    op_src2->type = OP_TYPE_IMM;
    op_src2->imm = (instr & 0x00000007);
}

// 向协处理器0的寄存器存值
make_helper(mtc0) {
    decode_mtc0(instr);
    if(op_dest->reg == R_BadVAddr && op_src2->imm == 0) {
        cpu.cp0.BadVAddr = reg_w(op_src1->reg);
        sprintf(assembly, "MTC0 %s, BadVAddr, 0x%04x", REG_NAME(op_src1->reg), op_src2->imm);
    }else if(op_dest->reg == R_Cause && op_src2->imm == 0) {
        cpu.cp0.cause.val = reg_w(op_src1->reg);
        sprintf(assembly, "MTC0 %s, Casue, 0x%04x", REG_NAME(op_src1->reg), op_src2->imm);
    }else if(op_dest->reg == R_EPC && op_src2->imm == 0) {
        cpu.cp0.EPC = reg_w(op_src1->reg);
        sprintf(assembly, "MTC0 %s, EPC, 0x%04x", REG_NAME(op_src1->reg), op_src2->imm);
    }else if(op_dest->reg == R_Status && op_src2->imm == 0) {
        cpu.cp0.status.val = reg_w(op_src1->reg);
        sprintf(assembly, "MTC0 %s, Status, 0x%04x", REG_NAME(op_src1->reg), op_src2->imm);
    }else {
        panic("[MTC0] Invalid cp0 register.\n");
    }
}
