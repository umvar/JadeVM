%include "jade.s"
%include "utils.s"

global vm_init
global vm_destroy
global vm_load_program
global vm_step
global vm_continue

extern perror
extern fopen
extern fclose
extern fread
extern exit
extern malloc
extern free
extern atoi
extern opcode_table
extern opcode_formats
extern dump_vm

section .data
fopen_format: db `rb\0`
fopen_failed: db `fopen() failed\0`

section .text
vm_init:
	push	rbx
	push	rbp
	push	r12
	push	r13
	mov	rbx, rdi ; vm
	movsx	r12, esi ; argc
	mov	r13, rdx ; argv

	; vm->state = JADE_VM_NOT_READY;
	mov	dword [rbx + jade_vm.state], JADE_VM_NOT_READY
	; vm->pc = 0;
	mov	word [rbx + jade_vm.pc], 0
	; vm->sp = 0xFFFF;
	mov	word [rbx + jade_vm.sp], 0xFFFF
	; vm->instr_mem = malloc(64 * 1024);
	mov 	rdi, 64 * 1024
	call	malloc
	mov	[rbx + jade_vm.instr_mem], rax
	; vm->stack_mem = malloc(64 * 1024);
	mov 	rdi, 64 * 1024
	call	malloc
	mov	[rbx + jade_vm.stack_mem], rax

	; for (size_t i = 2; i < argc; i++) {
	mov	rbp, 2
	.for:
	cmp	rbp, r12
	jge	.exit
	; atoi(argv[i]);
	mov	rdi, [r13 + rbp*8] ; argv[i]
	call	atoi
	; push arg
	mov	di, ax
	m_push
	inc	rbp
	jmp	.for
	; }

	.exit:
	; push argc
	mov	rdi, r12
	sub	rdi, 2
	m_push

	pop	r13
	pop	r12
	pop	rbp
	pop	rbx
	ret

vm_destroy:
	push	rbx
	mov	rbx, rdi

	; vm->state = JADE_VM_NOT_READY;
	mov	dword [rbx + jade_vm.state], JADE_VM_NOT_READY
	; free(vm->instr_mem);
	mov	rdi, [rbx + jade_vm.instr_mem]
	call	free
	; free(vm->stack_mem);
	mov	rdi, [rbx + jade_vm.stack_mem]
	call	free

	pop	rbx
	ret

vm_load_program:
	push	rbx
	mov	rbx, rdi ; vm

	; FILE* file = fopen(path, "rb");
	mov	rdi, rsi
	mov	rsi, fopen_format
	call	fopen
	test	rax, rax
	jz	.fopen_fail
	; if (file) {
	push	rbp
	mov	rbp, rax ; file
	; fread(vm->instr_mem, 1, 64 * 1024, file);
	mov	rdi, [rbx + jade_vm.instr_mem] ; vm->instr_mem
	mov	rsi, 1
	mov	rdx, 64 * 1024
	mov	rcx, rbp ; file
	call	fread
	; fclose(file);
	mov	rdi, rbp
	call	fclose
	; vm->state = JADE_VM_READY
	mov	dword [rbx + jade_vm.state], JADE_VM_READY

	pop	rbp
	pop	rbx
	ret
	; } else {
	.fopen_fail:
	; perror(fopen_failed);
	mov	rdi, fopen_failed
	call	perror
	pop	rbx
	; exit(1);
	mov	rdi, 1
	call	exit
	ret
	; }

%macro m_fetch 0
	; rax = vm->instr_mem[vm->pc++];
	; rbx = vm
	; rax, rcx clobbered
	mov	rax, [rbx + jade_vm.instr_mem]
	movzx	rcx, word [rbx + jade_vm.pc]
	movzx	rax, byte [rax + rcx]
	inc	word [rbx + jade_vm.pc]
%endmacro

vm_step:
	push	rbx
	push	rbp
	mov	rbx, rdi ; vm

	.fetch:
	m_fetch
	mov	rbp, [opcode_table + rax*8] ; opcode_handler
	mov	cl, [opcode_formats + rax] ; operand size

	.decode:
	cmp	cl, 1
	jb	.execute
	je	.read8
	.read16:
	m_fetch
	movzx	di, al
	m_fetch
	shl	ax, 8
	or	di, ax
	jmp	.execute
	.read8:
	m_fetch
	mov	dil, al

	.execute:
	; opcode_handler(rbx=vm, di=arg);
	call	rbp

	; dump_vm(vm);
	mov	rdi, rbx
	call	dump_vm

	pop	rbp
	pop	rbx
	ret

vm_continue:
	push	rbx ; vm

	; dump_vm(vm);
	mov	rdi, rbx
	call	dump_vm

	; while (vm->state == JADE_VM_READY) {
	.while:
	cmp	dword [rbx + jade_vm.state], JADE_VM_READY
	jne	.exit
	; vm_step(vm);
	mov	rdi, rbx
	call	vm_step
	jmp	.while
	; }

	.exit:
	pop	rbx
	ret
