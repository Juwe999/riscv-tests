#include "riscv_test.h"
#include "test_macros.h"
RVTEST_RV64U
RVTEST_CODE_BEGIN
    li   t0, 20
    li   t4, 0xF
    and  t1, t0, t4
    li   t2, 4
    bne  t1, t2, fail
    RVTEST_PASS
fail:
    RVTEST_FAIL
RVTEST_CODE_END
RVTEST_DATA_BEGIN
RVTEST_DATA_END
