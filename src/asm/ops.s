%include "jade.s"
%include "utils.s"

global opcode_table
global opcode_formats

section .data
opcode_table:
dq	op_hlt,  op_nop,  op_neg,  op_add, op_sub, op_mul, op_div, op_mod
dq	op_not,   op_or,  op_and,  op_xor, op_shl, op_shr, op_pop, op_ret
dq	op_jmp, op_jmpt, op_jmpf, op_call,  op_eq, op_neq,  op_lt,  op_le
dq	 op_gt,   op_ge,  op_get,  op_set, op_imm
opcode_formats:
db	     0,       0,       0,       0,      0,      0,      0,      0
db	     0,       0,       0,       0,      1,      1,      1,      0
db	     2,       2,       2,       2,      0,      0,      0,      0
db	     0,       0,       2,       2,      2

section .text
op_hlt:
	mov	dword [rbx + jade_vm.state], JADE_VM_HALTED
	ret

op_nop:
	ret

op_neg:
	m_pop
	neg	di
	m_push
	ret

op_add:
	m_pop
	mov	si, di
	m_pop
	add	di, si
	m_push
	ret

op_sub:
	m_pop
	mov	si, di
	m_pop
	sub	di, si
	m_push
	ret

op_mul:
	m_pop
	mov	si, di
	m_pop
	imul	di, si
	m_push
	ret

op_div:
	m_pop
	mov	si, di
	m_pop
	mov	ax, di
	xor	dx, dx
	idiv	si
	mov	di, ax
	m_push
	ret

op_mod:
	m_pop
	mov	si, di
	m_pop
	mov	ax, di
	xor	dx, dx
	idiv	si
	mov	di, dx
	m_push
	ret

op_not:
	m_pop
	not	di
	m_push
	ret

op_or:
	m_pop
	mov	si, di
	m_pop
	or	di, si
	m_push
	ret

op_and:
	m_pop
	mov	si, di
	m_pop
	and	di, si
	m_push
	ret

op_xor:
	m_pop
	mov	si, di
	m_pop
	xor	di, si
	m_push
	ret

op_shl:
	mov	sil, dil
	m_pop
	mov	cl, sil
	shl	di, cl
	m_push
	ret

op_shr:
	mov	sil, dil
	m_pop
	mov	cl, sil
	sar	di, cl
	m_push
	ret

op_pop:
	sub	word [rbx + jade_vm.sp], di
	ret

op_ret:
	m_pop
	mov	word [rbx + jade_vm.pc], di
	ret

op_jmp:
	add	word [rbx + jade_vm.pc], di
	ret

op_jmpt:
	mov	si, di
	m_pop
	test	di, di
	mov	di, si
	jnz	op_jmp
	ret

op_jmpf:
	mov	si, di
	m_pop
	test	di, di
	mov	di, si
	jz	op_jmp
	ret

op_call:
	mov	si, di
	mov	di, [rbx + jade_vm.pc]
	m_push
	add	word [rbx + jade_vm.pc], si
	ret

op_eq:
	m_pop
	mov	si, di
	m_pop
	cmp	di, si
	mov	di, 1
	je	.exit
	xor	di, di
	.exit:
	m_push
	ret

op_neq:
	m_pop
	mov	si, di
	m_pop
	cmp	di, si
	mov	di, 1
	jne	.exit
	xor	di, di
	.exit:
	m_push
	ret
op_lt:
	m_pop
	mov	si, di
	m_pop
	cmp	di, si
	mov	di, 1
	jl	.exit
	xor	di, di
	.exit:
	m_push
	ret
op_le:
	m_pop
	mov	si, di
	m_pop
	cmp	di, si
	mov	di, 1
	jle	.exit
	xor	di, di
	.exit:
	m_push
	ret
op_gt:
	m_pop
	mov	si, di
	m_pop
	cmp	di, si
	mov	di, 1
	jg	.exit
	xor	di, di
	.exit:
	m_push
	ret
op_ge:
	m_pop
	mov	si, di
	m_pop
	cmp	di, si
	mov	di, 1
	jge	.exit
	xor	di, di
	.exit:
	m_push
	ret

op_get:
	mov	rax, [rbx + jade_vm.stack_mem]
	movzx	rcx, word [rbx + jade_vm.sp]
	movzx	rdi, di
	sub	rcx, rdi
	mov	di, [rax + rcx*2]
	m_push
	ret

op_set:
	test	di, di
	jz	.exit

	movzx	rsi, di ; u16
	m_pop
	mov	rax, [rbx + jade_vm.stack_mem]
	movzx	rcx, word [rbx + jade_vm.sp]

	inc	cx
	sub	rcx, rsi
	mov	[rax + rcx*2], di

	.exit:
	ret

op_imm:
	m_push
	ret
