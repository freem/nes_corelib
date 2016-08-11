; Multi-discrete Mapper: ??KB PRG-ROM + 8KB CHR-RAM
; http://wiki.nesdev.com/w/index.php/INES_Mapper_028
; http://wiki.nesdev.com/w/index.php/User:Tepples/Multi-discrete_mapper
;------------------------------------------------------------------------------;
; Mirroring is handled via the mapper.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0000

; Mapper 028 (Multi-discrete) NES 2.0 header
	.byte "NES",$1A
	.byte $20 ; 32x 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $C0|MIRRORING ; flags 6
	.byte $18 ; flags 7
	.byte $00 ; Mapper Variant
	.byte $00 ; ROM size upper bits
	.byte $00 ; PRG-RAM size
	.byte $07 ; CHR-RAM size
	.byte $00 ; TV system
	.byte $00 ; Vs. Hardware
	.dsb 2, $00 ; clear the remaining bytes
