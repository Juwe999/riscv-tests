#!/bin/bash
# Day 9, Assignment 2: assemble your program, run it on Spike, dump the disassembly.
set -e
cd "$(dirname "$0")"

GCC=riscv64-unknown-elf-gcc
OBJDUMP=riscv64-unknown-elf-objdump
SPIKE=spike
ISA=rv64gcZicsr_Zifencei
CFLAGS="-march=rv64imafdczicsr_zifencei -mabi=lp64 -static -mcmodel=medany \
        -fvisibility=hidden -nostdlib -nostartfiles -std=gnu99 -O2 -I.. -T../link.ld"
OUT=work; ELF=$OUT/assign2.elf; mkdir -p "$OUT"

# 1. assemble your .S into a bare-metal ELF
echo ">> [1/3] assembling assign2.S"
$GCC $CFLAGS assign2.S -o "$ELF"

# 2. disassemble
echo ">> [2/3] disassembly -> $OUT/assign2.disass"
$OBJDUMP -d "$ELF" > "$OUT/assign2.disass"

# 3. run on Spike (bare metal, no pk)
echo ">> [3/3] running on spike (bare metal)"
timeout --foreground 5s $SPIKE --isa=$ISA --log-commits --log "$OUT/assign2.dump" "$ELF" && rc=0 || rc=$?

if [ "$rc" = "0" ]; then echo ">> PASS (exit 0)"; else echo ">> FAIL (exit $rc)"; fi
echo ">> disassembly: $OUT/assign2.disass   commit log: $OUT/assign2.dump"
