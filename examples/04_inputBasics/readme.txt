freemco NES Corelib Example 04: Input Basics
================================================================================
[Introduction]
The fourth example in the series introduces the basics of handling input.

(todo: needs input detection/display)

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
An important thing to note is that the NES and original Famicom have different
controllers. The NES controllers have plugs, while the Famicom controllers are
hard-wired into the console. Furthermore, the original Famicom controllers have
a microphone on controller 2 instead of Start and Select buttons. Later Famicoms
use NES controllers for most purposes (aside from 15-pin expansion hardware).

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


