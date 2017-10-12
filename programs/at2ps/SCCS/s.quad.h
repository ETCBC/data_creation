h19309
s 00041/00000/00000
d D 1.1 00/09/19 12:20:38 const 1 0
c Version of May 24 1996
e
u
U
f e 0
f m q2pro/at2ps/quad.h
t
T
I 1
#ifndef	QUAD_H
#define	QUAD_H

#pragma ident "%Z%%M% %I% %G%"

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
E 1
