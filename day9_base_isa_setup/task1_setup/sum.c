/* Day 9, Task 1 - first bare-metal C program on Spike.
   Computes 1+2+...+10 and returns it (expected 55).
   Freestanding: no libc, no printf. Startup is in entry.S. */

/* stack for the C code; entry.S points sp at the top of this array */
unsigned char _stack[16384] __attribute__((aligned(16)));

int sum_upto(int n) {
    int s = 0;
    for (int i = 1; i <= n; i++)
        s += i;
    return s;
}

int main(void) {
    return sum_upto(10);   /* 55 */
}
