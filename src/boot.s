; NASM Compatible Kernel Boot Stub

; -- Multiboot Header Constants --
MBALIGN  equ  1 << 0            ; align loaded modules on page boundaries
MEMINFO  equ  1 << 1            ; provide memory map
FLAGS    equ  MBALIGN | MEMINFO ; this is the Multiboot 'flag' field
MAGIC    equ  0x1BADB002        ; 'magic number' lets bootloader find the header
CHECKSUM equ -(MAGIC + FLAGS)   ; checksum of above, to prove we are real

; -- Section .multiboot --
; This must be in the first 8KB of the kernel file.
section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

; -- Section .bss --
; Reserve space for the stack
section .bss
align 16
stack_bottom:
    resb 16384 ; 16 KiB
stack_top:

; -- Section .text --
; The actual code
section .text
global _start
extern kmain ; We will call the C function defined in kernel.c

_start:
    ; Set up the stack pointer (ESP)
    mov esp, stack_top

    ; Call the C kernel main function
    call kmain

    ; If kmain returns, loop forever
    cli
hang:
    hlt
    jmp hang
