/* Day 9, Task 2 - 8x8 integer matrix multiply.
   Multiplies two 8x8 matrices and returns a checksum of the result.
   Purpose: compare rv64i (no hardware multiply) vs rv64im (M extension).

   A[i][j] = i+j+1,  B = identity  =>  C = A,  checksum(C) = 512. */

#define N 8

/* stack for the C code; entry.S points sp at the top of this array */
unsigned char _stack[16384] __attribute__((aligned(16)));

static int A[N][N], B[N][N], C[N][N];
volatile int seed = 1;          /* volatile: stops the compiler pre-computing the result */

int main(void) {
    int s = seed;               /* = 1, but unknown to the compiler */

    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) {
            A[i][j] = i + j + s;            /* i+j+1 */
            B[i][j] = (i == j) ? s : 0;     /* identity matrix */
        }

    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) {
            int acc = 0;
            for (int k = 0; k < N; k++)
                acc += A[i][k] * B[k][j];   /* <-- the multiply we care about */
            C[i][j] = acc;
        }

    int checksum = 0;
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            checksum += C[i][j];

    return checksum;            /* expected 512 */
}
