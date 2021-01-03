#pragma once

#include "vm.h"

void op_hlt(jade_vm* vm, short operand);
void op_nop(jade_vm* vm, short operand);
void op_neg(jade_vm* vm, short operand);
void op_add(jade_vm* vm, short operand);
void op_sub(jade_vm* vm, short operand);
void op_mul(jade_vm* vm, short operand);
void op_div(jade_vm* vm, short operand);
void op_mod(jade_vm* vm, short operand);
void op_not(jade_vm* vm, short operand);
void op_or(jade_vm* vm, short operand);
void op_and(jade_vm* vm, short operand);
void op_xor(jade_vm* vm, short operand);
void op_shl(jade_vm* vm, short operand);
void op_shr(jade_vm* vm, short operand);
void op_pop(jade_vm* vm, short operand);
void op_ret(jade_vm* vm, short operand);
void op_jmp(jade_vm* vm, short operand);
void op_jmpt(jade_vm* vm, short operand);
void op_jmpf(jade_vm* vm, short operand);
void op_call(jade_vm* vm, short operand);
void op_eq(jade_vm* vm, short operand);
void op_neq(jade_vm* vm, short operand);
void op_lt(jade_vm* vm, short operand);
void op_le(jade_vm* vm, short operand);
void op_gt(jade_vm* vm, short operand);
void op_ge(jade_vm* vm, short operand);
void op_get(jade_vm* vm, short operand);
void op_set(jade_vm* vm, short operand);
void op_imm(jade_vm* vm, short operand);
