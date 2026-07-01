# Day 9 — RISC-V Assembly & Simulator Setup

Get the toolchain + Spike working, then see why the ISA matters.

| Task | Folder | What you do |
|------|--------|-------------|
| 1 | `task1_setup/` | Build & run your first bare-metal C program on Spike; read its disassembly and commit log. |
| 2 | `task2_matmul/` | Matrix multiply built two ways — `rv64i` vs `rv64im` — comparing assembly, disassembly, code size and instructions executed. |
| A1 | `assign1/` | **Your turn:** write a multiply-heavy C kernel (`assign1.c`) and compare rv64i vs rv64im. |
| A2 | `assign2/` | **Your turn:** write your own RISC-V assembly (`assign2.S`) in a ready-made test harness. |

Each folder: `cd <folder>` then `./run.sh`.

The shared files here (`link.ld`, `riscv_test.h`, `test_macros.h`, `encoding.h`)
are the Spike bare-metal environment, used by both tasks.
