h44855
s 00013/00000/00000
d D 1.1 08/06/05 17:18:30 const 1 0
c date and time created 08/06/05 17:18:30 by const
e
u
U
f e 0
t
T
I 1
#ident "%W% %E%"

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
E 1
