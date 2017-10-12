h40282
s 00022/00000/00000
d D 1.1 00/09/19 12:20:31 const 1 0
c Version of May 23 1996
e
u
U
f e 0
f m q2pro/at2ps/lexer.h
t
T
I 1
#ifndef LEXER_H
#define LEXER_H

#pragma ident	"%Z%%M% %I% %G%"

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
E 1
