# NESTang 源码地图

本文件记录 `labs/lab2_nes_emulator/nestang/` 中优先阅读的源码结构，便于后续维护和复现。

## 工程入口

- Gowin 工程：`nestang/nes.gprj`
- 目标器件：`GW2AR-LV18QN88C8/I7`
- 设备显示：`GW2AR-18C`
- 主要顶层文件：`nestang/src/nes_tang20k.v`
- 物理约束：`nestang/src/nestang.cst`
- 时序约束：`nestang/src/nestang.sdc`

## 顶层模块

`NES_Tang20k` 是 Tang Nano 20K 的顶层模块，负责把 NES 逻辑和板卡外设连接起来。

主要外设端口包括：

- `sys_clk`：板载时钟输入。
- `s1`：板上 S1 按键，用于复位或菜单相关控制。
- `UART_RXD` / `UART_TXD`：串口通道。
- `led[1:0]`：调试 LED。
- SDRAM 端口：连接板载 64 Mbit SDRAM。
- MicroSD 端口：读取菜单和游戏 ROM。
- 手柄端口：两组 DualShock/手柄转接信号。
- HDMI TMDS 端口：输出视频。

## 时钟结构

顶层中使用 Gowin PLL/IP 生成多个时钟：

- `Gowin_rPLL_nes`：生成 NES 主逻辑时钟和 SDRAM 相移时钟。
- `Gowin_rPLL_hdmi`：生成 HDMI 高速时钟。
- `Gowin_CLKDIV`：从 HDMI 高速时钟分频出像素时钟。

这说明 NES 工程的时钟结构比 LED 闪烁工程复杂得多。NES 逻辑时钟、SDRAM 时钟和 HDMI 像素时钟不是同一个域，后续维护时需要重点关注跨时钟域路径。

## NES 核心

- `src/nes.v`：NES 主机核心，连接 CPU、PPU、APU、手柄、DMA、Mapper 和存储访问。
- `src/cpu.v`：CPU 实现。
- `src/ppu.v`：图形处理器实现。
- `src/apu.v`：音频处理器实现。
- `src/mmu.v`：Mapper 和地址映射逻辑。
- `src/MicroCode.v`：CPU 微码表。

## 存储和 ROM 加载

- `src/memory_controller.v`：连接 NES 访问请求和板载 SDRAM。
- `src/sdram.v`：Tang Nano 20K 板载 SDRAM 控制器。
- `src/game_loader.v`：解析 iNES 头并把 ROM 数据送入模拟器内部。
- `src/sd_loader.v`：从 MicroSD 菜单和游戏镜像中读取数据。
- `src/sd_reader.sv`、`src/sdcmd_ctrl.sv`：底层 SD 卡命令和数据读取。

## 视频和音频输出

- `src/nes2hdmi.sv`：把 NES 像素/音频数据转换到 HDMI 输出路径。
- `src/hdmi2/`：HDMI 数据包、TMDS 编码和序列化相关模块。
- `src/hw_sound.v`：音频硬件输出相关逻辑。

## 手柄输入

- `src/dualshock_controller.v`：手柄通信控制。
- 顶层中实例化两次，分别对应玩家 1 和玩家 2。
- 默认引脚见 `nestang/src/nestang.cst` 和 `nestang/README.md`。

## 后续分析问题

- NES 的 CPU 和 PPU 如何共享/竞争存储访问？
- `GameLoader` 如何根据 iNES 头确定 PRG/CHR ROM 大小？
- `mmu.v` 支持哪些 Mapper？
- MicroSD 菜单的元数据格式是什么？
- HDMI 输出为何需要像素时钟和 5 倍像素时钟？
