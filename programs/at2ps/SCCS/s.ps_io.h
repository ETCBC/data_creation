h16414
s 00055/00000/00000
d D 1.1 00/09/19 12:20:33 const 1 0
c Version of Dec 9 1994
e
u
U
f e 0
f m q2pro/at2ps/ps_io.h
t
T
I 1
#ifndef	_BL_PS_IO_H
#define	_BL_PS_IO_H

#pragma ident "%Z%/combinatory/%M% %I% %G%"

#include	<stdio.h>
#include	<biblan.h>
#include	"ECA_word.h"

/* I/O values */

#define	PS_READ		0
#define	PS_WRITE	1

typedef struct {
   FILE	*fp;
   int	new_verse;	/* TRUE on start of verse */
   int	prev_conj;	/* previous word was conjunction */
}	ps_t;


/* Usage:
      Open ps_file with ps_open.
      repeat
         Fill Word with calls to wrd_set_language,
	 wrd_set_vsid, wrd_set_graph, wrd_set_graph, etc, etc.
	 Do ps_putword;
      until last word of verse.
      Do ps_close.
*/


#if __STDC__

extern	ps_t	*ps_open
   (char *filename);
extern	int	ps_close
   (ps_t *ps);

extern	int	ps_putword
   (ps_t *ps, word_t *word);	

#else				/* __STDC__ */

extern ps_t	*ps_open
   ( /* char *filename */ );
extern int	ps_close
   ( /* ps_t *ps */ );

extern int	ps_putword
   ( /* ps_t *ps, word_t *word */ ); 

#endif				/* __STDC__ */

#endif				/* _BL_PS_IO_H */
E 1
