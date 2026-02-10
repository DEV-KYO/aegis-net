#!/bin/bash
# Run QEMU in headless mode (no window, output to terminal)
qemu-system-i386 -kernel build/kernel.bin -nographic

