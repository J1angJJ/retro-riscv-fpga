# Sipeed Tang Nano 20K 板卡记录

本目录保存本项目会反复用到的 Tang Nano 20K 板卡信息。这里不替代官方文档，只记录实验中需要快速查阅的型号、时钟、LED 和工具链信息。

## 器件信息

- 板卡：Sipeed Tang Nano 20K
- FPGA 具体型号：`GW2AR-LV18QN88C8/I7`
- Gowin 器件系列/名称：`GW2AR-18C`
- 板载下载器/USB 桥接芯片：BL616

## 当前已用引脚

| 信号 | FPGA 引脚 | 说明 |
| --- | --- | --- |
| `clk_27m` | `PIN04` | 板载 27 MHz 晶振，当前工程使用 LVCMOS33 |
| `led0_n` | `PIN15` | LED0，低电平点亮，当前工程使用 LVCMOS33 |

## 工具链记录

- 使用较新的受支持版本时，Gowin 教育版可能已经支持 `GW2AR-LV18QN88C8/I7`。
- Gowin 专业版在 license 激活后也可以使用。
- `.fs`、实现数据库、报告、波形文件等 FPGA 生成产物已由 `.gitignore` 忽略。

## 资料来源

- Tang Nano 20K 板卡页面：https://wiki.sipeed.com/hardware/zh/tang/tang-nano-20k/nano-20k.html
- Gowin IDE 安装说明：https://wiki.sipeed.com/hardware/zh/tang/Tang-Nano-Doc/get_started/install-the-ide.html
