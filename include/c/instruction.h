#pragma once

#include "vm.h"

#define iA 0
#define iB 1
#define iC 2

typedef enum {
	HLT,
	NOP,
	NEG,
	ADD, SUB, MUL, DIV, MOD,
	NOT, OR, AND, XOR,
	SHL, SHR,
	POP, RET,
	JMP, JMPT, JMPF, CALL,
	EQ, NEQ, LT, LE, GT, GE,
	GET, SET, IMM
} opcode;

typedef struct {
	char* mnemonic;
	char opcode;
	char format;
	void (*handler)(jade_vm* vm, short operand);
} optable;

extern optable instruction_table[IMM + 1];
