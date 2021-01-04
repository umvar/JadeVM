#include "vm.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
	if (argc >= 2) {
		jade_vm vm;
		vm_init(&vm, argc, argv);
		vm_load_program(&vm, argv[1]);
		vm_continue(&vm);
		vm_destroy(&vm);
		return EXIT_SUCCESS;
	} else {
		printf("USAGE: jadevm file.jb\n\nExecutes a JadeVM bytecode file.\n");
		return EXIT_FAILURE;
	}
}
