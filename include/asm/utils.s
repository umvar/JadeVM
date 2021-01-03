%macro m_push 0
	; vm->stack_mem[++vm->sp] = di
	; rbx = vm
	; rax, rcx clobbered
	inc	word [rbx + jade_vm.sp]
	mov	rax, [rbx + jade_vm.stack_mem]
	movzx	rcx, word [rbx + jade_vm.sp]
	mov	[rax + rcx*2], di
%endmacro

%macro m_pop 0
	; di = vm->stack_mem[vm->sp--]
	; rbx = vm
	; rax, rcx clobbered
	mov	rax, [rbx + jade_vm.stack_mem]
	movzx	rcx, word [rbx + jade_vm.sp]
	mov	di, [rax + rcx*2]
	dec	word [rbx + jade_vm.sp]
%endmacro
