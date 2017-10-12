h23864
s 00016/00000/00000
d D 1.1 00/09/19 12:20:22 const 1 0
c Version of Feb 12 1996
e
u
U
f e 0
f m q2pro/at2ps/compile.h
t
T
I 1
#ifndef COMPILE_H
#define COMPILE_H

#pragma ident	"%Z%%M% %I% %G%"

#include "exec.h"

#if __STDC__
extern exec_t    *compile(char *fname);

#else
extern exec_t    *compile();

#endif

#endif				/* COMPILE_H */
E 1
