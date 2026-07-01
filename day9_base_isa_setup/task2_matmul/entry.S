# Day 9, Task 2: bare-metal startup for the matrix-multiply program.
# Same environment as Task 1; only the expected result differs (checksum = 512).
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    la   sp, _stack          # give C a stack (grows down from the top)
    li   t0, 16384
    add  sp, sp, t0
    call main                # run matmul; checksum comes back in a0
    li   t0, 512             # expected checksum
    bne  a0, t0, fail
    RVTEST_PASS              # correct -> Spike PASS (exit 0)
fail:
    RVTEST_FAIL              # -> Spike exits non-zero

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END
