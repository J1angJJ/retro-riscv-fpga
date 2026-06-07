# NESTang：Tang Nano 20K NES 模拟器

本目录来自 Sipeed `TangNano-20K-example` 仓库中的 `nestang` 示例，用于 Lab 2。原始示例基于 NESTang 项目，在 Tang Nano 20K 上实现 NES 模拟器。

## 来源

- Sipeed 示例仓库：`https://github.com/sipeed/TangNano-20K-example/tree/main/nestang`
- 本次引入的上游提交：`154326f105e50cbb43dd4a3484ff3e32ce251b84`
- NESTang 原始项目：`https://github.com/nand2mario/nestang`

引入后已去掉外部仓库自己的 Git 管理，由当前课程项目仓库统一管理。

## 硬件需求

- Tang Nano 20K FPGA 板卡。
- HDMI 显示器或采集设备。
- 两个手柄及其转接板。
- 面包板和杜邦线，用于减少手柄转接时的飞线混乱。
- TF 卡，用于存放打包后的 NES 游戏镜像。

## FPGA 程序下载

示例中自带的 `nes.fs` 是预编译比特流。该文件较大，当前被 `.gitignore` 忽略，不作为本仓库源码提交。后续应优先在 Gowin 中重新综合、布局布线并生成自己的 `.fs`。

临时验证时可以使用 Programmer 的 SRAM 下载方式；如果希望断电后仍保留程序，再考虑写入 Flash。

## 游戏镜像准备

使用 `tools/nes2img.py` 可以把多个 `.nes` 游戏打包成一个 TF 卡镜像。例如：

```bash
python nes2img.py -o games.img 1.nes 2.nes 3.nes
```

生成 `games.img` 后，可以使用 Balena Etcher 或 `dd` 写入 TF 卡。Linux 下示例命令如下：

```bash
sudo dd if=games.img of=/dev/sdx bs=512
```

注意：写 TF 卡镜像前必须确认目标盘符，避免误覆盖电脑硬盘。

当前实验可使用 32G TF 卡。`games.img` 是原始镜像，不是普通文件复制；需要用 Balena Etcher 或等价工具写入整张 TF 卡。

本次实验发现，上届同学留下的 TF 卡里已经有可用内容，直接插入后可以进入 NES 游戏并游玩。因此 Lab 2 的运行验证已经通过，重新制作 `games.img` 不是当前阻塞项。这里仍保留制卡步骤，作为后续复现实验或更换 ROM 时的参考。

`nes2img.py` 依赖 Pillow。如果 Python 环境缺少 `PIL`，先安装：

```powershell
python -m pip install pillow
```

本机可使用 conda 环境 `dip`，无需在 base 环境安装依赖：

```powershell
C:\Users\JJ406\.conda\envs\dip\python.exe .\nes2img.py -o games.img game1.nes game2.nes
```

`.nes` 文件建议使用合法来源，例如自备卡带转储、homebrew / public domain 游戏或 nesdev 测试 ROM。

## 手柄连接

默认工程支持两个手柄。当前只有一个手柄配件时，先连接玩家 1 即可。上游说明中给出的默认引脚如下：

| 玩家 2 信号 | FPGA 引脚 | 玩家 1 信号 | FPGA 引脚 |
| --- | --- | --- | --- |
| `clk2` | 52 | `clk` | 17 |
| `mosi2` | 53 | `mosi` | 20 |
| `miso2` | 71 | `miso` | 19 |
| `cs2` | 72 | `cs` | 18 |

上游说明中提到，玩家 1 对应右侧手柄约束。

## 启动方式

1. 连接 HDMI 显示器。
2. 插入写好 `games.img` 的 TF 卡。
3. 连接手柄转接板。
4. 给 Tang Nano 20K 上电。
5. 使用手柄按键 `2` 启动游戏。
6. 使用 FPGA 板上 `S1` 按键切换到游戏选择菜单。

## 后续阅读重点

- `src/nestang_top.v`：顶层外设连接。
- `src/cpu.v`：NES CPU。
- `src/ppu.v`：图形处理器。
- `src/apu.v`：音频处理器。
- `src/mmu.v`：地址映射与 Mapper 相关逻辑。
- `src/sd_loader.v`、`src/sd_reader.sv`：TF 卡读取和 ROM 加载。
- `src/hdmi2/`：HDMI 输出相关模块。
