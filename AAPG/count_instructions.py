import re
import sys

f2 = open("Output10.txt", "w")
from collections import Counter

def count_instructions(filepath):
    counts = Counter()
    total = 0

    with open(filepath, 'r') as f:
        for line in f:
            match = re.match(r'^i[0-9a-fA-F]+:\s+(\S+)', line)
            if match:
                instr = match.group(1)
                counts[instr] += 1
                total += 1

    return counts, total

if len(sys.argv) < 2:
    print("Usage: python3 count_instructions.py <path_to_S_file>\n")
    sys.exit(1)

filepath = sys.argv[1]
counts, total = count_instructions(filepath)

with open("Output10.txt", "w") as f2:
    f2.write(f"Total instructions: {total}\n")
    f2.write(f"{'Instruction':<10} {'Count':<6} {'Percentage'}\n")
    f2.write("-" * 30)
    for instr, count in counts.most_common():
        pct = (count / total) * 100
        f2.write(f"{instr:<10} {count:<6} {pct:.1f}%\n")
