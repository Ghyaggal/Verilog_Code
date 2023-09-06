# UART_to_TFT

参照小梅哥串口传图帧缓存设计，实现的PC端串口传图通过TFT显示屏进行显示的功能。

***

#### 主控

EP4CE10F17C8N

***

#### 模块设计

| 文件 | 对应功能 |
| --------- | ---------------- |
| tft_lcd.v | TFT5.0屏显示模块 |
| uart_rx.v | 串口接收模块     |
|uart_rx.v	|串口接收模块			|
|UART_to_TFT.v		|顶层设计模块			|
|Sdram_Params.h		|SDRAM配置信息		|
|sdram_init.v		|SDRAM初始化模块	|
|sdram_ctrl.v		|SDRAM控制器模块	|
|sdram_ctrl_top.v	|SDRAM设计优化模块 |

***

#### 工具
| 文件 | 对应功能 |
| --------- | ---------------- |
|Picture2Hex 	|将图转换成对应数据|
|uart_send_800480	 |通过.exe选择对应串口传输该文件夹下的logo.c的图片数据|

***



