/*
 * Copyright (c) 2006-2018, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 */

#define REGBYTES        8           /* bytes of register width  */

/*
 * rt_base_t rt_hw_interrupt_disable(void);
 */
    .globl rt_hw_interrupt_disable
rt_hw_interrupt_disable:
    csrrci a0, mstatus, 8
    ret

/*
 * void rt_hw_interrupt_enable(rt_base_t level);
 */
    .globl rt_hw_interrupt_enable
rt_hw_interrupt_enable:
    csrw mstatus, a0
    ret

/*
 * void rt_hw_context_switch_to(rt_ubase_t to)/*
 * a0 --> to
 */
    .globl rt_hw_context_switch_to
rt_hw_context_switch_to:
    ld sp, (a0)

    /* load epc from stack */
    ld a0,   0 * REGBYTES(sp)
    csrw mepc, a0
    ld x1,   1 * REGBYTES(sp)
    /* load mstatus from stack */
    ld a0,   2 * REGBYTES(sp)
    csrw mstatus, a0
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

    addi sp,  sp, 32 * REGBYTES
    mret

/*
 * void rt_hw_context_switch(rt_ubase_t from, rt_ubase_t to)
 * a0 --> from
 * a1 --> to
 */
    .globl rt_hw_context_switch
rt_hw_context_switch:

    /* saved from thread context
     *     x1/ra       -> sp(0)
     *     x1/ra       -> sp(1)
     *     mstatus.mie -> sp(2)
     *     x(i)        -> sp(i-4)
     */
    addi  sp,  sp, -32 * REGBYTES
    sd sp,  (a0)

    sd x1,   0 * REGBYTES(sp)
    sd x1,   1 * REGBYTES(sp)

    csrr a0, mstatus
    andi a0, a0, 8
    beqz a0, save_mpie
    li   a0, 0x80
save_mpie:
    sd a0,   2 * REGBYTES(sp)

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

    /* restore to thread context
     * sp(0) -> epc;
     * sp(1) -> ra;
     * sp(i) -> x(i+2)
     */
    ld sp,  (a1)

    /* resw ra to mepc */
    ld a1,   0 * REGBYTES(sp)
    csrw mepc, a1
    ld x1,   1 * REGBYTES(sp)

    /* force to machin mode(MPP=11) */
    li a1, 0x00001800;
    csrs mstatus, a1
    ld a1,   2 * REGBYTES(sp)
    csrs mstatus, a1

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

    addi sp,  sp, 32 * REGBYTES
    mret
