h19988
s 00161/00000/00000
d D 1.1 00/09/19 12:20:38 const 1 0
c Version of Jan 13 1997
e
u
U
f e 0
f m q2pro/at2ps/quad.c
t
T
I 1
#pragma ident "%Z%%M% %I% %G%"

#include	<stdlib.h>
#include	<string.h>

#include	<biblan.h>

#include	"error.h"
#include	"qlist.h"
#include	"quad.h"
#include	"extra.h"


PUBLIC quad_t *
quad_create()
{
   quad_t *qp;

   if ((qp = malloc(sizeof(quad_t))) == NULL)
      ftlerr(ERRSTR);
   qp->label = NULL;
   qp->jmp_addr = 0;
   return qp;
}


PUBLIC int
quad_getaddr(quad)
   quad_t *quad;
{
   return quad->address;
}


PUBLIC void
quad_setaddr(quad, address)
   quad_t *quad;
   int address;
{
   quad->address = address;
}


PUBLIC void
quad_label(quad) /* Assign a new label to the quad */
   quad_t *quad;
{
   static int last_label = 0;
   char buf[] = "L99999";

   (void) sprintf(buf, "L%05d", last_label++ % 99999);
   if (quad->label != NULL) {
      (void) strcpy(quad->label, buf);
      return;
   }
   else
   if ((quad->label = strdup(buf)) == NULL) {
      ftlerr(ERRSTR);
      return;
   }
}


PUBLIC void
quad_delete(qp)
   quad_t *qp;
{
   if (qp->label != NULL)
      free(qp->label);
   free(qp);
}


PUBLIC void
quad_asm(qp, ep, addr)
   quad_t *qp;
   exec_t *ep;
   int addr;
{
   int arg1 = 0, arg2 = 0;

   switch(qp->operator) {
      case RET:
	 break;
      case JMP:
      case BNZ:
      case BZE:
	 arg1 = qp->jmp_addr;
	 break;
      case MOP:
      case ENC:
	 arg1 = qp->sym1->value;
	 break;
      case CMP:
      case MRK:
      case LDV:
	 arg1 = qp->sym1->value;
	 arg2 = qp->sym2->value;
	 break;
   }
   exec_asm(ep, addr, qp->operator, arg1, arg2);
}


PUBLIC void
quad_dump(ql, qp)
   qlist_t        *ql;
   quad_t         *qp;
{
   char           *jmp_lbl = qlist_byaddr(ql, qp->jmp_addr)->label;

   (void) printf("%s\t", qp->label == NULL ? "" : qp->label);
   (void) printf("%04d\t", qp->address);
   if (jmp_lbl == NULL)
      jmp_lbl = "??\t# unresolved jump";
   switch (qp->operator) {
   case RET:
      (void) printf("RET");
      break;
   case JMP:
      (void) printf("JMP\t%s", jmp_lbl);
      break;
   case BNZ:
      (void) printf("BNZ\t%s", jmp_lbl);
      break;
   case BZE:
      (void) printf("BZE\t%s", jmp_lbl);
      break;
   case MOP:
      (void) printf("MOP\t%d\t# exist %s",
		    qp->sym1->value, qp->sym1->name
	 );
      break;
   case CMP:
      (void) printf("CMP\t%d,%d\t# %s == \"%s\"",
		    qp->sym1->value, qp->sym2->value,
		    qp->sym1->name, qp->sym2->name
	 );
      break;
   case MRK:
      (void) printf("MRK\t%d,%d\t# %s has %s",
		    qp->sym1->value, qp->sym2->value,
		    qp->sym1->name, qp->sym2->name
	 );
      break;
   case LDV:
      (void) printf("LDV\t%d,%d\t# %s = %s",
		    qp->sym1->value, qp->sym2->value,
		    qp->sym1->name, qp->sym2->name
	 );
      break;
   case ENC:
      (void) printf("ENC\t%d\t# switch to %s",
		    qp->sym1->value, qp->sym1->name
	 );
      break;
   default:
      (void) printf("Unknown operator #%d", qp->operator);
   }
   (void) printf("\n");
}
E 1
