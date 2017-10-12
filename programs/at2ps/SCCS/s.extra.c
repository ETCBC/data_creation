h24569
s 00014/00000/00000
d D 1.1 00/09/19 12:20:26 const 1 0
c Version of May 24 1996
e
u
U
f e 0
f m q2pro/at2ps/extra.c
t
T
I 1
#include	<stdlib.h>
#include	<string.h>
#include	<biblan.h>

PUBLIC char *
strdup(const char *s1)
{
   char *s2;

   if ((s2 = malloc(strlen(s1) + 1)) == NULL)
      return NULL;
   (void) strcpy(s2, s1);
   return s2;
}
E 1
