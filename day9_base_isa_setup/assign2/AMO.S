#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    la   s0, counter          # s0 = address of shared counter

    
    # Task 1: AMOADD -- atomically increment a shared counter

    li      t0, 1
    li      t1, 100

    amoadd.d t2, t0, (s0)


    bne     t2, t1, fail

    ld      t3, 0(s0)
    li      t4, 101
    bne     t3, t4, fail


    # Task 2: AMOSWAP -- atomically exchange a value

    la      s1, lockvar
    li      t0, 1

    amoswap.d.aq t1, t0, (s1)


    li      t2, 0
    bne     t1, t2, fail

    ld      t3, 0(s1)
    li      t4, 1
    bne     t3, t4, fail


    # Task 3: AMOMIN / AMOMAX -- track extremes in an "update" flow

    la      s2, extreme_min
    la      s3, extreme_max

    # Simulate 3 incoming "updates": 50, 20, 80
    li      t0, 50
    amomin.d t4, t0, (s2)
    amomax.d t5, t0, (s3)

    li      t0, 20
    amomin.d t4, t0, (s2)
    amomax.d t5, t0, (s3)

    li      t0, 80
    amomin.d t4, t0, (s2)
    amomax.d t5, t0, (s3)

    ld      t6, 0(s2)
    li      t0, 20
    bne     t6, t0, fail

    ld      t6, 0(s3)
    li      t0, 80
    bne     t6, t0, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
    .align 3
counter:
    .dword 100

lockvar:
    .dword 0

extreme_min:
    .dword 100

extreme_max:
    .dword 0
RVTEST_DATA_END