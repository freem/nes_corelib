freemco NES Corelib
===================
The freemco NES Corelib is a set of routines for coding stuff on the NES.
As far as I know, there's no real "library" for coding NES games in ASM...
Every project has their own version of the same code (and rightfully so; some
games need different routines than others).

However, this hasn't been tested on real hardware, as I've got no way to run
the code on the console at the moment. Furthermore, this library is nowhere near
complete.

If you're not me, good luck using it.

-freem

## History
The freemco NES Corelib was originally developed alongside the MMC1 version of
Family Picross, as well as Bumpin' Cars.

## Features
- Coded by a complete 6502 asm noob!
- Routines I actually wrote!
- Routines borrowed from the internet!

## To Do
There's a lot of things to do, but here are some main ones:
- Private version is further along but needs to be cleaned up, updated, and finished before release.
- No APU/Sound support yet.
- "VRAM Buffer" routines not yet complete.
- Missing a lot of functionality.

## License
Aside from the half-joking statement in the license file, I have not decided on a
proper license for this code. Currently leaning towards ISC, like the [freemlib for Neo-Geo](https://github.com/freem/freemlib-neogeo/),
but open to suggestions that aren't the GPL.

## Contributions
I am open to allowing external contributions, especially if you fix something
that wasn't working on real hardware. See CONTRIBUTING.md for more information.
