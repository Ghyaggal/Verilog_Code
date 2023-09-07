# FIR

### 简介

FIR（Finite Impulse Response）滤波器是一种有限长单位冲激响应滤波器，又称为非递归型滤波器。

FIR 滤波器具有严格的线性相频特性，同时其单位响应是有限长的，因而是稳定的系统，在数字通信、图像处理等领域都有着广泛的应用。

FIR 滤波器本质上就是输入信号与单位冲击响应函数的卷积。

### 特性

FIR 滤波器有如下几个特性：

- 响应是有限长序列。
- 系统函数在 |z| > 0 处收敛，极点全部在 z=0 处，属于因果系统。
- 结构上是非递归的，没有输出到输入的反馈。
- 输入信号相位响应是线性的，因为响应函数 h(n) 系数是对称的。
- 输入信号的各频率之间，相对相位差也是固定不变的。
- 时域卷积等于频域相乘，因此该卷积相当于筛选频谱中各频率分量的增益倍数。某些频率分量保留，某些频率分量衰减，从而实现滤波的效果。

***

### FIR_Parallel

#### 设计说明

输入频率为 7.5 MHz 和 250 KHz 的正弦波混合信号，经过 FIR 滤波器后，高频信号 7.5MHz 被滤除，只保留 250KHz 的信号。设计参数如下：

```
输入频率：    7.5MHz 和 250KHz
采样频率：    50MHz
阻带：       1MHz ~ 6MHz
阶数：       15（N-1=15）
```

由 FIR 滤波器结构可知，阶数为 15 时，FIR 的实现需要 16 个乘法器，15 个加法器和 15 组延时寄存器。为了稳定第一拍的数据，可以再多用一组延时寄存器，即共用 16 组延时寄存器。由于 FIR 滤波器系数的对称性，乘法器可以少用一半，即共使用 8 个乘法器。

并行设计，就是在一个时钟周期内对 16 个延时数据同时进行乘法、加法运算，然后在时钟驱动下输出滤波值。这种方法的优点是滤波延时短，但是对时序要求比较高。