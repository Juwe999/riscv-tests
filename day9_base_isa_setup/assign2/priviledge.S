#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

    .option norvc
    .align 2

test_illegal:
    .word 0
    j fail

back:
    nop
    nop
    nop
    add t0, t1, t2

    RVTEST_PASS                  # exit 0
fail:
    RVTEST_FAIL                  # exit non-zero

.globl mtvec_handler
mtvec_handler:
    csrr t0, mcause
    csrr t0, mtval
    csrr t0, mstatus

    li   t1, (0x3 << 11)          # mask = 0x1800 -> bits [12:11] = MPP
    csrs mstatus, t1              # force MPP = 11 (M-mode) before returning

    la   t0, back
    csrw mepc, t0
    mret
RVTEST_CODE_END

RVTEST_DATA_BEGIN

test_mem:
.dword 0xdeadbeaf
.dword 0x12345678
.dword 0xdeadbeaf
.dword 0x12345678
.dword 0xdeadbeaf
.dword 0x12345678

RVTEST_DATA_END