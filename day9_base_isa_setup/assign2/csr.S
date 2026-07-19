#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # Read important CSRs
  csrr  t0, mstatus
  csrr  t1, mcycle
  csrr  t2, minstret

  # Temporary value
  li    t3, 0x1234

  # Read and Write CSR
  csrrw t4, mscratch, t3

  # Read and Set Bits
  csrrs t5, mscratch, t3

  # Read and Clear Bits
  csrrc t6, mscratch, t3

  # Read and Write Immediate
  csrrwi t0, mscratch, 5

  # Read and Set Immediate
  csrrsi t1, mscratch, 3

  # Read and Clear Immediate
  csrrci t2, mscratch, 1

  RVTEST_PASS

fail:
  RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
RVTEST_DATA_END