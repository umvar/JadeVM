# Interface

## CLI
```
jadevm file.jb

Executes a JadeVM bytecode file.
```

## VM Interface
```c
enum jade_vm_state {
	JADE_VM_NOT_READY,
	JADE_VM_READY,
	JADE_VM_HALTED
};

struct jade_vm {
	enum jade_vm_state state;
	unsigned short pc;
	unsigned short sp;
	char* instr_mem;
	short* stack_mem;
};

void vm_init(struct jade_vm* vm, int argc, char** argv);
void vm_destroy(struct jade_vm* vm);
void vm_load_program(struct jade_vm* vm, const char* path);
void vm_step(struct jade_vm* vm);
void vm_continue(struct jade_vm* vm);

/* Undefined behavior:
	- vm_init():
		- calling multiple times
	- vm_destroy():
		- calling before vm_init()
		- calling multiple times
	- vm_load_program():
		- calling before vm_init()
		- calling after vm_destroy()
	- vm_step():
		- calling before vm_init()
		- calling before vm_load_program()
		- calling after vm_destroy()
		- calling if state is not JADE_VM_READY
	- vm_continue():
		- calling before vm_init()
		- calling before vm_load_program()
*/
```
