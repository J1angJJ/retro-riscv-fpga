# Lab 0：板卡开箱与环境记录

本目录记录 Lab 0 中可以公开的硬件和环境确认信息。个人截图、串口原始日志、课程平台截图和报告草稿仍放在 `private/`。

## 当前板卡状态

- 板卡：Sipeed Tang Nano 20K
- FPGA：`GW2AR-LV18QN88C8/I7`
- USB 桥接/板载下载器：BL616
- 串口终端软件：MobaXterm
- Windows 下观察到的串口：`COM4`
- 上电结果：板卡可以正常上电
- 当前 FPGA/SoC 程序：观察到的是 `Hello World` 类程序，不是官方默认 LiteX 示例
- Gowin 教育版：已下载，等待安装和器件/下载链路验证
- Gowin 教育版器件选择：已确认可选 `GW2AR-LV18QN88C8/I7`，显示为 `GW2AR-18C`、`QFN88`、`C8/I7`

当前非默认程序视为前序使用留下的正常状态。对本实验而言，关键结论是板卡能够上电，且 BL616 终端链路可用。

## 待确认事项

- 记录 Windows 版本和 Gowin IDE 版本。
- 记录已安装的 Gowin 版本号。
- 确认 Programmer 是否能通过 BL616 识别板卡。
- IDE/license 准备完成后，重新做一次最小下载测试。
