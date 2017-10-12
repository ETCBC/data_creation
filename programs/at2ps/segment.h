#ifndef SEGMENT_H
#define SEGMENT_H

#pragma ident " @(#)q2pro/at2ps/segment.h 1.1 09/19/00"

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
