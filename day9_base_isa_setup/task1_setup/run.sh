#!/bin/bash
# Day 9, Task 1: build a bare-metal C program, run it on Spike, dump the disassembly.
set -e
cd "$(dirname "$0")"

# --- tools & flags (env files live one level up) -----------------------------
GCC=riscv64-unknown-elf-gcc
OBJDUMP=riscv64-unknown-elf-objdump
SPIKE=spike
ISA=rv64gcZicsr_Zifencei
CFLAGS="-march=rv64imafdczicsr_zifencei -mabi=lp64 -static -mcmodel=medany \
        -fvisibility=hidden -nostdlib -nostartfiles -std=gnu99 -O2 -I.. -T../link.ld"
OUT=work; ELF=$OUT/sum.elf; mkdir -p "$OUT"

# 1. compile C + startup into one bare-metal ELF
echo ">> [1/3] compiling sum.c + entry.S"
$GCC $CFLAGS entry.S sum.c -o "$ELF"

# 2. disassemble so you can read the generated RISC-V instructions
echo ">> [2/3] disassembly -> $OUT/sum.disass"
$OBJDUMP -d "$ELF" > "$OUT/sum.disass"

# 3. run on Spike (bare metal, no pk); commit log -> sum.dump
echo ">> [3/3] running on spike (bare metal)"
timeout --foreground 5s $SPIKE --isa=$ISA --log-commits --log "$OUT/sum.dump" "$ELF" && rc=0 || rc=$?

# PASS => spike exits 0 (means main() returned the expected 55)
if [ "$rc" = "0" ]; then echo ">> PASS (exit 0)"; else echo ">> FAIL (exit $rc)"; fi
echo ">> disassembly: $OUT/sum.disass   commit log: $OUT/sum.dump"
