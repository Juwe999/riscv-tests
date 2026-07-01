#!/bin/bash
# Day 9, Assignment 1: build YOUR kernel two ways - rv64i vs rv64im - and compare.
set -e
cd "$(dirname "$0")"

GCC=riscv64-unknown-elf-gcc
OBJDUMP=riscv64-unknown-elf-objdump
SIZE=riscv64-unknown-elf-size
SPIKE=spike
ISA=rv64gcZicsr_Zifencei
COMMON="-mabi=lp64 -static -mcmodel=medany -fvisibility=hidden \
        -nostdlib -nostartfiles -std=gnu99 -O2 -I.. -T../link.ld"
OUT=work; mkdir -p "$OUT"

build () {                    # $1=tag  $2=march  $3=extra source (softmul for rv64i)
  local tag=$1 march=$2 extra=$3
  echo ">> [$tag] compiling assign1.c  ($march)"
  $GCC -march=$march $COMMON -S assign1.c -o "$OUT/assign1_$tag.s"
  $GCC -march=$march $COMMON entry.S assign1.c $extra -o "$OUT/assign1_$tag.elf"
  $OBJDUMP -d "$OUT/assign1_$tag.elf" > "$OUT/assign1_$tag.disass"
  echo ">> [$tag] running on spike"
  timeout --foreground 10s $SPIKE --isa=$ISA --log-commits \
      --log "$OUT/assign1_$tag.dump" "$OUT/assign1_$tag.elf" \
      && echo ">> [$tag] PASS" || echo ">> [$tag] FAIL"
}

# rv64i needs the software multiply (softmul.c); rv64im uses the hardware 'mul'.
build i   rv64izicsr_zifencei    softmul.c
build im  rv64imzicsr_zifencei   ""

# --- comparison --------------------------------------------------------------
txt_i=$($SIZE  "$OUT/assign1_i.elf"  | awk 'NR==2{print $1}')
txt_im=$($SIZE "$OUT/assign1_im.elf" | awk 'NR==2{print $1}')
ins_i=$(wc -l  < "$OUT/assign1_i.dump")
ins_im=$(wc -l < "$OUT/assign1_im.dump")
echo "----------------------------------------------------------"
printf " your kernel             %-12s %-12s\n" "rv64i" "rv64im"
printf " .text size (bytes)      %-12s %-12s\n" "$txt_i" "$txt_im"
printf " instructions executed   %-12s %-12s\n" "$ins_i" "$ins_im"
echo "----------------------------------------------------------"
echo ">> compare: $OUT/assign1_i.s /.disass  vs  $OUT/assign1_im.s /.disass"
