# freemco NES corelib makefile
################################################################################
# this primarily exists for creating the documentation.
################################################################################
TOOL_NATURALDOCS = naturaldocs

DOCS_INPUT_SRC = src

DOCS_PROJDIR = ndocs
DOCS_OUTDIR = pages
DOCS_OUTFORMAT = HTML

.phony: all

all:
	$(TOOL_NATURALDOCS) -i $(DOCS_INPUT_SRC) -o $(DOCS_OUTFORMAT) $(DOCS_OUTDIR) -p $(DOCS_PROJDIR)
