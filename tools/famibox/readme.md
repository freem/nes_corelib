FamicomBox checksum generation tools
====================================
Despite having generalized names, these two source files are intended to
provide checksum data for the FamicomBox header found in some NES games.

With the included Makefile, the sources compile as follows:

fb_sectsum.c -> fbsectsum ("FamicomBox SECTion checkSUM")
fb_headsum.c -> fbheadsum ("FamicomBox HEADer checkSUM")

fbsectsum Usage
---------------
fbsectsum is used for creating PRG and CHR checksums.

"fbsectsum (infile)"
where infile is the binary file to create a checksum for.

The output is written to "(infile).chk", which can be included as a binary in
your FamicomBox header, assuming it outputs the data in little endian.

fbheadsum Usage
---------------
fbheadsum creates the checksum for the FamicomBox header.

"fbheadsum (infile)"
where infile is the binary output of the FamicomBox header.
Checksum values for PRG and CHR should be included, and the FamicomBox header
checksum should be set to 0. The checksum is placed into the binary file at
the proper location.

License
-------
These tools are released under the following licenses; choose whatever suits you:
- public domain
- unlicense
- wtfpl

The programs are short enough that there really is no need for me to assert any
sort of copyright on them. Both source files are under 100 lines, including
comments and whitespace. The code is simple enough that anyone with a basic idea
of C could have probably written it themselves.
