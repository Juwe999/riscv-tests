#include "riscv_test.h"
#include "test_macros.h"
RVTEST_RV64U
RVTEST_CODE_BEGIN
    li   t0, 30
    li   t3, -10
    sltu t1, t3, t0

juwe:
    li   t2, 0
    bne  t1, t2, fail
    RVTEST_PASS
fail:
    RVTEST_FAIL
RVTEST_CODE_END
RVTEST_DATA_BEGIN
RVTEST_DATA_END
