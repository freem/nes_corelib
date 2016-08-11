makefds | a Lua 5.2 script for creating Famicom Disk System images
==================================================================
[Introduction]
makefds is a Lua script that creates a Famicom Disk System disk image from
a small, text-based script file.

Making FDS images by hand is a time consuming process. Using a GUI program would
be a better idea, but none of the currently available programs let you create a
disk from scratch. In the absence of a GUI program, having a script you can feed
to a parser is your next best bet.

================================================================================
[Usage]
lua makefds.lua (infile) (outfile)

(infile) is the input script file.
(outfile) is the name of the output FDS disk image file.

================================================================================
[Script Format]
The script files that makefds expects are basic text files.

Comments begin with the # or ; characters.
All numbers are in hex (00-FF) without any leading or trailing characters.

The command reference:
--------------------------------------------------------------------------------
{header, noheader}
The first parsed line of the script must be either "header" or "noheader".
This will determine if the output image has a fwNES FDS header or not.
Most NES/Famicom emulators require a header, but MAME/MESS requires no header.

IMPORTANT NOTE:
If noheader is set, the script will only create a single disk side.
(This might be temporary; I haven't determined if multiple scripts should be
used in this situation or not.)

--------------------------------------------------------------------------------
{totalsides:##}
If a header is declared, the number of total disk sides must be declared as
well. This command should only be used once.

Not required with noheader, at the moment.

--------------------------------------------------------------------------------
{manufacturer:##}
Nintendo maintained a manufacturer list for FDS games.
This value is interpreted as hex. Recommended values are $00 or $FF.

For a list of known manufacturer codes, please see:
http://wiki.nesdev.com/w/index.php/Family_Computer_Disk_System#Manufacturer_codes

--------------------------------------------------------------------------------
{gamename:ABC}
Three letter game code. (uppercase letters, maybe numbers?)
Data longer than three characters will be truncated.
Data under three characters will be padded with spaces (character 0x20).

--------------------------------------------------------------------------------
{gametype:str}
Game type is an odd value.

The script expects a string, which is converted into one of the known values:
"normal" - normal disk   = space (0x20)
"event"  - event disk    = E (0x45)
"sale"   - reduced price = R (0x52)

Custom values are not supported.

--------------------------------------------------------------------------------
{version:##}
Game version/revision number. You can typically set this to 00.

--------------------------------------------------------------------------------
{sidenum:#}
Side number for this disk.

0=Side A/Single sided disk, 1=Side B.
I still wonder if I should allow "A" and "B" for this.

--------------------------------------------------------------------------------
{disknum:##}
Disk number in the set. For a single disk, set this to $00.

--------------------------------------------------------------------------------
{disktype:##}
Disk type is another odd value. You can typically set this to 00.

00 = FMC (normal card)
01 = FSC (card w/shutter)

--------------------------------------------------------------------------------
{bootfile:##}
Choose file code/number to load on bootup.

--------------------------------------------------------------------------------
{makedate:######}
Date the disk was created.

The format is YY MM DD, using BCD (no hex). Years are offset from 1925,
so the last possible year before wrapping around is 2024 (99).

See you in 9 years, I guess.

--------------------------------------------------------------------------------
{unknown6a:##}
{unknown6b:##}
{unknown6c:##}
{unknown6d:##}
{unknown6e:##}
Six unknown values that are possibly used for game identification.

--------------------------------------------------------------------------------
{country:str}
Currently not supported; all disks are forced to Japan/$49.

--------------------------------------------------------------------------------
{writedate:######}
Date the disk was written to. (or rewritten)

Same format as makedate.
Original (non-rewritten) games have the same date as in makedate.

--------------------------------------------------------------------------------
{diskwriter:####}
Disk writer serial number (two bytes)

--------------------------------------------------------------------------------
{realdiskside:##}
I don't know why there's a second disk side variable.
$00 = Side A; $01 = Side B

--------------------------------------------------------------------------------
{price:##}
welcome to the price field, where the rules are made up and the price doesn't matter.

The interpretation of this value depends on the disk rewrite count field (which
is currently not exposed to scripts).

If the disk rewrite count field is $00, the price field represents the cost of
a new/original disk. $01 would be equivalent to 3400 yen, while $03 is 3400 yen,
but with a peripheral included.

If the disk rewrite count is $01, the price field represents the cost of a disk
rewrite. Known values: $00 = 500 yen; $01 = 600 yen.

--------------------------------------------------------------------------------
{numfiles:##}
Number of files on the disk that the BIOS can see.

--------------------------------------------------------------------------------
{rewrites:##} (optional) - not currently implemented
Currently not supported. I need to stop being lazy about it.

--------------------------------------------------------------------------------
{file:...}
The file command is probably the most important.

Parameters for file, in order:
* file number   (1 byte)  unique number, increasing
* file ID code  (1 byte)  not unique; smaller than boot num = boot file
* filename      (8 bytes) filename with ""
* load address  (2 bytes) in hex
* file type     (1 byte)  PRG, CHR, or NT
* path to file  (using "" is recommended but not required unless spaces in path)

example:
file:0,0,"FILENAME",6000,PRG,(path to file)

File paths are relative to the directory the program is run in, making the
program work best when it's in the same folder as the disk script and files for
the disk.

The filename is padded with $00 if it's less than 8 characters long.

--------------------------------------------------------------------------------
{nextside} - not currently implemented
Tentative command to switch disk sides for writing.
Only supported with headered images?

--------------------------------------------------------------------------------
{newdisk} - not currently implemented
Tentative command to save the current disk info and make a new disk.
Only supported with headered images?
