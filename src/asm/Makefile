.PHONY: all clean

all:
	mkdir -p $(BUILD)/asm
	nasm -f elf64 main.s -I $(ROOT)/include/asm -o $(BUILD)/asm/main.o
	ld -e main $(BUILD)/asm/main.o -o $(BUILD)/jadevm-asm

clean:
	rm -f $(BUILD)/jadevm-asm $(BUILD)/asm
