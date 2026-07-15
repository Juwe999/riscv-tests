#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # ---------------------------------------------------------
  # Step 1: Set mtvec to point to our trap handler
  # ---------------------------------------------------------
  la    t6, trap_handler
  csrw  mtvec, t6

  # ---------------------------------------------------------
  # Step 2: mie.MSIE = 1  (enable software interrupt source)
  # Bit 3 = MSIE (Machine Software Interrupt Enable)
  # ---------------------------------------------------------
  li    t1, (1 << 3)
  csrw  mie, t1

  # ---------------------------------------------------------
  # Step 3: mstatus.MIE = 1  (global interrupt enable)
  # Bit 3 = MIE in mstatus. csrs = set bits only (OR)
  # ---------------------------------------------------------
  li    t2, (1 << 3)
  csrs  mstatus, t2

  # ---------------------------------------------------------
  # Step 4: Store 1 to msip address -> triggers the interrupt
  # ---------------------------------------------------------
  li    t3, 0x2000000
  li    t4, 1
  sw    t4, 0(t3)

  # ---------------------------------------------------------
  # Step 5: 10-15 nops (gives the core cycles to take the trap
  # before falling through to "back:")
  # ---------------------------------------------------------
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

back:
  # ---------------------------------------------------------
  # Step 6: Check the handler actually ran
  # ---------------------------------------------------------
  li    x6, 1
  bne   x5, x6, fail

  RVTEST_PASS

  # ===========================================================
  # Trap handler
  # ===========================================================
trap_handler:
  csrr  x7, mcause             # read cause
  csrr  x8, mepc                # read return address

  li    x5, 1                   # prove handler ran

  # clear the software interrupt so it doesn't fire again
  li    t3, 0x2000000
  sw    x0, 0(t3)

  mret

fail:
  RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
TEST_DATA
RVTEST_DATA_END