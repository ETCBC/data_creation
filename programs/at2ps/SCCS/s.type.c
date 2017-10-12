h35788
s 00023/00000/00000
d D 1.1 00/09/19 12:20:45 const 1 0
c Version of Oct 3 1995
e
u
U
f e 0
f m q2pro/at2ps/type.c
t
T
I 1
#pragma ident	"%Z%%M% %I% %G%"

/* Constantijn Sikkel */

#include	<stdlib.h>
#include	<stdio.h>
#include	<limits.h>
#include	<biblan.h>

#include	"type.h"

PRIVATE int     last_type = 0;


PUBLIC int
type_create()
{
   if (last_type == INT_MAX) {
      (void) fprintf(stderr, "compiler error: too many types\n");
      exit(1);
   }
   return ++last_type;
}
E 1
