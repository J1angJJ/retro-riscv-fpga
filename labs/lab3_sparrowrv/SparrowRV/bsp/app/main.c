#include "system.h"

int main()
{
    uint32_t mimpid_value;

    init_uart0_printf(115200);
    printf("%s", "Hello world SparrowRV\n");
    printf("%s", "SparrowRV on Tang Nano 20K\n");

    mimpid_value = read_csr(mimpid);
    printf("mimpid = %lx\n", mimpid_value);

    while (1) {
        printf("%s", "Hello world SparrowRV\n");
    }
}
