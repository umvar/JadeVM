#pragma once

#define MEM_SIZE 16*1024

typedef enum {
	JADE_VM_NOT_READY,
	JADE_VM_READY,
	JADE_VM_HALTED
} jade_vm_state;

typedef struct {
	jade_vm_state state;
	unsigned short pc;
	unsigned short sp;
	unsigned char* instr_mem;
	short* stack_mem;
} jade_vm;

void vm_init(jade_vm* vm, int argc, char** argv);
void vm_destroy(jade_vm* vm);
unsigned char vm_fetch(jade_vm* vm);
void vm_step(jade_vm* vm);
void vm_continue(jade_vm* vm);
void vm_push(jade_vm* vm, short val);
short vm_pop(jade_vm* vm);
void vm_load_program(jade_vm* vm, const char* path);
