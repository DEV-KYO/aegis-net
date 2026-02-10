# Project: Aegis-Net OS
**Type:** Headless Networking Kernel (x86_64 / i686)
**Goal:** High-throughput TCP/IP stack with no GUI.

## Core Constraints
1. **Architecture:** i686-elf (32-bit Protected Mode) transitioning to Long Mode.
2. **Bootloader:** Multiboot2 compliant (GRUB).
3. **Environment:**
   - **NO** standard library (freestanding).
   - **NO** local toolchain (Must use Docker container `aegis-compiler`).
   - **Root Path:** `/mnt/f/dev/aegis-net`.

## Build Rules
* **Compiler:** `docker run --rm -v $(pwd):/src aegis-compiler i686-elf-gcc`
* **Linker:** `docker run --rm -v $(pwd):/src aegis-compiler i686-elf-ld`
* **Flags:** `-ffreestanding -O2 -nostdlib -lgcc`

## Hardware Targets
* **NIC:** Intel E1000 (82540EM).
* **Serial:** COM1 (0x3F8) for headless output.
