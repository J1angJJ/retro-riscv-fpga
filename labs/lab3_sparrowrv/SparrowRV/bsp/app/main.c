#include <stdint.h>

#define REG32(addr) (*(volatile uint32_t *)(addr))
#define REG8(addr)  (*(volatile uint8_t *)(addr))

#define UART0_CTRL   0x20000000u
#define UART0_BAUD   0x20000008u
#define UART0_TXDATA 0x2000000cu
#define FPIOA_OT1    0x20000f01u
#define FPIOA_IN2    0x20000f82u

static void uart0_delay(void)
{
    for (volatile uint32_t delay = 0; delay < 20000u; delay++) {
    }
}

static void uart0_putc(uint8_t ch)
{
    REG32(UART0_TXDATA) = ch;
    uart0_delay();
}

static void uart0_puts_hello(void)
{
    uart0_putc('H');
    uart0_putc('e');
    uart0_putc('l');
    uart0_putc('l');
    uart0_putc('o');
    uart0_putc(' ');
    uart0_putc('w');
    uart0_putc('o');
    uart0_putc('r');
    uart0_putc('l');
    uart0_putc('d');
    uart0_putc(' ');
    uart0_putc('S');
    uart0_putc('p');
    uart0_putc('a');
    uart0_putc('r');
    uart0_putc('r');
    uart0_putc('o');
    uart0_putc('w');
    uart0_putc('R');
    uart0_putc('V');
    uart0_putc('\r');
    uart0_putc('\n');
    uart0_putc('T');
    uart0_putc('a');
    uart0_putc('n');
    uart0_putc('g');
    uart0_putc(' ');
    uart0_putc('N');
    uart0_putc('a');
    uart0_putc('n');
    uart0_putc('o');
    uart0_putc(' ');
    uart0_putc('2');
    uart0_putc('0');
    uart0_putc('K');
    uart0_putc('\r');
    uart0_putc('\n');
}

int main(void)
{
    REG8(FPIOA_OT1) = 7u;
    REG8(FPIOA_IN2) = 0u;
    REG32(UART0_BAUD) = 234u;
    REG32(UART0_CTRL) = 3u;

    while (1) {
        uart0_puts_hello();

        for (volatile uint32_t delay = 0; delay < 50000u; delay++) {
        }
    }
}
