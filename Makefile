# Docker wrapper
DOCKER_CMD = docker run --rm -v $(shell pwd):/root/env -w /root/env aegis-compiler

# Tools
CC = $(DOCKER_CMD) gcc
AS = $(DOCKER_CMD) nasm
LD = $(DOCKER_CMD) ld

# Flags
# -n: Disable page alignment (Fixes the "Header not found" QEMU bug)
CFLAGS = -m32 -ffreestanding -O2 -nostdlib -fno-pie -fno-stack-protector
LDFLAGS = -m elf_i386 -T src/link.ld -n

# Targets
all: build/kernel.bin

build/boot.o: src/boot.s
	mkdir -p build
	$(AS) -f elf32 src/boot.s -o build/boot.o

build/kernel.o: src/kernel.c
	$(CC) -c src/kernel.c -o build/kernel.o $(CFLAGS)

build/kernel.bin: build/boot.o build/kernel.o
	$(LD) -o build/kernel.bin build/boot.o build/kernel.o $(LDFLAGS)

clean:
	rm -rf build
