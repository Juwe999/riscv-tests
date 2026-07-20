#!/usr/bin/env python3
"""
Task 07 - RISC-V Opcode Repository Parser
Objective:
Read instruction definitions from the official riscv-opcodes repository
using Python file handling and display the instruction mnemonics grouped
by ISA extension.
"""
import os

REPO = os.path.expanduser("~/frontend-Juwe999/design-verif-Juwe999/riscv-opcodes/extensions")
extensions = [
    "rv_i",
    "rv64_i",
]
total = 0
print("=" * 70)
print("RISC-V OPCODE PARSER")
print("=" * 70)
for ext in extensions:
    filename = os.path.join(REPO, ext)
    if not os.path.exists(filename):
        print(f"\n[WARNING] {ext} not found.")
        continue
    instructions = []
    with open(filename, "r") as f:
        for line in f:
            line = line.strip()
            # Skip blank lines
            if not line:
                continue
            # Skip comments
            if line.startswith("#"):
                continue
            # Skip pseudo operations
            if line.startswith("$"):
                continue
            mnemonic = line.split()[0]
            instructions.append(mnemonic)
    print(f"\nExtension : {ext}")
    print("-" * 70)
    for i, inst in enumerate(instructions, start=1):
        print(f"{i:3}. {inst}")
    print(f"\nInstruction Count : {len(instructions)}")
    total += len(instructions)
print("\n" + "=" * 70)
print(f"TOTAL INSTRUCTIONS PARSED : {total}")
print("=" * 70)
