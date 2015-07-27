freemco NES Corelib Example 02: "Hello World" on the Sprite Layer
================================================================================
[Introduction]
The second example is meant to be a simple demonstration of possible ways of
drawing sprites on screen. Both raw writes and the freemco NES Corelib are
used. As this is meant to be a basic "Hello World", the sprites don't move or
do anything.

(This code is broken; it's going to take me a bit to fix it, so please be patient.)

================================================================================
[Files]
_c.bat				Batch file for compiling with asm6
02_helloSpr.asm		Main source file
Makefile			Makefile for compiling with asm6
nes.inc				NES system defines
NROM-128.asm		Header for iNES Mapper 000, NROM-128 configuration
ram.inc				Program RAM defines
readme.txt			This file!
test.chr			Example CHR-ROM data.
corelib/oam.asm		freemco NES Corelib OAM (Sprite) functionality (excerpt)

================================================================================
[Setup]
It's assumed that you've gone through the first example, as it lays down the
basic setup. Like the last example, this will be an NROM-128 project, so we'll
be using iNES Mapper 000. Include "nes.inc" and "ram.inc" like before... We're
still not going to touch the RAM defines yet.

<Code>
This time around, our code at $C000 isn't as simple. The first thing that's done
is to include "corelib/oam.asm", which contains an excerpt of the freemco NES
Corelib OAM routines.

Following the include is the data for the project. Y positions for the tops and
bottoms of each row are included, along with the X position for each letter,
and the tile indices. Of special note are the sprDataBot_* entries, which are
used with the Corelib's oam_setEntryData subroutine to help set up sprites.

<NMI>
Our NMI routine is the same as the last one, as we're not doing anything special.

<IRQ>
The IRQ still does nothing in this example.

<Reset>
Reset code is similar to the first example, up to the "at this point, you can
start setting up your program." comment.

================================================================================
[Process]
After Reset is finished handling the second VBlank, we can set up our program.

<Palette>
This demo expands on the first demo's palette setup by writing palette data for
the sprite tiles... We kind of need that.

<Sprites, the Manual Way>
For this demo, we're going to work with 8x8 sprites only.

The top "Hello" sprite is written using manual writes to the OAM_BUF.
Since we're not updating the sprite after drawing it, this is an ok way of doing
things. However, in a real game, you'd want to have some sort of routine convert
object coordinates and such to the proper sprite values.

OAM_BUF is 64 bytes long, and each four bytes represents one entry.
The first four bytes represent Sprite 0, the next four represent Sprite 1, etc.
Sprite 0 is special, so we don't want to use it unless we really have to.

The "Hello" sprite starts at 1, which means OAM_BUF+4. The data in the OAM_BUF
is laid out as follows:
(+0) Y position (value is off by 1)
(+1) Tile number
(+2) Attributes
(+3) X position

We write these values for each of the letters in the right position, first for
the tops of the letters, then the bottoms. This sure takes a lot of effort,
though... There must be a better way.

<Sprites, the freemco Corelib Way>
(todo)

<Post-Sprites>
(todo)
