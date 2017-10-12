h50403
s 00034/00033/00065
d D 1.3 99/03/25 10:38:48 const 3 2
c Added surface text to the phrase pattern statistics.
e
s 00082/00005/00016
d D 1.2 99/02/16 14:33:22 const 2 1
c New makefile for the modular version of syn03.
e
s 00021/00000/00000
d D 1.1 98/01/23 16:26:35 const 1 0
c date and time created 98/01/23 16:26:35 by const
e
u
U
f e 0
f l a
f m dapro/syn03/Makefile
t
T
I 1
#ident "%Z%%M% %I% %G%"

D 3
include ../.makefile
E 3
I 3
include ../MakeDefs
E 3

I 2
CPPFLAGS = -I.

E 2
MAN1	= ps2phd.1 syn03.1
MAN5	= lexcond.5 morfcond.5 phd.5 phrset.5 ps3.5
D 2
PRGMS	= ps2phd syn03
E 2
I 2
PRGMS	= ps2phd syn03 syn03x
E 2

I 2
MODULES = Atom AtomList Compare CondSet CondSetList Division Error \
D 3
	  Feature File Grammar IO IntList Item LCTable Lexeme MCond \
	  MCTable Pattern PhraseSet String Surface User Verse \
	  VerseLabel VerseLabelList Word
E 3
I 3
	  Feature File Grammar IO IntList Item LCTable Lexeme Loci \
	  Locus MCond MCTable Pattern PhraseSet String Surface User \
	  Verse VerseLabel Word
E 3

HEADERS	= $(MODULES:=.h)
OBJECTS = Main.o GetWindowSize.o $(MODULES:=.o)
SOURCES	= Main.p GetWindowSize.c $(MODULES:=.p)

E 2
all: $(PRGMS) $(MAN1) $(MAN5)

D 2
depend:
	true
E 2
I 2
syn03x: $(OBJECTS)
	$(LINK.p) -o $@ $(OBJECTS) $(LDLIBS)
E 2

I 2
depend: $(HEADERS) $(SOURCES)
	makedepend $(CPPFLAGS) $(SOURCES)

E 2
install: all
	$(INSTALL) $(PRGMS) $(BIN)
	$(INSTALL) -m 444 $(MAN1) $(MAN)/man1
	$(INSTALL) -m 444 $(MAN5) $(MAN)/man5

I 2
P2CTMP	= Main.c $(MODULES:=.c)

E 2
clean:
D 2
	rm -f $(PRGMS)
	rm -f a.out core *.o *.c *.bak *.ps
E 2
I 2
	rm -f $(PRGMS) $(P2CTMP)
	rm -f a.out core *.o *.bak *.ps

# DO NOT DELETE THIS LINE -- make depend depends on it.

Main.o: AtomList.h Atom.h IntList.h Compare.h Word.h Feature.h String.h
Main.o: Lexeme.h VerseLabel.h Division.h Pattern.h Item.h CondSetList.h
D 3
Main.o: CondSet.h Error.h File.h Grammar.h LCTable.h MCTable.h MCond.h
Main.o: PhraseSet.h VerseLabelList.h IO.h Surface.h Verse.h User.h
E 3
I 3
Main.o: CondSet.h Error.h File.h Grammar.h LCTable.h Locus.h MCTable.h
Main.o: MCond.h PhraseSet.h Loci.h IO.h Surface.h Verse.h User.h
E 3
GetWindowSize.o: /usr/include/errno.h /usr/include/sys/errno.h
GetWindowSize.o: /usr/include/stdio.h /usr/include/sys/feature_tests.h
GetWindowSize.o: /usr/include/sys/isa_defs.h /usr/include/sys/va_list.h
GetWindowSize.o: /usr/include/stdio_tag.h /usr/include/stdio_impl.h
GetWindowSize.o: /usr/include/termios.h /usr/include/sys/termios.h
GetWindowSize.o: /usr/include/sys/ttydev.h /usr/include/sys/time.h
GetWindowSize.o: /usr/include/sys/types.h /usr/include/sys/machtypes.h
GetWindowSize.o: /usr/include/sys/int_types.h /usr/include/sys/select.h
GetWindowSize.o: /usr/include/sys/time.h /usr/include/unistd.h
GetWindowSize.o: /usr/include/sys/unistd.h /usr/include/sys/ioctl.h
Atom.o: Atom.h IntList.h Compare.h Word.h Feature.h String.h Lexeme.h Error.h
AtomList.o: AtomList.h Atom.h IntList.h Compare.h Word.h Feature.h String.h
AtomList.o: Lexeme.h VerseLabel.h
Compare.o: Compare.h
CondSet.o: CondSet.h Compare.h
CondSetList.o: CondSetList.h CondSet.h Compare.h
Division.o: Division.h AtomList.h Atom.h IntList.h Compare.h Word.h Feature.h
Division.o: String.h Lexeme.h VerseLabel.h Pattern.h Item.h CondSetList.h
Division.o: CondSet.h Error.h
D 3
Error.o: Error.h String.h
Feature.o: Feature.h String.h
File.o: Error.h String.h File.h
Grammar.o: Error.h String.h Grammar.h File.h CondSet.h Compare.h LCTable.h
Grammar.o: Lexeme.h MCTable.h MCond.h Feature.h IntList.h Pattern.h
Grammar.o: AtomList.h Atom.h Word.h VerseLabel.h Item.h CondSetList.h
Grammar.o: PhraseSet.h VerseLabelList.h IO.h Surface.h Verse.h
IO.o: Error.h String.h IO.h AtomList.h Atom.h IntList.h Compare.h Word.h
IO.o: Feature.h Lexeme.h VerseLabel.h File.h LCTable.h MCTable.h MCond.h
IO.o: Pattern.h Item.h CondSetList.h CondSet.h Surface.h Verse.h
IO.o: VerseLabelList.h
E 3
I 3
Error.o: Error.h String.h Compare.h
Feature.o: Feature.h String.h Compare.h
File.o: Error.h String.h Compare.h File.h
Grammar.o: Error.h String.h Compare.h Grammar.h CondSet.h File.h LCTable.h
Grammar.o: Lexeme.h Locus.h VerseLabel.h MCTable.h MCond.h Feature.h
Grammar.o: IntList.h Pattern.h AtomList.h Atom.h Word.h Item.h CondSetList.h
Grammar.o: PhraseSet.h Loci.h IO.h Surface.h Verse.h
IO.o: Error.h String.h Compare.h IO.h AtomList.h Atom.h IntList.h Word.h
IO.o: Feature.h Lexeme.h VerseLabel.h File.h LCTable.h Loci.h Locus.h
IO.o: MCTable.h MCond.h Pattern.h Item.h CondSetList.h CondSet.h Surface.h
IO.o: Verse.h
E 3
IntList.o: IntList.h Compare.h
D 3
Item.o: Error.h String.h Item.h Atom.h IntList.h Compare.h Word.h Feature.h
E 3
I 3
Item.o: Error.h String.h Compare.h Item.h Atom.h IntList.h Word.h Feature.h
E 3
Item.o: Lexeme.h CondSetList.h CondSet.h
LCTable.o: LCTable.h Lexeme.h Compare.h
Lexeme.o: Lexeme.h Compare.h
D 3
MCond.o: MCond.h Feature.h String.h IntList.h Compare.h
MCTable.o: MCTable.h MCond.h Feature.h String.h IntList.h Compare.h
Pattern.o: Error.h String.h Pattern.h AtomList.h Atom.h IntList.h Compare.h
E 3
I 3
Loci.o: Loci.h Compare.h Locus.h String.h VerseLabel.h
Locus.o: Error.h String.h Compare.h Locus.h VerseLabel.h
MCond.o: MCond.h Feature.h String.h Compare.h IntList.h
MCTable.o: MCTable.h MCond.h Feature.h String.h Compare.h IntList.h
Pattern.o: Error.h String.h Compare.h Pattern.h AtomList.h Atom.h IntList.h
E 3
Pattern.o: Word.h Feature.h Lexeme.h VerseLabel.h Item.h CondSetList.h
Pattern.o: CondSet.h
D 3
PhraseSet.o: Error.h String.h PhraseSet.h Pattern.h AtomList.h Atom.h
PhraseSet.o: IntList.h Compare.h Word.h Feature.h Lexeme.h VerseLabel.h
PhraseSet.o: Item.h CondSetList.h CondSet.h VerseLabelList.h
String.o: String.h
Surface.o: Surface.h String.h VerseLabel.h Compare.h
User.o: Error.h String.h IO.h AtomList.h Atom.h IntList.h Compare.h Word.h
User.o: Feature.h Lexeme.h VerseLabel.h File.h LCTable.h MCTable.h MCond.h
User.o: Pattern.h Item.h CondSetList.h CondSet.h Surface.h Verse.h
User.o: VerseLabelList.h User.h Division.h
Verse.o: Error.h String.h Verse.h VerseLabel.h Compare.h Word.h Feature.h
E 3
I 3
PhraseSet.o: Error.h String.h Compare.h PhraseSet.h Loci.h Locus.h
PhraseSet.o: VerseLabel.h Pattern.h AtomList.h Atom.h IntList.h Word.h
PhraseSet.o: Feature.h Lexeme.h Item.h CondSetList.h CondSet.h
String.o: String.h Compare.h
Surface.o: Surface.h String.h Compare.h VerseLabel.h
User.o: Error.h String.h Compare.h IO.h AtomList.h Atom.h IntList.h Word.h
User.o: Feature.h Lexeme.h VerseLabel.h File.h LCTable.h Loci.h Locus.h
User.o: MCTable.h MCond.h Pattern.h Item.h CondSetList.h CondSet.h Surface.h
User.o: Verse.h User.h Division.h
Verse.o: Error.h String.h Compare.h Verse.h VerseLabel.h Word.h Feature.h
E 3
Verse.o: Lexeme.h
VerseLabel.o: VerseLabel.h Compare.h
D 3
VerseLabelList.o: VerseLabelList.h Compare.h VerseLabel.h
Word.o: Word.h Feature.h String.h Lexeme.h Compare.h
E 3
I 3
Word.o: Word.h Feature.h String.h Compare.h Lexeme.h
E 3
E 2
E 1
