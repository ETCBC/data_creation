h42072
s 00024/00000/00000
d D 1.1 00/09/19 12:20:42 const 1 0
c Version of May 11 1995
e
u
U
f e 0
f m q2pro/at2ps/symbol.h
t
T
I 1
#ifndef SYMBOL_H
#define SYMBOL_H

#pragma ident "%Z%%M% %I% %G%"

typedef struct symbol {
   char           *name;
   int             type;
   int             class;
   int             value;
} symbol_t;

#if __STDC__
extern symbol_t *symbol_create(char *name);
extern void     symbol_delete(symbol_t *symbol);

#else				/* __STDC__ */

extern symbol_t *symbol_create();
extern void     symbol_delete();

#endif				/* ! __STDC__ */

#endif				/* ! SYMBOL_H */
E 1
