; MMC1 mapper code and defines
;==============================================================================;
; MMC1 zero page vars
.enum $00E0
	mmc1Data		.dsb 1, $00		; data to write to MMC1 register
	int_mmc1Ctrl	.dsb 1, $00		; last full value written to control reg
	curPrgBank		.dsb 1, $00		; current swappable program bank
	;curBankCHR0	.dsb 1, $00		; current CHR-ROM Bank (0)
	;curBankCHR1	.dsb 1, $00		; current CHR-ROM Bank (1)
.ende

;==[MMC1 Register defines]=============f========================================;
; load register ($8000-$FFFF)
MMC1_Load	= $8000
; 7654 3210
; ---------
; Rxxx xxxD
; |       |
; |       +- Data bit to be shifted into shift register, LSB first
; +--------- 1: Reset shift register and write Control with (Control OR $0C),
;              locking PRG ROM at $C000-$FFFF to the last bank.

;------------------------------------------------------------------------------;
; control register (internal; $8000-$9FFF)
MMC1_Ctrl	= $8000
; 43210
; -----
; CPPMM
; |||||
; |||++---- Mirroring (0: one-screen, lower bank; 1: one-screen, upper bank;
; |||       2: vertical; 3: horizontal)
; |++------ PRG ROM bank mode (0, 1: switch 32 KB at $8000, ignoring low bit of bank number;
; |         2: fix first bank at $8000 and switch 16 KB bank at $C000;
; |         3: fix last bank at $C000 and switch 16 KB bank at $8000)
; +-------- CHR ROM bank mode (0: switch 8 KB; 1: switch two separate 4 KB banks)

;------------------------------------------------------------------------------;
; CHR bank 0 (internal; $A000-$BFFF)
MMC1_Chr0	= $A000
; 43210
; -----
; CCCCC
; |||||
; +++++---- Select 4KB or 8KB CHR bank at PPU $0000

; on SNROM:
; 43210
; -----
; ExxxC
; |   |
; |   +---- Select 4KB CHR-RAM bank at PPU $0000 (ignored in 8KB mode)
; +-------- PRG-RAM disable (0: enable, 1: open bus)

;------------------------------------------------------------------------------;
; CHR bank 1 (internal; $C000-$DFFF)
MMC1_Chr1	= $C000
; 43210
; -----
; CCCCC
; |||||
; +++++---- Select 4KB or 8KB CHR bank at PPU $1000

; on SNROM:
; 43210
; -----
; ExxxC
; |   |
; |   +---- Select 4KB CHR-RAM bank at PPU $1000 (ignored in 8KB mode)
; +-------- PRG-RAM disable (0: enable, 1: open bus) (ignored in 8 KB mode)

;------------------------------------------------------------------------------;
; PRG bank (internal; $E000-$FFFF)
MMC1_Prg	= $E000
; 43210
; -----
; RPPPP
; |||||
; |++++---- Select 16 KB PRG ROM bank (low bit ignored in 32 KB mode)
; +-------- PRG RAM chip enable (0: enabled; 1: disabled; ignored on MMC1A)

;==[MMC1 Routines]=============================================================;
; MMC1_WriteControl
; Writes data to the MMC1 Control Register ($8000-$9FFF).

; Params:
; A			Value to write

MMC1_WriteControl:
	sta mmc1Data		; store full value
	sta int_mmc1Ctrl	; store our internal value

	; disable interrupts and save current PPU control
	sei
	lda int_ppuCtrl
	pha
	jsr ppu_disableNMI

	; write data
	lda mmc1Data
	sta MMC1_Ctrl
	lsr a
	sta MMC1_Ctrl
	lsr a
	sta MMC1_Ctrl
	lsr a
	sta MMC1_Ctrl
	lsr a
	sta MMC1_Ctrl

	; restore current PPU control and re-enable interrupts
	pla
	sta int_ppuCtrl
	sta PPU_CTRL
	cli

	rts

;------------------------------------------------------------------------------;
; MMC1_SetCHRBank0
; Writes data to the MMC1 CHR Bank 0 Register ($A000-$BFFF).
; (Low bit is ignored in 8K mode.)

; Params:
; A			Value of CHR bank 0
; Note: in SNROM, the value includes the PRG-RAM disable toggle in bit 4.

MMC1_SetCHRBank0:
	sta mmc1Data		; store full value

	; disable interrupts and save current PPU control
	sei
	lda int_ppuCtrl
	pha
	jsr ppu_disableNMI

	; write data
	lda mmc1Data
	sta MMC1_Chr0
	lsr a
	sta MMC1_Chr0
	lsr a
	sta MMC1_Chr0
	lsr a
	sta MMC1_Chr0
	lsr a
	sta MMC1_Chr0

	; restore current PPU control and re-enable interrupts
	pla
	sta int_ppuCtrl
	sta PPU_CTRL
	cli

	rts

;------------------------------------------------------------------------------;
; MMC1_SetCHRBank1
; Writes data to the MMC1 CHR Bank 1 Register ($C000-$DFFF).
; This is ignored in 8K mode.

; Params:
; A			Value of CHR bank 0
; Note: in SNROM, the value includes the PRG-RAM disable toggle in bit 4.
; However, this one is ignored in 8K mode.

MMC1_SetCHRBank1:
	sta mmc1Data		; store full value

	; disable interrupts and save current PPU control
	sei
	lda int_ppuCtrl
	pha
	jsr ppu_disableNMI

	; write data
	lda mmc1Data
	sta MMC1_Chr1
	lsr a
	sta MMC1_Chr1
	lsr a
	sta MMC1_Chr1
	lsr a
	sta MMC1_Chr1
	lsr a
	sta MMC1_Chr1

	; restore current PPU control and re-enable interrupts
	pla
	sta int_ppuCtrl
	sta PPU_CTRL
	cli

	rts
;------------------------------------------------------------------------------;
; MMC1_SetPRGBank
; Writes data to the MMC1 PRG Bank Register ($E000-$FFFF)

; Params:
; A			PRG bank to switch to.
; Note: the value includes the PRG-RAM disable toggle in bit 4.

MMC1_SetPRGBank:
	sta mmc1Data

	; check if the bank is already loaded
	cmp curPrgBank
	beq @exit

	; disable interrupts and save current PPU control
	sei
	lda int_ppuCtrl
	pha
	jsr ppu_disableNMI

	; write PRG bank
	lda mmc1Data
	sta curPrgBank
	sta MMC1_Prg
	lsr a
	sta MMC1_Prg
	lsr a
	sta MMC1_Prg
	lsr a
	sta MMC1_Prg
	lsr a
	sta MMC1_Prg

	; restore current PPU control and re-enable interrupts
	pla
	sta int_ppuCtrl
	sta PPU_CTRL
	cli

@exit:
	rts
