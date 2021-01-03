#include "instruction.h"
#include "opcodes.h"

optable instruction_table[] = {
	{"hlt", HLT, iA, op_hlt},
	{"nop", NOP, iA, op_nop},
	{"neg", NEG, iA, op_neg},
	{"add", ADD, iA, op_add},
	{"sub", SUB, iA, op_sub},
	{"mul", MUL, iA, op_mul},
	{"div", DIV, iA, op_div},
	{"mod", MOD, iA, op_mod},
	{"not", NOT, iA, op_not},
	{"or", OR, iA, op_or},
	{"and", AND, iA, op_and},
	{"xor", XOR, iA, op_xor},
	{"shl", SHL, iB, op_shl},
	{"shr", SHR, iB, op_shr},
	{"pop", POP, iB, op_pop},
	{"ret", RET, iA, op_ret},
	{"jmp", JMP, iC, op_jmp},
	{"jmpt", JMPT, iC, op_jmpt},
	{"jmpf", JMPF, iC, op_jmpf},
	{"call", CALL, iC, op_call},
	{"eq", EQ, iA, op_eq},
	{"neq", NEQ, iA, op_neq},
	{"lt", LT, iA, op_lt},
	{"le", LE, iA, op_le},
	{"gt", GT, iA, op_gt},
	{"ge", GE, iA, op_ge},
	{"get", GET, iC, op_get},
	{"set", SET, iC, op_set},
	{"imm", IMM, iC, op_imm}
};
