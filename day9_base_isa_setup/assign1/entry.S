# Day 9, Assignment 1: startup for your C experiment.
# Convention: main() returns 0 on success (PASS), non-zero on failure (FAIL).
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    la   sp, _stack          # give C a stack (grows down from the top)
    li   t0, 16384
    add  sp, sp, t0
    call main                # your C code; return 0 to PASS
    bnez a0, fail            # non-zero return -> fail
    RVTEST_PASS
fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END
