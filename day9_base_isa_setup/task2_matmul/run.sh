#!/bin/bash
# Day 9, Task 2: matrix multiply built two ways - rv64i (no M) vs rv64im (M ext).
# Shows the difference in assembly, disassembly, code size and instructions run.
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
  echo ">> [$tag] compiling matmul.c  ($march)"
  $GCC -march=$march $COMMON -S matmul.c -o "$OUT/matmul_$tag.s"             # compiler assembly
  $GCC -march=$march $COMMON entry.S matmul.c $extra -o "$OUT/matmul_$tag.elf"
  $OBJDUMP -d "$OUT/matmul_$tag.elf" > "$OUT/matmul_$tag.disass"             # disassembly
  echo ">> [$tag] running on spike"
  timeout --foreground 10s $SPIKE --isa=$ISA --log-commits \
      --log "$OUT/matmul_$tag.dump" "$OUT/matmul_$tag.elf" \
      && echo ">> [$tag] PASS" || echo ">> [$tag] FAIL"
}

# rv64i needs the software multiply (softmul.c); rv64im uses the hardware 'mul'.
build i   rv64izicsr_zifencei    softmul.c
build im  rv64imzicsr_zifencei   ""

# --- comparison --------------------------------------------------------------
txt_i=$($SIZE  "$OUT/matmul_i.elf"  | awk 'NR==2{print $1}')
txt_im=$($SIZE "$OUT/matmul_im.elf" | awk 'NR==2{print $1}')
ins_i=$(wc -l  < "$OUT/matmul_i.dump")
ins_im=$(wc -l < "$OUT/matmul_im.dump")
echo "----------------------------------------------------------"
printf " matmul 8x8              %-12s %-12s\n" "rv64i" "rv64im"
printf " .text size (bytes)      %-12s %-12s\n" "$txt_i" "$txt_im"
printf " instructions executed   %-12s %-12s\n" "$ins_i" "$ins_im"
echo "----------------------------------------------------------"
echo ">> assembly:    $OUT/matmul_i.s      vs  $OUT/matmul_im.s"
echo ">> disassembly: $OUT/matmul_i.disass vs  $OUT/matmul_im.disass"
echo ">> tip: in the inner loop rv64i does 'call __mulsi3', rv64im does one 'mul'."
