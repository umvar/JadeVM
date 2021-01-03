#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "instruction.h"
#include "vm.h"

void vm_init(jade_vm* vm, int argc, char** argv) {
	vm->state = JADE_VM_NOT_READY;
	vm->pc = 0;
	vm->sp = -1;
	vm->instr_mem = malloc(MEM_SIZE);
	vm->stack_mem = malloc(MEM_SIZE);
	for (int i = 2; i < argc; i++) {
		vm_push(vm, atoi(argv[i]));
	}
	vm_push(vm, argc - 2);
}

void vm_destroy(jade_vm* vm) {
	vm->state = JADE_VM_HALTED;
	free(vm->instr_mem);
	free(vm->stack_mem);
}

void vm_push(jade_vm* vm, short val) {
	vm->sp++;
	vm->stack_mem[vm->sp] = val;
}

short vm_pop(jade_vm* vm) {
	short val = vm->stack_mem[vm->sp];
	vm->sp--;
	return val;
}

unsigned char vm_fetch(jade_vm* vm) {
	unsigned char instr = vm->instr_mem[vm->pc];
	vm->pc++;
	return instr;
}

void vm_step(jade_vm* vm) {
	unsigned char opcode = vm_fetch(vm);
	optable* instr = &instruction_table[opcode];
	unsigned short operand = 0;
	if (instr->format == iB) {
		operand = vm_fetch(vm);
	} else if (instr->format == iC) {
		unsigned char lower = vm_fetch(vm);
		unsigned char upper = vm_fetch(vm);
		operand = (upper << 8) | lower;
	}
	instr->handler(vm, (short)operand);
}

void vm_continue(jade_vm* vm) {
	while (vm->state == JADE_VM_READY)
		vm_step(vm);
	printf("VM HALTED\n");
}

void vm_load_program(jade_vm* vm, const char* path) {
	FILE* file = fopen(path, "rb");
	if (file) {
		fread(vm->instr_mem, 1, 64 * 1024, file);
		fclose(file);
		vm->state = JADE_VM_READY;
	} else {
		perror("jadevm file.jb\n\nExecutes a JadeVM bytecode file.");
		exit(EXIT_FAILURE);
	}
}
