/* Day 9 - Assignment 1: your own M-extension experiment.
   Write a multiply-heavy kernel below, then run ./run.sh to build it both
   rv64i and rv64im and compare assembly / disassembly / size / instructions.

   Convention: main() returns 0 on success, non-zero on failure. */

/* stack for the C code; entry.S points sp at the top of this array */
unsigned char _stack[16384] __attribute__((aligned(16)));

/* TODO: implement a kernel that does lots of integer multiplies
   (e.g. dot product, factorial, polynomial eval, a small matrix multiply). */
static int compute(void) {
    int result = 0;
    /* TODO: your code here */
    return result;
}

int main(void) {
    int r = compute();
    int expected = 0;              /* TODO: set the value you expect */
    return (r == expected) ? 0 : 1;   /* 0 = PASS */
}
