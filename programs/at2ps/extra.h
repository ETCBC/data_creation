#ifndef	EXTRA_H
#define	EXTRA_H

#if __STDC__
extern char    *strdup(const char *s);

#else
extern char    *strdup( /* const char *s */ );

#endif				/* __STDC__ */

#endif				/* EXTRA_H */
