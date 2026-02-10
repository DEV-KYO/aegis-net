/* * Aegis-Net Kernel (Headless)
 * Direct Serial Port Output
 */
#include <stdint.h>

// Serial Port Ports
#define SERIAL_COM1_BASE 0x3F8

// Hardware I/O Wrapper (Assembly)
static inline void outb(uint16_t port, uint8_t val) {
    asm volatile ( "outb %0, %1" : : "a"(val), "Nd"(port) );
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile ( "inb %1, %0" : "=a"(ret) : "Nd"(port) );
    return ret;
}

// Initialize Serial Port
void init_serial() {
    outb(SERIAL_COM1_BASE + 1, 0x00);    // Disable all interrupts
    outb(SERIAL_COM1_BASE + 3, 0x80);    // Enable DLAB (set baud rate divisor)
    outb(SERIAL_COM1_BASE + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
    outb(SERIAL_COM1_BASE + 1, 0x00);    //                  (hi byte)
    outb(SERIAL_COM1_BASE + 3, 0x03);    // 8 bits, no parity, one stop bit
    outb(SERIAL_COM1_BASE + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
    outb(SERIAL_COM1_BASE + 4, 0x0B);    // IRQs enabled, RTS/DSR set
}

// Write a character to Serial
void serial_putc(char c) {
    while ((inb(SERIAL_COM1_BASE + 5) & 0x20) == 0); // Wait for transmit empty
    outb(SERIAL_COM1_BASE, c);
}

// Write a string
void serial_puts(const char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        serial_putc(str[i]);
    }
}

// KERNEL ENTRY POINT
void kmain() {
    init_serial();
    
    // Clear screen (ANSI Escape Code)
    serial_puts("\033[2J\033[H"); 

    // Banner
    serial_puts("\n");
    serial_puts("   ___            _           _   _      _   \n");
    serial_puts("  / _ \\          (_)         | \\ | |    | |  \n");
    serial_puts(" / /_\\ \\ ___ __ _ _ _________|  \\| | ___| |_ \n");
    serial_puts(" |  _  |/ _ \\ _` | / __|_____| . ` |/ _ \\ __|\n");
    serial_puts(" | | | |  __/ (_| | \\__ \\     | |\\  |  __/ |_ \n");
    serial_puts(" \\_| |_/\\___|\\__, |_|___/     \\_| \\_/\\___|\\__|\n");
    serial_puts("              __/ |                           \n");
    serial_puts("             |___/                            \n");
    serial_puts("\n");
    serial_puts("[ OK ] Serial Driver Initialized.\n");
    serial_puts("[ OK ] Global Descriptor Table (GDT) Loaded.\n");
    serial_puts("[INFO] Waiting for Network Card...\n");

    // Halt Loop
    while(1) {
        asm volatile("hlt");
    }
}
