h64562
s 00004/00002/00027
d D 1.5 15/02/18 14:35:53 const 5 4
c Added phrase.suggest
e
s 00001/00001/00028
d D 1.4 10/08/18 09:54:13 const 4 3
c Branch for word_grammar is 1.4.1, not 1.
e
s 00016/00003/00013
d D 1.3 07/04/18 12:21:09 const 3 2
c Added files for parseclauses and syn04types.
e
s 00001/00001/00015
d D 1.2 06/09/18 17:45:10 const 2 1
c Added phrase.param
e
s 00016/00000/00000
d D 1.1 02/06/17 10:47:07 const 1 0
c date and time created 02/06/17 10:47:07 by const
e
u
U
f e 0
t
T
I 1
D 5
#ident %W% %E%
E 5
I 5
#ident "%W% %E%"
E 5

D 3
NEW	= alphabet anwb lexicon word_grammar
E 3
SCCS	= ../../../lib/aramaic/SCCS
D 2
SYN0X	= lexcond lexset morfcond morfset phrset
E 2
I 2
D 3
SYN0X   = lexcond lexset morfcond morfset phrase.param phrset
E 3
E 2

D 3
all: $(NEW) $(SYN0X)
E 3
I 3
NEW	= alphabet anwb lexicon word_grammar
E 3

I 3
ANALYZEPHRSET	= phrase.param
I 5
PARSEPHRASES	= phrase.suggest
E 5
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

D 5
all: $(ANALYZEPHRSET) $(NEW) $(PARSECLAUSES) $(SYN0X) $(SYN04TYPES)
E 5
I 5
all: $(NEW) $(ANALYZEPHRSET) $(PARSECLAUSES) $(PARSEPHRASES) $(SYN0X) \
   $(SYN04TYPES)
E 5

E 3
alphabet: $(SCCS)/s.alphabet
	get -r1.2 $(SCCS)/s.alphabet

lexicon: $(SCCS)/s.lexicon lexdif.sed
	get -p $(SCCS)/s.lexicon | sed -f lexdif.sed > $@

word_grammar: $(SCCS)/s.word_grammar
D 4
	get -r1 $(SCCS)/s.word_grammar
E 4
I 4
	get -r1.4.1 $(SCCS)/s.word_grammar
E 4
E 1
