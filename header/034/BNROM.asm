; BNROM: 128KB PRG-ROM + 8KB CHR-RAM
; http://bootgod.dyndns.org:7777/search.php?keywords=BNROM&kwtype=pcb
;------------------------------------------------------------------------------;
; BNROM mirroring is hardwired via solder pads.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 034 (BNROM) iNES header
	.byte "NES",$1A
	.byte $08 ; 8x 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $20|MIRRORING ; flags 6
	.byte $20 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
