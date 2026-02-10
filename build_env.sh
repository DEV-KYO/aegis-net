#!/bin/bash
# 1. Build the compiler environment
docker build -t aegis-compiler .

# 2. Run the build process
# We chain: Clean -> Build -> Verify
docker run --rm -v $(pwd):/root/env -w /root/env aegis-compiler /bin/bash -c "
    make clean && 
    make && 
    if grub-file --is-x86-multiboot build/kernel.bin; then
        echo '✅ SUCCESS: Kernel is Multiboot confirmed.'
    else
        echo '❌ ERROR: Kernel is NOT Multiboot compliant.'
    fi
"
