# Spike Bare-Metal Debug Cheatsheet (`spike -d`)

## Start

``` bash
spike -d --isa=rv64imafdczicsr_zifencei <filename>.elf
```

------------------------------------------------------------------------

## Execution

  Command   Use
  --------- -------------------------
  `Enter`   Execute one instruction
  `c`       Continue execution
  `r`       Run until program exits
  `q`       Quit debugger

------------------------------------------------------------------------

## Registers

  Command       Use
  ------------- ---------------------------------
  `reg 0 pc`    Show program counter
  `reg 0 sp`    Show stack pointer
  `reg 0 ra`    Show return address
  `reg 0 gp`    Show global pointer
  `reg 0 tp`    Show thread pointer
  `reg 0 a0`    Show argument / return register
  `reg 0 a1`    Show argument register
  `reg 0 t0`    Show temporary register
  `reg 0 s0`    Show saved register
  `reg 0 x10`   Read register by number

General syntax:

``` text
reg <hart> <register>
```

------------------------------------------------------------------------

## Machine CSRs

  Command            Use
  ------------------ --------------------
  `reg 0 mstatus`    Machine status
  `reg 0 mepc`       Exception PC
  `reg 0 mcause`     Trap cause
  `reg 0 mtvec`      Trap vector
  `reg 0 mtval`      Trap value
  `reg 0 mie`        Interrupt enable
  `reg 0 mip`        Pending interrupts
  `reg 0 mscratch`   Scratch register

------------------------------------------------------------------------

## Memory

General syntax:

``` text
mem <address>
```

  Command               Use
  --------------------- ------------------------
  `mem 0x80000000`      Read memory at address
  `mem <sp>`            Inspect stack
  `mem <global_addr>`   Read global variable
  `mem <array_addr>`    Read array element

------------------------------------------------------------------------

## Run Until

  Command                    Use
  -------------------------- ---------------------------------
  `until pc 0x80000100`      Run until PC reaches address
  `until reg a0 10`          Run until register equals value
  `until mem 0x80002000 1`   Run until memory equals value

------------------------------------------------------------------------

## Run While

  Command                    Use
  -------------------------- --------------------------------------
  `while pc 0x80000100`      Continue while PC equals address
  `while reg a0 0`           Continue while register equals value
  `while mem 0x80002000 0`   Continue while memory equals value

------------------------------------------------------------------------

## Common Workflow

``` text
spike -d firmware.elf
Enter
reg 0 pc
reg 0 sp
mem 0x80002000
until pc 0x80000100
c
q
```
