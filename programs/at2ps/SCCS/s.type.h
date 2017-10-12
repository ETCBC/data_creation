h60650
s 00036/00000/00000
d D 1.1 00/09/19 12:20:46 const 1 0
c Version of May 18 1995
e
u
U
f e 0
f m q2pro/at2ps/type.h
t
T
I 1
#ifndef	TYPE_H
#define	TYPE_H

#pragma ident "%Z%%M% %I% %G%"

/* Constantijn Sikkel */

typedef struct {
   int             class;
   int             type;
   int             enclitic;
} type_t;

#define	TYPE_ANY	(-1)

#define	CLASS_ANY	0x00
#define	CLASS_FUNCTION	0x01
#define	CLASS_MARKER	0x02
#define	CLASS_MORPHEME	0x04
#define	CLASS_ENCLITIC	0x08

#define	IS_FUNCTION(c)	(((c) & CLASS_FUNCTION) == CLASS_FUNCTION)
#define	IS_MARKER(c)	(((c) & CLASS_MARKER) == CLASS_MARKER)
#define	IS_MORPHEME(c)	(((c) & CLASS_MORPHEME) == CLASS_MORPHEME)
#define	IS_ENCLITIC(c)	(((c) & CLASS_ENCLITIC) == CLASS_ENCLITIC)

#if __STDC__
extern int  type_create(void);

#else				/* __STDC__ */

extern int type_create();

#endif				/* __STDC__ */

#endif				/* TYPE_H */
E 1
