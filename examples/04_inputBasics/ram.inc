; RAM.inc - RAM layout (shared variables, defines, etc.)
;==============================================================================;
;-- zero page --------------------------------;
	; $00-$0F: "Operating Space"
	; temp space for function arguments, etc.
	.enum $0000
		tmp00			.dsb 1, $00
		tmp01			.dsb 1, $00
		tmp02			.dsb 1, $00
		tmp03			.dsb 1, $00
		tmp04			.dsb 1, $00
		tmp05			.dsb 1, $00
		tmp06			.dsb 1, $00
		tmp07			.dsb 1, $00
		tmp08			.dsb 1, $00
		tmp09			.dsb 1, $00
		tmp0A			.dsb 1, $00
		tmp0B			.dsb 1, $00
		tmp0C			.dsb 1, $00
		tmp0D			.dsb 1, $00
		tmp0E			.dsb 1, $00
		tmp0F			.dsb 1, $00
	.ende

	; $10-??: System Variables
	.enum $0010
		vblanked			.dsb 1			; are we in vblank?
		frameCount			.dsw 1			; frame counter

		; internal ppu control variables
		int_ppuCtrl			.dsb 1			; internal PPU_CTRL (last2000)
		int_ppuMask			.dsb 1			; internal PPU_MASK (last2001)
		int_ppuStatus		.dsb 1			; internal PPU_STATUS read (last2002)
		int_scrollX			.dsb 1			; internal PPU_SCROLL (first write)
		int_scrollY			.dsb 1			; internal PPU_SCROLL (second write)
		int_last4016		.dsb 1			; last write to $4016

		; controller input variables
		pad1Trigger			.dsb 1			; Momentary input
		pad2Trigger			.dsb 1			; "UpDown" in some sources.
		pad1State			.dsb 1			; Continued input?
		pad2State			.dsb 1			; "Data" in some sources.

		; vram buffer variables
	.ende

	; tokumaru's tile decompression code vars at $C0-$DF
	; mapper-specific variables typically at $E0-$EF (use more space if needed?)

;-- $0300 page --------------------------------;
	; This page holds the various PPU buffers (VRAM and Palette).
	.enum $0300
		vramBufData		.dsb $E0			; $0300-$03DF: vram buffer data
		palBufData		.dsb $20			; $03E0-$03FF: palette buf data
	.ende

;-- $0400-$07FF can be used by the program.
