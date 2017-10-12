h52962
s 00003/00003/00021
d D 1.2 04/07/20 11:43:27 const 2 1
c Resolved a few compiler warnings.
e
s 00024/00000/00000
d D 1.1 00/09/19 12:20:23 const 1 0
c Version of May 23 1996
e
u
U
f e 0
f m q2pro/at2ps/error.h
t
T
I 1
D 2
#ifndef ERROR_H
#define ERROR_H
E 2
I 2
#ifndef AT2PS_ERROR_H
#define AT2PS_ERROR_H
E 2

#pragma ident "%Z%%M% %I% %G%"

#include	<errno.h>
#include	<string.h>

#define	ERRSTR	(strerror(errno))

#if __STDC__
extern void       ftlerr(char *fmt,...);
extern void       error(char *fmt,...);
extern void       die(char *file, int line);

#else				/* __STDC__ */

extern void       ftlerr();
extern void       error();
extern void       die();

#endif				/* __STDC__ */

D 2
#endif				/* ERROR_H */
E 2
I 2
#endif				/* AT2PS_ERROR_H */
E 2
E 1
