# Day 9, Task 1: bare-metal startup that runs a C main() on Spike.
# Reuses the riscv-tests environment (../riscv_test.h): _start, trap vector, PASS/FAIL.
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    la   sp, _stack          # give C a stack (grows down from the top)
    li   t0, 16384
    add  sp, sp, t0
    call main                # run the C program; result comes back in a0
    li   t0, 55              # expected result of sum(1..10)
    bne  a0, t0, fail        # wrong value -> fail
    RVTEST_PASS              # correct -> tell Spike PASS (exit 0)
fail:
    RVTEST_FAIL              # -> Spike exits non-zero

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END
