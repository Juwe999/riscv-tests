#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # ---------------------------------------------------------
  # Step 1: mstatus.MIE = 1  (global interrupt enable)
  # ---------------------------------------------------------

  li    t2, (1 << 3)
  csrs  mstatus, t2

  li    t1, (1 << 3)
  csrw  mie, t1



  # ---------------------------------------------------------
  # Step 4: Store 1 to msip address -> triggers the interrupt
  # ---------------------------------------------------------
  la    t3, 0x2000000
  li    t4, 1
  sb    t4, 0(t3)

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


back:
  # ---------------------------------------------------------
  # Step 6: Check the handler actually ran
  # ---------------------------------------------------------
  li    x6, 1


  RVTEST_PASS

  # ===========================================================
  # Trap handler
  # ===========================================================


fail:
  RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
TEST_DATA
RVTEST_DATA_END