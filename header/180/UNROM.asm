; UNROM - Crazy Climber: 128KB PRG-ROM + 8KB CHR-RAM
; http://bootgod.dyndns.org:7777/profile.php?id=3869
; http://wiki.nesdev.com/w/index.php/INES_Mapper_180
;------------------------------------------------------------------------------;
; In this mapper, the fixed bank is at $8000-$BFFF, as opposed to $C000-$FFFF.

; UNROM mirroring is hardwired via solder pads.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 180 (UNROM - Crazy Climber) iNES header
	.byte "NES",$1A
	.byte $08 ; 8x 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $40|MIRRORING ; flags 6
	.byte $B0 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
