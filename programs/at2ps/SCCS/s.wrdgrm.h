h36301
s 00021/00000/00000
d D 1.1 00/09/19 12:20:49 const 1 0
c Version of Feb 8 1996
e
u
U
f e 0
f m q2pro/at2ps/wrdgrm.h
t
T
I 1
#ifndef WRDGRM_H
#define WRDGRM_H

#pragma ident	"%Z%%M% %I% %G%"

#include	"word.h"

#if __STDC__
extern int        wrdgrm_open(char *fname);
extern int        wrdgrm_exec(word_t *word);
extern int        wrdgrm_close(void);

#else

extern int        wrdgrm_open();
extern int        wrdgrm_exec();
extern int        wrdgrm_close();

#endif

#endif				/* WRDGRM_H */
E 1
