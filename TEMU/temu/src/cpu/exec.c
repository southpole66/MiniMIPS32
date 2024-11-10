#include "helper.h"
#include "all-instr.h"
#include "monitor.h"

typedef void (*op_fun)(uint32_t);
static make_helper(_2byte_esc);
static make_helper(b_sel);
static make_helper(privilege_instr);
static make_helper(trap_handler);

Operands ops_decoded;
uint32_t instr;
	

/* TODO: Add more instructions!!! */

op_fun opcode_table [64] = {
/* 0x00 */	_2byte_esc, b_sel, j, jal,
/* 0x04 */	beq, bne, blez, bgtz,
/* 0x08 */	addi, addiu, slti, sltiu,
/* 0x0c */	andi,ori, xori, lui,
/* 0x10 */  privilege_instr, inv, temu_trap, inv,
/* 0x14 */	inv, inv, inv, inv,
/* 0x18 */	inv, inv, inv, inv,
/* 0x1c */	inv, inv, inv, inv,
/* 0x20 */	lb, lh, inv, lw,
/* 0x24 */	lbu, lhu, inv, inv,
/* 0x28 */	sb, sh, inv, sw,
/* 0x2c */	inv, inv, inv, inv,
/* 0x30 */	inv, inv, inv, inv,
/* 0x34 */	inv, inv, inv, inv,
/* 0x38 */	inv, inv, inv, inv,
/* 0x3c */	inv, inv, inv, inv
};

op_fun _2byte_opcode_table [64] = {
/* 0x00 */	sll, inv, srl, sra, 
/* 0x04 */	sllv, inv, srlv, srav, 
/* 0x08 */	jr, jalr, inv, inv, 
/* 0x0c */	syscall, break_, inv, inv, 
/* 0x10 */	mfhi, mthi, mflo, mtlo, 
/* 0x14 */	inv, inv, inv, inv, 
/* 0x18 */	mult, multu, div, divu, 
/* 0x1c */	inv, inv, inv, inv, 
/* 0x20 */	add, addu, sub, subu, 
/* 0x24 */	and, or, xor, nor,
/* 0x28 */	inv, inv, slt, sltu, 
/* 0x2c */	inv, inv, inv, inv, 
/* 0x30 */	inv, inv, inv, inv, 
/* 0x34 */	inv, inv, inv, inv,
/* 0x38 */	inv, inv, inv, inv, 
/* 0x3c */	inv, inv, inv, bad_temu_trap
};

make_helper(exec) {
	// 判断地址错误例外
	if(pc & 0x3) {
		if(cpu.cp0.status.EXL == 0){
			cpu.cp0.cause.ExcCode = AdEL;
			cpu.cp0.EPC = pc;
			pc = TRAP_ADDR;
			cpu.cp0.status.EXL = 1;
		}
		return;
	}
	if(pc == 0x1FC00380 && cpu.cp0.cause.ExcCode != 0) {
		trap_handler(pc);   //处理异常
		return;
	}


	instr = instr_fetch(pc, 4);
	ops_decoded.opcode = instr >> 26;
	opcode_table[ ops_decoded.opcode ](pc);

	/*----------Gloden_trace----------*/
	if(temu_state != END){
	int Rd_num = op_dest->reg;
	//根据测试更新
	if(Rd_num==-1)
	Trace("%08x		%02d(%s)		%08x\n", cpu.pc, -1, "$HI", cpu.hi);
	else if(Rd_num==-2)
	Trace("%08x		%02d(%s)		%08x\n", cpu.pc, -1, "$LO", cpu.lo);
	else if(Rd_num==-3)
	Trace("%08x		%08x(%s)		%08x(%s)\n", cpu.pc, cpu.hi, "$HI", cpu.lo, "$LO");
	else
	Trace("%08x		%02d(%s)		%08x\n", cpu.pc, Rd_num, REG_NAME(Rd_num), reg_w(Rd_num));
	}
}

static make_helper(_2byte_esc) {
	ops_decoded.func = instr & FUNC_MASK;
	_2byte_opcode_table[ops_decoded.func](pc); 
}


static make_helper(b_sel) {
	uint32_t select = (instr & 0x001F0000) >> 16;
	switch(select) {
		case 0:
			bltz(pc);
            break;
		case 1:
			bgez(pc);
            break;
		case 16:
			bltzal(pc);
            break;
		case 17:
			bgezal(pc);
            break;
	}
}

static make_helper(privilege_instr) {
	uint32_t select = (instr >> 21) & 0x001F;
	switch(select) {
		case 0:
			mfc0(pc);
            break;
		case 4:
			mtc0(pc);
            break;
		case 16:
			eret(pc);
            break;
	}
}

static make_helper(trap_handler) {
	switch(cpu.cp0.cause.ExcCode) {
		case AdEL:
			printf("Instruction read address error.\n");
			break;
		case AdES:
			printf("Instruction write address error.\n");
			break;
		case Ov:
			printf("Int overflow error.\n");
			break;
		case Sys:
			printf("Syscall.\n");
			break;
		case Bp:
			printf("Break.\n");
			break;
		case RI:
			printf("Reversed instruction error.\n");
			break;
		default:
			printf("Unresolved exception.\n");
	}
	eret(pc);
}