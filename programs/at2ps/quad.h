#ifndef	QUAD_H
#define	QUAD_H

#pragma ident "@(#)q2pro/at2ps/quad.h 1.1 09/19/00"

#include	"symtbl.h"
#include	"exec.h"

typedef struct {
   int             operator;
   int             address;
   symbol_t       *sym1;
   symbol_t       *sym2;
   char           *label;
   int             jmp_addr;
}               quad_t;

typedef struct quad_list qlist_t;

#if __STDC__
extern void     quad_asm(quad_t *quad, exec_t *exec, int addr);
extern quad_t  *quad_create(void);
extern void     quad_delete(quad_t * quad);
extern void     quad_dump(qlist_t *qlist, quad_t * quad);
extern int      quad_getaddr(quad_t * quad);
extern void     quad_label(quad_t * quad);
extern void     quad_setaddr(quad_t * quad, int address);

#else				/* __STDC__ */

extern void     quad_asm();
extern quad_t  *quad_create();
extern void     quad_delete();
extern void     quad_dump();
extern int      quad_getaddr();
extern void     quad_label();
extern void     quad_setaddr();

#endif				/* __STDC__ */

#endif				/* ! QUAD_H */
