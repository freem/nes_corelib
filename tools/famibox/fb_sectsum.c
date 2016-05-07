/* checksum calculator for famicombox header sections */

#include <stdio.h>
#include <inttypes.h>

void usage(){
	puts("usage: fbsectsum (infile)");
}

int main(int argc, char *argv[]){
	uint16_t checksum = 0;
	FILE *inFile;
	FILE *outFile;
	int c;
	char outName[128];

	puts("FamicomBox header section checksum calculator");

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

	/* checksum file */
	do {
		c = getc(inFile);
		checksum += c;
	} while(c !=EOF);
	fclose(inFile);

	/* print result */
	printf("Checksum of '%s' is 0x%04X (depending on architecture endian...)\n",argv[1],checksum);

	sprintf(outName,"%s.chk",argv[1]);

	/* write to file */
	outFile = fopen(outName,"wb");
	if(outFile == NULL){
		printf("Error opening output file '%s",outName);
		perror("'");
		return;
	}
	/* outFile */
	fwrite(&checksum,sizeof(uint16_t),1,outFile);
	fclose(outFile);

	return 0;
}
