h29914
s 00021/00000/00000
d D 1.1 00/09/19 12:20:40 const 1 0
c Version of Feb 26 1996
e
u
U
f e 0
f m q2pro/at2ps/segment.h
t
T
I 1
#ifndef SEGMENT_H
#define SEGMENT_H

#pragma ident " %Z%%M% %I% %G%"

#include <biblan.h>
#include "grammar.h"
#include "word.h"

#if __STDC__

extern int segmenter
   (word_t *word, char *AT);

#else	/* __STDC__ */

extern int segmenter ();

#endif	/* __STDC__ */

#endif	/* SEGMENT_H */
E 1
