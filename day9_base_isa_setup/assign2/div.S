#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # Q1: DIV / REM of -7 / 2  (signed, round toward zero)
    li   t0, -7
    li   t1, 2

    div  t2, t0, t1                 # t2 = -7 / 2
    li   t3, -3
    bne  t2, t3, fail

    rem  t4, t0, t1                 # t4 = -7 % 2
    li   t3, -1
    bne  t4, t3, fail

    # Q2: DIVU of 0xFFFFFFFFFFFFFFFF / 2  (unsigned)
    li    t0, -1                    # bit pattern 0xFFFFFFFFFFFFFFFF
    li    t1, 2
    divu  t2, t0, t1                # unsigned division

    li    t3, 0x7FFFFFFFFFFFFFFF
    bne   t2, t3, fail

    # Q3: DIV by zero -- defined behavior, NOT a trap
    li   a0, 12345                  
    div  t0, a0, zero

    li   t3, -1
    bne  t0, t3, fail
    # If this line is reached without crashing/trapping, that alone proves
    # division-by-zero did NOT raise an exception on RISC-V.

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END