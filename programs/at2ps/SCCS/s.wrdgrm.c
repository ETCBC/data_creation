h40846
s 00030/00000/00000
d D 1.1 00/09/19 12:20:49 const 1 0
c Version of Jan 20 1997
e
u
U
f e 0
f m q2pro/at2ps/wrdgrm.c
t
T
I 1
#pragma ident	"%Z%%M% %I% %G%"

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
E 1
