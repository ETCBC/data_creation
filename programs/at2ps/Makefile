#ident "@(#)q2pro/at2ps/Makefile.SunOS	1.7 13/12/08"

NAME	= at2ps

include ../config

INCLUDES	= -I$(BASEDIR)/include/obl
LDFLAGS		= -L$(BASEDIR)/lib -R$(BASEDIR)/lib
LDLIBS		= -lobl -ll


AUX		= ctcor.sed ps2cor.awk
GENERATED	= Lpars.c Lpars.h lexer.c compile.c
HEADERS		= Lpars.h backpatch.h compile.h error.h exec.h extra.h\
		  global.h grammar.h lexer.h ps_io_2.h qlist.h quad.h\
		  segment.h symbol.h symtbl.h type.h word.h wrdgrm.h
SOURCES		= at2ps.c ps_io_2.c segment.c wrdgrm.c compile.c\
		  Lpars.c lexer.c backpatch.c qlist.c quad.c error.c\
		  exec.c word.c grammar.c symtbl.c type.c symbol.c

LNFILES	= $(SOURCES:.c=.ln)
OBJECTS	= $(SOURCES:.c=.o)

MAN1	= $(NAME).1
MAN5	= word_grammar.5


all: $(NAME) $(AUX) $(MAN1) $(MAN5)

$(NAME): $(OBJECTS)
	$(LINK.c) -o $@ $(OBJECTS) $(LDLIBS)

lexer.c: lexer.l
	$(LEX.l) lexer.l > $@

Lpars.c + Lpars.h + compile.c: compile.g
	rm -f Lpars.c Lpars.h compile.c
	LLgen -a compile.g

lint: lintflags $(LNFILES)
	$(LINT.c) -flagsrc=lintflags $(LNFILES) $(LNLIBS)

install: all
	mkdir -p $(DESTDIR)/bin
	$(INSTALL) -m 555 $(NAME) $(DESTDIR)/bin
	mkdir -p $(DESTDIR)/$(NAME)
	$(INSTALL) -m 444 $(AUX) $(DESTDIR)/$(NAME)
	minstall -M $(DESTDIR)/man $(MAN1) $(MAN5)

depend: $(HEADERS) $(SOURCES)
	$(CC) $(DEPOPT) $(CPPFLAGS) $(SOURCES) > $@
	$(CC) $(DEPOPT) $(CPPFLAGS) $(SOURCES) |\
	sed 's/\.o:/.ln:/' >> $@

clean:
	rm -f $(NAME) $(OBJECTS) $(LNFILES) *.bak core

distclean: $(DISTRIBUTION) clean
	rm -f $(GENERATED)
	rm -f *.ln *.o ,* depend
	test ! -h Makefile || rm Makefile

include depend
