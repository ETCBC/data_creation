#ident "@(#)Makefile	1.1 08/06/05"

PARSECLAUSES	= $(PC_INPUT) $(PC_REQUIRED)
PC_INPUT	= clause.struc lexcondcl morfcondcl
PC_REQUIRED	= loc.ref time.ref verblessList verbvalList
ST_INPUT	= ClTypesList CodesList ParsingList verbLexList
ST_REQUIRED	= ArgumentsList QuotActorsList QuotList
SYN03		= lexcond morfcond phrset
SYN04		= clset lexcondcl morfcondcl
SYN04TYPES	= $(ST_INPUT) $(ST_REQUIRED)
SYN0X		= $(SYN03) $(SYN04)

all: $(ANALYZEPHRSET) $(PARSECLAUSES) $(SYN0X) $(SYN04TYPES)
