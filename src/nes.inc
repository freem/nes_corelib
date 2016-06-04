; File: nes.inc
; various NES-related defines.

; Constant: PPU_CTRL
; Main PPU control register. ($2000)
;
; (start code)
; [Write]
;
; 76543210
; VPHBSINN
; ||||||||
; ||||||++-- Nametable select
; |||||+---- VRAM Increment mode (0=+1, 1=+32)
; ||||+----- Sprite tiles source (0=PPU $0000, 1=PPU $1000)
; |||+------ Background tiles source (0=PPU $0000, 1=PPU $1000)
; ||+------- Sprite height (0=8x8, 1=8x16)
; |+-------- PPU Master/Slave
; +--------- NMI enable
; (end)
PPU_CTRL		= $2000

; Constant: PPU_MASK
; PPU rendering mask. ($2001)
;
; (start code)
; [Write]
;
; 76543210
; BGRsbMmG
; ||||||||
; |||||||+-- Greyscale (0=off/Color, 1=on/greyscale)
; ||||||+--- Background display in leftmost 8 pixels (0=hide, 1=show)
; |||||+---- Sprite display in leftmost 8 pixels (0=hide, 1=show)
; ||||+----- Show background (0=hide, 1=show)
; |||+------ Show sprtes (0=hide, 1=show)
; ||+------- Red emphasis (NTSC)/Green emphasis (PAL)
; |+-------- Green emphasis (NTSC)/Red emphasis (PAL)
; +--------- Blue emphasis
; (end)
PPU_MASK		= $2001

; Constant: PPU_STATUS
; PPU status register. ($2002)
;
; (start code)
; [Read]
;
; 76543210
; VSOxxxxx
; ||||___|
; |||  |
; |||  +---- (last PPU register written bits)
; ||+------- Sprite overflow flag
; |+-------- Sprite 0 hit flag
; +--------- Vertical blank start (0=not in vblank, 1=in vblank)
; (end)
PPU_STATUS		= $2002

; Constant: OAM_ADDR
; OAM address port. ($2003)
;
; Probably easiest to write $00 here and have <OAM_DMA> handle the transfer.
OAM_ADDR		= $2003

; Constant: OAM_DATA
; OAM data port. ($2004)
;
; Mostly unused by games.
OAM_DATA		= $2004

; Constant: PPU_SCROLL
; PPU scroll register. ($2005)
;
; Write to this register twice to set the X and Y scroll.
PPU_SCROLL		= $2005

; Constant: PPU_ADDR
; PPU address register. ($2006)
;
; Write to this register twice (first with the address high byte, then the low byte)
; to set the PPU address.
PPU_ADDR		= $2006

; Constant: PPU_DATA
; PPU data register. ($2007)
;
; You can read and write data through this register. The PPU address will increment
; based on the relevant bit in <PPU_CTRL>.
PPU_DATA		= $2007

; Constant: OAM_DMA
; Perform OAM DMA transfer. ($4014)
OAM_DMA			= $4014

; Constant: OAM_BUF
; By default, the OAM buffer is placed at $0200. Edit this value to change where
; it should appear in memory (preferably on a $xx00 page).
OAM_BUF			= $0200

; Constants: Input Ports
; Named constants for input registers.
;
; JOYSTICK1 - Player 1 controls ($4016 normally, $4017 on VS System)
; JOYSTICK2 - Player 2 controls ($4017 normally, $4016 on VS System)
; VS_CONTROL - VS System control register ($4016; VS System only)
; COIN_COUNTER - Handles coins ($4020; VS System only)
.ifdef VS_SYSTEM
	VS_CONTROL		= $4016
	JOYSTICK2		= $4016
	JOYSTICK1		= $4017
	COIN_COUNTER	= $4020
.else
	JOYSTICK1		= $4016
	JOYSTICK2		= $4017
.endif

; Constants: Nametable addresses
; Named aliases for nametable addresses.
;
; PPU_NT0 - Nametable 0 data ($2000)
; PPU_ATTRIB0 - Nametable 0 attributes ($23C0)
; PPU_NT1 - Nametable 1 data ($2400
; PPU_ATTRIB1 - Nametable 1 attributes ($27C0)
; PPU_NT2 - Nametable 2 data ($2800)
; PPU_ATTRIB2 - Nametable 2 attributes ($2BC0)
; PPU_NT3 - Nametable 3 data ($2C00)
; PPU_ATTRIB3 - Nametable 3 attributes ($2FC0)
PPU_NT0			= $2000
PPU_ATTRIB0		= $23C0
PPU_NT1			= $2400
PPU_ATTRIB1		= $27C0
PPU_NT2			= $2800
PPU_ATTRIB2		= $2BC0
PPU_NT3			= $2C00
PPU_ATTRIB3		= $2FC0

; Constants: APU registers
; Named aliases for APU registers.
;
; APU_PULSE1_MAIN - Pulse 1 channel main register ($4000)
; APU_PULSE1_SWEEP - Pulse 1 channel sweep register ($4001)
; APU_PULSE1_TIMELO - Pulse 1 channel timer low ($4002)
; APU_PULSE1_LEN - Pulse 1 channel timer high, length counter ($4003)
; APU_PULSE2_MAIN - Pulse 2 channel main register ($4004)
; APU_PULSE2_SWEEP - Pulse 2 channel sweep register ($4005)
; APU_PULSE2_TIMELO - Pulse 2 channel timer low ($4006)
; APU_PULSE2_LEN - Pulse 2 channel timer high, length counter ($4007)
; APU_TRI_MAIN - Triangle channel main register ($4008)
; APU_TRI_TIMELO - Triangle channel timer low ($400A)
; APU_TRI_LEN - Triangle channel timer high, length counter ($400B)
; APU_NOISE_MAIN - Noise channel main register ($400C)
; APU_NOISE_LOOP - Noise period and loop noise ($400E)
; APU_NOISE_LEN - Noise channel length counter ($400F)
; APU_DMC_FREQ - DMC frequency index, loop sample, IRQ enable ($4010)
; APU_DMC_DIRECT - 7-bit load counter ($4011)
; APU_SAMP_ADDR - Sample address ($4012)
; APU_SAMP_LEN - Sample length ($4013)
; APU_STATUS - APU control register ($4015)
; APU_FRAMECOUNT - APU frame counter register ($4017)

APU_PULSE1_MAIN		= $4000
APU_PULSE1_SWEEP	= $4001
APU_PULSE1_TIMELO	= $4002
APU_PULSE1_LEN		= $4003
;--;
APU_PULSE2_MAIN		= $4004
APU_PULSE2_SWEEP	= $4005
APU_PULSE2_TIMELO	= $4006
APU_PULSE2_LEN		= $4007
;--;
APU_TRI_MAIN		= $4008
; $4009 is unused
APU_TRI_TIMELO		= $400A
APU_TRI_LEN			= $400B
;--;
; unsure if these names are good...
APU_NOISE_MAIN		= $400C
; $400D is unused
APU_NOISE_LOOP		= $400E
APU_NOISE_LEN		= $400F
;--;
APU_DMC_FREQ		= $4010
APU_DMC_DIRECT		= $4011		; 7-bit load counter
APU_SAMP_ADDR		= $4012
APU_SAMP_LEN		= $4013
;--;
APU_STATUS			= $4015		; status and control
APU_FRAMECOUNT		= $4017

; Constants: APU channel masks
; 2A03 channel bitmasks (for use with $4015/APU_STATUS and/or apu_enableChan)
;
; APU_CHAN1 - Pulse 1
; APU_CHAN2 - Pulse 2
; APU_CHAN3 - Triangle
; APU_CHAN4 - Noise
; APU_CHAN5 - DPCM
APU_CHAN1 = %00000001			; pulse 1
APU_CHAN2 = %00000010			; pulse 2
APU_CHAN3 = %00000100			; triangle
APU_CHAN4 = %00001000			; noise
APU_CHAN5 = %00010000			; dpcm

; Constants: Joypad defines
; Various button masks.
;
; PAD_A - A Button
; PAD_B - B Button
; PAD_SELECT - Select Button
; PAD_START - Start Button
; PAD_UP - D-Pad Up
; PAD_DOWN - D-Pad Down
; PAD_LEFT - D-Pad Left
; PAD_RIGHT - D-Pad Right
PAD_A			= %10000000
PAD_B			= %01000000
PAD_SELECT		= %00100000
PAD_START		= %00010000
PAD_UP			= %00001000
PAD_DOWN		= %00000100
PAD_LEFT		= %00000010
PAD_RIGHT		= %00000001
