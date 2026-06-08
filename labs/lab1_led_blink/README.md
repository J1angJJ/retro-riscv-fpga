# Tang Nano 20K LED 闪烁工程

本目录保存 Tang Nano 20K 的最小 Verilog LED 闪烁工程，用于验证 Gowin 工具链、板卡引脚约束、综合、布局布线和 SRAM 下载流程。

## 目录结构

- `src/led_blink.v`：顶层 Verilog 模块，使用板载 27 MHz 时钟驱动 LED0 闪烁。
- `constraints/tang_nano_20k.cst`：Tang Nano 20K 的 Gowin 物理约束，绑定时钟和 LED0 引脚。
- `constraints/tang_nano_20k.sdc`：27 MHz 时钟的时序约束。
- `tb/led_blink_tb.v`：仿真 testbench，用较小参数加速观察 LED 翻转并做自检。
- `gowin/README.md`：Gowin 工程创建和导入步骤。
- `../../scripts/run_lab1_sim.ps1`：Icarus Verilog 仿真辅助脚本，输出到 `build/lab1_led_blink/`。

## 板卡信息

- 板卡：Sipeed Tang Nano 20K
- FPGA：`GW2AR-LV18QN88C8/I7`
- Gowin 器件：`GW2AR-18C`
- 板载晶振：27 MHz，FPGA 引脚 `PIN04`
- LED0：FPGA 引脚 `PIN15`
- LED 电平：低电平点亮
- IO 电平：当前工程使用 `LVCMOS33`。Gowin PnR 日志显示相关 Bank 的 VCCIO 已锁定为 3.3 V。

## 设计说明

`led_blink` 内部使用一个计数器做时钟分频。默认参数下：

- 输入时钟 `CLK_HZ = 27_000_000`
- LED 每 `TOGGLE_TICKS = 13_500_000` 个时钟周期翻转一次
- 因此 LED 每 0.5 秒翻转一次，完整亮灭周期约 1 秒

输出端口 `led0_n` 使用低有效命名。仿真和代码阅读时可以直接根据 `_n` 后缀判断：`0` 表示 LED 亮，`1` 表示 LED 灭。

## Gowin 工程创建

`labs/lab1_led_blink/` 是源码目录，不是 Gowin 工程目录，不能直接当工程打开。

推荐先阅读：

- `gowin/README.md`

有两种方式：

- 在 Gowin IDE 中新建工程，然后手动添加 `src/led_blink.v` 和 `constraints/tang_nano_20k.cst`。
- 使用 `scripts/create_lab1_gowin_project.ps1` 调用 Gowin 的 `gw_sh` 生成工程文件。

工程创建完成后，Gowin 生成的工程文件通常位于：

- `gowin/lab1_led_blink/lab1_led_blink.gprj`

当前已确认可选器件：

- Part Number：`GW2AR-LV18QN88C8/I7`
- Device：`GW2AR-18C`
- Package：`QFN88`
- Speed：`C8/I7`

## 约束与布局布线

如果工程已经添加 `constraints/tang_nano_20k.cst`，通常不需要再手动在 FloorPlanner 中重新填约束。需要确认工程文件列表里有这个 CST 文件。另需确认 `constraints/tang_nano_20k.sdc` 已作为时序约束加入工程，用于声明 27 MHz 时钟。

如果想按 Sipeed 网页手动操作：

1. 综合完成后，双击 `FloorPlanner`。
2. 首次进入时按提示创建物理约束文件。
3. 在 `I/O Constraints` 表中填写：
   - `clk_27m`：Location 为 `4`，IO Type 为 `LVCMOS33`，Pull Mode 为 `UP`。
   - `led0_n`：Location 为 `15`，IO Type 为 `LVCMOS33`，Drive 为 `8`，Pull Mode 为 `UP`。
4. 保存约束后关闭 FloorPlanner。
5. 回到 IDE 主界面，双击 `Place&Route`。

## 可选仿真

如果本机安装了 Icarus Verilog，可以运行：

```powershell
.\scripts\run_lab1_sim.ps1
```

脚本会生成：

- `build/lab1_led_blink/led_blink_tb.vvp`
- `build/lab1_led_blink/led_blink_tb.vcd`

`build/` 已被 `.gitignore` 忽略。

## 协作注意事项

- 源码和约束文件优先维护在 `src/` 与 `constraints/`，不要把 Gowin 自动复制出的同名文件当作主版本。
- `gowin/` 中只保留必要工程文件和说明，`impl/`、工具报告、比特流等生成物不提交。
- 如果调整 LED、时钟或 IO 电平，请同步更新本文件和 `boards/tang_nano_20k/README.md`。
