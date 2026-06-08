# Tang Nano 20K 板卡说明

本目录记录本项目使用的 Sipeed Tang Nano 20K 板卡信息。内容只保留复现项目所需的公开技术信息，不替代官方手册。

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
| `uart_tx` | `PIN69` | FPGA 到 BL616 串口桥接 |
| `uart_rx` | `PIN70` | BL616 串口桥接到 FPGA |

## 工具链记录

- 使用较新的受支持版本时，Gowin 教育版可能已经支持 `GW2AR-LV18QN88C8/I7`。
- `.fs`、实现数据库、工具报告、波形文件等 FPGA 生成产物已由 `.gitignore` 忽略。

## 协作约定

- 板卡公共信息记录在本目录。
- 个人环境截图、串口原始日志和临时调试记录不放入公开目录。
- 新增引脚约束时，同步更新本页的“当前已用引脚”表，便于复核跨工程复用情况。

## 资料来源

- Tang Nano 20K 板卡页面：https://wiki.sipeed.com/hardware/zh/tang/tang-nano-20k/nano-20k.html
- Gowin IDE 安装说明：https://wiki.sipeed.com/hardware/zh/tang/Tang-Nano-Doc/get_started/install-the-ide.html
