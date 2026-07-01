/* Software multiply, linked only into the rv64i build (no M extension).
   Without 'mul', the compiler turns each  a * b  into a call to these
   routines. rv64im does not use them - it emits a single 'mul' instruction.

   Shift-and-add; the low bits are correct for signed two's-complement too. */

int __mulsi3(int a, int b) {
    unsigned int x = a, y = b, r = 0;
    while (y) { if (y & 1) r += x; x <<= 1; y >>= 1; }
    return (int)r;
}

long __muldi3(long a, long b) {
    unsigned long x = a, y = b, r = 0;
    while (y) { if (y & 1) r += x; x <<= 1; y >>= 1; }
    return (long)r;
}
