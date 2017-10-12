#pragma ident "@(#)q2pro/at2ps/qlist.c 1.1 09/19/00"

#include	<stdlib.h>
#include	<assert.h>

#include	<biblan.h>

#include	"error.h"
#include	"qlist.h"

#define	CHUNK_SIZE		0x100
#define	MIN(a,b)		((a)>(b)?(b):(a))

typedef struct link {
   quad_t         *chunk[CHUNK_SIZE];
   struct link    *next;
}               link_t;


struct quad_list {
   link_t         *head;
   link_t         *tail;
   size_t          n_chunks;
   size_t          n_elements;
};


PRIVATE link_t *
link_create()
{
   int i;
   link_t *lp;

   if ((lp = malloc(sizeof (link_t))) == NULL)
      ftlerr(ERRSTR);
   for (i = 0; i < CHUNK_SIZE; i++)
      lp->chunk[i] = quad_create();
   lp->next = NULL;
   return lp;
}


PUBLIC size_t
qlist_size(qlist)
   qlist_t *qlist;
{
   return qlist->n_elements;
}


PUBLIC qlist_t *
qlist_create()
{
   qlist_t *qlist;

   if ((qlist = malloc(sizeof(qlist_t))) == NULL)
      ftlerr(ERRSTR);
   qlist->head = link_create();
   qlist->tail = qlist->head;
   qlist->n_chunks = 1;
   qlist->n_elements = 0;
   return qlist;
}


PUBLIC quad_t *
qlist_next(qlist)
   qlist_t *qlist;
{
   assert(qlist->n_elements <= qlist->n_chunks * CHUNK_SIZE);
   if (qlist->n_elements == qlist->n_chunks * CHUNK_SIZE) {
      qlist->tail->next = link_create();
      qlist->tail = qlist->tail->next;
      qlist->n_chunks++;
   }
   assert(qlist->n_elements >= 0);
   quad_setaddr(
	 qlist->tail->chunk[qlist->n_elements % CHUNK_SIZE],
	 qlist->n_elements
      );
   return qlist->tail->chunk[qlist->n_elements % CHUNK_SIZE];
}


PUBLIC quad_t *
qlist_byaddr(qlist, address)
   qlist_t *qlist;
   int address;
{
   link_t *lp = qlist->head;

   assert(0 <= address && address < qlist->n_elements);
   if (address >= qlist->n_elements)
      return NULL;
   while (address >= CHUNK_SIZE) {
      address -= CHUNK_SIZE;
      lp = lp->next;
   }
   return lp->chunk[address];
}


PUBLIC void
qlist_emit(qlist, operator, sym1, sym2)
   qlist_t *qlist;
   int operator;
   symbol_t *sym1;
   symbol_t *sym2;
{
   register quad_t *qp;

   assert(qlist->n_elements <= qlist->n_chunks * CHUNK_SIZE);
   if (qlist->n_elements == qlist->n_chunks * CHUNK_SIZE) {
      qlist->tail->next = link_create();
      qlist->tail = qlist->tail->next;
      qlist->n_chunks++;
   }

   qlist->n_elements++;

   qp = qlist->tail->chunk[(qlist->n_elements - 1) % CHUNK_SIZE];

   qp->operator = operator;
   qp->address = qlist->n_elements - 1;
   qp->sym1 =  sym1;
   qp->sym2 =  sym2;
}


PUBLIC void
qlist_delete(qlist)
   qlist_t *qlist;
{
   int i;
   link_t *lp;

   for (lp = qlist->head; lp != NULL; lp = qlist->head) {
      qlist->head = lp->next;
      for (i = 0; i < CHUNK_SIZE; i++)
	 quad_delete(lp->chunk[i]);
      free(lp);
   }
   free(qlist);
}


PUBLIC void
qlist_asm(qlist, exec)
   qlist_t *qlist;
   exec_t *exec;
{
   int i;
   int left;
   link_t *lp;

   left = qlist->n_elements;
   for (lp = qlist->head; lp != NULL; lp = lp->next) {
      for (i = 0; i < MIN(left, CHUNK_SIZE); i++)
	 quad_asm(lp->chunk[i], exec, qlist->n_elements - left + i);
      left -= CHUNK_SIZE;
   }
}


PUBLIC void
qlist_dump(qlist)
   qlist_t *qlist;
{
   int i;
   int left;
   link_t *lp;

   left = qlist->n_elements;
   for (lp = qlist->head; lp != NULL; lp = lp->next) {
      for (i = 0; i < MIN(left, CHUNK_SIZE); i++)
	 quad_dump(qlist, lp->chunk[i]);
      left -= CHUNK_SIZE;
   }
}
