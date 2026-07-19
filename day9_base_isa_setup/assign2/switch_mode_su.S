.section .text
.globl _start
_start:
    # --- Stage 1: M -> S ---
    li      t3, (3 << 11)
    csrc    mstatus, t3        # clear MPP
    li      t4, (1 << 11)
    csrs    mstatus, t4        # MPP = 01 (S)

    la      t0, s_stage
    csrw    mepc, t0
    mret

s_stage:
    # --- Stage 2: S -> U ---
    li      t3, (1 << 8)       # SPP bit
    csrc    sstatus, t3        # clear SPP -> 0 = U-mode

    la      t0, u_stage
    csrw    sepc, t0
    sret                       # S -> U

u_stage:
    nop
    nop
    add     t0, t1, t2
loop_u2:
    j       loop_u2