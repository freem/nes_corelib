; NROM-368: 46KB PRG-ROM + 8KB CHR-ROM
; http://wiki.nesdev.com/w/index.php/NROM-368
; An unofficial configuration that allows up to 46KB of ROM instead of 32.

; Important Note!
; "The PRG ROM is 47104 bytes in size. Due to constraints of the iNES format,
; it is padded at the beginning with 2048 bytes of ignored data so that it is
; an even multiple of 16384 bytes; the rest is loaded in order into $4800-$7FFF,
; $8000-$BFFF, and $C000-$FFFF."
;------------------------------------------------------------------------------;
; NROM mirroring is hardwired via solder pads.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 000 (NROM-368) iNES header
	.byte "NES",$1A
	.byte $03 ; 3x 16K PRG banks (just under 48K)
	.byte $01 ; 1x 8K CHR banks
	.byte $00|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
