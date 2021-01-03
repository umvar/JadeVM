.PHONY: all clean

all:
	mkdir -p $(BUILD)/asm
	nasm -f elf64 main.s -I $(ROOT)/include/asm -o $(BUILD)/asm/main.o
	nasm -f elf64 vm.s -I $(ROOT)/include/asm -o $(BUILD)/asm/vm.o
	nasm -f elf64 ops.s -I $(ROOT)/include/asm -o $(BUILD)/asm/ops.o
	nasm -f elf64 debug.s -I $(ROOT)/include/asm -o $(BUILD)/asm/debug.o
	gcc -no-pie $(BUILD)/asm/*.o -o $(BUILD)/jadevm-asm

clean:
	rm -f $(BUILD)/jadevm-asm $(BUILD)/asm
