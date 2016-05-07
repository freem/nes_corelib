/* famicombox header checksum calculator ($FFF2-$FFF8) */

#include <stdio.h>
#include <inttypes.h>

/* algorithm is $00 minus the bytes at $FFF2-$FFF8 (file offset 0x12 in a standalone header binary) */

void usage(){
	puts("usage: fbheadsum (infile)");
}

int main(int argc, char *argv[]){
	uint8_t headsum = 0;
	FILE *inFile;
	FILE *outFile;
	int c;
	char *outName = "header.chk";

	puts("FamicomBox header checksum calculator ($FFF2-$FFF8)");

	if(argc < 2){
		usage();
		return;
	}

	/* try opening file */
	inFile = fopen(argv[1],"rb");
	if(inFile == NULL){
		printf("Error opening input file '%s",argv[1]);
		perror("'");
		return;
	}

	/* seek to correct location in bin (0x12) */
	fseek(inFile,0x12,SEEK_SET);

	/* checksum file */
	do {
		c = getc(inFile);
		headsum -= c;
	} while(c !=EOF);
	fclose(inFile);

	/* print result */
	printf("Checksum of '%s' is 0x%02X (depending on architecture endian...)\n",argv[1],headsum);

	/* write to input file at the proper location (0x19) */
	outFile = fopen(argv[1],"r+b");

	/* write to out file */
	if(outFile == NULL){
		printf("Error opening output file '%s",outName);
		perror("'");
		return;
	}

	/* outFile */
	fseek(outFile,0x19,SEEK_SET);
	fwrite(&headsum,sizeof(uint8_t),1,outFile);
	fclose(outFile);

	return 0;
}
