# Lab 3 源码地图

## 顶层与 SoC

- `SparrowRV/rtl/board/tang_nano_20k_sparrowrv_top.v`
  - 本实验新增的 Tang Nano 20K 包装层。
  - 负责连接 27 MHz 时钟、复位、UART、LED 和 SparrowRV SoC。

- `SparrowRV/rtl/soc/sparrow_soc.v`
  - SparrowRV SoC 顶层。
  - 实例化处理器内核、JTAG、SRAM、sysio、AXI4-Lite 多主多从互连。

## 处理器内核

- `SparrowRV/rtl/core/core.v`
  - 处理器内核顶层。
  - 连接取指、译码执行、寄存器、CSR、控制器、IRAM 和总线接口。

- `SparrowRV/rtl/core/idex.v`
  - 译码与执行核心逻辑。
  - 处理算术逻辑、访存、跳转、CSR、乘除法等指令路径。

- `SparrowRV/rtl/core/regs.v`
  - 32 个通用寄存器。
  - 需要注意 `x0` 恒为 0。

- `SparrowRV/rtl/core/csr.v`
  - 机器模式 CSR、性能计数器、仿真打印 CSR 等。
  - `msprint` 用于仿真环境输出字符，`mends` 用于仿真结束标志。

- `SparrowRV/rtl/core/iram.v`
  - 指令 RAM。
  - 本实验让 RTL 行为模型支持从 `../../bsp/obj/SparrowRV.mif` 初始化程序。

- `SparrowRV/rtl/core/dpram.v`
  - 通用双端口 RAM。
  - 支持行为模型和原工程中的 EG4 原语分支。

- `SparrowRV/rtl/core/div.v`
  - 除法器。
  - 由 `config.v` 中 `DIV_MODE` 控制模式。

- `SparrowRV/rtl/core/rstc.v`
  - 复位控制。

- `SparrowRV/rtl/core/trap.v`
  - 中断/异常相关逻辑。

## 总线与外设

- `SparrowRV/rtl/perips/axi4lite_2mt16s.v`
  - AXI4-Lite 互连模块。
  - 两个 master：JTAG 与 core。
  - 多个 slave：IRAM、SRAM、sysio 等。

- `SparrowRV/rtl/perips/sram.v`
  - 数据 SRAM。

- `SparrowRV/rtl/perips/sysio/sysio.v`
  - 系统 IO 外设集合。
  - 实例化 UART0、UART1、SPI、GPIO、FPIOA。

- `SparrowRV/rtl/perips/sysio/uart.v`
  - UART 外设寄存器与收发状态机。

- `SparrowRV/rtl/perips/sysio/fpioa.v`
  - 可编程 IO 复用矩阵。
  - BSP 中 `init_uart0_printf()` 通过它把 UART0 RX/TX 映射到 `fpioa[0]` 和 `fpioa[1]`。

## BSP 与软件

- `SparrowRV/bsp/app/main.c`
  - Lab 3 当前 Hello World 程序入口。

- `SparrowRV/bsp/app/makefile`
  - 命令行编译入口。
  - 依赖 `SparrowRV/tools/RISC-V_Embedded_GCC`。

- `SparrowRV/bsp/lib/start.S`
  - 启动文件，负责建立 C 运行环境并跳转到 `main()`。

- `SparrowRV/bsp/link.lds`
  - 链接脚本，决定程序段地址布局。

- `SparrowRV/bsp/lib/src/printf.c`
  - 轻量 printf 与 UART0 初始化。

## 仿真

- `SparrowRV/tb/tb_core.sv`
  - SoC testbench。
  - 从 `inst.txt` / `btrm.txt` 读入程序。

- `SparrowRV/tb/tools/isa_test.py`
  - 原工程提供的仿真辅助脚本。
  - 能把 `.bin` 转成 `inst.txt` 或 `btrm.txt`。

## 报告阅读重点

1. 解释两级流水线为什么把 `ID+EX+MEM+WB` 合并在一级。
2. 说明 IRAM/SRAM、AXI4-Lite、sysio 的地址访问关系。
3. 说明 Hello World 的路径：`main.c -> printf -> UART0 -> FPIOA -> 顶层 uart_tx -> BL616/串口终端`。
4. 说明当前移植点：27 MHz 主频、IRAM 初始化文件、Tang Nano 20K 顶层与约束。
