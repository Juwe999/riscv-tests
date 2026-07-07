# Day 9, Assignment 2: write your own RISC-V assembly.
# Edit the area marked below, then run ./run.sh to build + run it on Spike.
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # ---- your code here -------------------------------------------------
    # Example: multiplication with

    #Q1 1 MUL of -1 × -1: what is the result?
    li   t0, -1
    li   t1, -1
    mul  t2, t0, t1              # your result in t2
juwe:
    # ---- self-check: PASS if t2 == expected -----------------------------
    li   t3, 0x01                   # TODO: set the value you expect
    bne  t2, t3, fail
    # ---------------------------------------------------------------------

    #Q2 MULHU of -1 x -1, treated as UNSIGNED (upper 64 bits)
    #     0xFFFFFFFFFFFFFFFF x 0xFFFFFFFFFFFFFFFF
    #     -> upper 64 bits = 0xFFFFFFFFFFFFFFFE
    # ============================================================
    mulhu t4, t0, t1              # reuse t0/t1, still -1/-1

    li    t3, 0xFFFFFFFFFFFFFFFE  # expected upper 64 bits
    bne   t4, t3, fail
    RVTEST_PASS                  # exit 0
fail:
    RVTEST_FAIL                  # exit non-zero

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END