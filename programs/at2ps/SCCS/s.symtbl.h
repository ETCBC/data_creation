h08961
s 00033/00000/00000
d D 1.1 00/09/19 12:20:44 const 1 0
c Version of Jun 12 1996
e
u
U
f e 0
f m q2pro/at2ps/symtbl.h
t
T
I 1
#ifndef SYMTBL_H
#define SYMTBL_H

#pragma ident "%Z%%M% %I% %G%"

/* Constantijn Sikkel */

#include	<stddef.h>

#include	"symbol.h"

typedef struct symbol_table symtbl_t;

#if __STDC__
extern symtbl_t *symtbl_create(size_t size);
extern symbol_t *symtbl_insert(symtbl_t *symtbl, char *key);
extern symbol_t *symtbl_lookup(symtbl_t *symtbl, char *key);
extern symbol_t *symtbl_repeat(char *key);
extern void     symtbl_delete(symtbl_t *symtbl);
extern void     symtbl_dump(symtbl_t *symtbl);

#else				/* __STDC__ */

extern symtbl_t *symtbl_create();
extern symbol_t *symtbl_insert();
extern symbol_t *symtbl_lookup();
extern symbol_t *symtbl_repeat();
extern void     symtbl_delete();
extern void     symtbl_dump();

#endif				/* ! __STDC__ */

#endif				/* ! SYMTBL_H */
E 1
