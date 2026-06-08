# Tang Nano 20K NES FPGA 工程

本目录用于在 Tang Nano 20K 上运行和分析 NES FPGA 工程。工程基于 NESTang 相关开源实现，重点关注 HDMI 显示、TF 卡游戏镜像加载、手柄输入和 NES 核心结构。

## 目标

- 整理 Tang Nano 20K 可用的 NES FPGA 示例工程。
- 完成 HDMI、手柄、TF 卡和 ROM 加载相关准备。
- 从源码重新综合、布局布线并生成比特流。
- 阅读源码，理解 CPU、PPU、APU、ROM、输入和视频输出之间的关系。

## 目录结构

- `README.md`：本目录中文说明和当前状态。
- `notes/nes_architecture.md`：NES 架构阅读笔记。
- `notes/source_map.md`：NESTang 源码地图。
- `nestang/`：Sipeed TangNano-20K-example 中的 `nestang` 示例代码。原有 `.git` 管理已删除，由本仓库统一管理。

## 资料来源

- Sipeed TangNano-20K-example / nestang：  
  https://github.com/sipeed/TangNano-20K-example/tree/main/nestang
- NESTang 原始项目：  
  https://github.com/nand2mario/nestang
- NES 架构分析：  
  https://www.copetti.org/zh-hans/writings/consoles/nes/

## 硬件准备

- Tang Nano 20K FPGA 板卡。
- HDMI 显示器或采集设备。
- USB/板载 BL616 下载链路。
- TF 卡，用于放置 NES 菜单和 ROM 镜像。
- 手柄或手柄转接板，具体接口以示例工程文档和约束文件为准。

## 当前状态

- 已引入 Sipeed `TangNano-20K-example` 仓库中的 `nestang` 示例代码。
- 已删除外部 Git 管理，由当前仓库统一接管。
- 已将上游 `nestang/README.md` 保持为该目录内的工程说明。
- 已完成一次综合和布局布线，生成 `impl/pnr/nes.fs`。
- 首次布局布线遇到 `sys_clk` 和 `s1` 的 IO 电平默认值与 Bank VCCIO 冲突，已在 `nestang/src/nestang.cst` 中显式改为 `LVCMOS33`。
- HDMI PLL 中旧器件参数 `GW2A-18C` 已改为当前工程目标 `GW2AR-18C`。
- 使用已有 TF 卡内容实测可以进入 NES 游戏并游玩。当前未重新制作 TF 卡镜像，后续如需完整复现可按 `nes2img.py` 路线重新写卡。

## 源码阅读重点

- 顶层模块如何连接 Tang Nano 20K 的时钟、HDMI、TF 卡、手柄和音频。
- NES CPU 如何取指、译码、访存和响应中断。
- PPU 如何生成像素时序并输出到 HDMI。
- APU 或音频模块如何生成声音。
- ROM/Mapper 如何影响 CPU 和 PPU 的地址空间。
- 菜单系统如何从 TF 卡选择和加载游戏。

初步源码地图见：

- `notes/source_map.md`

## Gowin 工程入口

- 工程文件：`nestang/nes.gprj`
- 顶层文件：`nestang/src/nes_tang20k.v`
- 顶层模块：`NES_Tang20k`
- 物理约束：`nestang/src/nestang.cst`
- 时序约束：`nestang/src/nestang.sdc`
- 目标器件：`GW2AR-LV18QN88C8/I7`

上游目录中的预编译比特流和本地生成的 `impl/` 产物已由 `.gitignore` 忽略。后续优先从源码重新生成比特流。

## 当前 PnR 结果

已完成一次本地布局布线并生成比特流：

- `nestang/impl/pnr/nes.fs`
- `nestang/impl/pnr/nes.bin`
- `nestang/impl/pnr/nes.rpt.txt`

这些文件位于 `impl/` 生成目录中，不提交到仓库。

当前 warning 主要分为两类：

- 时钟创建 warning：多个内部信号被识别为时钟但没有显式创建时钟约束，例如 HDMI 音频时钟、手柄扫描信号、分频输出等。
- 时钟关系 warning：部分内部时钟与 `clk` / `clk_p5` 的关系无法自动计算。

这些 warning 暂不阻止生成比特流。后续如继续完善工程，可优先补充时钟约束并复核跨时钟域路径。

## TF 卡和手柄

玩家 1 默认手柄引脚如下：

| 玩家 1 信号 | FPGA 引脚 |
| --- | --- |
| `clk` | 17 |
| `mosi` | 20 |
| `miso` | 19 |
| `cs` | 18 |

TF 卡镜像通过 `nestang/tools/nes2img.py` 生成。该脚本依赖 Pillow，建议在独立 Python 虚拟环境或 conda 环境中安装：

```powershell
python -m pip install pillow
```

准备合法来源的 `.nes` 文件后，在 `nestang/tools/` 目录运行：

```powershell
python .\nes2img.py -o games.img game1.nes game2.nes
```

随后用 Balena Etcher 或其他可靠工具把 `games.img` 写入 TF 卡。写入会覆盖 TF 卡原内容，操作前需要确认目标盘符。

`.nes` 文件应使用合法来源，例如自备卡带转储、NES homebrew / public domain 游戏，或 nesdev 社区测试 ROM。不要把来源不明的商业 ROM 放入仓库。

## 协作注意事项

- 上游 `nestang/` 代码尽量保持来源清晰；如需修改，在本文件记录原因和效果。
- 截图、视频、原始串口日志和个人环境信息不提交到公开目录。
- 生成的比特流、实现数据库、工具报告和 TF 卡镜像不提交。
