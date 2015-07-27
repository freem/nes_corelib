freemco NES Corelib Example 04: Input Basics
================================================================================
[Introduction]
The fourth example in the series introduces the basics of handling input.

(todo: this code isn't perfect; the PPU scroll is blehh just before starting,
plus there is sprite garbage)

================================================================================
[Files]
_c.bat					Batch file for compiling with asm6
04_inputBasics.asm		Main source file
Makefile				Makefile for compiling with asm6
nes.inc					NES system defines
NROM-128.asm			Header for iNES Mapper 000, NROM-128 configuration
ram.inc					Program RAM defines
readme.txt				This file!
test.chr				Example CHR-ROM data, modified for Example 4.
corelib/io.asm			freemco NES Corelib I/O functionality

================================================================================
[Setup]

<Code>


<NMI>


<IRQ>
The IRQ is still doing nothing.

<Reset>
Reset code is similar to the first example, up to the "at this point, you can
start setting up your program." comment.

================================================================================
[Process]
After Reset is finished handling the second VBlank, we can set up our program.


