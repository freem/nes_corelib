; Generic MMC1 Template (iNES)
; This template does not impose a specific "S*ROM" board layout.
;------------------------------------------------------------------------------;
; number of 16K PRG-ROM banks
PRG_BANKS = $08

; number of 8K CHR banks ($00 = CHR-RAM)
CHR_BANKS = $02

; MMC1 mirroring is mapper controlled. This just sets the default.
; If you want one-screen mapping, you will need to set it via MMC1 writes.
; %0000 = Horizontal
; %0001 = Vertical
MIRRORING = %0001

; Should the SRAM be battery backed or not?
; %0010 = battery backed
; %0000 = no battery
SRAM_BATTERY = %0000

; number of 8K PRG-RAM banks
SRAM_SIZE = $00

; Mapper 001 (MMC1 - generic) iNES header
	.byte "NES",$1A
	.byte PRG_BANKS ; 16K PRG-ROM banks
	.byte CHR_BANKS ; 8K CHR banks
	.byte $10|SRAM_BATTERY|MIRRORING ; flags 6
	.byte $00 ; flags 7
	.byte SRAM_SIZE ; PRG RAM size in 8K increments
	.dsb 7, $00 ; clear the remaining bytes
