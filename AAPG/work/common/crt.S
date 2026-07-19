#include "encoding.h"

#if __riscv_xlen == 64
  # define LREG ld
  # define LREGU lwu
  # define SREG sd
  # define REGBYTES 8
  # define FMV fmv.d.x
#else
  # define LREG lw
  # define SREG sw
  # define LREGU lw
  # define REGBYTES 4
  # define FMV fmv.w.x
#endif

  .section ".text.init"
  .globl _start
_start:
  la sp, begin_signature
  LREG  x1, 0*REGBYTES(sp)
  LREG  x3, 1*REGBYTES(sp)
  LREG  x4, 2*REGBYTES(sp)
  LREG  x5, 3*REGBYTES(sp)
  LREG  x6, 4*REGBYTES(sp)
  LREG  x7, 5*REGBYTES(sp)
  LREG  x8, 6*REGBYTES(sp)
  LREG  x9, 7*REGBYTES(sp)
  LREG  x10,8*REGBYTES(sp)
  LREG  x11,9*REGBYTES(sp)
  LREG  x12,10*REGBYTES(sp)
  LREG  x13,11*REGBYTES(sp)
  LREG  x14,12*REGBYTES(sp)
  LREG  x15,13*REGBYTES(sp)
  LREG  x16,14*REGBYTES(sp)
  LREG  x17,15*REGBYTES(sp)
  LREG  x18,16*REGBYTES(sp)
  LREG  x19,17*REGBYTES(sp)
  LREG  x20,18*REGBYTES(sp)
  LREG  x21,19*REGBYTES(sp)
  LREG  x22,20*REGBYTES(sp)
  LREG  x23,21*REGBYTES(sp)
  LREG  x24,22*REGBYTES(sp)
  LREG  x25,23*REGBYTES(sp)
  LREG  x26,24*REGBYTES(sp)
  LREG  x27,25*REGBYTES(sp)
  LREG  x28,26*REGBYTES(sp)
  LREG  x29,27*REGBYTES(sp)
  LREG  x30,28*REGBYTES(sp)
  LREG  x31,29*REGBYTES(sp)

  # enable FPU and accelerator if present
  li t0, MSTATUS_FS | MSTATUS_XS
  csrs mstatus, t0

  # make sure XLEN agrees with compilation choice
  li t0, 1
  slli t0, t0, 31
#if __riscv_xlen == 64
  bgez t0, 1f
#else
  bltz t0, 1f
#endif
2:
  li a0, 1
  sw a0, tohost, t0
  j 2b
1:

#ifdef __riscv_flen
  # initialize FPU if we have one
  la t0, 1f
  csrw mtvec, t0

  fssr    x0
  FMV  f0, x1
  FMV  f1, x1
  FMV  f2, x2
  FMV  f3, x3
  FMV  f4, x4
  FMV  f5, x5
  FMV  f6, x6
  FMV  f7, x7
  FMV  f8, x8
  FMV  f9, x9
  FMV  f10, x10
  FMV  f11, x11
  FMV  f12, x12
  FMV  f13, x13
  FMV  f14, x14
  FMV  f15, x15
  FMV  f16, x16
  FMV  f17, x17
  FMV  f18, x18
  FMV  f19, x19
  FMV  f20, x20
  FMV  f21, x21
  FMV  f22, x22
  FMV  f23, x23
  FMV  f24, x24
  FMV  f25, x25
  FMV  f26, x26
  FMV  f27, x27
  FMV  f28, x28
  FMV  f29, x29
  FMV  f30, x30
  FMV  f31, x31
  .align 4
1:
#endif

  # initialize trap vector
  la t0, trap_entry
  csrw mtvec, t0

  la  tp, _end + 63
  and tp, tp, -64

  # get core id
  csrr a0, mhartid
  # for now, assume only 1 core
  li a1, 1
1:bgeu a0, a1, 1b

  # give each core 128KB of stack + TLS
#define STKSHIFT 17
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  add sp, a0, 1
  sll sp, sp, STKSHIFT
  add sp, sp, tp

  j main

  .align 2
trap_entry:
  addi sp, sp, -272

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause                 # copy the mcause to register a0.
  csrr a1, mepc                   # copy the mepc to register a1.
  lhu  a2, 0(a1)                  # load instruction into reg a1.

  # check the lower 2 bits to see if the instruction is 32-bit or 16-bit.
  andi a2, a2, 0x3;
  li t0, 0x3
  bne a2,t0,inst16

  inst32:                           # is 32-bit instruction then increment by 4
  addi a1,a1,0x4
  beqz x0,1f

inst16:
  addi a1,a1,0x2                  # is 16-bit instruction then increment by 2

1: 
  csrw mepc, a1                   # point mepc to the next instruction.

  # use mcause to update the number of exceptions encountered in the program.

  # Remain in M-mode after eret
  li t0, MSTATUS_MPP
  csrs mstatus, t0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 272
  mret

.section ".tdata.begin"
.globl _tdata_begin
_tdata_begin:

.section ".tdata.end"
.globl _tdata_end
_tdata_end:

.section ".tbss.end"
.globl _tbss_end
_tbss_end:

.section ".tohost","aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0

# Exception generation numbers
.align 4
.globl ecause_num
ecause_num:
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0

# Read only data
.section ".rodata"
.globl rodata
rodata:
    	.dword 0x5b707269762d6d6f
	.dword 0x64655d0a6d6f6465
	.dword 0x203d206d0a5b6765
	.dword 0x6e6572616c5d0a74
	.dword 0x6f74616c5f696e73
	.dword 0x7472756374696f6e
	.dword 0x73203d2031303030
	.dword 0x30300a726567735f
	.dword 0x6e6f745f75736520
	.dword 0x3d2078312c78320a
	.dword 0x637573746f6d5f74
	.dword 0x7261705f68616e64
	.dword 0x6c6572203d205472
	.dword 0x75650a636f64655f
	.dword 0x73746172745f6164
	.dword 0x6472657373203d20
	.dword 0x3231343734383336
	.dword 0x34380a6465666175
	.dword 0x6c745f70726f6772
	.dword 0x616d5f6578697420
	.dword 0x3d20547275650a64
	.dword 0x656c65676174696f
	.dword 0x6e203d2034303935
	.dword 0x0a5b6973612d696e
	.dword 0x737472756374696f
	.dword 0x6e2d646973747269
	.dword 0x627574696f6e5d0a
	.dword 0x72656c5f73797320
	.dword 0x3d20300a72656c5f
	.dword 0x7379732e63737220
	.dword 0x3d20300a72656c5f
	.dword 0x72763332692e6374
	.dword 0x726c203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e636f6d70757465
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e64
	.dword 0x617461203d20300a
	.dword 0x72656c5f72763332
	.dword 0x692e66656e636520
	.dword 0x3d20300a72656c5f
	.dword 0x72763634692e636f
	.dword 0x6d70757465203d20
	.dword 0x300a72656c5f7276
	.dword 0x3634692e64617461
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e7a
	.dword 0x6261203d20300a72
	.dword 0x656c5f7276363469
	.dword 0x2e7a6261203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32692e7a6262203d
	.dword 0x20300a72656c5f72
	.dword 0x763634692e7a6262
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e7a
	.dword 0x6263203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e7a6273203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32692e7a6265203d
	.dword 0x20300a72656c5f72
	.dword 0x763634692e7a6265
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e7a
	.dword 0x6266203d20300a72
	.dword 0x656c5f7276363469
	.dword 0x2e7a6266203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34692e7a626d203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e7a6270
	.dword 0x203d20300a72656c
	.dword 0x5f72763634692e7a
	.dword 0x6270203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e7a6272203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34692e7a6272203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e7a6274
	.dword 0x203d20300a72656c
	.dword 0x5f72763634692e7a
	.dword 0x6274203d20300a72
	.dword 0x656c5f727633326d
	.dword 0x203d20300a72656c
	.dword 0x5f727636346d203d
	.dword 0x20300a72656c5f72
	.dword 0x76333261203d2031
	.dword 0x350a72656c5f7276
	.dword 0x363461203d203135
	.dword 0x0a72656c5f727633
	.dword 0x3266203d20300a72
	.dword 0x656c5f7276363466
	.dword 0x203d20300a72656c
	.dword 0x5f7276333264203d
	.dword 0x20300a72656c5f72
	.dword 0x76363464203d2030
	.dword 0x0a72656c5f727663
	.dword 0x2e6374726c203d20
	.dword 0x300a72656c5f7276
	.dword 0x632e636f6d707574
	.dword 0x65203d20300a7265
	.dword 0x6c5f7276632e7370
	.dword 0x203d20300a72656c
	.dword 0x5f7276632e646174
	.dword 0x61203d20300a7265
	.dword 0x6c5f7276632e6664
	.dword 0x617461203d20300a
	.dword 0x72656c5f72763332
	.dword 0x632e636f6d707574
	.dword 0x65203d20300a7265
	.dword 0x6c5f72763332632e
	.dword 0x6374726c203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32632e6664617461
	.dword 0x203d20300a72656c
	.dword 0x5f72763634632e63
	.dword 0x6f6d70757465203d
	.dword 0x20300a72656c5f72
	.dword 0x763634632e646174
	.dword 0x61203d20300a5b66
	.dword 0x6c6f61742d726f75
	.dword 0x6e64696e675d0a72
	.dword 0x6e65203d2031300a
	.dword 0x72747a203d203130
	.dword 0x0a72646e203d2031
	.dword 0x300a727570203d20
	.dword 0x31300a726d6d203d
	.dword 0x2031300a5b627261
	.dword 0x6e63682d636f6e74
	.dword 0x726f6c5d0a626163
	.dword 0x6b776172642d7072
	.dword 0x6f626162696c6974
	.dword 0x79203d20302e350a
	.dword 0x626c6f636b2d7369
	.dword 0x7a65203d20370a5b
	.dword 0x726563757273696f
	.dword 0x6e2d6f7074696f6e
	.dword 0x735d0a7265637572
	.dword 0x73696f6e2d656e61
	.dword 0x626c65203d204661
	.dword 0x6c73650a72656375
	.dword 0x7273696f6e2d6465
	.dword 0x707468203d203130
	.dword 0x0a72656375727369
	.dword 0x6f6e2d63616c6c73
	.dword 0x203d20350a5b6163
	.dword 0x636573732d736563
	.dword 0x74696f6e735d0a62
	.dword 0x6567696e5f736967
	.dword 0x6e6174757265203d
	.dword 0x2030783830303931
	.dword 0x3030302c30783830
	.dword 0x3039353030302c72
	.dword 0x770a5b6373722d73
	.dword 0x656374696f6e735d
	.dword 0x0a73656374696f6e
	.dword 0x73203d2030783031
	.dword 0x30303a3078646666
	.dword 0x2c2030783332352c
	.dword 0x2030783530303a30
	.dword 0x786666660a5b7573
	.dword 0x65722d66756e6374
	.dword 0x696f6e735d0a6675
	.dword 0x6e6331203d207b30
	.dword 0x3a22616464207830
	.dword 0x2c78302c7830227d
	.dword 0x0a5b737769746368
	.dword 0x2d707269762d6d6f
	.dword 0x6465735d0a737769
	.dword 0x7463685f6d6f6465
	.dword 0x73203d2046616c73
	.dword 0x650a6e756d5f7377
	.dword 0x697463686573203d
	.dword 0x20300a5b692d6361
	.dword 0x6368655d0a6e756d
	.dword 0x5f63616c6c73203d
	.dword 0x20300a6e756d5f62
	.dword 0x797465735f706572
	.dword 0x5f626c6f636b203d
	.dword 0x2031360a6e756d5f
	.dword 0x626c6f636b73203d
	.dword 0x20380a6e756d5f63
	.dword 0x79636c6573203d20
	.dword 0x31300a5b642d6361
	.dword 0x6368655d0a6e756d
	.dword 0x5f63616c6c73203d
	.dword 0x20300a6e756d5f62
	.dword 0x797465735f706572
	.dword 0x5f626c6f636b203d
	.dword 0x2031360a6e756d5f
	.dword 0x626c6f636b73203d
	.dword 0x20380a6e756d5f63
	.dword 0x79636c6573203d20
	.dword 0x31300a5b65786365
	.dword 0x7074696f6e2d6765
	.dword 0x6e65726174696f6e
	.dword 0x5d0a656361757365
	.dword 0x3030203d20300a65
	.dword 0x6361757365303120
	.dword 0x3d20300a65636175
	.dword 0x73653032203d2030
	.dword 0x0a65636175736530
	.dword 0x33203d20300a6563
	.dword 0x617573653034203d
	.dword 0x20300a6563617573
	.dword 0x653035203d20300a
	.dword 0x6563617573653036
	.dword 0x203d20300a656361
	.dword 0x7573653037203d20
	.dword 0x300a656361757365
	.dword 0x3038203d20300a65
	.dword 0x6361757365303920
	.dword 0x3d20300a65636175
	.dword 0x73653130203d2030
	.dword 0x0a65636175736531
	.dword 0x31203d20300a6563
	.dword 0x617573653132203d
	.dword 0x20300a6563617573
	.dword 0x653133203d20300a
	.dword 0x6563617573653134
	.dword 0x203d20300a5b6461
	.dword 0x74612d68617a6172
	.dword 0x64735d0a7261775f
	.dword 0x70726f62203d2030
	.dword 0x2e350a7761725f70
	.dword 0x726f62203d20302e
	.dword 0x350a7761775f7072
	.dword 0x6f62203d20302e35
	.dword 0x0a6e756d5f726567
	.dword 0x735f6c6f6f6b6265
	.dword 0x68696e64203d2033
	.dword 0x0a5b70726f677261
	.dword 0x6d2d6d6163726f5d
	.dword 0x0a7072655f70726f
	.dword 0x6772616d5f6d6163
	.dword 0x726f203d20616464
	.dword 0x2078302c78302c78
	.dword 0x300a706f73745f70
	.dword 0x726f6772616d5f6d
	.dword 0x6163726f203d2061
	.dword 0x64642078302c7830
	.dword 0x2c78300a7072655f
	.dword 0x6272616e63685f6d
	.dword 0x6163726f203d2061
	.dword 0x64642078302c7830
	.dword 0x2c78300a706f7374
	.dword 0x5f6272616e63685f
	.dword 0x6d6163726f203d20
	.dword 0x6164642078302c78
	.dword 0x302c78300a656361
	.dword 0x7573653030203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365303120
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736530
	.dword 0x32203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653033203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653034203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365303520
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736530
	.dword 0x36203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653037203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653038203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365303920
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736531
	.dword 0x30203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653131203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653132203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365313320
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736531
	.dword 0x34203d2072616e64
	.dword 0x6f6d0a5b73656c66
	.dword 0x2d636865636b696e
	.dword 0x675d0a7261746520
	.dword 0x3d203130300a7465
	.dword 0x73745f706173735f
	.dword 0x6d6163726f203d20
	.dword 0x6c61202020202020
	.dword 0x73702c2062656769
	.dword 0x6e5f7369676e6174
	.dword 0x7572653b20616464
	.dword 0x692020202073702c
	.dword 0x2073702c20322a52
	.dword 0x454742595445533b
	.dword 0x206c692020202020
	.dword 0x2074312c20307866
	.dword 0x666666663b205352
	.dword 0x4547202020207431
	.dword 0x2c20302a52454742
	.dword 0x5954455328737029
	.dword 0x0a746573745f6661
	.dword 0x696c5f6d6163726f
	.dword 0x203d206164642078
	.dword 0x302c78302c78300a
