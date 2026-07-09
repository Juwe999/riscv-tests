#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

    .option norvc
    .align 2

test_illegal:
    .word 0
    j fail

back:
    nop
    nop
    nop
    add t0, t1, t2

    RVTEST_PASS                  # exit 0
fail:
    RVTEST_FAIL                  # exit non-zero

.globl mtvec_handler
mtvec_handler:
 csrr t0, mcause
 csrr t0, mtval
 csrr t0, mstatus

 li   t3, (3 << 11)       # mask for MPP bits [12:11]
 csrc mstatus, t0         # clear both bits → MPP = 00 (U-mode)

 # --- Set mepc to user program entry ---
 la   t0, back      # address of user code
 csrw mepc, t0

 # --- Return to new privilege level ---
 mret
RVTEST_CODE_END

RVTEST_DATA_BEGIN

test_mem:
.dword 0xdeadbeaf
.dword 0x12345678
.dword 0xdeadbeaf
.dword 0x12345678
.dword 0xdeadbeaf
.dword 0x12345678

RVTEST_DATA_END