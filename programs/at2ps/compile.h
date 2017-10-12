#ifndef COMPILE_H
#define COMPILE_H

#pragma ident	"@(#)q2pro/at2ps/compile.h 1.1 09/19/00"

#include "exec.h"

#if __STDC__
extern exec_t    *compile(char *fname);

#else
extern exec_t    *compile();

#endif

#endif				/* COMPILE_H */
