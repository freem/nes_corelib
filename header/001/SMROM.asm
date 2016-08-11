; SMROM: 256KB PRG-ROM + 8KB CHR-RAM
; http://bootgod.dyndns.org:7777/search.php?keywords=SMROM&kwtype=pcb
; Only used for "Hokkaidou Rensa Satsujin: Okhotsu ni Shoyu" (J)?
;------------------------------------------------------------------------------;
; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mapping, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 001 (MMC1 - SMROM) iNES header
	.byte "NES",$1A
	.byte $10 ; 16x 16K PRG banks
	.byte $00 ; 8K CHR-RAM
	.byte $10|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
