########
# How to make PostScript docs from man pages

SUFFIXEN = $(SUFFIXES) .tr .ms .tbl .eqn .ps .man .3 .5 .3.ps .5.ps \
	   .dvi .tex

.SUFFIXES: $(SUFFIXEN)

PSFILTER = /usr/lib/lp/postscript/dpost

.3.3.ps:
	eqn $< | tbl | troff -man | $(PSFILTER) > $@

.5.5.ps:
	eqn $< | tbl | troff -man | $(PSFILTER) > $@

.tex.dvi:
	nllatex $<

.dvi.ps:
	dvips -o $@ $<

.eqn.ps:
	eqn $< | tbl | troff -ms | $(PSFILTER) > $@
#
########

.tbl.ps:
	tbl $< | troff -ms | $(PSFILTER) > $@
#
########

.ms.ps:
	troff -ms $< | $(PSFILTER) > $@
#
########

.tr.ps:
	troff $< | $(PSFILTER) > $@

.man.ps:
	eqn $< | tbl | troff -man | $(PSFILTER) > $@

.c.ps:
	vgrind $< | $(PSFILTER) > $@
#
########

all: word_grammar.5.ps
