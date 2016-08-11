; NINA-001: 64KB PRG-ROM + 8KB PRG-RAM + 32KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?unif=AVE-NINA-01
;------------------------------------------------------------------------------;
; BNROM mirroring is hardwired via solder pads.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 034.1 (NINA-001) NES 2.0 header
	.byte "NES",$1A
	.byte $04 ; 4x 16K PRG banks
	.byte $04 ; 4 8K CHR banks
	.byte $20|MIRRORING ; flags 6
	.byte $28 ; flags 7
	.byte $10 ; Mapper Variant
	.byte $00 ; Upper ROM size bits
	.byte $07 ; PRG-RAM size (8KB non-battery backed)
	.dsb 8, $00 ; clear the remaining bytes
