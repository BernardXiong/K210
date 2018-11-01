/*
 * Copyright (c) 2006-2018, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018/09/30     Bernard      The first version
 */

#include <rtthread.h>
#include <stdio.h>

int main(void)
{
    rt_kprintf("Hello, world\n");

    return 0;
}

int libctest(void)
{
    printf("hello!!\n");
    printf("int => %d\n", 10);
    printf("float => %f\n", 1.1234);

    return 0;
}
MSH_CMD_EXPORT(libctest, libc test);
