# Lab 3：SparrowRV RISC-V 处理器实验

本目录用于 Lab 3：引入 SparrowRV 小麻雀处理器，完成源码阅读、Hello World 程序准备、Tang Nano 20K 顶层适配，并为后续 Gowin 综合/烧录和串口验证做准备。

## 当前进度

- 已从公开 Gitee fork 克隆 SparrowRV 源码。
- 原始仓库 Git 管理已删除，由当前课程仓库统一管理。
- 引入版本记录：
  - 来源：`https://gitee.com/hangzhou_zhinuo_co_ltd_pangzhifeng/SparrowRV.git`
  - 原项目：`https://gitee.com/xiaowuzxc/SparrowRV`
  - 当前提交：`e318c51 可综合性优化`
- 已把软硬件主频统一为 Tang Nano 20K 板载 27 MHz。
- 已将 `bsp/app/main.c` 整理为 Lab 3 的 Hello World 串口程序。
- 已为 Tang Nano 20K 新增顶层包装文件和 Gowin 约束草稿。
- 已新增 `bin_to_readmemh.py`，用于把 BSP 编译得到的 `obj.bin` 转成 IRAM 可读的初始化文本。

## 目录说明

- `SparrowRV/`：SparrowRV 源码。
- `SparrowRV/rtl/core/`：处理器内核，包括取指、译码执行、寄存器、CSR、除法器、IRAM/SRAM 等。
- `SparrowRV/rtl/soc/`：SoC 顶层，连接 core、JTAG、SRAM、sysio 和 AXI4-Lite 互连。
- `SparrowRV/rtl/perips/`：片上外设，包括 UART、SPI、GPIO、FPIOA、SRAM 和 SM3 模块。
- `SparrowRV/bsp/`：板级支持包和示例程序。
- `SparrowRV/tb/`：仿真 testbench 与指令测试脚本。
- `SparrowRV/rtl/board/tang_nano_20k_sparrowrv_top.v`：本实验新增的 Tang Nano 20K 顶层包装。
- `constraints/`：Tang Nano 20K 物理约束与时钟约束。
- `tools/bin_to_readmemh.py`：二进制程序转 32 位 `readmemh` 文本工具。
- `notes/source_map.md`：源码阅读地图。

## 处理器概览

SparrowRV 是 32 位 RISC-V 处理器，原 README 描述为单周期两级流水线结构：

- 流水线：`IF -> ID+EX+MEM+WB`。
- 指令集：RV32I，并支持 M、Zicsr、Zifencei 扩展。
- 特权级：机器模式。
- 存储结构：哈佛结构，指令存储器映射到存储空间。
- 总线：AXI4-Lite。
- 外设：UART、SPI、GPIO、FPIOA、SRAM、JTAG 等。

## Hello World 程序

Lab 3 默认程序位于：

- `SparrowRV/bsp/app/main.c`

当前程序通过 UART0 输出：

```text
Hello world SparrowRV
SparrowRV on Tang Nano 20K
mimpid = ...
Hello world SparrowRV
...
```

UART0 的 FPIOA 映射由 `init_uart0_printf(115200)` 完成：

- UART0 RX 映射到 `fpioa[0]`。
- UART0 TX 映射到 `fpioa[1]`。

Tang Nano 20K 顶层包装再把：

- `fpioa[0]` 连接到顶层 `uart_rx`。
- `fpioa[1]` 连接到顶层 `uart_tx`。
- `fpioa[3:2]` 固定为 `00`，选择直接启动模式。

## 软件编译准备

当前本机尚未找到命令行 RISC-V GCC 和 `make`，因此还没有在本机完成 BSP 编译。SparrowRV 原工程支持两种路线：

- 使用 MounRiver Studio 打开 `SparrowRV/bsp/SparrowRV.wvproj` 编译。
- 安装 `RISC-V_Embedded_GCC` 后在 `SparrowRV/bsp/app/` 下执行 `make`。

编译后需要得到类似 `obj.bin` 的程序二进制。随后运行：

```powershell
cd R:\retro-riscv-fpga
python .\labs\lab3_sparrowrv\tools\bin_to_readmemh.py `
  .\labs\lab3_sparrowrv\SparrowRV\bsp\app\obj.bin `
  .\labs\lab3_sparrowrv\SparrowRV\bsp\obj\SparrowRV.mif
```

`SparrowRV/rtl/core/iram.v` 当前会从 `../../bsp/obj/SparrowRV.mif` 初始化指令 RAM。这个文件是 `readmemh` 风格的 32 位十六进制文本，扩展名保留为 `.mif` 是为了匹配原工程路径。

## Gowin 工程建议

在 Gowin IDE 中新建 Lab 3 工程：

- 工程名：`lab3_sparrowrv`
- 器件：`GW2AR-LV18QN88C8/I7`
- 顶层模块：`tang_nano_20k_sparrowrv_top`
- 顶层文件：`SparrowRV/rtl/board/tang_nano_20k_sparrowrv_top.v`
- 需要加入的 RTL：
  - `SparrowRV/rtl/config.v`
  - `SparrowRV/rtl/defines.v`
  - `SparrowRV/rtl/core/*.v`
  - `SparrowRV/rtl/soc/*.v`
  - `SparrowRV/rtl/jtag/*.v`
  - `SparrowRV/rtl/perips/*.v`
  - `SparrowRV/rtl/perips/sysio/*.v`
  - 如启用 SM3，再加入 `SparrowRV/rtl/perips/sm3/*.v`
- 约束：
  - `constraints/tang_nano_20k_sparrowrv.cst`
  - `constraints/tang_nano_20k_sparrowrv.sdc`

## 串口验证

约束草稿把 `uart_tx` / `uart_rx` 映射到 Tang Nano 20K 的 BL616 串口桥接方向，目标是继续使用前面记录过的 MobaXterm `COM4`。

建议串口设置：

- 波特率：115200
- 数据位：8
- 校验：None
- 停止位：1

如果烧录后串口无输出，优先检查：

1. `SparrowRV.mif` 是否已经生成且被 Gowin 重新读取。
2. 顶层模块是否为 `tang_nano_20k_sparrowrv_top`。
3. `uart_tx` / `uart_rx` 引脚是否与实际 BL616 串口桥接一致。
4. 复位按键 `S1` 是否保持释放状态。

## 待完成

1. 安装或配置 RISC-V GCC / MRS，编译 `bsp/app/main.c`。
2. 生成 `SparrowRV.mif`。
3. 在 Gowin 中创建工程并完成综合、布局布线。
4. 使用 SRAM Program 下载比特流。
5. 在 MobaXterm `COM4` 观察 Hello World 输出。
