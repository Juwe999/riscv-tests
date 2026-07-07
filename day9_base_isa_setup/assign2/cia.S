     #Q1. What registers can C.ADD encode?
     #C.ADD uses the CR format, which has full 5-bit register fields — so it can encode any of the 32 registers (x0–x31),
	 with the restriction that rs2 ≠ x0 (that encoding is reserved for other meanings like c.jalr/c.ebreak).
	 This is different from instructions like C.LW/C.SW/C.SUB which use CL/CS/CA formats with only
	 3-bit register fields, restricting them to the 8 "common" registers x8–x15 (s0–s1, a0–a5).

     #Q2. Range of immediate for C.LI rd, imm?
     #C.LI uses a 6-bit signed immediate, giving a range of -32 to +31.

     #Q3. Why can't ALL instructions be compressed?

	 #Register fields — addressing all 32 registers needs 5 bits per field; most compressed formats
	 only have room for 3-bit fields (8 registers), so instructions needing arbitrary registers can't compress.
	 Immediate range — full instructions support wider immediates (e.g. 12-bit for addi); compressed
	 forms only fit much smaller immediates (e.g. C.LI's 6 bits), so anything needing a large constant can't compress.

	 Q4. Average code size reduction from the C extension?
	 Typically 25–30% for real-world compiled workloads — because a large share of real
	 programs consists of small, common operations (stack loads/stores, small constants, simple
	 moves/branches) that fit the compressed formats well.