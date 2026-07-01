# Day 9, Task 1 — Setup & first bare-metal C program

Confirm your toolchain and Spike work by building and running a small
**bare-metal C program**, then reading the RISC-V code and trace it produces.

## Run
```bash
./run.sh
```
Compiles `sum.c` (+ `entry.S`), runs it on Spike (bare metal — no `pk`), and writes:
- `work/sum.disass` — the RISC-V instructions the compiler generated
- `work/sum.dump` — Spike commit log (every instruction executed)

`sum.c` computes 1+2+…+10. The run **PASSes** (exit 0) only if the result is 55.

## Look at
- `work/sum.disass` — find `main` and `sum_upto`; spot the loop and the call.
- `work/sum.dump` — follow the instructions Spike actually executed.

## Files
| File | Purpose |
|------|---------|
| `sum.c` | the C program |
| `entry.S` | minimal startup: sets the stack, calls `main`, signals PASS/FAIL |
| `run.sh` | compile → disassemble → run on Spike |
