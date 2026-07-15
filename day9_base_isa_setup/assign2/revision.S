#include "riscv_test.h"
#include "test_macros.h"

	RVTEST_RV64U
	RVTEST_CODE_BEGIN

	li t0, 30
	li t1, 30
	add t2, t0, t1

#check for test result t2

	li t3, 60
	bne t2, t3, fail

	RVTEST_PASS
fail:
	RVTEST_FAIL

	RVTEST_CODE_END
	RVTEST_DATA_BEGIN
	RVTEST_DATA_END

