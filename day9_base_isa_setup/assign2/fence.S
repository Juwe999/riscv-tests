#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN


    # Task 1: FENCE to order stores and loads

    la    s0, data_flag
    la    s1, ready_flag

    li    t0, 42
    sd    t0, 0(s0)

    fence rw, rw


    li    t1, 1
    sd    t1, 0(s1)


    ld    t2, 0(s0)
    li    t3, 42
    bne   t2, t3, fail

    ld    t2, 0(s1)
    li    t3, 1
    bne   t2, t3, fail


    # Task 2 & 3: FENCE.I before jumping to newly written code

    la     s2, code_slot           # address of a small patch of instruction memory



    li     t0, 0x00700513
    sw     t0, 0(s2)

    li     t0, 0x00008067
    sw     t0, 4(s2)

    fence.i


    jalr   ra, s2, 0

    li     t4, 7
    bne    a0, t4, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
    .align 3
data_flag:
    .dword 0

ready_flag:
    .dword 0

    .align 3
code_slot:
    .space 16                       # room for our self-modified instructions
RVTEST_DATA_END