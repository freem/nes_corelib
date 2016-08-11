; FJROM: (128,256)KB PRG-ROM + 8KB PRG-RAM (battery optional) + (16,32,64)KB CHR-ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=FJROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K)
PRG_BANKS = $10

; number of 8K CHR banks
; Valid configurations: $02 (16K), $04 (32K), $08 (64K)
CHR_BANKS = $02

; Should the SRAM be battery backed or not?
; %0010 = battery backed
; %0000 = no battery
SRAM_BATTERY = %0000

; MMC4 mirroring is mapper controlled. This just sets the default.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Mapper 010 (MMC4 - FJROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG-ROM banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $A0|SRAM_BATTERY|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $01 ; PRG RAM size in 8K increments
	.dsb 7, $00 ; clear the remaining bytes
