/* Tests for qlist */

#include	"qlist.h"

#define	NTESTS	100000

main()
{
   int i;
   qlist_t *q;

   for (i = 0; i < NTESTS; i++) {
      if ((q = qlist_create()) == NULL) {
	 perror("qlist");
	 exit(1);
      }
      qlist_delete(q);
   }
   return 0;
}
