#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # ============================================================
    # Part 1: 64-bit ADD overflow  (0x7FFFFFFFFFFFFFFF + 1)
    # ============================================================
    li   t0, 0x7FFFFFFFFFFFFFFF
    li   t1, 1
    add  t2, t0, t1

    li   t3, 0x8000000000000000
    bne  t2, t3, fail


    # Part 2: 32-bit ADDW overflow (0x7FFFFFFF + 1)

    li   t0, 0x7FFFFFFF              # INT32_MAX
    li   t1, 1
    addw t2, t0, t1                  # 32-bit add, sign-extended to 64

    li   t3, 0xFFFFFFFF80000000      # expected: sign-extended INT32_MIN
    bne  t2, t3, fail

    # Part 3: overflow-safe add — detect overflow using comparisons
    # Test case: a = INT64_MAX, b = 1  --> should DETECT overflo

    li   a0, 0x7FFFFFFFFFFFFFFF
    li   a1, 1

    add  t0, a0, a1

    slt  t1, a0, zero
    slt  t2, a1, zero                
    slt  t3, t0, zero

    xor  t4, t1, t2                  # 0 if a,b same sign
    xor  t5, t1, t3                  # nonzero if a,result differ in sign

    seqz t4, t4                      # 1 if a,b SAME sign
    snez t5, t5                      # 1 if a,result DIFFERENT sign
    and  t6, t4, t5                  # t6 = 1 => overflow detected

    li   t3, 1
    bne  t6, t3, fail                # expect overflow flag == 1

    # ------------------------------------------------------------
    # Sanity check: a = 5, b = 10  --> should NOT detect overflow
    # ------------------------------------------------------------
    li   a0, 5
    li   a1, 10
    add  t0, a0, a1

    slt  t1, a0, zero
    slt  t2, a1, zero
    slt  t3, t0, zero

    xor  t4, t1, t2
    xor  t5, t1, t3

    seqz t4, t4
    snez t5, t5
    and  t6, t4, t5                  # should be 0 (no overflow)

    bnez t6, fail                    # expect overflow flag == 0

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END
