#include "riscv_test.h"
#include "test_macros.h"



    # Q1: Confirm bit pattern of 1.0 as a double

    li    t0, 0x3FF0000000000000
    fmv.d.x f1, t0
    fmv.x.d t1, f1
    bne   t0, t1, fail


    # Q2: FADD.D f0 = f1 + f2, where f1=1.0, f2=2.0 -> expect 3.0

    li     t0, 0x3FF0000000000000
    fmv.d.x f1, t0

    li     t0, 0x4000000000000000
    fmv.d.x f2, t0

    fadd.d f0, f1, f2

    fmv.x.d t2, f0
    li     t3, 0x4008000000000000
    bne    t2, t3, fail

    # Q3: FDIV.D by zero -- expect +infinity, no trap, DZ flag set
    li      t0, 0x3FF0000000000000    # 1.0
    fmv.d.x f1, t0

    fmv.d.x f2, zero

    fdiv.d  f0, f1, f2

    fmv.x.d t2, f0
    li      t3, 0x7FF0000000000000
    bne     t2, t3, fail

    frcsr   t4
    andi    t4, t4, 0x8
    li      t5, 0x8
    bne     t4, t5, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END