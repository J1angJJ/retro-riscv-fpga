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
- Lab 2 尚未开始本地重新编译；下一步是在 Gowin 中打开 `nestang/nes.gprj`。

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

## 实验记录要求

- 保留编译日志、下载方式和运行现象。
- 截图或视频放入 `private/`，避免把个人环境和课程平台信息提交到公开仓库。
- 如果对上游代码做修改，在本目录记录修改原因和效果。
