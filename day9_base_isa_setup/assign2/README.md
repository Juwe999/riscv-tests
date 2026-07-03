# Day 9, Assignment 2 — write your own assembly

Blank RISC-V assembly tests you can edit freely. Each test is its own `<name>.S`
file, run and inspected independently.

## Do
1. Write your instructions in a `<name>.S` file (e.g. `assign2.S`, `compute.S`),
   following the pattern in `assign2.S` (marked area).
2. Set the expected value for the self-check.
3. `./run.sh <name>` — assembles `<name>.S`, runs it on Spike, and writes
   `work/<name>/<name>.elf`, `work/<name>/<name>.disass`, and
   `work/<name>/<name>.dump`. **PASS = exit 0.**

   Example: `./run.sh assign2` or `./run.sh compute`.
4. `./run.sh clean` — deletes everything under `work/`.

Uses the same bare-metal environment as the other tasks (`../riscv_test.h`, `../link.ld`).
