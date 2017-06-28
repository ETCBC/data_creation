# This Makefile is for manual corrections to the analyses beyond word
# level. The procedure is as follows.

# example% make clean
# example% make edit
# example% vi Mesa1.PX.corr
# example% make check
# example% mv Mesa1.ps5 Mesa1.PX.corr
# example% make check
# example% make delta

BOOK	= Mesa
CHAPTER	= 1

ANALYSE	= /projects/synvar/analyse
ETC	= /projects/synvar/etc
LIB	= /projects/synvar/lib/hebrew
SYNLIB	= /projects/grammar/lib/hebrew
TEXTS	= /projects/texts/ahi

LANG_CF	= $(AT2PS_CF:%=$(LIB)/%)

AT2PS_CF	= psdef lexicon word_grammar alphabet
SYN03_CF	= phrset lexcond morfcond
SYN04_CF	= clset lexcondcl morfcondcl
PARSECLAUSES_CF	= clause.struc
PARSECLAUSES_RW	= loc.ref time.ref verblessList verbvalList
SYN04TYPES_CF	= CodesList verbLexList
SYN04TYPES_RW	= ArgumentsList QuotActorsList

PARSECLAUSES	= parseclauses
SYN04TYPES	= syn04types

C	= $(BOOK)$(CHAPTER)
CORR	= $C.PX.corr

check: $C.ps5

edit:
	sccs -d $(ANALYSE) edit -s -G$(CORR) $C.ps5

delta: $C.ps5
	sccs -d $(ANALYSE) delta $C.ps5
	mv -f $(CORR) $(CORR)~


$C.ps5: $C.PX
	@test `wc -l < $C.usertab` -eq \
	   `awk '$$1 == "*" {n++} END{print n}' $C.ps4.p` || \
	(touch $C.usertab; echo $C.usertab is incomplete; false)
	fmtpx -rt -o $@ $C.PX || (rm -f $@ && false)

$C.PX: $C.ct4.p $C.ps4.p $C.usertab $(SYN04TYPES_CF) $(SYN04TYPES_RW)
	echo 5 $C > synnr
	$(SYN04TYPES) -n
	touch $@

$C.usertab: $(CORR)
	exusertab $(CORR) > $@

$C.ct4.p + $C.ps4.p: $C.div.p $C.ct $C.ps3.p $C.ps4 \
   $(PARSECLAUSES_CF) $(PARSECLAUSES_RW)
	echo 4 $C > synnr
	echo n | $(PARSECLAUSES)
	postparsecl $C
	ls -Et $(PARSECLAUSES_RW) $C.ct4.p $C.ps4.p

$C.div.p: $(CORR)
	exdivp $(CORR) > $@

$C.ct4 + $C.ps4: $C.div $C.ps3 $(SYN04_CF)
	echo 3 $C > synnr
	echo n | syn04

$C.div: $(CORR)
	ps2div $(CORR) > $@

$C.ps3.p: $C.phd.p $C.ps3
	mkps3p -v phd=$C.phd.p $C.ps3 > $@

$C.phd.p: $(CORR)
	exphdp $(CORR) > $@

$C.ps3: $C.ps2 $C.phd $(SYN03_CF)
	regenphd $C
	echo 2 $C > synnr && syn03

$C.phd: $(CORR)
	psentvers $(CORR) | ps2phd > $@

# To retrieve a $(CORR) when just a check (no edits) is desired
$(CORR):
	sccs -d $(ANALYSE) get -s -G$@ $C.ps5

$C.ps2 + $C.ct: $(LANG_CF) $C.at $(ETC)/at2ps.conf
	at2ps -c $(ETC)/at2ps.conf -o $C.ps2 -t $C.ct $C.at

$C.at: $(BOOK).an
	genat -b $(BOOK) -f '%s%1d' -l hebrew -u $C $(BOOK).an

$(BOOK).an: $(BOOK)
	@echo
	@echo $@ is out of date with respect to $(BOOK).
	@echo Use the following commands to update $@:
	@test -w $@ || echo example% sccs -d $(ANALYSE) edit $@
	@test -s anzb || touch anzb
	@echo example% update $@
	@echo example% adjust_an $(BOOK)
	@echo example% diff $@~ $@
	@echo Where necessary, correct the new analyses output by diff.
	@echo If no changes, use unedit instead of delget
	@echo example% sccs -d $(ANALYSE) delget $@
	@echo
	@false

$(BOOK): $(BOOK).pil
	pil2wit -sv -t hebrew -o $@ $(BOOK).pil

$(BOOK).pil: $(TEXTS)/$(BOOK).pil
	sccs -d $(TEXTS) get -s $@


# $(SYN03_CF): files read by syn03(1)
lexcond: $(LIB)/lexcond
	sccs -d $(LIB) get -s $@

morfcond: $(LIB)/morfcond
	sccs -d $(LIB) get -s $@

phrset: $(SYNLIB)/phrset
	sccs -d $(SYNLIB) get -s $@


# $(SYN04_CF): files read by syn04(1)
clset: $(SYNLIB)/clset
	sccs -d $(SYNLIB) get -s $@

lexcondcl: $(SYNLIB)/lexcondcl
	sccs -d $(SYNLIB) get -s $@

morfcondcl: $(SYNLIB)/morfcondcl
	sccs -d $(SYNLIB) get -s $@


# $(PARSECLAUSES_CF): files read by $(PARSECLAUSES)
clause.struc: $(SYNLIB)/clause.struc
	sccs -d $(SYNLIB) get -s $@

# $(PARSECLAUSES_RW): files modified by $(PARSECLAUSES)
loc.ref: $(SYNLIB)/loc.ref
	sccs -d $(SYNLIB) get -s -p $@ > $@

time.ref: $(SYNLIB)/time.ref
	sccs -d $(SYNLIB) get -s -p $@ > $@

verblessList: $(SYNLIB)/verblessList
	sccs -d $(SYNLIB) get -s -p $@ > $@

verbvalList: $(SYNLIB)/verbvalList
	sccs -d $(SYNLIB) get -s -p $@ > $@


# Files read by syn04types $(SYN04TYPES_CF)
ClTypesList: $(SYNLIB)/ClTypesList
	sccs -d $(SYNLIB) get -s $@

CodesList: $(LIB)/CodesList
	sccs -d $(LIB) get -s $@

ParsingList: $(SYNLIB)/ParsingList
	sccs -d $(SYNLIB) get -s $@

verbLexList: $(LIB)/verbLexList
	sccs -d $(LIB) get -s $@

# Files modified by syn04types $(SYN04TYPES_RW)
ArgumentsList: $(LIB)/ArgumentsList
	sccs -d $(LIB) get -s -p $@ > $@

QuotActorsList: $(SYNLIB)/QuotActorsList
	sccs -d $(SYNLIB) get -s -p $@ > $@

QuotList: $(SYNLIB)/QuotList
	sccs -d $(SYNLIB) get -s -p $@ > $@

clean:
	rm -f $(PARSECLAUSES_RW) $(SYN04TYPES_RW)
	rm -f ArgumentsList CL4sort CTTsort ClConnList ClFreqTot
	rm -f Clauseconnsort Clausetypesort NCLsort NEW NamesList
	rm -f Nclause.struc PHR Ps3pV QuotActorsList
	rm -f addClSet loc.ref noparses partcldivis synnr time.ref
	rm -f verblessList verbvalList
	rm -f $C.Actors $C.CTT $C.Nclauses $C.PX $C.Ps3pED
	rm -f $C.VBLESS $C.arg $C.at $C.cl4 $C.clfreq $C.constit
	rm -f $C.ct $C.ct4 $C.ct4.p $C.div $C.div.p $C.hierarch
	rm -f $C.npd $C.phd $C.phd.p $C.pps $C.ps2 $C.ps3 $C.ps3.p
	rm -f $C.ps4 $C.ps4.p $C.ps5 $C.report $C.typ.asc $C.usertab
