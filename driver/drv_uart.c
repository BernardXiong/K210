/*
 * Copyright (c) 2006-2018, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 */

#include <rthw.h>
#include <rtthread.h>
#include <rtdevice.h>

#include "board.h"
#include "drv_uart.h"

#include <stdio.h>

// #include "uart.h"
#include "uarths.h"
#include "plic.h"

struct device_uart
{
    rt_uint32_t hw_base;
    rt_uint32_t irqno;
};

static rt_err_t  uart_configure(struct rt_serial_device *serial, struct serial_configure *cfg);
static rt_err_t  uart_control(struct rt_serial_device *serial, int cmd, void *arg);
static int       drv_uart_putc(struct rt_serial_device *serial, char c);
static int       drv_uart_getc(struct rt_serial_device *serial);

static void     uart_irq_handler(int irqno, void *param);

const struct rt_uart_ops _uart_ops =
{
    uart_configure,
    uart_control,
    drv_uart_putc,
    drv_uart_getc,
    RT_NULL
};

/*
 * UART Initiation
 */
int rt_hw_uart_init(void)
{
    struct rt_serial_device *serial;
    struct device_uart      *uart;
    struct serial_configure config = RT_SERIAL_CONFIG_DEFAULT;

#ifdef BSP_USING_UART_HS
    {
        static struct rt_serial_device  serial_hs;
        static struct device_uart       uart_hs;

        serial  = &serial_hs;
        uart    = &uart_hs;

        serial->ops              = &_uart_ops;
        serial->config           = config;
        serial->config.baud_rate = 115200;

        uart->hw_base   = UARTHS_BASE_ADDR;
        uart->irqno     = IRQN_UARTHS_INTERRUPT;

        /* initialize UART HS */
        uarths_init();

        rt_hw_serial_register(serial,
                              "uarths",
                              RT_DEVICE_FLAG_RDWR | RT_DEVICE_FLAG_INT_RX,
                              uart);
    }
#endif

#ifdef BSP_USING_UART1
    {
        static struct rt_serial_device  serial1;
        static struct device_uart       uart1;

        serial  = &serial1;
        uart    = &uart1;

        serial->ops              = &_uart_ops;
        serial->config           = config;
        serial->config.baud_rate = 115200;

        uart->hw_base   = UART1_BASE_ADDR;
        uart->irqno     = IRQN_UART1_INTERRUPT;

        rt_hw_serial_register(serial,
                              "uarths",
                              RT_DEVICE_FLAG_RDWR | RT_DEVICE_FLAG_INT_RX,
                              uart);
    }
#endif

#ifdef BSP_USING_UART2
#endif

#ifdef BSP_USING_UART3
#endif

    return 0;
}

/*
 * UART interface
 */
static rt_err_t uart_configure(struct rt_serial_device *serial, struct serial_configure *cfg)
{
    rt_uint32_t baud_div;
    struct device_uart *uart;

    RT_ASSERT(serial != RT_NULL);
    serial->config = *cfg;

    uart = serial->parent.user_data;
    RT_ASSERT(uart != RT_NULL);

    /* Init UART Hardware */

    /* Enable UART clock */

    /* Set both receiver and transmitter in UART mode (not SIR) */

    /* Set databits, stopbits and parity. (8-bit data, 1 stopbit, no parity) */

    /* set baudrate */

    return (RT_EOK);
}

static rt_err_t uart_control(struct rt_serial_device *serial, int cmd, void *arg)
{
    struct device_uart *uart;

    uart = serial->parent.user_data;

    RT_ASSERT(uart != RT_NULL);

    switch (cmd)
    {
    case RT_DEVICE_CTRL_CLR_INT:
        /* Disable the UART Interrupt */
        rt_hw_interrupt_mask(uart->irqno);
        break;

    case RT_DEVICE_CTRL_SET_INT:
        /* install interrupt */
        rt_hw_interrupt_install(uart->irqno, uart_irq_handler,
                                serial, serial->parent.parent.name);
        rt_hw_interrupt_umask(uart->irqno);
        break;
    }

    return (RT_EOK);
}

static int drv_uart_putc(struct rt_serial_device *serial, char c)
{
    struct device_uart *uart;

    uart = serial->parent.user_data;
    if (uart->hw_base == UARTHS_BASE_ADDR)
    {
        uarths_putchar(c);
    }
    else
    {
        /* other uart */
    }

    return (1);
}

static int drv_uart_getc(struct rt_serial_device *serial)
{
    int ret = -1;
    struct device_uart *uart = serial->parent.user_data;

    if (uart->hw_base == UARTHS_BASE_ADDR)
    {
        ret = uarths_getc();
        if (ret != EOF) return ret;
    }

    /* Receive Data Available */

    return (-1);
}

/* UART ISR */
static void uart_irq_handler(int irqno, void *param)
{
    rt_ubase_t isr;
    struct rt_serial_device *serial = (struct rt_serial_device *)param;
    struct device_uart *uart = serial->parent.user_data;

    /* read interrupt status and clear it */
    if (uart->hw_base == UARTHS_BASE_ADDR)
    {
        if (uarths->ip.rxwm) 
            rt_hw_serial_isr(serial, RT_SERIAL_EVENT_RX_IND);
    }
}
