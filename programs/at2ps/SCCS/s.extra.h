h21840
s 00012/00000/00000
d D 1.1 00/09/19 12:20:27 const 1 0
c Version of May 24 1996
e
u
U
f e 0
f m q2pro/at2ps/extra.h
t
T
I 1
#ifndef	EXTRA_H
#define	EXTRA_H

#if __STDC__
extern char    *strdup(const char *s);

#else
extern char    *strdup( /* const char *s */ );

#endif				/* __STDC__ */

#endif				/* EXTRA_H */
E 1
