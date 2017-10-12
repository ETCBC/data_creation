#pragma ident	"@(#)q2pro/at2ps/wrdgrm.c 1.1 09/19/00"

#include	"compile.h"
#include	"exec.h"
#include	"grammar.h"
#include	"wrdgrm.h"

static exec_t    *Program;

int
wrdgrm_open(char *fname)
{
   grammar_create();
   return (Program = compile(fname)) != NULL;
}

int
wrdgrm_exec(word_t *word)
{
   exec_run(Program, word);
   return 1;
}

int
wrdgrm_close(void)
{
   exec_delete(Program);
   grammar_delete();
   return 1;
}
