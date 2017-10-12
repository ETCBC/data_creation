h41723
s 00031/00000/00000
d D 1.1 00/09/19 12:20:41 const 1 0
c Version of Oct 7 1996
e
u
U
f e 0
f m q2pro/at2ps/symbol.c
t
T
I 1
#include	<stdlib.h>

#include	<biblan.h>

#include	"global.h"
#include	"symbol.h"


PUBLIC symbol_t *
symbol_create(name)
   char           *name;
{
   symbol_t       *sp;

   if ((sp = malloc(sizeof (symbol_t))) == NULL)
      return NULL;
   if ((sp->name = strdup(name)) == NULL) {
      free(sp);
      return NULL;
   }
   return sp;
}


PUBLIC void
symbol_delete(symbol)
   symbol_t       *symbol;
{
   free(symbol->name);
   free(symbol);
}
E 1
