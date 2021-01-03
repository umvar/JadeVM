#include "opcodes.h"
#include "vm.h"

#define BINARYOP(op) short x = vm_pop(vm); vm_push(vm, vm_pop(vm) op x)
#define UNARYOP(op) vm_push(vm, op vm_pop(vm))
#define BINARYOPIMM(op) vm_push(vm, vm_pop(vm) op operand)

void op_hlt(jade_vm* vm, short operand) {
	vm->state = JADE_VM_HALTED;
}

void op_nop(jade_vm* vm, short operand) {
	;
}

void op_neg(jade_vm* vm, short operand) {
	UNARYOP(-);
}

void op_add(jade_vm* vm, short operand) {
	BINARYOP(+);
}

void op_sub(jade_vm* vm, short operand) {
	BINARYOP(-);
}

void op_mul(jade_vm* vm, short operand) {
	BINARYOP(*);
}

void op_div(jade_vm* vm, short operand) {
	BINARYOP(/);
}

void op_mod(jade_vm* vm, short operand) {
	BINARYOP(%);
}

void op_not(jade_vm* vm, short operand) {
	UNARYOP(~);
}

void op_or(jade_vm* vm, short operand) {
	BINARYOP(|);
}

void op_and(jade_vm* vm, short operand) {
	BINARYOP(&);
}

void op_xor(jade_vm* vm, short operand) {
	BINARYOP(^);
}

void op_shl(jade_vm* vm, short operand) {
	BINARYOPIMM(<<);
}

void op_shr(jade_vm* vm, short operand) {
	BINARYOPIMM(>>);
}

void op_pop(jade_vm* vm, short operand) {
	vm->sp -= operand;
}

void op_ret(jade_vm* vm, short operand) {
	vm->pc = vm_pop(vm);
}

void op_jmp(jade_vm* vm, short operand) {
	vm->pc += operand;
}

void op_jmpt(jade_vm* vm, short operand) {
	if (vm_pop(vm))
		vm->pc += operand;
}

void op_jmpf(jade_vm* vm, short operand) {
	if (!vm_pop(vm))
		vm->pc += operand;
}

void op_call(jade_vm* vm, short operand) {
	vm_push(vm, vm->pc);
	vm->pc += operand;
}

void op_eq(jade_vm* vm, short operand) {
	BINARYOP(==);
}

void op_neq(jade_vm* vm, short operand) {
	BINARYOP(!=);
}

void op_lt(jade_vm* vm, short operand) {
	BINARYOP(<);
}

void op_le(jade_vm* vm, short operand) {
	BINARYOP(<=);
}

void op_gt(jade_vm* vm, short operand) {
	BINARYOP(>);
}

void op_ge(jade_vm* vm, short operand) {
	BINARYOP(>=);
}

void op_get(jade_vm* vm, short operand) {
	vm_push(vm, vm->stack_mem[vm->sp - (unsigned short)operand]);
}

void op_set(jade_vm* vm, short operand) {
	if (operand)
		vm->stack_mem[vm->sp - operand] = vm_pop(vm);
}

void op_imm(jade_vm* vm, short operand) {
	vm_push(vm, operand);
}
