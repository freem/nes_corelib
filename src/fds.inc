; File: fds.inc
; various Famicom Disk System-related defines.
;==============================================================================;
; Section: Main FDS Registers
; The primary FDS registers.

; Constant: FDS_TIMER_RELOAD_LOW
; Timer IRQ Reload Value Low. ($4020)
FDS_TIMER_RELOAD_LOW = $4020

; Constant: FDS_TIMER_RELOAD_HIGH
; Timer IRQ Reload Value High. ($4021)
FDS_TIMER_RELOAD_HIGH = $4021

; Constant: FDS_TIMER_IRQ_CONTROL
; Timer IRQ Control. ($4022)
;
; (start code)
; [Write]
;
; 76543210
; xxxxxx||
;       |+-- Timer IRQ Repeat Flag
;       +--- Timer IRQ Enabled
; (end)
FDS_TIMER_IRQ_CONTROL = $4022

; Constant: FDS_IO_ENABLE
; I/O Enable. ($4023)
;
; "Disabling disk registers disables both disk and timer IRQs."
;
; (start code)
; [Write]
;
; 76543210
; |xxxxx||
; |     |+-- Enable disk I/O registers
; |     +--- Enable sound I/O registers
; +--------- unknown
; (end)
FDS_IO_ENABLE = $4023

; Constant: FDS_WRITE_DATA_REG
; Write Data Register ($4024)
;
; "The data that this register is programmed with will be the next 8-bit
; quantity to load into the shift register (next time the byte transfer
; flag raises), and to be shifted out and appear on pin 5 of the RAM adapter
; cable (2C33 pin 52)."
FDS_WRITE_DATA_REG = $4024

; Constant: FDS_CONTROL
; FDS Control ($4025)
;
; (start code)
; [Write]
;
; 76543210
; ||||||||
; |||||||+-- Transfer Reset (1=reset transfer timing to initial state)
; ||||||+--- Drive Motor Control (0=start, 1=stop)
; |||||+---- Transfer Mode (0=write, 1=read)
; ||||+----- Nametable Arrangement (0=horizontal (v mirror), 1=vertical (h mirror))
; |||+------ CRC Transfer Control (1=transfer CRC)
; ||+------- Unknown, always set to 1
; |+-------- CRC Enable/Disable (0=disable/reset, 1=enable)
; +--------- Interrupt Enabled (1=generate IRQ every time the byte transfer flag is raised)
; (end)
FDS_CONTROL = $4025

; Constant: FDS_EXTERNAL_CONNECTOR_OUT
; External Connector output ($4026)
;
; "Output of expansion terminal where there's a shutter on the back of
; the RAM adapter. The outputs of $4026 (open-collector with 4.7K ohm pull-ups
; (except on bit 7)), are shared with the inputs on $4033."
FDS_EXTERNAL_CONNECTOR_OUT = $4026

; Constant: FDS_DISK_STATUS
; Disk Status Register ($4030)
;
; (start code)
; [Write]
;
; 76543210
; ||x||x||
; || || |+-- Timer Interrupt (1=IRQ occurred)
; || || +--- "unknown interrupt source"
; || |+----- Nametable Arrangement (see $4025 d3)
; || +------ CRC control (0=CRC passted, 1=CRC error)
; |+-------- End of Head (1=disk head is on innermost track)
; +--------- Byte Transfer Flag
; (end)
FDS_DISK_STATUS = $4030

; Constant: FDS_READ_DATA_REG
; Read Data Register ($4031)
;
; "This register is loaded with the contents of an internal shift register
; every time the byte transfer flag raises. The shift register receives its
; serial data via pin 9 of the RAM adapter cable (2C33 pin 51)."
FDS_READ_DATA_REG = $4031

; Constant: FDS_DRIVE_STATUS
; Disk Drive Status ($4032)
;
; (start code)
; [Read]
;
; 76543210
; xxxxx|||
;      ||+-- Disk Flag (0=disk inserted, 1=no disk inserted)
;      |+--- Ready Flag (0=disk ready, 1=disk not ready)
;      +---- Protect Flag (0=not write protected, 1=write protected or disk ejected)
; (end)
FDS_DRIVE_STATUS = $4032

; Constant: FDS_EXTERNAL_CONNECTOR_IN
; External Connector Read ($4033)
;
; (start code)
; [Read]
;
; 76543210
; ||||||||
; |+++++++-- input from RAM adapter expansion terminal
; +--------- Battery Status (0=low voltage, 1=good; Motor must be on/enabled to check)
; (end)
FDS_EXTERNAL_CONNECTOR_IN = $4033

;==============================================================================;
; Section: Audio Registers
; The FDS audio-related registers.

; Constant: FDS_AUDIO_WAVETABLE_RAM
; Wavetable ram ($4040-$407F)
FDS_AUDIO_WAVETABLE_RAM = $4040

; Constant: FDS_AUDIO_WAVETABLE_RAM_SIZE
; Size of wavetable RAM section.
FDS_AUDIO_WAVETABLE_RAM_SIZE = FDS_AUDIO_VOLUME_ENVELOPE-FDS_AUDIO_WAVETABLE_RAM

; Constant: FDS_AUDIO_VOLUME_ENVELOPE
; Volume envelope. ($4080)
;
; (start code)
; [Write]
;
; 76543210
; MDVVVVVV
; ||||||||
; ||++++++-- Volume envelope speed (if M==1, also controls volume gain)
; |+-------- Volume change direction (0=decrease, 1=increase)
; +--------- Volume envelope mode (0=on, 1=off)
; (end)
FDS_AUDIO_VOLUME_ENVELOPE = $4080

; Constant: FDS_AUDIO_FREQUENCY_LOW
; frequency low ($4082; write)
FDS_AUDIO_FREQUENCY_LOW = $4082

; Constant: FDS_AUDIO_FREQUENCY_HIGH
; frequency high ($4083)
;
; (start code)
; [Write]
;
; 76543210
; ||xx||||
; ||  ++++-- frequency bits 8-11
; |+-------- "Disable volume and sweep envelopes (but not modulation)"
; +--------- "When enabled, envelopes run 4x faster. Also stops the mod table accumulator."
; (end)
FDS_AUDIO_FREQUENCY_HIGH = $4083

; Constant: FDS_AUDIO_MOD_ENVELOPE
; mod envelope ($4084)
;
; (start code)
; [Write]
;
; 76543210
; MDSSSSSS
; ||||||||
; ||++++++-- Mod envelope speed (if M==1, also controls mod gain)
; |+-------- Mod envelope direction (0=decrease, 1=increase)
; +--------- Mod envelope mode (0=on, 1=off)
; (end)
FDS_AUDIO_MOD_ENVELOPE = $4084

; Constant: FDS_AUDIO_MOD_COUNTER
; mod counter ($4085)
;
; (start code)
; [Write]
;
; 76543210
; x|||||||
;  +++++++-- Mod counter (7 bit signed, minimum $40, maximum $3F)
; (end)
FDS_AUDIO_MOD_COUNTER = $4085

; Constant: FDS_AUDIO_MOD_FREQUENCY_LOW
; mod frequency low ($4086, write)
FDS_AUDIO_MOD_FREQUENCY_LOW = $4086

; Constant: FDS_AUDIO_MOD_FREQUENCY_HIGH
; mod frequency high ($4087)
;
; (start code)
; [Write]
;
; 76543210
; ||xx||||
; ||  ++++-- Modulation frequency bits 8-11
; |+-------- "Force a carry out from bit 11 of mod accumulator. Step every clock."
; +--------- Halt mod table counter
; (end)
FDS_AUDIO_MOD_FREQUENCY_HIGH = $4087

; Constant: FDS_AUDIO_MOD_TABLE_WRITE
; mod table write ($4088)
; "This register has no effect unless the mod unit is disabled via the high bit of $4087."
; (start code)
; [Write]
;
; 76543210
; xxxxx|||
;      +++-- Modulation input
; (end)
FDS_AUDIO_MOD_TABLE_WRITE = $4088

; Constant: FDS_AUDIO_WAVE_WRITE_MASTER_VOLUME
; wave write/master volume ($4089)
;
; (start code)
; [Write]
;
; 76543210
; |xxxxx||
; |     ++-- Master Volume (0=full, 1=2/3, 2=1/2, 3=2/5)
; +--------- Wavetable write enable (0=write protect, 1=write enable and hold channel)
; (end)
FDS_AUDIO_WAVE_WRITE_MASTER_VOLUME = $4089

; Constant: FDS_AUDIO_ENVELOPE_SPEED
; $408A envelope speed (write)
FDS_AUDIO_ENVELOPE_SPEED = $408A

; Constant: FDS_AUDIO_VOLUME_GAIN
; volume gain ($4090)
;
; (start code)
; [Read]
;
; 76543210
; xx||||||
;   ++++++-- Current volume gain level (see $4080)
; (end)
FDS_AUDIO_VOLUME_GAIN = $4090

; Constant: FDS_AUDIO_WAVE_ACCUMULATOR
; wave accumulator ($4091)
;
; (start code)
; [Read]
;
; 76543210
; ||||||||
; ++++++++-- "Bits 12-19 of the wavetable address accumulator"
; (end)
FDS_AUDIO_WAVE_ACCUMULATOR = $4091

; Constant: FDS_AUDIO_MOD_GAIN_READ
; mod gain ($4092)
;
; (start code)
; [Read]
;
; 76543210
; xx||||||
;   ++++++-- Current mod gain level (see $4084)
; (end)
FDS_AUDIO_MOD_GAIN_READ = $4092

; Constant: FDS_AUDIO_MOD_ACCUMULATOR_READ
; mod table address accumulator ($4093)
;
; (start code)
; [Read]
;
; 76543210
; x|||||||
;  +++++++-- "Bits 5-11 of the mod table address accumulator"
; (end)
FDS_AUDIO_MOD_ACCUMULATOR_READ = $4093

; Constant: FDS_AUDIO_MOD_COUNTER_TIMES_GAIN
; mod counter*gain result ($4094)
;
; (start code)
; [Read]
;
; 76543210
; ||||||||
; ++++++++-- "Bits 4-11 of mod counter*gain intermediate result"
; (end)
FDS_AUDIO_MOD_COUNTER_TIMES_GAIN = $4094

; Constant: FDS_AUDIO_MOD_COUNTER_INCREMENT
; mod counter increment ($4095)
;
; (start code)
; [Read]
;
; 76543210
; ||||||||
; ||||++++-- "Next mod counter (FDS_AUDIO_MOD_COUNTER) increment."
; ++++------ "unknown counter"
; (end)
FDS_AUDIO_MOD_COUNTER_INCREMENT = $4095

; Constant: FDS_AUDIO_WAVETABLE_READ
; wavetable value ($4096)
;
; (start code)
; [Read]
;
; 76543210
; xx||||||
;   ++++++-- "Value at current wavetable position, masked by PWM from volume envelope."
; (end)
FDS_AUDIO_WAVETABLE_READ = $4096

; Constant: FDS_AUDIO_MOD_COUNTER_VALUE
; $4097 mod counter value ($4097)
;
; (start code)
; [Read]
;
; 76543210
; x|||||||
;  +++++++-- Current mod counter value (see FDS_AUDIO_MOD_COUNTER)
; (end)
FDS_AUDIO_MOD_COUNTER_VALUE = $4097

;==============================================================================;
; Section: Game vectors around $DFFx
; The FDS BIOS expects the game to set its own vectors for NMI, Reset, and IRQ.

; Constant: FDS_GAME_NMI_VECTOR_1
; Disk Game NMI vector 1 (value at $0100 = %01xxxxxx) ($DFF6)
FDS_GAME_NMI_VECTOR_1 = $DFF6

; Constant: FDS_GAME_NMI_VECTOR_2
; Disk Game NMI vector 2 (value at $0100 = %10xxxxxx) ($DFF8)
FDS_GAME_NMI_VECTOR_2 = $DFF8

; Constant: FDS_GAME_NMI_VECTOR_3
; Disk Game NMI vector 3 (value at $0100 = %11xxxxxx) ($DFFA)
FDS_GAME_NMI_VECTOR_3 = $DFFA

; Constant: FDS_GAME_RESET_VECTOR
; Disk Game Reset vector ($DFFC)
FDS_GAME_RESET_VECTOR = $DFFC

; Constant: FDS_GAME_IRQ_VECTOR
; Disk Game IRQ vector ($DFFE)
FDS_GAME_IRQ_VECTOR = $DFFE

;==============================================================================;
; fds unsorted routine pile
;==============================================================================;
;LE229 = $E229 ; in the middle of __e224
;LE3E7 = $E3E7 ; ("GetHCPwNWPchk"-brad, "readsetup"-loopy)
;LE7AD = $E7AD ; ("DecPtr0C"-brad, "decCD"-loopy)
;LFE40 = $FE40
;LFEFE = $FEFE
;LFF5D = $FF5D

;==============================================================================;
; Section: FDS BIOS disk access routines

; Routine: FDSBIOS_LoadFiles
; Located at $E1F8 in the FDS BIOS.
;
; Parameters:
; *ReturnAddr* - pointer to 10 byte disk header compare string
; *ReturnAddr+2* - pointer to list of files to identify & load
;
; Returns:
; - *A* - Error number (if any)
; - *Y* - Number of files found
FDSBIOS_LoadFiles = $E1F8

; Routine: FDSBIOS_AppendFile
; Located at $E237 in the FDS BIOS.
FDSBIOS_AppendFile = $E237

; Routine: FDSBIOS_WriteFile
; Located at $E239 in the FDS BIOS.
FDSBIOS_WriteFile = $E239

; Routine: FDSBIOS_CheckFileCount
; Located at $E2B7 in the FDS BIOS.
FDSBIOS_CheckFileCount = $E2B7

; Routine: FDSBIOS_AdjustFileCount
; Located at $E2BB in the FDS BIOS.
FDSBIOS_AdjustFileCount = $E2BB

; Routine: FDSBIOS_SetFileCount1
; Sets the file count to A+1.
; Located at $E301 in the FDS BIOS.
FDSBIOS_SetFileCount1 = $E301

; Routine: FDSBIOS_SetFileCount
; Located at $E305 in the FDS BIOS.
FDSBIOS_SetFileCount = $E305

; Routine: FDSBIOS_GetDiskInfo
; Located at $E32A in the FDS BIOS.
;
; Parameters:
; - *ReturnAddr* - Pointer to disk information
;
; Returns:
; - *A* - Error number (if any)
FDSBIOS_GetDiskInfo = $E32A

;==============================================================================;
; Section: FDS BIOS low-level disk access routines

; Routine: FDSBIOS_CheckDiskHeader
; Compares the first 10 bytes after the *NINTENDO-HVC* string to the 10 bytes
; pointed to by $00. (To bypass checks, place -1 (0xFF) in the compare string.)
;
; (Natural Docs assumes anything surrounded in asterisks is bold and does not
; provide an escape sequence; the above mention of NINTENDO-HVC includes
; asterisks around it.)
;
; Located at $E445 in the FDS BIOS.
;
; Parameters:
; - *$00,$01* - Pointer to disk information table
FDSBIOS_CheckDiskHeader = $E445

; Routine: FDSBIOS_GetNumFiles
; Loads the number of files recorded in block type #2 into $06.
; This may not be the actual amount of files on the disk!
;
; Located at $E484 in the FDS BIOS.
;
; Returns:
; - *$06* - Number of files on disk, according to the block type.
FDSBIOS_GetNumFiles = $E484

; Routine: FDSBIOS_SetNumFiles
; Writes the number of files to be recorded onto the disk.
;
; Located at $E492 in the FDS BIOS.
;
; Parameters:
; - *A* - Number of files to write.
FDSBIOS_SetNumFiles = $E492

; Routine: FDSBIOS_FileMatchTest
; Located at $E4A0 in the FDS BIOS.
;
; Parameters:
; - *$02,$03* - pointer to list of files to load, terminated by $FF
FDSBIOS_FileMatchTest = $E4A0

; Routine: FDSBIOS_SkipFiles
; Located at $E4DA in the FDS BIOS.
;
; Skip file count is in $06.
FDSBIOS_SkipFiles = $E4DA

;==============================================================================;
; Section: FDS BIOS low-level disk drive routines
; Hopefully, you don't actually need to use these, but just in case...

; Routine: FDSBIOS_WaitDriveReady
; Located at $E64D in the FDS BIOS.
FDSBIOS_WaitDriveReady = $E64D

; Routine: FDSBIOS_StopMotor
; Located at $E685 in the FDS BIOS.
FDSBIOS_StopMotor = $E685

; Routine; FDSBIOS_CheckBlockType
; Located at $E68F in the FDS BIOS.
FDSBIOS_CheckBlockType = $E68F

; Routine: FDSBIOS_WriteBlockType
; Located at $E6B0 in the FDS BIOS.
FDSBIOS_WriteBlockType = $E6B0

; Routine: FDSBIOS_StartTransfer
; Located at $E6E3 in the FDS BIOS.
FDSBIOS_StartTransfer = $E6E3

; Routine: FDSBIOS_EndBlockRead
; Located at $E706 in the FDS BIOS.
FDSBIOS_EndBlockRead = $E706

; Routine: FDSBIOS_EndBlockWrite
; Located at $E729 in the FDS BIOS.
FDSBIOS_EndBlockWrite = $E729

; Routine: FDSBIOS_CheckDiskSet
; Located at $E74C in the FDS BIOS.
FDSBIOS_CheckDiskSet = $E74C

; Routine: FDSBIOS_TransferDone
; Located at $E778 in the FDS BIOS.
FDSBIOS_TransferDone = $E778

; Routine: FDSBIOS_TransferError
; Located at $E781 in the FDS BIOS.
FDSBIOS_TransferError = $E781

; Routine: FDSBIOS_TransferByte
; Located at $E7A3 in the FDS BIOS.
FDSBIOS_TransferByte = $E7A3

;==============================================================================;
; Section: other FDS BIOS routines

; Routine: FDSBIOS_Delay132
; Delays for 132 clock cycles.
; Located at $E149 in the FDS BIOS.
FDSBIOS_Delay132 = $E149

; Routine: FDSBIOS_DelayMs
; "Delay in clock cycles is: 1790*Y+5."
; Located at $E153 in the FDS BIOS.
;
; Parameters:
; - *Y* - Delay count
FDSBIOS_DelayMs = $E153

; Routine: FDSBIOS_DisPFObj
; Disable Sprites and BG (Disable Playfield and Objects).
; Located at $E161 in the FDS BIOS.
FDSBIOS_DisPFObj = $E161

; Routine: FDSBIOS_EnPFObj
; Enable Sprites and BG (Enable Playfield and Objects).
; Located at $E16B in the FDS BIOS.
FDSBIOS_EnPFObj = $E16B

; Routine: FDSBIOS_DisObj
; Disable Sprites.
; Located at $E171 in the FDS BIOS.
FDSBIOS_DisObj = $E171

; Routine: FDSBIOS_EnObj
; Enable Sprites.
; Located at $E178 in the FDS BIOS.
FDSBIOS_EnObj = $E178

; Routine: FDSBIOS_DisPF
; Disable Background.
; Located at $E17E in the FDS BIOS.
FDSBIOS_DisPF = $E17E

; Routine: FDSBIOS_EnPF
; Enable Background.
; Located at $E185 in the FDS BIOS.
FDSBIOS_EnPF = $E185

; Routine: FDSBIOS_VINTWait
; Wait until next VBL NMI and return; further vblanks are disabled.
; Located at $E1B2 in the FDS BIOS.
FDSBIOS_VINTWait = $E1B2

; Routine: FDSBIOS_VRAMStructWrite
; VRAM structure write. A two-byte address should follow the jsr to this routine.
; Located at $E7BB in the FDS BIOS.
FDSBIOS_VRAMStructWrite = $E7BB

; Routine: FDSBIOS_FetchDirectPtr
; Fetch a pointer located just after a jsr.
; Located at $E844 in the FDS BIOS.
FDSBIOS_FetchDirectPtr = $E844

; Routine: FDSBIOS_WriteVRAMBuffer
; Transfers VRAM buffer starting at $0302 to VRAM.
; Located at $E86A in the FDS BIOS.
FDSBIOS_WriteVRAMBuffer = $E86A

; Routine: FDSBIOS_ReadVRAMBuffer
; Read bytes from the VRAM to the VRAM buffer.
;
; Located at $E8B3 in the FDS BIOS.
;
; Parameters:
; - *X* - Start address of read buffer
; - *Y* - number of bytes to read
FDSBIOS_ReadVRAMBuffer = $E8B3

; Routine: FDSBIOS_PrepareVRAMString
; Copy pointed data into the VRAM buffer.
;
; Located at $E8D2 in the FDS BIOS.
;
; Parameters:
; - *A* - NT address high byte
; - *X* - NT address low byte
; - *Y* - string length
; - *ReturnAddr* - pointer to data to write
FDSBIOS_PrepareVRAMString = $E8D2

; Routine: FDSBIOS_PrepareVRAMStrings
; Copy a 2-dimensional string into the VRAM buffer.
; "The first byte of the data determines the width and height of the following
; string (in tiles): Upper nybble = height, lower nybble = width."
;
; Located at $E8E1 in the FDS BIOS.
;
; Parameters:
; - *A* - NT address high byte
; - *X* - NT address low byte
; - *ReturnAddr* - pointer to data to write
FDSBIOS_PrepareVRAMStrings = $E8E1

; Routine: FDSBIOS_GetVRAMBufferByte
;
; Located at $E94F in the FDS BIOS.
;
; Parameters:
; - *X* - Read buffer start index
; - *Y* - Number of address to compare
; - *$00,$01* - read address
FDSBIOS_GetVRAMBufferByte = $E94F

; Routine: FDSBIOS_Pixel2NamConv
; Converts a pixel position to nametable coordinates.
;
; Located at $E97D in the FDS BIOS.
;
; Parameters:
; - *$02* - Pixel Y coordinate
; - *$03* - Pixel X coordinate
;
; Returns:
; - *$00* - NT address high byte
; - *$01* - NT address low byte
FDSBIOS_Pixel2NamConv = $E97D

; Routine: FDSBIOS_Nam2PixelConv
; Converts nametable coordinates to a pixel position.
;
; Located at $E997 in the FDS BIOS.
;
; Parameters:
; - *$00* - NT address high byte
; - *$01* - NT address low byte
;
; Returns:
; - *$02* - Pixel Y coordinate
; - *$03* - Pixel X coordinate
FDSBIOS_Nam2PixelConv = $E997

; Routine: FDSBIOS_Random
;
; Located at $E9B1 in the FDS BIOS.
;
; Parameters:
; X = Zero Page address where the random bytes are placed
; Y = # of shift register bytes (normally $02) 
FDSBIOS_Random = $E9B1

; Routine: FDSBIOS_SpriteDMA
; Transfers sprites to the PPU. Uses the $200 area.
; Located at $E9C8 in the FDS BIOS.
FDSBIOS_SpriteDMA = $E9C8

; FDSBIOS_CounterLogic = $E9D3

; Routine: FDSBIOS_ReadPads
; Located at $E9EB in the FDS BIOS.
FDSBIOS_ReadPads = $E9EB

; Routine: FDSBIOS_OrPads
; pad values OR'd with data in $00 (pad1) and $01 (pad2)
; Located at $EA0D in the FDS BIOS.
FDSBIOS_OrPads = $EA0D

; Routine: FDSBIOS_ReadDownPads
; Located at $EA1A in the FDS BIOS.
FDSBIOS_ReadDownPads = $EA1A

; Routine: FDSBIOS_ReadOrDownPads
; Located at $EA1F in the FDS BIOS.
FDSBIOS_ReadOrDownPads = $EA1F

; Routine: FDSBIOS_ReadDownVerifyPads
; DMC-fortified controller read routine
; Located at $EA36 in the FDS BIOS.
FDSBIOS_ReadDownVerifyPads = $EA36

; Routine: FDSBIOS_ReadOrDownVerifyPads
; DMC-fortified controller read routine
; Located at $EA4C in the FDS BIOS.
FDSBIOS_ReadOrDownVerifyPads = $EA4C

; Routine: FDSBIOS_ReadDownExpPads
; Read expansion controller?
; Located at $EA68 in the FDS BIOS.
FDSBIOS_ReadDownExpPads = $EA68

; Routine: FDSBIOS_VRAMFill
; if A < $20, fill with X for 16 * Y tiles.
; if A >= $20, fill nametable with X and attributes with Y.
;
; Located at $EA84 in the FDS BIOS.
;
; Parameters:
; - *A* - High VRAM Address (aka tile row #)
; - *X* - Fill value
; - *Y* - # of tile rows OR attribute fill data
FDSBIOS_VRAMFill = $EA84

; Routine: FDSBIOS_MemFill
; fill RAM pages
;
; Located at $EAD2 in the FDS BIOS.
;
; Parameters:
; - *A* - Fill Value
; - *X* - First page number
; - *Y* - Last page number
FDSBIOS_MemFill = $EAD2

; Routine: FDSBIOS_SetScroll
; Sets scroll registers based on values in $FC, $FD, and $FF
; Located at $EAEA in the FDS BIOS.
FDSBIOS_SetScroll = $EAEA

; Routine: FDSBIOS_JumpEngine
; "RTS trick" jump table routine.
; After the jsr to this routine, place up to 128 pointers (256 bytes)
;
; Located at $EAFD in the FDS BIOS.
;
; Parameters:
; - *A* - jump table entry (calculated as (A << 1) + 1)
; - *ReturnAddr* - list of possible jump values
FDSBIOS_JumpEngine = $EAFD

; Routine: FDSBIOS_ReadKeyboard
; Located at $EB13 in the FDS BIOS.
FDSBIOS_ReadKeyboard = $EB13

; Routine: FDSBIOS_LoadTileset
; Loads a tileset.
;
; Located at $EBAF in the FDS BIOS.
;
; Parameters:
; A = Low VRAM address and flags
; Y = High VRAM address
; X = Number of tiles to transfer to/from VRAM
; ReturnAddr = source/destination address
FDSBIOS_LoadTileset = $EBAF

; Routine: FDSBIOS_UploadObject
; Upload an object to OAM data.
;
; Located at $EC22 in the FDS BIOS.
;
; Parameters:
; - *$00,$01* - pointer to object structure
FDSBIOS_UploadObject = $EC22

;==============================================================================;
; Section: Disk-related constants
; These constants are meant to be used when creating the disk layout.

; Constant: FDS_DISK_BLOCKTYPE_DISK_INFO
; Block type for disk information. (1)
FDS_DISK_BLOCKTYPE_DISK_INFO   = 1

; Constant: FDS_DISK_BLOCKTYPE_FILE_AMOUNT
; Block type for file count. (2)
FDS_DISK_BLOCKTYPE_FILE_AMOUNT = 2

; Constant: FDS_DISK_BLOCKTYPE_FILE_HEADER
; Block type for file header. (3)
FDS_DISK_BLOCKTYPE_FILE_HEADER = 3

; Constant: FDS_DISK_BLOCKTYPE_FILE_DATA
; Block type for file data. (4)
FDS_DISK_BLOCKTYPE_FILE_DATA   = 4

; Constant: FDS_DISK_FILETYPE_PRG
; Program data file type. (0)
FDS_DISK_FILETYPE_PRG  = 0

; Constant: FDS_DISK_FILETYPE_CHR
; Character data filetype. (1)
FDS_DISK_FILETYPE_CHR  = 1

; Constant: FDS_DISK_FILETYPE_VRAM
; VRAM/nametable data file type. (2)
FDS_DISK_FILETYPE_VRAM = 2
