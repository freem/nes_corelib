# Skeleton Makefile for building a NES project with asm6.

# ASM6: executable name of asm6 you wish to use.
ASM6 = asm6

# target "all"
# create ROM image from asm files (quick and dirty)
all:
	$(ASM6) 00_skeleton.asm 00_skeleton.nes

# tell make that "clean" is a phony target. (todo: explain)
PHONY: clean

# target "clean"
# remove any ROM images.
clean:
	rm *.nes
