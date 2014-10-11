ASM6 = asm6

all: nes famicom

# build NES/AV Famicom version (Player 2 uses normal controller)
nes:
	$(ASM6) 04_inputBasics.asm 04_inputBasics.nes

# build original Famicom version (Player 2 has microphone)
famicom:
	$(ASM6) -dFAMICOM 04_inputBasics.asm 04_inputBasics_f.nes

PHONY: clean

clean:
	rm *.nes
