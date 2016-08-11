; DE1ROM: 128KB PRG-ROM + 64KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=DE1ROM&kwtype=pcb
; DE1ROM uses Nintendo's clone of a Tengen 800030. (See also: Mapper 064)
;------------------------------------------------------------------------------;
; DE1ROM mirroring is like MMC3; mapper controlled.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 206 (DE1ROM) iNES header
	.byte "NES",$1A
	.byte $08 ; 8x 16K PRG banks
	.byte $08 ; 8x 8K CHR-ROM banks
	.byte $E0|MIRRORING ; flags 6
	.byte $C0 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
