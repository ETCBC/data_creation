#include	<stdlib.h>
#include	<assert.h>
#include	<biblan.h>

#include	"word.h"
#include	"exec.h"

struct instruction {
   int             opcode;
   int             arg1;
   int             arg2;
};

struct executable {
   instr_t        *text;
   size_t          size;
};


PUBLIC exec_t  *
exec_create(size_t size)
{
   exec_t         *ep;

   if ((ep = malloc(sizeof (exec_t))) == NULL)
      return NULL;
   if ((ep->text = malloc(size * sizeof(instr_t))) == NULL) {
      free(ep);
      return NULL;
   }
   ep->size = size;
   return ep;
}


PUBLIC void
exec_asm(exec, addr, opcode, arg1, arg2)
   exec_t         *exec;
   int             addr;
   int             opcode;
   int             arg1;
   int             arg2;
{
   assert(0 <= addr && addr < exec->size);
   exec->text[addr].opcode = opcode;
   exec->text[addr].arg1 = arg1;
   exec->text[addr].arg2 = arg2;
}


PUBLIC void
exec_delete(exec)
   exec_t         *exec;
{
   free(exec->text);
   free(exec);
}


PUBLIC void
exec_run(exec, word)
   exec_t         *exec;
   word_t         *word;
{
   int             pc = 0;	/* Program counter */
   int             cc = 0;	/* Condition code */
   int             ec = -1;	/* Enclitic code */
   instr_t        *ip;

   /* CONSTANTCONDITION */
   while (TRUE) {
      ip = exec->text + pc;
      switch (ip->opcode) {
      case RET:
	 return;
      case BNZ:
	 if (cc != 0) {
	    pc = ip->arg1;
	    continue;
	 }
	 break;
      case BZE:
	 if (cc == 0) {
	    pc = ip->arg1;
	    continue;
	 }
	 break;
      case JMP:
	 pc = ip->arg1;
	 continue;
      case MOP:
	 cc = word_get_morpheme(word, ip->arg1) != WORD_VALUE_ABSENT;
	 break;
      case CMP:
	 cc = word_get_morpheme(word, ip->arg1) == ip->arg2;
	 break;
      case MRK:
	 cc = word_get_mark(word, ip->arg1, ip->arg2);
	 break;
      case LDV:
	 word_set_function(word, ec, ip->arg1, ip->arg2);
	 ec = WORD_NOT_ENCLITIC;
	 break;
      case ENC:
	 ec = ip->arg1;
	 break;
      }
      pc++;
   }
}
