#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # ============================================================
    # Q1: Convert 2.5 to integer under each rounding mode
    # ============================================================
    li      t0, 0x4004000000000000    # IEEE 754 double bit pattern for 2.5
    fmv.d.x f1, t0

    # ---- RNE: round to nearest, ties to even -> expect 2 --------------
    fcvt.w.d t1, f1, rne
    li       t2, 2
    bne      t1, t2, fail

    # ---- RTZ: truncate toward zero -> expect 2 --------------------------
    fcvt.w.d t1, f1, rtz
    li       t2, 2
    bne      t1, t2, fail

    # ---- RDN: round down toward -infinity -> expect 2 --------------------
    fcvt.w.d t1, f1, rdn
    li       t2, 2
    bne      t1, t2, fail

    # ---- RUP: round up toward +infinity -> expect 3 ------------------------
    fcvt.w.d t1, f1, rup
    li       t2, 3
    bne      t1, t2, fail

    # ============================================================
    # Q2: Confirm ties-to-even -- 3.5 should round to 4 under RNE
    # ============================================================
    li      t0, 0x400C000000000000    # IEEE 754 double bit pattern for 3.5
    fmv.d.x f2, t0

    fcvt.w.d t1, f2, rne
    li       t2, 4
    bne      t1, t2, fail

    # ============================================================
    # Q3: FDIV.D f0 = f1 / f0, where f0 = 0.0 -> DZ flag should be set
    # ============================================================
    fmv.d.x f0, zero                  # f0 = 0.0
    # f1 still holds 2.5 from before -- nonzero, good for this test

    fdiv.d  f0, f1, f0                 # f0 = 2.5 / 0.0 -> +infinity

    csrr    t3, fcsr                    # read the full fcsr (flags + rounding mode)
    andi    t3, t3, 0x8                 # isolate DZ bit (bit 3 of fflags)
    li      t4, 0x8
    bne     t3, t4, fail                 # confirm DZ flag got set

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END