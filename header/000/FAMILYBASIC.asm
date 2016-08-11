; HVC-FAMILYBASIC: 32KB PRG-ROM + 8KB PRG-RAM + 8KB CHR-ROM (NES 2.0)
; http://bootgod.dyndns.org:7777/search.php?unif=HVC-FAMILYBASIC
;------------------------------------------------------------------------------;
; NROM mirroring is hardwired via solder pads.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 000.1 (HVC-FAMILYBASIC) NES 2.0 header
	.byte "NES",$1A
	.byte $02 ; 1x 16K PRG banks
	.byte $01 ; 1x 8K CHR banks
	.byte $00|MIRRORING ; flags 6
	.byte $08 ; flags 7
	.byte $10 ; Mapper Variant
	.byte $00 ; ROM size upper bits
	.byte $60 ; PRG-RAM size
	.byte $00 ; CHR-RAM size
	.byte $00 ; TV system
	.byte $00 ; Vs. Hardware
	.dsb 2, $00 ; clear the remaining bytes
