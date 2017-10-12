#ifndef SYMTBL_H
#define SYMTBL_H

#pragma ident "@(#)q2pro/at2ps/symtbl.h 1.1 09/19/00"

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
