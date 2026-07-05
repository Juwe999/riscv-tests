#include "riscv_test.h"
#include "test_macros.h"
RVTEST_RV64U
RVTEST_CODE_BEGIN
    la   t0, scratch
    li   t1, 0x80000001
    sw   t1, 8(t0)
    lw   t2, 8(t0)
    li   t3, -2147483647
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
