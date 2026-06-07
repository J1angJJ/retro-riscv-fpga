# Lab 2：Tang Nano 20K NES 模拟器实验

本目录用于 Lab 2：在 Tang Nano 20K 上运行 NES 模拟器，并分析 NES 系统架构与 FPGA 工程实现。

## 实验目标

- 获取并整理 Tang Nano 20K 可用的 NES FPGA 示例工程。
- 完成 HDMI 显示、手柄输入、TF 卡/ROM 加载等外设准备。
- 编译并下载 NES 示例到 Tang Nano 20K。
- 记录运行截图或视频。
- 阅读源码，理解 NES 模拟器中 CPU、PPU、APU、ROM、输入和视频输出之间的关系。

## 当前目录规划

- `README.md`：Lab 2 中文说明和进度记录。
- `notes/nes_architecture.md`：NES 架构阅读笔记。
- `nestang/`：计划放置 Sipeed TangNano-20K-example 中的 `nestang` 示例代码。引入后删除原有 `.git` 管理，由本仓库统一管理。

## 资料来源

- Sipeed TangNano-20K-example / nestang：  
  https://github.com/sipeed/TangNano-20K-example/tree/main/nestang
- NESTang 原始项目：  
  https://github.com/nand2mario/nestang
- NES 架构分析：  
  https://www.copetti.org/zh-hans/writings/consoles/nes/

## 硬件准备

根据课程要求和 Sipeed 示例方向，Lab 2 预计需要：

- Tang Nano 20K FPGA 板卡。
- HDMI 显示器或采集设备。
- USB/板载 BL616 下载链路。
- TF 卡，后续用于放置 NES ROM 或菜单所需资源。
- 手柄或手柄转接板，具体接口以示例工程文档为准。

## 当前进度

- Lab 1 已完成 FPGA 基本开发闭环，说明 Gowin 工具链、器件选择、约束、综合、布局布线、比特流生成和 SRAM 下载链路可用。
- 已引入 Sipeed `TangNano-20K-example` 仓库中的 `nestang` 示例代码。
- 已删除外部 Git 管理，由当前仓库统一接管。
- 已把上游 `nestang/README.md` 改写为中文说明。
- Lab 2 已完成一次综合，综合成功但 warning 较多。
- 首次布局布线因 `sys_clk` 和 `s1` 的 IO 电平默认值与 Bank VCCIO 冲突失败；已在 `nestang/src/nestang.cst` 中显式改为 `LVCMOS33`。
- HDMI PLL 中旧器件参数 `GW2A-18C` 已改为当前工程目标 `GW2AR-18C`。
- 重新综合和布局布线已成功，生成 `impl/pnr/nes.fs`。`PA1003` 已消失，当前仍有多条时钟相关 warning，后续需要继续整理约束。
- 使用上届同学留下的 TF 卡实测可以进入 NES 游戏并游玩，Lab 2 的板上运行验证已通过。当前未重新制作 TF 卡镜像，后续如需复现可再按 `nes2img.py` 路线重新写卡。

## 源码阅读重点

后续阅读 `nestang` 时重点关注：

- 顶层模块如何连接 Tang Nano 20K 的时钟、HDMI、TF 卡、手柄和音频。
- NES CPU 如何取指、译码、访存和响应中断。
- PPU 如何生成像素时序并输出到 HDMI。
- APU 或音频模块如何生成声音。
- ROM/Mapper 如何影响 CPU 和 PPU 的地址空间。
- 菜单系统如何从 TF 卡选择和加载游戏。

已整理初步源码地图：

- `notes/source_map.md`

## Gowin 工程入口

- 工程文件：`nestang/nes.gprj`
- 顶层文件：`nestang/src/nes_tang20k.v`
- 顶层模块：`NES_Tang20k`
- 物理约束：`nestang/src/nestang.cst`
- 时序约束：`nestang/src/nestang.sdc`
- 目标器件：`GW2AR-LV18QN88C8/I7`

上游目录中的 `nes.fs` 是预编译比特流，当前被 `.gitignore` 忽略。后续实验优先从源码重新生成比特流。

## 当前 PnR 结果

2026-06-07 已完成一次本地布局布线并生成比特流：

- `nestang/impl/pnr/nes.fs`
- `nestang/impl/pnr/nes.bin`
- `nestang/impl/pnr/nes.rpt.txt`

这些文件位于 `impl/` 生成目录中，已由 `.gitignore` 忽略。

当前 warning 主要分为两类：

- 时钟创建 warning：多个内部信号被识别为时钟但没有显式创建时钟约束，例如 HDMI 音频时钟、手柄扫描信号、分频输出等。
- 时钟关系 warning：部分内部时钟与 `clk` / `clk_p5` 的关系无法自动计算。

这些 warning 暂不阻止生成比特流；后续报告中需要说明它们是时钟约束/时钟关系类 warning，没有阻塞本次实验运行。

## 板上运行验证

2026-06-07，使用已有 TF 卡内容进行实机验证：

- TF 卡中已经有可用的 NES 游戏/镜像内容。
- 板卡接入 TF 卡和 HDMI 后，可以进入游戏并实际游玩。
- 当前操作方式还没有完全熟悉，但从实验验收角度看，NES 模拟器已经完成板上运行验证。
- 本次没有把重新制作 TF 卡镜像作为必要步骤；如果后续需要展示完整可复现流程，再使用 `nestang/tools/nes2img.py` 重新生成 `games.img`。

## TF 卡和手柄准备

当前可用硬件：

- 32G TF 卡。
- 一个游戏手柄配件。

一个手柄足够先验证玩家 1。默认玩家 1 引脚如下：

| 玩家 1 信号 | FPGA 引脚 |
| --- | --- |
| `clk` | 17 |
| `mosi` | 20 |
| `miso` | 19 |
| `cs` | 18 |

TF 卡镜像通过 `nestang/tools/nes2img.py` 生成。该脚本依赖 Pillow：

```powershell
python -m pip install pillow
```

本机可以直接使用 conda 环境 `dip`，不用污染 base 环境。已确认：

- `C:\Users\JJ406\.conda\envs\dip\python.exe`
- Pillow 可用，版本为 `11.3.0`

准备合法来源的 `.nes` 文件后，在 `nestang/tools/` 目录运行：

```powershell
C:\Users\JJ406\.conda\envs\dip\python.exe .\nes2img.py -o games.img game1.nes game2.nes
```

随后用 Balena Etcher 或其他可靠工具把 `games.img` 写入 32G TF 卡。写入会覆盖 TF 卡原内容，操作前需要确认盘符。写入后将 TF 卡插入 Tang Nano 20K，再用 Programmer 下载 `impl/pnr/nes.fs` 进行运行验证。

`.nes` 文件应使用合法来源，例如自备卡带转储、NES homebrew / public domain 游戏，或 nesdev 社区测试 ROM。不要把来源不明的商业 ROM 放入仓库。

## 实验记录要求

- 保留编译日志、下载方式和运行现象。
- 截图或视频放入 `private/`，避免把个人环境和课程平台信息提交到公开仓库。
- 如果对上游代码做修改，在本目录记录修改原因和效果。
