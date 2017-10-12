#pragma ident "@(#)sk2at/q2pro/at2ps/error.c 1.1 09/19/00"

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
