# Day 9, Task 2 — rv64i vs rv64im (why the M extension matters)

Builds the **same** 8×8 integer matrix multiply two ways and compares them:

- **rv64i** — base integer ISA, *no* hardware multiply. Each `a*b` becomes a call
  to a software routine `__mulsi3` (provided in `softmul.c`).
- **rv64im** — adds the **M** extension, so `a*b` is a single `mul` instruction.

## Run
```bash
./run.sh
```
Prints a comparison table and writes, for each variant (`i`, `im`):
- `work/matmul_<v>.s` — compiler assembly
- `work/matmul_<v>.disass` — disassembly
- `work/matmul_<v>.dump` — Spike commit log

## What to compare
- **Assembly / disassembly** — the inner loop: `rv64i` does `call __mulsi3`;
  `rv64im` does a single `mul`.
- **Code size** — `.text` bytes (printed): rv64im is smaller (no software routine).
- **Performance** — instructions executed (commit-log lines): rv64im runs far fewer.

Both variants compute the same result (checksum 512) and PASS.

## Files
| File | Purpose |
|------|---------|
| `matmul.c` | the matrix-multiply program |
| `softmul.c` | `__mulsi3` / `__muldi3` — software multiply for the rv64i build |
| `entry.S` | startup: sets the stack, calls `main`, checks checksum == 512 |
| `run.sh` | builds both variants, runs them, prints the comparison |
