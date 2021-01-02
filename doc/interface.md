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

void vm_init(struct jade_vm* vm);
void vm_destroy(struct jade_vm* vm);
void vm_step(struct jade_vm* vm, int n);
void vm_continue(struct jade_vm* vm);
void vm_load_program(struct jade_vm* vm, const char* path);
```
