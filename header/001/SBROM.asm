; SBROM: 64KB PRG-ROM + (16,32,64)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=SBROM&kwtype=pcb
; Used for only three USA region games?
;------------------------------------------------------------------------------;
; number of 8K CHR banks
; Valid configurations: $02 (16K), $04 (32K), $08 (64K)
CHR_BANKS = $02

; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mirroring, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 001 (MMC1 - SBROM) iNES header
	.byte "NES",$1A
	.byte $04 ; 4x 16K PRG banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $10|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $00 ; no PRG RAM
	.dsb 7, $00 ; clear the remaining bytes
