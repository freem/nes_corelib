; SCROM: 64KB PRG-ROM + 128KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=SCROM&kwtype=pcb
; Appears to only have been used for a handful of NES games, mostly USA.
; [SC1ROM has a nonstandard pinout, but that doesn't matter for iNES headers.]
;------------------------------------------------------------------------------;
; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mirroring, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 001 (MMC1 - SCROM) iNES header
	.byte "NES",$1A
	.byte $04 ; 4x 16K PRG banks (64k total)
	.byte $10 ; 16x 8K CHR banks (128k total)
	.byte $10|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
