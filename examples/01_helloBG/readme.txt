freemco NES Corelib Example 01: "Hello World" on the Background Layer
================================================================================
[Introduction]
The first example is meant to be a very simple demonstration of writing a NES
program. It should be noted that this example doesn't really use the freemco NES
Corelib to write on the background. In fact, it doesn't even do background updates
like a "proper" program! We'll get to that in another example, though.

================================================================================
[Files]
_c.bat				Batch file for compiling with asm6
01_helloBG.asm		Main source file
Makefile			Makefile for compiling with asm6
nes.inc				NES system defines
NROM-128.asm		Header for iNES Mapper 000, NROM-128 configuration
ram.inc				Program RAM defines
readme.txt			This file!
test.chr			Example CHR-ROM data.

================================================================================
[Setup]
Before going into the code itself, it's pretty important to explain exactly how
this file is made, as any changes could possibly mess things up.

<iNES Header>
.NES ROM images always need a header at the beginning, which lets the emulator
(or flashcart) know what mapper to emulate. The Corelib includes a number of
files that represent various iNES mapper setups.

For our examples, we're going to use the simplest possible mapper.
iNES mapper 000 represents the NROM board, which was used for all of the early
first-party NES games from 1983-1985.

Since our examples aren't going to be too long, we'll use the smaller NROM-128
(16KB) setup. NROM-128.asm contains all of the bytes required to define our iNES
header. By including it at the top of the file, the bytes get written to the
binary, and emulators/flashcarts can recognize it.

<Defines>
Just below the header are two defines, one for "nes.inc" and one for "ram.inc".

As mentioned in the Files section above, "nes.inc" handles the NES system
defines; these include the various PPU and APU ports, as well as bitmasks for
2A03 (sound) channels and joystick buttons.

"ram.inc" is a bit more complex, as it follows the "ram.example" template from
the main corelib src/ directory. A number of things have been removed from it,
since we're not going to use them in this example.

<Code>
Finally, we can begin the code. Since NROM-128 only allows for 16KB of program
data, we must start our code at $C000 (as opposed to $8000, which we'd do if
this was an NROM-256 example). This is done with the ".org $C000" command.

A string is stored for later writing... This is where normal tutorials would
tell you about having a non-ASCII character setup for better CHR usage. However,
these examples are meant to be simple, and I'm super lazy.

<NMI>
The NMI is a very important part of NES development. Though it's called a
"non-maskable interrupt", it's possible to mask NMIs on the NES via a PPU write.
(This is not recommended; todo: add note from NESDev wiki)

The reason NMI is important is that it's guaranteed to run once per frame, so
long as it's not disabled.

It's important to note that "NMI" and "VBlank" are not interchangeable terms,
as the NMI can run well outside of the VBlank period if too much is going on.

In this demo, the NMI doesn't do much.
1) Save the A,X,Y registers (since we could be in the middle of anything).
2) Update the frame counter.
3) A comment for "proper NMI code", which this demo doesn't use...
4) Set the "vblanked" variable to 0 (it's set to 1 in a function called waitVBlank)
5) Restore the Y,X,A registers (note that the order is reversed from how you pushed them)
6) rti, or "get the hell out of this interrupt".

While it's not the simplest thing one could do in an NMI, it's a pretty good base
for a "real" NMI routine.

<IRQ>
The IRQ does nothing in this example, and won't be doing much in the next few.

<Reset>
It's very important to reset the NES into a known state, otherwise weird things
happen. Put Mega Man 1 or 2 into a Game Genie and lemme know how the music sounds.

The code does a much better job of explaining the Reset process than I can write
here.

It should be noted that the "at this point, you can start setting up your program"
comment might move around in the other examples.

================================================================================
[Process]
After Reset is finished handling the second VBlank, we can set up our program.

It's very important to note that rendering is still turned off; the following
code will only work if rendering is off.

<Palette>
In order to have anything visible on the screen, we'll need to write some
palette data. The palette is 32 bytes long, but we only need to write four of
them in this example. Writing to the palette involves doing some PPU writes.

Before doing anything, we need to ensure the PPU is using +1 increment. If this
isn't set, the PPU will jump 32 bytes between PPU locations, which will be
awkward for palette writes.

In order to write the palettes, we need to set the PPU's address to $3F00, which
is where the palette data begins. This is done by writing to PPU_ADDR twice, with
the values in little endian format (unlike the rest of the NES/6502!).

Once the PPU address is set, we can just write bytes to PPU_DATA, which will put
them into the Palette.

An important thing to do after every palette write is to fix the location of
PPU_ADDR. In the example code, the $3F that we put into X is untouched, and
the last color we write is an $00 gray. Both of these help us out, as we need
to set the PPU address for the palette to $3F00, and the overall PPU address
to $0000 after that.

<Writing to the Background Layer>
Please read the important note at the beginning of the Process section again.
What we're about to do is not going to work during a game, since rendering is
unlikely to be turned off. However, since rendering is off in our setup, and
this example is simple, we can get away with writing to the nametable now.

Before doing anything, we need to ensure the memory in the Nametable section
is cleared. There's a small looking section of code that expands to a large
amount of PPU data writes. The 32*30 represents the main nametable area,
while the 64 represents the attribute area.

We also need to ensure that the sprite data we cleared above gets sent to the
PPU, so there's a quick write to OAM_DMA just after clearing the nametable data.

Like the palette setup before, we need to set the PPU_ADDR. This time, I've
picked a cell location of (x10,y15) for the text to begin. The PPU needs these
values converted to an address, so let's explain how this maps out.

The NES background layer consists of multiple 8x8 tiles, and each location
represents a point on this map. For example, (x0,y0) is $2000, (x1,y0) is $2001,
(x0,y1) is $2020, and so on. From there, to get a PPU address from coordinates,
it's simple multiplication (in hex, anyways.)

After setting the PPU address, there's a small loop to write the "Hello World!"
string from above to the PPU.

Once that's finished, we ensure the PPU has the correct scroll values, as well
as the PPU address itself, for extra measure.
(note to self: look into this to see if this is required and/or good practice)

In order to display anything, we need to re-enable the NMIs and turn the PPU
back on. Sprites will be loaded from $1000-$1FFF in CHR data (the right side
in various emulator's CHR viewers).

We have finally reached the main loop. Since this example has the majority of
the setup complete, there's not much we need to do in the main loop. Still,
there are some comments placed which allow you to separate out the periods of
the main loop.

(todo: finish this)
