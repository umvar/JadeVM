%include "jade.s"

global dump_vm
global dump_stack

extern printf

section .data
vm_summary: db `state: %d, pc: 0x%.4hX, sp: 0x%.4hX\n\0`
stack_entry: db `%.4hX \0`
newline: db `\n\0`
instruction: db `instruction: %s\n\0`
mnemonics:
db	` hlt\0`, ` nop\0`, ` neg\0`, ` add\0`, ` sub\0`, ` mul\0`, ` div\0`, ` mod\0`
db	` not\0`, `  or\0`, ` and\0`, ` xor\0`, ` shl\0`, ` shr\0`, ` pop\0`, ` ret\0`
db	` jmp\0`, `jmpt\0`, `jmpf\0`, `call\0`, `  eq\0`, ` neq\0`, `  lt\0`, `  le\0`
db	`  gt\0`, `  ge\0`, ` get\0`, ` set\0`, ` imm\0`

section .text
dump_vm:
	push	rbx
	mov	rbx, rdi

	; printf(vm_summary, vm->state, vm->pc, vm->sp);
	xor	al, al
	mov	rdi, vm_summary
	mov	esi, [rbx + jade_vm.state]
	mov	dx, [rbx + jade_vm.pc]
	mov	cx, [rbx + jade_vm.sp]
	call	printf

	; dump_instruction(vm);
	mov	rdi, rbx
	call	dump_instruction

	; dump_stack(vm);
	mov	rdi, rbx
	call	dump_stack

	; printf("\n");
	xor	rax, rax
	mov	rdi, newline
	call	printf

	pop	rbx
	ret

dump_stack:
	push	rbx
	push	rbp
	push	r12

	mov	rbx, rdi
	movzx	r12, word [rbx + jade_vm.sp] ; vm->sp
	mov	rbx, [rbx + jade_vm.stack_mem] ; vm->stack_mem
	xor	rbp, rbp ; i

	; for (unsigned short i = 0; i <= vm->sp; i++) {
	.for:
	cmp	rbp, r12
	jg	.exit
	; printf("%.4X ", vm->memory[i]);
	xor	rax, rax
	mov	rdi, stack_entry
	mov	si, [rbx + rbp*2]
	call	printf

	test	rbp, 0xF
	inc	rbp
	jnz	.for
	; if (i & 0xF == 0) printf("\n");
	xor	rax, rax
	mov	rdi, newline
	call	printf
	inc	rbp
	jmp	.for
	; }

	.exit:
	; printf("\n");
	xor	rax, rax
	mov	rdi, newline
	call	printf

	pop	r12
	pop	rbp
	pop	rbx
	ret

dump_instruction:
	mov	rax, [rbx + jade_vm.instr_mem]
	movzx	rcx, word [rbx + jade_vm.pc]
	movzx	rax, byte [rax + rcx]
	mov	rcx, rax
	shl	rcx, 2
	add	rcx, rax ; opcode * 5

	; printf("instruction: %s\n", mnemonic)
	mov	rdi, instruction
	lea	rsi, [mnemonics + rcx]
	xor	al, al
	call	printf

	ret
