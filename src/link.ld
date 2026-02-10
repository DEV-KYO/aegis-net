ENTRY(_start)

SECTIONS {
    /* The kernel will live at 1MB in RAM */
    . = 1M;

    /* FORCE the Multiboot header to be at the very start */
    .multiboot : {
        KEEP(*(.multiboot))
    }

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }

    /* TRASH: Throw away the "Notes" that confuse QEMU */
    /DISCARD/ : {
        *(.note*)
        *(.comment*)
        *(.eh_frame*)
    }
}
