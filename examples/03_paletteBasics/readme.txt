freemco NES Corelib Example 03: Palette Basics
================================================================================
[Introduction]
Example number three goes into detail about the palette.

================================================================================
[Files]
_c.bat					Batch file for compiling with asm6
03_paletteBasics.asm	Main source file
Makefile				Makefile for compiling with asm6
nes.inc					NES system defines
NROM-128.asm			Header for iNES Mapper 000, NROM-128 configuration
ram.inc					Program RAM defines
readme.txt				This file!
test.chr				Example CHR-ROM data.
corelib/palette.asm		freemco NES Corelib Palette functionality (excerpt)

================================================================================
[Setup]
The first two examples cover the basic setup; Like before, this is an NROM-128
project, iNES Mapper 000. Include "nes.inc" and "ram.inc" like before... We're
still not going to touch the RAM defines yet. Yes, it's gonna be like this for
quite some time.

<Code>
This example contains macros, since there'd be a lot of repeated code without
them. Think of a macro as a repeatable set of code that you can pass different
values to. It can be similar to a subroutine, but doesn't have to be one. Macros
are highly useful when you have similar code where only the data differs.

One of the keys to take away from macros is that your assembler will pre-process
them, meaning you can perform various arithmetic in them (as you'll see in
drawSprPalBox) without having to do such calculation at runtime. The drawback to
this is that I believe you'll need to know the values ahead of time.

The first macro, drawBgPalBox, draws tiles onto the nametable. Those tiles will
be used to show the background palettes.

The second macro is drawSprPalBox, and it's a bit more complex. To show the
sprite palettes, we need to put sprites on the screen. In the Hello World
sprite example, we did this both manually and with the Corelib functions.
For this macro, manual writes are used.

After all the macros, we include an excerpt from the Corelib's ppu/palette.asm,
which will be used to write the palette data that follows it.

<NMI>
Our NMI routine is the same as the last one, as we're still not doing anything
special. If we were going to update the palette, this is where we would want to
do it, by the way. (You'll see that in a later example.)

<IRQ>
The IRQ still does nothing in this example.

<Reset>
Reset code is similar to the first example, up to the "at this point, you can
start setting up your program." comment.

================================================================================
[Process]
After Reset is finished handling the second VBlank, we can set up our program.

<Palette>
In the first two demos, we wrote to the palette manually. This gets old after a
while, so the Corelib includes a routine called ppu_XferFullPalToPPU, which
transfers a full 32 bytes to the PPU's palette. It's only meant to be used while
rendering is off (namely, during initialization). To use it, you set up the
pointer to the palette data in tmp00 and tmp01, then jsr ppu_XferFullPalToPPU.

After resetting the PPU addresses, we draw some labels and lines with manual
writes to the PPU. Then the fun begins!

In the previous examples, the code has been pretty straightforward, and we
haven't had a need for any macros. In the interest of de-duplicating code,
there are two macros in this example: drawBgPalBox and drawSprPalBox.

Many calls to drawBgPalBox are made, in order to draw the background tiles
used to demonstrate the palettes. The arguments, in order, are as follows:
* tile to use
* ppu address start high byte
* ppu address start low byte
* second ppu address low byte

Now, if this was all we did, all the swatches would be using the first palette.
In order to color them properly, we need to mess with the attribute data.

Attribute data on the NES is kind of tricky to deal with.
Each byte of the attribute data deals with a 32x32 pixel section of the screen
(aside from the bottom two rows), which is further divided into four 16x16
sections. Each of these 16x16 sections can use one of the four background
palette sets. This is very tricky to think about in practice.

Where {} represents one byte and [] represents one 16x16px quadrant:
{[A][B]
 [C][D]}

The value of each byte in the attribute data table follows this pattern:

DDCCBBAA
||||||||
||||||++- Top left
||||++--- Top right
||++----- Bottom left
++------- Bottom right

The value of each of the two letter combinations, in binary:
00		BG Palette 1
01		BG Palette 2
10		BG Palette 3
11		BG Palette 4

The NESdev wiki gives a simple equation for this:
value = (topleft << 0) | (topright << 2) | (bottomleft << 4) | (bottomright << 6)

With the attribute data out of the way, we can use the drawSprPalBox macro to
draw various sprites. To create the equivalent of the background palette
preview boxes, we'll need four 8x8 sprites.

drawSprPalBox's arguments are as follows:
* starting sprite index
* tile index
* palette
* x position
* y position

After that, the setup is complete and the example runs.
