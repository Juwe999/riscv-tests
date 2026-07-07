#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    la    s0, counter          # s0 = address of shared counter (starts at 100)

    # ============================================================
    # Atomic increment via LR.D / SC.D retry loop
    # ============================================================
retry:
    lr.d   t0, (s0)              # load-reserved: t0 = current value, reservation set
    addi   t0, t0, 1             # compute new value = old + 1
    sc.d   t1, t0, (s0)           # store-conditional: try to write t0 back
    bnez   t1, retry              # t1 != 0 means it FAILED -- retry the whole thing

    # At this point, the increment succeeded exactly once.
    ld     t2, 0(s0)                # re-read memory to confirm final value
    li     t3, 101                   # expected: 100 + 1 = 101
    bne    t2, t3, fail

    # ============================================================
    # Demonstrate reservation breaking: LR.D, then an unrelated STORE
    # to the SAME address from "outside" the pair, then SC.D should FAIL
    # ============================================================
    lr.d   t0, (s0)                 # reservation set on s0 (value = 101)
    addi   t0, t0, 1                 # t0 = 102 (intended new value)

    li     t4, 999                    # simulate another "core" writing to s0
    sd     t4, 0(s0)                   # this store breaks the reservation

    sc.d   t1, t0, (s0)                 # this SHOULD fail since reservation broke
    li     t5, 0
    beq    t1, t5, fail                  # if t1 == 0, SC incorrectly "succeeded" -- fail the test

    # Confirm memory still holds 999 (our SC.D did NOT overwrite it)
    ld     t2, 0(s0)
    bne    t2, t4, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
    .align 3
counter:
    .dword 100
RVTEST_DATA_END