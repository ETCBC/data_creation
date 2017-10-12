#ifndef LEXER_H
#define LEXER_H

#pragma ident	"@(#)q2pro/at2ps/lexer.h 1.1 09/19/00"

extern char      *lex_strval;

#if __STDC__
extern int        lex_close(void);
extern void       lex_goback(void);
extern int        lex_lineno(void);
extern int        lex_open(char *fname);

#else
extern int        lex_close();
extern void       lex_goback();
extern int        lex_lineno();
extern int        lex_open();

#endif

#endif				/* LEXER_H */
