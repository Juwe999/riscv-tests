# Day 9, Assignment 2: write your own RISC-V assembly.
# Edit the area marked below, then run ./run.sh to build + run it on Spike.
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # ---- your code here -------------------------------------------------
    # SLTIU same with SLTI but not unsigned integers which only applicabl +ve value


    li   t0, 23
    sltiu  t1, t0, 300              # your result in t2

    # ---- self-check: PASS if t2 == expected -----------------------------
    li   t2, 1                   # TODO: set the value you expect
    bne  t1, t2, fail
    # ---------------------------------------------------------------------

    RVTEST_PASS                  # exit 0
fail:
    RVTEST_FAIL                  # exit non-zero

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END
