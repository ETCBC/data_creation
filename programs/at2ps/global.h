#ifndef	GLOBAL_H
#define	GLOBAL_H


#if __STDC__
extern char    *strdup(const char *s);

#else
extern char    *strdup( /* const char *s */ );

#endif				/* __STDC__ */

#endif				/* GLOBAL_H */
