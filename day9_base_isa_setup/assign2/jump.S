#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # ---- your code here -------------------------------------------------

    # ===== Challenge 1: even/odd check =====
even_odd:
    li      x5, 66              # value to test
    andi    x6, x5, 1           # x6 = x5 & 1  -> 0 if even, 1 if odd
    bnez    x6, fail            # if odd (x6 != 0), jump to fail

    # ===== Challenge 2: increment memory contents, store back =====
    la      x10, test_mem       # x10 = base address of test_mem
    li      x11, 20             # x11 = number of dwords (20 entries)

incr_loop:
    ld      x12, 0(x10)         # load current value
    addi    x12, x12, 1         # increment by 1
    sd      x12, 0(x10)         # store back to the same address
    addi    x10, x10, 8         # move to next dword (8 bytes each)
    addi    x11, x11, -1        # decrement counter
    bnez    x11, incr_loop      # loop until counter == 0

    # ---------------------------------------------------------------------

    RVTEST_PASS                  # exit 0
fail:
    RVTEST_FAIL                  # exit non-zero

RVTEST_CODE_END

RVTEST_DATA_BEGIN
test_mem:
.dword 0x1
.dword 0x2
.dword 0x3
.dword 0x4
.dword 0x5
.dword 0x1
.dword 0x2
.dword 0x3
.dword 0x4
.dword 0x5
.dword 0x1
.dword 0x2
.dword 0x3
.dword 0x4
.dword 0x5
.dword 0x1
.dword 0x2
.dword 0x3
.dword 0x4
.dword 0x5
RVTEST_DATA_END