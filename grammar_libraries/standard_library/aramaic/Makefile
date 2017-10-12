#ident "@(#)Makefile	1.5 15/02/18"

SCCS	= ../../../lib/aramaic/SCCS

NEW	= alphabet anwb lexicon word_grammar

ANALYZEPHRSET	= phrase.param
PARSEPHRASES	= phrase.suggest
PARSECLAUSES	= $(PC_INPUT) $(PC_REQUIRED)
PC_INPUT	= clause.struc lexcondcl morfcondcl
PC_REQUIRED	= loc.ref time.ref verblessList verbvalList
ST_INPUT	= ClTypesList CodesList ParsingList verbLexList
ST_REQUIRED	= ArgumentsList QuotActorsList QuotList
SYN01		= morfset
SYN02		= lexset
SYN03		= lexcond morfcond phrset
SYN04		= clset lexcondcl morfcondcl
SYN04TYPES	= $(ST_INPUT) $(ST_REQUIRED)
SYN0X		= $(SYN01) $(SYN02) $(SYN03) $(SYN04)

all: $(NEW) $(ANALYZEPHRSET) $(PARSECLAUSES) $(PARSEPHRASES) $(SYN0X) \
   $(SYN04TYPES)

alphabet: $(SCCS)/s.alphabet
	get -r1.2 $(SCCS)/s.alphabet

lexicon: $(SCCS)/s.lexicon lexdif.sed
	get -p $(SCCS)/s.lexicon | sed -f lexdif.sed > $@

word_grammar: $(SCCS)/s.word_grammar
	get -r1.4.1 $(SCCS)/s.word_grammar
