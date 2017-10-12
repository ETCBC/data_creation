#ifndef	EXEC_H
#define	EXEC_H

#pragma ident "@(#)q2pro/at2ps/exec.h 1.1 09/19/00"

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
