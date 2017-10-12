#ifndef WRDGRM_H
#define WRDGRM_H

#pragma ident	"@(#)q2pro/at2ps/wrdgrm.h 1.1 09/19/00"

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
