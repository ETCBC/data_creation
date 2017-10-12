h29498
s 00086/00000/00000
d D 1.1 00/09/19 12:20:23 const 1 0
c Version of Oct 7 1996
e
u
U
f e 0
f m q2pro/at2ps/error.c
t
T
I 1
#pragma ident "%Z%sk2at/%M% %I% %G%"

#include	<stdlib.h>
#include	<stdio.h>

#include	<biblan.h>

#include	"error.h"


#if  __STDC__
#include	<stdarg.h>

/*VARARGS0*/
PUBLIC void
ftlerr(char *fmt,...)
{
   va_list         args;

   va_start(args, fmt);
   (void) vfprintf(stderr, fmt, args);
   (void) fprintf(stderr, "\n");
   va_end(args);
   exit(1);
}


PUBLIC void
error(char *fmt,...)
{
   va_list         args;

   va_start(args, fmt);
   (void) vfprintf(stderr, fmt, args);
   va_end(args);
}

#else

#include	<varargs.h>

/*VARARGS0*/
PUBLIC void
ftlerr(va_alist)
va_dcl
{
   va_list         args;
   char           *fmt;

   va_start(args);
   fmt = va_arg(args, char *);
   (void) vfprintf(stderr, fmt, args);
   (void) fprintf(stderr, "\n");
   va_end(args);
   exit(1);
}


PUBLIC void
error(va_alist)
va_dcl
{
   va_list         args;
   char           *fmt;

   va_start(args);
   fmt = va_arg(args, char *);
   (void) vfprintf(stderr, fmt, args);
   va_end(args);
}

#endif


PUBLIC void
die(file, line)
   char *file;
   int line;
{
   (void) fprintf(stderr,
      "internal error at source line %d of %s\n",
	 line,
	 file
   );
   exit(1);
}
E 1
