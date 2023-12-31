# 除法器设计

参照菜鸟教程设计的除法器

***

####  原理

除法运算过程如下：

- 取被除数的高几位数据，位宽和除数相同（实例中是 3bit 数据）。

-  将被除数高位数据与除数作比较，如果前者不小于后者，则可得到对应位的商为 1，两者做差得到第一步的余数；否则得到对应的商为 0，将前者直接作为余数。

-  将上一步中的余数与被除数剩余最高位 1bit 数据拼接成新的数据，然后再和除数做比较。可以得到新的商和余数。

-  重复过程 (3)，直到被除数最低位数据也参与计算。

需要说明的是，商的位宽应该与被除数保持一致，因为除数有可能为1。**所以上述手动计算除法的实例中，第一步做比较时，应该取数字 27 最高位 1 (3'b001) 与 3'b101 做比较。** 根据此计算过程，设计位宽可配置的流水线式除法器，流水延迟周期个数与被除数位宽一致。

