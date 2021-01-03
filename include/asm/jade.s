JADE_VM_NOT_READY equ 0
JADE_VM_READY equ 1
JADE_VM_HALTED equ 2

struc jade_vm
	.state: resd 1
	.pc: resw 1
	.sp: resw 1
	.instr_mem: resq 1
	.stack_mem: resq 1
endstruc
