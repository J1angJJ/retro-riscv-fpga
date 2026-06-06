# Lab 1: LED Blink on Tang Nano 20K

本目录保存 Lab 1 的最小 Verilog 点灯实验。当前代码不依赖 Gowin IDE 即可阅读和仿真；等 IDE/license 可用后，再导入源码与约束进行综合、布局布线和烧录。

## 目录结构

- `src/led_blink.v`：顶层 Verilog 模块，使用板载 27 MHz 时钟驱动 LED0 闪烁。
- `constraints/tang_nano_20k.cst`：Tang Nano 20K 的 Gowin 物理约束，绑定时钟和 LED0 引脚。
- `tb/led_blink_tb.v`：仿真 testbench，用较小参数加速观察 LED 翻转。

## 板卡信息

- 板卡：Sipeed Tang Nano 20K
- FPGA：`GW2AR-LV18QN88C8/I7`
- Gowin Device：`GW2AR-18C`
- 板载晶振：27 MHz，FPGA 引脚 `PIN04`
- LED0：FPGA 引脚 `PIN15`
- LED 电平：低电平点亮

## 设计说明

`led_blink` 内部使用一个计数器做时钟分频。默认参数下：

- 输入时钟 `CLK_HZ = 27_000_000`
- LED 每 `TOGGLE_TICKS = 13_500_000` 个时钟周期翻转一次
- 因此 LED 每 0.5 秒翻转一次，完整亮灭周期约 1 秒

输出端口 `led0_n` 使用低有效命名。仿真和代码阅读时可以直接根据 `_n` 后缀判断：`0` 表示 LED 亮，`1` 表示 LED 灭。

## 后续 IDE 步骤

1. 在 Gowin IDE 中新建 FPGA Design Project。
2. 器件选择 `GW2AR-LV18QN88C8/I7`，Device 显示应为 `GW2AR-18C`。
3. 添加 `src/led_blink.v`。
4. 添加或导入 `constraints/tang_nano_20k.cst`。
5. 依次运行 Synthesize、Place & Route、Generate Bitstream。
6. 使用 Programmer 通过板载 BL616 下载到 FPGA。

## 可选仿真

如果本机安装了 Icarus Verilog，可以运行：

```powershell
iverilog -o private/build/lab1_led_blink_tb.vvp labs/lab1_led_blink/src/led_blink.v labs/lab1_led_blink/tb/led_blink_tb.v
vvp private/build/lab1_led_blink_tb.vvp
```

仿真产物建议放在 `private/build/` 或其他被忽略路径中。
