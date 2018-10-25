# Kendryte K210板级支持包说明

---

## 1. 简介

[说明硬件平台的基本情况，包括芯片情况，频率，RAM空间，Flash空间等，最好也提供一份照片图]

skeleton芯片 是 cc 公司的一款面向 nn 等领域的芯片。包括如下硬件特性：

| 硬件 | 描述 |
| -- | -- |
|芯片型号| K210 |
|CPU| 双核RV64GC |
|主频| 400MHz |
|片内SRAM| 8MB |

## 2. 编译说明

[说明测试的编译器版本，或env版本情况]
    
编译K210，需要先下载K210 BSP以及RT-Thread代码：

    git clone https://github.com/BernardXiong/K210.git
    cd K210
    git submodule init
    git submodule update

    git clone https://github.com/RT-Thread/rt-thread.git
    cd rt-thread
    git checkout -b dev-4.0.x origin/dev-4.0.x

注意，因为RT-Thread整体代码太庞大，所以并未把RT-Thread git repo以一个submodule方式加入到K210 BSP git repo中，
而是需要把RT-Thread代码克隆到K210目录下。

编译推荐使用[env工具][1]，可以在console下进入到`K210`目录中，运行以下命令：

    scons

来编译这个板级支持包。如果编译正确无误，会产生rtthread.elf、rtthread.bin文件。其中rtthread.bin需要烧写到设备中进行运行。

## 3. 烧写及执行

[需要说明电源连接情况，串口连接情况]

连接好串口，可以使用115200-N-8-1的配置方式连接到设备上。设备使用的串口引脚是：`[PA1/PA2]`

当正确编译产生出rtthread.bin映像文件后，可以使用...的方式来烧写到设备中。

### 3.1 运行结果

如果编译 & 烧写无误，当复位设备后，会在串口上看到RT-Thread的启动logo信息：

## 4. 驱动支持情况及计划

| 驱动 | 支持情况  |  备注  |
| ------ | ----  | :------:  |
| UART | 支持 | UART0/1 |
| clock | 支持 |  |
| SPI |  | SPI0/1，预计在2018/Q2支持 |

### 4.1 IO在板级支持包中的映射情况

| IO号 | 板级包中的定义 |
| -- | -- |
| PA1 | LED1 |

## 5. 联系人信息

维护人：xxx < abc@name.com >

## 6. 参考

* 板子[数据手册][2]
* 芯片[数据手册][3]

  [1]: https://www.rt-thread.org/page/download.html
  [2]: http://abc.com/datasheet.pdf
  [3]: http://abc.com/um.pdf
