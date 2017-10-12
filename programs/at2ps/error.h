#ifndef AT2PS_ERROR_H
#define AT2PS_ERROR_H

#pragma ident "@(#)q2pro/at2ps/error.h 1.2 07/20/04"

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

#endif				/* AT2PS_ERROR_H */
