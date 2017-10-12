h18449
s 00040/00000/00000
d D 1.1 00/09/19 12:20:25 const 1 0
c Version of Jun 6 1996
e
u
U
f e 0
f m q2pro/at2ps/exec.h
t
T
I 1
#ifndef	EXEC_H
#define	EXEC_H

#pragma ident "%Z%%M% %I% %G%"

#include	<stdlib.h>
#include 	"word.h"

#define	RET	0x00		/* Return */
#define	JMP	0x01		/* Unconditional jump */
#define	BNZ	0x02		/* Branch if non-zero */
#define	BZE	0x03		/* Branch if zero */
#define	MOP	0x04		/* Presence of morpheme */
#define	CMP	0x05		/* Compare two strings */
#define	MRK	0x06		/* Presence of mark */
#define	LDV	0x07		/* Load value */
#define	ENC	0x08		/* Set enclitic function */

typedef struct instruction instr_t;

typedef struct executable exec_t;


#if __STDC__

extern exec_t    *exec_create (size_t size);
extern void       exec_asm (exec_t *exec, int addr, int opcode, int arg1, int arg2);
extern void       exec_delete (exec_t *exec);
extern void	  exec_run (exec_t *exec, word_t *word);

#else	/* __STDC__ */

extern exec_t    *exec_create ();
extern void       exec_asm ();
extern void       exec_delete ();
extern void	  exec_run ();

#endif	/* __STDC__ */

#endif				/* ! EXEC_H */
E 1
