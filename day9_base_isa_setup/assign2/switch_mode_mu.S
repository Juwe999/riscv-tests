.section .text
.globl _start
_start:
    csrr    t0, mcause
    csrr    t1, mtval
    csrr    t2, mstatus

    # Clear MPP [12:11] -> 00 = U-mode
    li      t3, (3 << 11)
    csrc    mstatus, t3

    la      t0, u_entry
    csrw    mepc, t0
    mret                      # M -> U

u_entry:
    nop
    nop
    add     t0, t1, t2
loop_u:
    j       loop_u