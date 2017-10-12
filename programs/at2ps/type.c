#pragma ident	"@(#)q2pro/at2ps/type.c 1.1 09/19/00"

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
