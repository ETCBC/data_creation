#pragma ident "@(#)q2pro/at2ps/symtbl.c 1.1 09/19/00"

#include	<stdlib.h>
#include	<string.h>
#include	<stdio.h>

#include	<biblan.h>

#include	"symbol.h"
#include	"symtbl.h"

typedef struct bucket {
   symbol_t       *symbol;
   struct bucket  *next;
}               bucket_t;

struct symbol_table {
   bucket_t      **table;
   size_t          size;
};


PRIVATE bucket_t *last_bucket = NULL;

PRIVATE bucket_t *
bucket_create(name)
   char           *name;
{
   bucket_t       *bp;

   if ((bp = malloc(sizeof (bucket_t))) == NULL)
      return NULL;
   if ((bp->symbol = symbol_create(name)) == NULL) {
      free(bp);
      return NULL;
   }
   bp->next = NULL;
   return bp;
}


PRIVATE void
bucket_delete(bucket)
   bucket_t       *bucket;
{
   symbol_delete(bucket->symbol);
   free(bucket);
}


PUBLIC symtbl_t *
symtbl_create(size)
   size_t          size;
{
   symtbl_t       *symtbl;
   int             i;

   if ((symtbl = malloc(sizeof (symtbl_t))) == NULL)
      return NULL;
   if ((symtbl->table = malloc(size * sizeof (bucket_t *))) == NULL) {
      free(symtbl);
      return NULL;
   }
   for (i = 0; i < size; i++)
      symtbl->table[i] = NULL;
   symtbl->size = size;
   return symtbl;
}


/* hash() is from P. J. Weinberger's C compiler */

PRIVATE int
hash(name, size)
   char           *name;
   size_t          size;
{
   char           *p;
   unsigned        g;
   unsigned        h = 0;

   for (p = name; *p != '\0'; p++) {
      h = (h << 4) + *p;
      if ((g = h & 0xF0000000) != 0) {
	 h = h ^ (g >> 24);
	 h = h ^ g;
      }
   }
   return h % size;
}


PUBLIC symbol_t *
symtbl_lookup(symtbl, name)
   symtbl_t       *symtbl;
   char           *name;
{
   bucket_t       *bp;

   bp = symtbl->table[hash(name, symtbl->size)];
   while (bp != NULL) {
      if (strcmp(name, bp->symbol->name) == 0)
	 break;
      bp = bp->next;
   }
   return (last_bucket = bp) == NULL ? NULL : bp->symbol;
}


PUBLIC symbol_t *
symtbl_repeat(key)
   char *key;
{
   bucket_t       *bp;

   if ((bp = last_bucket) == NULL)
      return NULL;
   if ((bp = bp->next) == NULL)
      return NULL;
   while (bp != NULL) {
      if (strcmp(key, bp->symbol->name) == 0)
	 break;
      bp = bp->next;
   }
   return (last_bucket = bp) == NULL ? NULL : bp->symbol;
}


PUBLIC symbol_t *
symtbl_insert(symtbl, name)
   symtbl_t       *symtbl;
   char           *name;
{
   bucket_t       *bp;		/* bucket pointer */
   bucket_t       *lbp;		/* pointer to last bucket */
   int             slot = hash(name, symtbl->size);

   if ((bp = symtbl->table[slot]) == NULL) {
      if ((bp = bucket_create(name)) == NULL)
	 return NULL;
      symtbl->table[slot] = bp;
      return bp->symbol;
   }
   while (bp->next != NULL)
      bp = bp->next;
   lbp = bp;
   if ((bp = bucket_create(name)) == NULL)
      return NULL;
   return (lbp->next = bp)->symbol;
}


PUBLIC void
symtbl_delete(symtbl)
   symtbl_t       *symtbl;
{
   int             i;
   bucket_t       *bp;		/* bucket pointer */
   bucket_t       *nbp;		/* next bucket pointer */

   for (i = 0; i < symtbl->size; i++) {
      if ((bp = symtbl->table[i]) != NULL) {
	 do {
	    nbp = bp->next;
	    bucket_delete(bp);
	    bp = nbp;
	 } while (bp != NULL);
      }
   }
   free(symtbl);
}


PUBLIC void
symtbl_dump(symtbl)
   symtbl_t       *symtbl;
{
   int             i;
   bucket_t       *bp;

   for (i = 0; i < symtbl->size; i++) {
      if ((bp = symtbl->table[i]) != NULL) {
	 (void) printf("%3d:", i);
	 do {
	    (void) printf(" %s", bp->symbol->name);
	    if (bp->next != NULL)
	       (void) printf(",");
	    bp = bp->next;
	 } while (bp != NULL);
	 (void) printf("\n");
      }
   }
}
