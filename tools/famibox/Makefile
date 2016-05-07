CC = tcc
INFILE_SSUM = fb_sectsum.c
INFILE_HSUM = fb_headsum.c
OUTFILE_SSUM = fbsectsum
OUTFILE_HSUM = fbheadsum

.phony: all clean

all: $(OUTFILE_SSUM) $(OUTFILE_HSUM)

$(OUTFILE_SSUM):
	$(CC) -o $@ $(INFILE_SSUM)

$(OUTFILE_HSUM):
	$(CC) -o $@ $(INFILE_HSUM)

clean:
	$(RM) $(OUTFILE_SSUM) $(OUTFILE_HSUM)
