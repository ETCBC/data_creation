h23547
s 00225/00000/00000
d D 1.1 00/09/19 12:20:31 const 1 0
c Version of May 30 1996
e
u
U
f e 0
f m q2pro/at2ps/grammar.h
t
T
I 1
#ifndef	GRAMMAR_H
#define	GRAMMAR_H

/* grammar.h
** defines the information that is handed over from the compiler
** to the segmentator
*/

#include	<biblan.h>

#define	GRAMMAR_EXIST	(-5)
#define GRAMMAR_NEW	(-4)
#define GRAMMAR_NO_FUNCTION	(-3)
#define	GRAMMAR_NO_MORPHEME	(-2)
#define GRAMMAR_ERROR	(-1)
#define	GRAMMAR_SUCCES	(0)
#define	GRAMMAR_PREFIX	(1)
#define	GRAMMAR_INFIX	(2)
#define	GRAMMAR_SUFFIX	(3)
#define	GRAMMAR_MARKER	(4)
#define	GRAMMAR_ENCLITIC	(5)


#if __STDC__


/* basic setup routines */


extern	void grammar_create	/* Use this one first!! */
   (void);
/* retval = grammar_create (); */

extern void grammar_delete	/* And this one before */
   (void);			/* a second creation */
/* grammar_delete (); */

extern	int grammar_add_morpheme
   (int type, char separator, char *name, int morph_number);
/* retval = grammar_add_morpheme (GRAMMAR_PREFIX, '!', "preformative", 1);
** morph_numbers range from 1 to inf. and must be unique */


extern	int grammar_add_morph_element
   (int morph_number, char *paradigm, int elem_number);
/* retval = grammar_add_morph_element (1, "T=", 7); */


extern	int grammar_add_function
   (char *name, int func_number);
/* retval = grammar_add_function ("gender", 1);
** func_number must be unique. If ok then retval == func_number,
** else retval = -1: not unique, -2: no room */


extern	int grammar_add_func_element
   (int func_number, char *name, int elem_number);
/* retval = grammar_add_func_element (1, "masculine", 1); */


extern	int grammar_assign
   (int morph_number, int func_number);
/* retval = grammar_copy_function (1, 1);
**   copies function (e.g. gender) from 'word' to 'enclitic 1'.
**   the functions' elements are copied too! */


extern	int grammar_has_function
   (int morph_nr, int func_nr);
/* bool = grammar_has_function (7,1);
**    test if enclitic (7) has function gender (1) */


extern void grammar_set_lexical
   (int morph_number);
/* grammar_set_lexical (5);
**    defines morpheme 5 as one that adds its sentinel to the lecxeme */


extern int grammar_get_lexical
   (int morph_number);
/* add = grammar_get_lexical (5);
**    returns boolean whether to add sentinel to lexeme or not */


/* morpheme properties retrieval routines */


extern int grammar_morph_type
   (int morph_number);
/* morph_type = grammar_morph_type (1);
** retval is -1: no such morpheme */

extern char grammar_morph_separator
   (int morph_number);
/* separator = grammar_morph_separator (1); */

extern char *grammar_morph_name
   (int morph_number);
/* morph_name = grammar_get_morpheme_name (1);
** equals morph_name = "preformative"; */

extern int grammar_morph_number
   (char *name);
/* n = grammar_morph_number (char *morph_name); */


/* morpheme element properties retrieval routines */


extern char *grammar_morph_paradigm
   (int morph_number, int elem_number);
/* paradigm = grammar_get_morph_paradigm (2, 7); */

extern int grammar_morph_element_number
   (int morph_number, char *paradigm);
/* number = grammar_get_morph_element_number (1, "T=");
** returns number of paradigm, -1 if no such paradigm */


/* function properties retrieval routines */


extern char *grammar_function_name
   (int func_number);
/* func_name = grammar_function_name (1);
** returns NULL if no such function */

extern int grammar_function_number
   (char *function_name);


/* function element retrieval routines */


extern char *grammar_func_element_name
   (int func_number, int func_element_number);
/* fe_name = grammar_func_element_name (2,4);
** returns NULL if no such element */

extern int grammar_func_element_number
   (int func_number, char *func_element_name);
/* number = grammar_func_element_number (1, "masculine"); */

extern int grammar_next_morpheme
   (int morph_number);
/* morph_nr = grammar_next_morpheme (-1); { gets first morph } */


#else				/* __STDC__ */


/* basic setup routines */


extern	void grammar_create
   ( /* void */ );

extern void grammar_delete
   ( /* void */ );

extern	int grammar_add_morpheme
   ( /* int type, char separator, char *name, int morph_number */ );

extern	int grammar_add_morph_element
   ( /* int morph_number, char *paradigm, int elem_number */ );

extern	int grammar_add_function
   ( /* char *name, int func_number */ );

extern	int grammar_add_func_element
   ( /* int func_number, char *name, int elem_number */ );

extern	int grammar_copy
   ( /* int morph_number, int func_number */ );

extern void grammar_set_lexical
   (/* int morph_number */);

extern int grammar_get_lexical
   (/* int morph_number */);

/* morpheme properties retrieval routines */

extern int grammar_morph_type
   ( /* int morph_number */ );

extern char grammar_morph_separator
   ( /* int morph_number */ );

extern char *grammar_morph_name
   ( /* int morph_number */ );

extern int grammar_morph_number
   ( /* char separator */ );

/* morpheme element properties retrieval routines */

extern char *grammar_morph_paradigm
   ( /* int morph_number, int elem_number */ );

extern int grammar_morph_element_number
   ( /* int morph_number, char *paradigm */ );

/* function properties retrieval routines */

extern char *grammar_function_name
   ( /* int func_number */ );

/* function element retrieval routines */

extern char *grammar_func_element_name
   ( /* int func_number, int func_element_number */ );

extern int grammar_func_element_number
   ( /* int func_number, char *func_element_name */ );

extern int grammar_next_morpheme
   (/* int morph_number */);
/* morph_nr = grammar_next_morpheme (-1); { gets first morph } */


#endif				/* __STDC__ */

#endif				/* GRAMMAR_H */
E 1
