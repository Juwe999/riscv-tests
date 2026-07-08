#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN
.option norvc
.align 2
li TESTNUM, 2

la t0, mtvec_handler
csrw mtvec, t0

illegal_test:
    .word 0

back:

    RVTEST_PASS              # correct -> tell Spike PASS (exit 0)
fail:
    RVTEST_FAIL              # -> Spike exits non-zero

.align 8
.global mtvec_handler
 #read the mcause
    csrr t1, mcause
    li t2, 2
    mret

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END