Title: Main Page/Introduction

Section: Introduction
The freemco NES corelib is a set of assembly language routines meant to help
make it easier to create a NES game/utility/etc.

Section: Prerequisites
A list of tools either required or recommended for using the freemco NES corelib.

- *Assembler*: Either *<asm6 at http://3dscapture.com/NES/>* or *<asm6f at https://github.com/freem/asm6f>* can be used. asm6f is only required for
  FCEUX .nl export, so if you're not using that, you can use the original version.
  If you want to write your own linker scripts, I guess you could use <ca65 at http://cc65.github.io/cc65/>
  as well, but no support will be given for that setup (until further notice).
- *Tile Compressor*: <tokumaru's tile compression utility at http://forums.nesdev.com/viewtopic.php?f=2&t=5860>
- *Nametable Layout Tool*: <shiru's NES Screen Tool at http://shiru.untergrund.net/software.shtml>
- *Graphics Editor/Converter*: Whatever you want; I prefer YY-CHR.

Section: Memory Usage
As with any library, a number of things need to be kept track of, meaning there's
less room for your game. The freemco NES corelib tries to keep this space to a minimum.

Please see "ram.example" for an example RAM layout for a freemco NES corelib project.

Topic: Zero Page Variables
Zero page ($00-$FF) is the best place to put variables that need to be accessed
often. The freemco NES corelib takes up a bit of space at the beginning of zero
page for its own purposes.

Topic: The Stack ($0100-$01FF)
Depending on how much you use the stack, you might be able to get away with
putting some variables in the top few addresses (e.g. $0100-$0120).

Topic: OAM (Sprite) Data ($0200-$02FF)
While the OAM data can technically live anywhere within $0000-$07FF, NES games
typically put the OAM data just after the stack. The corelib follows this convention.

Topic: Everywhere else ($0300-$07FF)
The details of this section are to be determined, but typically this area is used
for any variables your game needs.

Variables: Temporary Variables ($00-$0F)
The temporary variables at $00-$0F can be used for any purpose, as long as you're
aware that other routines may be using them. The names for these variables are tmp00
to tmp0F.

Variables: System Variables ($10-$2F)
In addition to temporary variables, the freemco NES corelib also sets up a number
of variables that a game will typically need.

vblanked - "in VBlank" indicator
frameCount - Current number of frames run (two bytes)
int_ppuCtrl - internal copy of <PPU_CTRL>
int_ppuMask - internal copy of <PPU_MASK>
int_ppuStatus - internal <PPU_STATUS> read
int_scrollX - Internal <PPU_SCROLL> (first write)
int_scrollY - Internal <PPU_SCROLL> (second write)
int_last4016 - Last write to $4016/JOYSTICK1
pad1Trigger - Button trigger status for controller 1
pad2Trigger - Button trigger status for controller 2
pad3Trigger - (Optional) Button trigger status for controller 3
pad4Trigger - (Optional) Button trigger status for controller 4
pad1State - Button data for controller 1
pad2State - Button data for controller 2
pad3State - (Optional) Button data for controller 3
pad4State - (Optional) Button data for controller 4

Variables: Undefined ($30-$BF)
The range of $30-$BF is not used by the corelib, meaning you can abuse it to your
heart's content.

Variables: CHR-RAM Tile Decompression ($C0-$DF)
The decompression code for CHR-RAM uses a number of variables.
See <ppu/decomp_tiles.asm> for a full list.

Variables: Mapper-specific ($E0-$EF?)
Each mapper has its own way of operating, which means more variables. Each mapper
is different, so you'll have to see the documentation for the mapper you're using
in order to find out what variables are available.

Section: Headers and Mappers, oh my!
In order to make a NES game/program/whatever, you're going to need to determine
what type of cart to create. In addition, the ROM image you create for emulators
will (typically) need a header in order for the game to run.

Topic: Mappers
The mapper is the heart of the cartridge. It can allow for bankswitching of
program data and character data, among many other things. Choosing the right
mapper is largely a function of what your game/utility/etc. needs to do.

Some commonly used mappers::
- *NROM*, etc. (iNES mapper 000) e.g. Balloon Fight, Bomberman, Super Mario Bros.
- *MMC1* (iNES mapper 001) e.g. Blaster Master, Dr. Mario, The Legend of Zelda (U), Mega Man 2...
- *UxROM* (iNES mapper 002) e.g. Contra (U), DuckTales, Mega Man
- *CNROM* (iNES mapper 003) e.g. Arkanoid, Gradius, Paperboy
- *MMC3*  (iNES mapper 004) e.g. Batman, Kirby's Adventure, Mega Man 3-6, Super Mario Bros. 3...

Topic: Headers
Most NES emulators require your ROM to have a header. The header is a set of bytes
identifying the cartridge setup, including the mapper used, the sizes for PRG and CHR,
and so on.

