#ident "@(#)Makefile	1.2 15/11/24"

NEW	= alphabet anwb lexicon word_grammar
SCCS	= ../../../lib/hebrew/SCCS
SYN0X   = ArgumentsList ClTypesList CodesList ParsingList\
	  QuotActorsList QuotList clause.struc lexcond lexcondcl\
	  lexset loc.ref morfcond morfcondcl morfset phrase.param\
	  phrset time.ref verbLexList verblessList verbvalList

all: $(NEW) $(SYN0X)

alphabet: $(SCCS)/s.alphabet
	get -r1.1.1 $(SCCS)/s.alphabet

lexicon: $(SCCS)/s.lexicon lexdif.sed
	get -p -r1 $(SCCS)/s.lexicon | sed -f lexdif.sed > $@

word_grammar: $(SCCS)/s.word_grammar
	get -r1.5.1 $(SCCS)/s.word_grammar
