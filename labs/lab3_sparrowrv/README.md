# Tang Nano 20K SparrowRV 工程

本目录用于在 Tang Nano 20K 上运行 SparrowRV RISC-V 处理器，并通过板载 BL616 串口桥接输出演示信息。工程重点包括 SparrowRV 源码适配、Gowin 工程组织、IRAM 初始化和 UART 输出验证。

## 当前状态

- 已引入 SparrowRV 源码，原始仓库 Git 管理已删除，由当前仓库统一管理。
- 已记录来源：
  - 引入来源：`https://gitee.com/hangzhou_zhinuo_co_ltd_pangzhifeng/SparrowRV.git`
  - 原项目：`https://gitee.com/xiaowuzxc/SparrowRV`
  - 引入提交：`e318c51 可综合性优化`
- 已把软硬件主频统一为 Tang Nano 20K 板载 27 MHz。
- 已新增 Tang Nano 20K 顶层包装、物理约束和时钟约束。
- 已改用 Gowin DPB 原语生成指令 RAM，避免普通 RAM 模板在综合和布局布线阶段触发不兼容问题。
- 已完成 MRS 构建、`.bin -> .mif -> gowin_dpb_iram.v -> Gowin run all` 流程。
- 已通过 Programmer SRAM 下载方式完成板上串口输出验证。

## 目录结构

- `SparrowRV/`：SparrowRV 源码。
- `SparrowRV/rtl/board/tang_nano_20k_sparrowrv_top.v`：Tang Nano 20K 顶层包装。
- `SparrowRV/rtl/core/gowin_dpb_iram.v`：由脚本生成的 Gowin DPB 指令 RAM。
- `SparrowRV/bsp/app/main.c`：当前板上演示程序。
- `constraints/`：Tang Nano 20K 物理约束与时钟约束。
- `gowin/lab3_sparrowrv/lab3_sparrowrv.gprj`：Gowin 工程文件。
- `notes/source_map.md`：SparrowRV 源码地图。
- `scripts/generate_gowin_iram.py`：根据 `SparrowRV.mif` 生成 Gowin DPB 初始化 RTL。
- `tools/bin_to_readmemh.py`：将 MRS 生成的二进制程序转换为 32 位 `readmemh` 文本。

## 处理器概览

SparrowRV 是 32 位 RISC-V 处理器，原 README 描述为单周期两级流水线结构：

- 流水线：`IF -> ID+EX+MEM+WB`。
- 指令集：RV32I，并支持 M、Zicsr、Zifencei 扩展。
- 特权级：机器模式。
- 存储结构：哈佛结构，指令存储器映射到存储空间。
- 总线：AXI4-Lite。
- 外设：UART、SPI、GPIO、FPIOA、SRAM、JTAG 等。

## 板级连接

- 板载时钟：27 MHz。
- UART：通过 BL616 串口桥接连接到电脑终端。
- UART0 TX：经 FPIOA1 输出到顶层 `uart_tx`。
- UART0 RX：经顶层 `uart_rx` 输入到 FPIOA0。
- LED0：用于临时观察心跳或处理器活动，不作为程序正确性的唯一依据。

串口终端建议：

- 波特率：115200
- 数据位：8
- 校验：None
- 停止位：1

进入 BL616 控制终端后，可使用：

```text
choose uart
```

切换到 FPGA UART 透传。切换瞬间可能接收到半个 UART 字符帧，导致首字符乱码；后续完整输出正常即可。

## 演示程序

当前程序位于：

- `SparrowRV/bsp/app/main.c`

程序不使用 `printf`，也不读取 `UART0_STATUS`，而是采用固定延时直接写 `UART0_TXDATA` 的方式输出短文本。这样可以避开当前移植版本中状态位轮询和长文本连续输出带来的不稳定。

当前演示输出为：

```text
Hello SparrowRV
Tang Nano 20K
J1angJJ
27MHz
```

程序每轮输出后等待较长时间，便于观察和录屏。该版本已在板上观察到多轮循环输出，适合作为当前工程演示版本。

## 软件构建

推荐使用 MounRiver Studio 打开：

- `SparrowRV/bsp/SparrowRV.wvproj`

构建后会生成：

- `SparrowRV/bsp/obj/SparrowRV.bin`
- `SparrowRV/bsp/obj/SparrowRV.elf`
- `SparrowRV/bsp/obj/SparrowRV.lst`
- `SparrowRV/bsp/obj/SparrowRV.map`

这些文件属于构建产物，已被 `.gitignore` 忽略。

## IRAM 生成流程

MRS 构建成功后，在仓库根目录运行：

```powershell
python .\labs\lab3_sparrowrv\tools\bin_to_readmemh.py `
  .\labs\lab3_sparrowrv\SparrowRV\bsp\obj\SparrowRV.bin `
  .\labs\lab3_sparrowrv\SparrowRV\bsp\obj\SparrowRV.mif
```

随后生成 Gowin DPB 指令 RAM：

```powershell
python .\labs\lab3_sparrowrv\scripts\generate_gowin_iram.py
```

生成目标：

- `SparrowRV/rtl/core/gowin_dpb_iram.v`

该文件由当前程序镜像生成，需要随源码状态一同维护。`SparrowRV.mif` 位于 BSP 构建目录中，作为中间产物由 `.gitignore` 忽略。

## Gowin 工程

工程文件：

- `gowin/lab3_sparrowrv/lab3_sparrowrv.gprj`

工程配置：

- 工程名：`lab3_sparrowrv`
- 器件：`GW2AR-LV18QN88C8/I7`
- 顶层模块：`tang_nano_20k_sparrowrv_top`
- 顶层文件：`SparrowRV/rtl/board/tang_nano_20k_sparrowrv_top.v`
- 物理约束：`constraints/tang_nano_20k_sparrowrv.cst`
- 时钟约束：`constraints/tang_nano_20k_sparrowrv.sdc`

生成流程：

1. 先在 MRS 中重新构建 BSP。
2. 运行 `.bin -> .mif` 转换脚本。
3. 运行 `generate_gowin_iram.py`。
4. 在 Gowin 中执行综合、布局布线和比特流生成。
5. 使用 Programmer 以 `SRAM Program` 下载生成的 `.fs`。
6. 通过串口终端观察输出。

`impl/`、`.gprj.user`、比特流、工具报告和日志等生成文件不提交。

## 调试记录摘要

适配过程中确认了几条重要边界：

- 硬件 UART 自检可输出连续 `U`，说明 BL616 串口桥接和板级 TX 引脚可用。
- 最小 MMIO 程序可输出连续 `U`，说明 CPU、IRAM 初始化、AXI/sysio、UART0 和 FPIOA 路径可用。
- 使用 `printf` 或读取 `UART0_STATUS` 的版本不稳定，因此当前演示程序采用固定延时直接写 UART。
- 长文本和运行时变量格式化容易造成输出停止，当前版本选择短文本和较长轮间延时作为稳定展示方案。

## 协作注意事项

- 上游 SparrowRV 文档和源码尽量保持来源清晰；本项目新增适配内容集中记录在本目录外层 README、`notes/`、`constraints/`、`scripts/` 和板级顶层文件中。
- 修改 `main.c` 后必须重新执行 MRS 构建和 IRAM 生成流程，否则 Gowin 使用的仍是旧程序镜像。
- 个人环境截图、串口原始日志、本地绝对路径和临时材料不提交到公开目录。
