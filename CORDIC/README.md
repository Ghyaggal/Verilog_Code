# CORDIC

坐标旋转数字计算机（Coordinate Rotation Digital Computer ）



### 一、基本原理

CORDIC算法是一个“化繁为简”的算法，将许多复杂的运算转化为一种“仅需要移位和加法”的迭代操作。CORDIC算法有旋转和向量两个模式，分别可以在圆坐标系、线性坐标系和双曲线坐标系使用，从而可以演算出8种运算。

|              | 旋转模式    | 向量模式          |
| ------------ | ----------- | ----------------- |
| 圆坐标系     | cos & sin   | tan<sup>-1</sup>  |
| 线性坐标系   | *           | /                 |
| 双曲线坐标系 | cosh & sinh | tanh<sup>-1</sup> |



### 二、几何原理

假设在xy坐标系中有一个点P1（x1，y1），将P1点绕原点旋转θ角后得到点P2（x2，y2）。可以得到P1和P2的关系如下：

x2 = x1cosθ – y1sinθ = cosθ(x1 – y1tanθ)
y2 = y1cosθ + x1sinθ = cosθ(y1 +x1tanθ)



### 三、算法

将旋转角θ细化成若干分固定大小的角度θi，并且规定θi满足tanθi = 2-i，因此∑θi的值在[-99.7°，99.7°]范围内，如果旋转角θ超出此范围，则运用简单的三角运算操作即可（加减π）。

假设在xy坐标系中有一个点P0（x0，y0），将P0点绕原点旋转θ角后得到点Pn（xn，yn）。于是可以得到P0和Pn的关系：
xn = x0cosθ – y0sinθ = cosθ(x0 – y0tanθ)
yn = y0cosθ + x0sinθ = cosθ(y0 + x0tanθ)

在我们旋转的过程中，式子里一直会有tanθi和cosθi，而每次都可以提取出cosθi。虽然我们的FPGA无法计算tanθi，但我们知道tanθi = 2-i，因此可以执行和tanθi效果相同的移位操作2-i来取代tanθi。而对于cosθi，我们可以事先全部提取出来，然后等待迭代结束之后（角度剩余值zi+1趋近于0，一般当系统设置最大迭代次数为16时zi+1已经很小了），然后计算出∏cosθi的值即可。



迭代公式：
x<sup>i+1</sup> = x<sub>i</sub> – d<sub>i</sub>y<sub>i</sub><sup>2-i</sup>，提取了cosθi，2-i等效替换了tanθi之后
y<sup>i+1</sup> = y<sub>i</sub> + d<sub>i</sub>x<sub>i</sub><sup>2-i</sup>>，提取了cosθi，2-i等效替换了tanθi之后
z<sup>i+1</sup> = z<sub>i</sub> - d<sub>i</sub>θ<sub>i</sub>



### 四、设计

本设计采用了16级流水线，为了避免浮点运算，为了满足精度要求，对每个变量都放大了2^16倍，并且引入了有符号型reg和算术右移。



