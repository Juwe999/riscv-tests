.section .text
.globl _start
_start:
    # --- Save cause/val/status just so we can inspect them if needed ---
    csrr    t0, mcause
    csrr    t1, mtval
    csrr    t2, mstatus

    # --- Clear MPP [12:11], then set MPP = 01 (S-mode) ---
    li      t3, (3 << 11)
    csrrc   x0, mstatus, t3        # mstatus &= ~t3
    li      t4, (1 << 11)
    csrrs   x0, mstatus, t4        # mstatus |= t4

    # --- Set return address and go ---
    la      t0, s_entry
    csrw    mepc, t0
    mret                          # M -> S

s_entry:
    nop
    nop
    add     t0, t1, t2
loop_s:
    j       loop_s