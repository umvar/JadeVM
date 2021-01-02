.PHONY: all clean asm c

export ROOT = $(PWD)
export BUILD = $(ROOT)/build

all: asm c

clean:
	$(MAKE) -C src/asm clean
	$(MAKE) -C src/c clean
	rm -rf build/

asm:
	$(MAKE) -C src/asm

c:
	$(MAKE) -C src/c
