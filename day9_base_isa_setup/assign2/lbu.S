#include "riscv_test.h"
#include "test_macros.h"
RVTEST_RV64U
RVTEST_CODE_BEGIN
    la   t0, scratch
    li   t1, 0xAB
    sb   t1, 0(t0)
    lbu  t2, 0(t0)
    li   t3, 171
    bne  t2, t3, fail
    RVTEST_PASS
fail:
    RVTEST_FAIL
RVTEST_CODE_END
RVTEST_DATA_BEGIN
    .align 3
scratch:
    .fill 32, 1, 0
RVTEST_DATA_END
