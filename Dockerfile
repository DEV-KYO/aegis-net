# Use official Ubuntu (Reliable, fast, always exists)
FROM ubuntu:24.04

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install standard GCC with 32-bit support (gcc-multilib)
# This replaces the need for a special "i686-elf-gcc"
RUN apt-get update && apt-get install -y     build-essential     gcc-multilib     nasm     make     xorriso     mtools     git     && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root/env
