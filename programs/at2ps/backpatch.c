/**********************************************************************/
/*                                                                    */
/*     backpatch.c                                                    */
/*                                                                    */
/**********************************************************************/

#include	<stdlib.h>

#include	<biblan.h>

#include	"error.h"
#include	"quad.h"
#include	"backpatch.h"


typedef struct node {
   quad_t         *quad;
   struct node    *next;
}               node_t;

struct bplist {
   void           *head;
   void           *tail;
};


PRIVATE node_t *
node_create(quad)
   quad_t         *quad;
{
   node_t         *node;

   if ((node = malloc(sizeof (node_t))) == NULL)
      ftlerr(ERRSTR);
   node->quad = quad;
   node->next = NULL;
   return node;
}


PUBLIC bplist_t *
bplist_create(quad)
   quad_t         *quad;
{
   bplist_t       *list;

   if ((list = malloc(sizeof (bplist_t))) == NULL)
      ftlerr(ERRSTR);
   list->tail = list->head = node_create(quad);
   return list;
}


PUBLIC bplist_t *
bplist_merge(list1, list2)
   bplist_t       *list1;
   bplist_t       *list2;
{
   node_t         *tail1 = list1->tail;

   tail1->next = list2->head;
   list1->tail = list2->tail;
   free(list2);
   return list1;
}


PUBLIC void
bplist_patch(list, quad)
   bplist_t       *list;
   quad_t         *quad;
{
   node_t         *np;

   np = list->head;
   while (np != NULL) {
      np->quad->jmp_addr = quad->address;
      np = np->next;
   }
}


PUBLIC void
bplist_delete(list)
   bplist_t       *list;
{
   node_t         *np;

   for (np = list->head; np != NULL; list->head = np) {
      np = np->next;
      free(list->head);
   }
   free(list);
}
