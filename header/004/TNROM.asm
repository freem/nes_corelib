; TNROM: (128,256,512)KB PRG-ROM + 8KB PRG-RAM + 8KB CHR-RAM
; http://bootgod.dyndns.org:7777/search.php?keywords=TNROM&kwtype=pcb
;------------------------------------------------------------------------------;
; number of 16K PRG banks
; Valid configurations: $08 (128K), $10 (256K), $20 (512K)
PRG_BANKS = $08

; TNROM mirroring is controlled by MMC3.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Should the SRAM be battery backed or not?
; %0010 = battery backed
; %0000 = no battery
SRAM_BATTERY = %0000

; Mapper 004 (MMC3 - TNROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte $00 ; CHR-RAM
	.byte $40|SRAM_BATTERY|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $01 ; PRG RAM in 8K increments
	.dsb 7, $00 ; clear the remaining bytes
