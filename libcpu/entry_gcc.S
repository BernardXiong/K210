/*
 * Copyright (c) 2006-2018, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018/10/02     Bernard      The first version
 */

#define REGBYTES        8           /* bytes of register width  */
#define __STACKSIZE__   4096        /* system stack size        */

  .section      .text.entry
  .align 2
  .global trap_entry
trap_entry:

    // save all from thread context
    addi sp, sp, -32 * REGBYTES

    sd x1,   1 * REGBYTES(sp)
    li t0,   0x80
    sd t0,   2 * REGBYTES(sp)

    sd x4,   4 * REGBYTES(sp)
    sd x5,   5 * REGBYTES(sp)
    sd x6,   6 * REGBYTES(sp)
    sd x7,   7 * REGBYTES(sp)
    sd x8,   8 * REGBYTES(sp)
    sd x9,   9 * REGBYTES(sp)
    sd x10, 10 * REGBYTES(sp)
    sd x11, 11 * REGBYTES(sp)
    sd x12, 12 * REGBYTES(sp)
    sd x13, 13 * REGBYTES(sp)
    sd x14, 14 * REGBYTES(sp)
    sd x15, 15 * REGBYTES(sp)
    sd x16, 16 * REGBYTES(sp)
    sd x17, 17 * REGBYTES(sp)
    sd x18, 18 * REGBYTES(sp)
    sd x19, 19 * REGBYTES(sp)
    sd x20, 20 * REGBYTES(sp)
    sd x21, 21 * REGBYTES(sp)
    sd x22, 22 * REGBYTES(sp)
    sd x23, 23 * REGBYTES(sp)
    sd x24, 24 * REGBYTES(sp)
    sd x25, 25 * REGBYTES(sp)
    sd x26, 26 * REGBYTES(sp)
    sd x27, 27 * REGBYTES(sp)
    sd x28, 28 * REGBYTES(sp)
    sd x29, 29 * REGBYTES(sp)
    sd x30, 30 * REGBYTES(sp)
    sd x31, 31 * REGBYTES(sp)

    // switch to interrupt stack
    move s0, sp

    /* get cpu id */
    csrr t0, mhartid

    /* switch interrupt stack of current cpu */
    la   sp, __stack_start__
    addi t1, t0, 1
    li   t2, __STACKSIZE__
    mul  t1, t1, t2
    add  sp, sp, t1 /* sp = (cpuid + 1) * __STACKSIZE__ + __stack_start__ */

    // interrupt handle
    call rt_interrupt_enter
    csrr a0, mcause
    csrr a1, mepc
    mv   a2, sp
    call handle_trap
    call rt_interrupt_leave

    // switch to from thread stack
    move sp, s0

    /* need to switch new thread */
    la   s0, rt_thread_switch_interrupt_flag
    ld   s2, 0(s0)
    beqz s2, spurious_interrupt
    sd   zero, 0(s0)

    csrr a0, mepc
    sd   a0, 0 * REGBYTES(sp)

    la   s0, rt_interrupt_from_thread
    ld   s1, 0(s0)
    sd   sp, 0(s1)

    la   s0, rt_interrupt_to_thread
    ld   s1, 0(s0)
    ld   sp, 0(s1)

    ld  a0,  0 * REGBYTES(sp)
    csrw mepc, a0

spurious_interrupt:
    ld x1,   1 * REGBYTES(sp)

    // Remain in M-mode after mret
    li t0, 0x00001800
    csrs mstatus, t0
    ld t0,   2 * REGBYTES(sp)
    csrs mstatus, t0 

    ld x4,   4 * REGBYTES(sp)
    ld x5,   5 * REGBYTES(sp)
    ld x6,   6 * REGBYTES(sp)
    ld x7,   7 * REGBYTES(sp)
    ld x8,   8 * REGBYTES(sp)
    ld x9,   9 * REGBYTES(sp)
    ld x10, 10 * REGBYTES(sp)
    ld x11, 11 * REGBYTES(sp)
    ld x12, 12 * REGBYTES(sp)
    ld x13, 13 * REGBYTES(sp)
    ld x14, 14 * REGBYTES(sp)
    ld x15, 15 * REGBYTES(sp)
    ld x16, 16 * REGBYTES(sp)
    ld x17, 17 * REGBYTES(sp)
    ld x18, 18 * REGBYTES(sp)
    ld x19, 19 * REGBYTES(sp)
    ld x20, 20 * REGBYTES(sp)
    ld x21, 21 * REGBYTES(sp)
    ld x22, 22 * REGBYTES(sp)
    ld x23, 23 * REGBYTES(sp)
    ld x24, 24 * REGBYTES(sp)
    ld x25, 25 * REGBYTES(sp)
    ld x26, 26 * REGBYTES(sp)
    ld x27, 27 * REGBYTES(sp)
    ld x28, 28 * REGBYTES(sp)
    ld x29, 29 * REGBYTES(sp)
    ld x30, 30 * REGBYTES(sp)
    ld x31, 31 * REGBYTES(sp)

    addi sp, sp, 32 * REGBYTES
    mret

.weak handle_trap
handle_trap:
1:
    j 1b
