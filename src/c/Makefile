.PHONY: all clean

all:
	mkdir -p $(BUILD)/c
	gcc -Wall -Werror -Wpedantic -O3 --std=c17 -I $(ROOT)/include/c *.c -o $(BUILD)/jadevm-c

clean:
	rm -f $(BUILD)/jadevm-c $(BUILD)/c
