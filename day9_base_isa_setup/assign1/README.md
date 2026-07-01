# Day 9, Assignment 1 — your own M-extension experiment

Write a multiply-heavy kernel in `assign1.c`, then build it **both** ways and see
what the **M** extension buys you (same idea as Task 2, but your code).

## Do
1. Implement `compute()` in `assign1.c` — a dot product, factorial, small matmul, …
2. Set `expected` in `main()` so it self-checks (`main` returns 0 = PASS).
3. `./run.sh` — builds rv64i vs rv64im, runs both, prints a comparison, and writes
   `work/assign1_<v>.s`, `.disass`, `.dump`.

## Compare
- Inner loop: rv64i → `call __mulsi3` (software, from `softmul.c`); rv64im → `mul`.
- `.text` size and instructions executed (printed).
