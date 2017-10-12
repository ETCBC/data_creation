#ident @(#)dapro/syn03/Makefile.SunOS	1.2 04/07/20

NAME	= syn03

include ../config

CPPFLAGS	= -I.
CPPFLAGS_C	= -D__EXTENSIONS__

MAN1		= $(NAME).1
MAN5		= lexcond.5 morfcond.5 phd.5 phrset.5 ps3.5
PROGRAMS	= $(NAME) $(NAME)x

MODULES = Grammar PhraseSet User Division IO File LCTable Loci Locus\
	  MCTable MCond Pattern AtomList Item Atom CondSetList CondSet\
	  Feature IntList Compare String Surface Verse Error VerseLabel\
	  Word Lexeme

C_SOURCE	= GetWindowSize.c
P_SOURCE	= Main.p $(MODULES:=.p)

HEADERS	= $(MODULES:=.h)
OBJECTS = $(P_SOURCE:.p=.o) $(C_SOURCE:.c=.o)
SOURCES	= $(C_SOURCE) $(P_SOURCE)

$(C_SOURCE:.c=.o)	:= CPPFLAGS = $(CPPFLAGS_C)


all: $(PROGRAMS) $(MAN1) $(MAN5)

$(NAME)x: $(OBJECTS)
	$(LINK.p) -o $@ $(OBJECTS) $(LDLIBS)


.sh:
	sed 's:%BASEDIR%:$(BASEDIR):g' $< > $@
	chmod +x $@

install: all
	mkdir -p $(DESTDIR)/bin
	$(INSTALL) -m 555 $(PROGRAMS) $(DESTDIR)/bin
	mkdir -p $(DESTDIR)/man/man1
	$(INSTALL) -m 444 $(MAN1) $(DESTDIR)/man/man1
	mkdir -p $(DESTDIR)/man/man5
	$(INSTALL) -m 444 $(MAN5) $(DESTDIR)/man/man5

depend: $(HEADERS) $(SOURCES)
	$(CC) $(DEPOPT) $(CPPFLAGS_C) $(C_SOURCE) > $@
	cat Depend >> $@

clean:
	rm -f $(OBJECTS) $(PROGRAMS) *.bak core

distclean: $(DISTRIBUTION) clean
	rm -f *.ln *.o ,* depend
	test ! -h Makefile || rm Makefile

include depend
