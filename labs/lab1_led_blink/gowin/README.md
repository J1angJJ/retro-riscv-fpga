# Lab 1：Gowin 工程创建说明

`labs/lab1_led_blink/` 只是源码目录，不是 Gowin IDE 工程目录。Gowin 需要打开 `.gprj` 工程文件，不能直接把源码文件夹当工程打开。

## 方式一：在 IDE 中手动新建

1. 打开 Gowin IDE。
2. 选择新建 FPGA 设计工程。
3. 工程名建议填写：`lab1_led_blink`。
4. 工程位置建议选择：`labs/lab1_led_blink/gowin/`。
5. 器件选择：`GW2AR-LV18QN88C8/I7`。
6. 如果界面要求选择器件版本，选择 `C`；界面中也可能显示为 `GW2AR-18C`。
7. 工程创建完成后，添加 Verilog 源码：
   - `labs/lab1_led_blink/src/led_blink.v`
8. 添加物理约束文件：
   - `labs/lab1_led_blink/constraints/tang_nano_20k.cst`
9. 添加时序约束文件：
   - `labs/lab1_led_blink/constraints/tang_nano_20k.sdc`
10. 确认顶层模块为 `led_blink`。
11. 保存工程。

完成后，Gowin IDE 会在 `gowin/lab1_led_blink/` 下生成 `.gprj`、实现目录和中间文件。大型生成文件已由 `.gitignore` 忽略。

## 当前已确认的工程选择

教育版 IDE 中 `GW2ARx` 系列下可选到的目标器件信息如下：

- 工程名：`lab1_led_blink`
- 工程目录：`R:\retro-riscv-fpga\labs\lab1_led_blink\gowin`
- Gowin 默认源码目录：`R:\retro-riscv-fpga\labs\lab1_led_blink\gowin\lab1_led_blink\src`
- Gowin 默认实现目录：`R:\retro-riscv-fpga\labs\lab1_led_blink\gowin\lab1_led_blink\impl`
- Part Number：`GW2AR-LV18QN88C8/I7`
- Series：`GW2AR`
- Device：`GW2AR-18C`
- Package：`QFN88`
- Speed：`C8/I7`

注意：本仓库的主源码仍放在 `labs/lab1_led_blink/src/`，主约束仍放在 `labs/lab1_led_blink/constraints/`。Gowin 向导显示的默认源码目录只是工程内部默认位置；添加文件时优先添加本仓库已有文件，避免后续出现两份源码互相不同步。

## 方式二：用脚本生成工程

如果 Gowin 的 `gw_sh` 已加入 `PATH`，在仓库根目录运行：

```powershell
.\scripts\create_lab1_gowin_project.ps1
```

如果没有加入 `PATH`，手动指定 `gw_sh.exe` 路径，例如：

```powershell
.\scripts\create_lab1_gowin_project.ps1 -GwSh "C:\Gowin\Gowin_V1.9.11.01_Education\IDE\bin\gw_sh.exe"
```

脚本会创建或更新：

- `labs/lab1_led_blink/gowin/lab1_led_blink/lab1_led_blink.gprj`

然后在 Gowin IDE 中打开这个 `.gprj` 文件即可。

## 后续编译与烧录

1. 打开 `labs/lab1_led_blink/gowin/lab1_led_blink/lab1_led_blink.gprj`。
2. 确认工程文件列表包含：
   - `led_blink.v`
   - `tang_nano_20k.cst`
   - `tang_nano_20k.sdc`
3. 运行综合。
4. 运行布局布线。
5. 生成比特流。
6. 打开 Programmer，通过 BL616 下载到 Tang Nano 20K。

第一次烧录前建议先确认 Programmer 能识别板卡，再执行写入。

## 当前验证结果

- Gowin 版本：V1.9.11.03 Education 64-bit。
- 下载器：Programmer 可检测到 `USB Debugger A`。
- 下载方式：`SRAM Program`。
- 目标器件：`GW2AR-18C`。
- 比特流文件：`impl/pnr/lab1_led_blink.fs`。
- 当前状态：已通过 SRAM 下载方式完成一次板上验证，LED 闪烁现象基本正常。

当前 PnR 日志仍有两个时钟相关 warning：

- `TA1132`：`clk_27m` 被识别为时钟，但未创建时钟。
- `PR1014`：`clk_27m_d` 使用通用布线资源作为时钟，可能带来延迟或偏斜。

已新增 `constraints/tang_nano_20k.sdc` 声明 27 MHz 时钟。后续可重新综合和布局布线，确认 warning 是否减少。当前 LED 闪烁实验功能已可继续作为 Lab 1 初步结果记录。
