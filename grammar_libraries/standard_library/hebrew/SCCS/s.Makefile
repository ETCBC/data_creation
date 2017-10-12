h63377
s 00001/00001/00018
d D 1.2 15/11/24 13:37:26 const 2 1
c Alphabet now has its own branch: 1.1.1
e
s 00019/00000/00000
d D 1.1 06/09/18 17:45:36 const 1 0
c Added phrase.param
e
u
U
f e 0
t
T
I 1
#ident "%W% %E%"

NEW	= alphabet anwb lexicon word_grammar
SCCS	= ../../../lib/hebrew/SCCS
SYN0X   = ArgumentsList ClTypesList CodesList ParsingList\
	  QuotActorsList QuotList clause.struc lexcond lexcondcl\
	  lexset loc.ref morfcond morfcondcl morfset phrase.param\
	  phrset time.ref verbLexList verblessList verbvalList

all: $(NEW) $(SYN0X)

alphabet: $(SCCS)/s.alphabet
D 2
	get -r1.1 $(SCCS)/s.alphabet
E 2
I 2
	get -r1.1.1 $(SCCS)/s.alphabet
E 2

lexicon: $(SCCS)/s.lexicon lexdif.sed
	get -p -r1 $(SCCS)/s.lexicon | sed -f lexdif.sed > $@

word_grammar: $(SCCS)/s.word_grammar
	get -r1.5.1 $(SCCS)/s.word_grammar
E 1
