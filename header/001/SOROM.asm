; SOROM: (128,256KB)PRG-ROM + 16KB PRG-RAM + 8KB CHR-RAM/ROM
; http://bootgod.dyndns.org:7777/search.php?keywords=SOROM&kwtype=pcb

; todo: create NES 2.0 Mapper 001.2 version and use that.
;------------------------------------------------------------------------------;
; number of 16k PRG banks
; Valid configurations: $08 (128K), $10 (256K)
PRG_BANKS = $08

; CHR RAM/ROM toggle
; Valid configurations: $00 (8K CHR-RAM), $01 (8K CHR-ROM)
CHR_BANKS = $01

; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mapping, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Should the SRAM be battery backed or not?
; %0010 = battery backed
; %0000 = no battery
SRAM_BATTERY = %0000

; Mapper 001 (MMC1 - SOROM) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG banks
	.byte CHR_BANKS ; 8K CHR-RAM
	.byte $10|SRAM_BATTERY|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte $02 ; PRG RAM size in 8K increments
	.dsb 8, $00 ; clear the remaining bytes
