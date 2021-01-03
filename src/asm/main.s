global main

extern printf
extern vm_init
extern vm_destroy
extern vm_load_program
extern vm_continue

%include "jade.s"

section .data
usage: db `USAGE: jadevm file.jb\n\nExecutes a JadeVM bytecode file.\n\0`

section .text
main:
	cmp	rdi, 2
	jl	.print_usage

	; if (argc >= 2) {
	push	rbx
	push	rbp
	sub	rsp, jade_vm_size ; sturct jade_vm vm;
	mov	rbx, rsp ; &vm
	mov	rbp, rsi ; argv

	; vm_init(&vm, argc, argv);
	mov	esi, edi ; argc
	mov	rdi, rbx ; &vm
	mov	rdx, rbp ; argv
	call	vm_init

	; vm_load_program(&vm, argv[1]);
	mov	rdi, rbx
	mov	rsi, rbp
	mov	rsi, [rsi + 8]
	call	vm_load_program

	; vm_continue(&vm);
	mov	rdi, rbx
	call	vm_continue

	; vm_destroy(&vm);
	mov	rdi, rbx
	call	vm_destroy

	; return 0;
	add	rsp, jade_vm_size
	pop	rbp
	pop	rbx
	xor	eax, eax
	ret
	; }

	.print_usage:
	; printf(usage);
	mov	rdi, usage
	xor	al, al
	call	printf

	; return 1;
	mov	eax, 1
	ret
