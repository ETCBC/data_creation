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
