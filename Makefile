# freemco NES corelib makefile
################################################################################
# this primarily exists for creating the documentation.

# at some point I should probably consider having it create the examples...
# not sure if that's a job for the exampled directory, though.
################################################################################
TOOL_NATURALDOCS = naturaldocs

DOCS_INPUT_SRC = src

DOCS_PROJDIR = ndocs
DOCS_OUTDIR = pages
DOCS_OUTFORMAT = HTML

.phony: all

all:
	$(TOOL_NATURALDOCS) -i $(DOCS_INPUT_SRC) -o $(DOCS_OUTFORMAT) $(DOCS_OUTDIR) -p $(DOCS_PROJDIR)
