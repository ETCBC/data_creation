#ifndef SYMBOL_H
#define SYMBOL_H

#pragma ident "@(#)q2pro/at2ps/symbol.h 1.1 09/19/00"

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
