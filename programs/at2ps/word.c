/* word.c
** stores the information concerning the word of a grammar
*/

#include	<stdlib.h>
#include	<stdio.h>
#include	<string.h>
#include	<error.h>
#include	<biblan.h>
#include	"word.h"
#include	"grammar.h"
#include 	"global.h"

#define	FIRST	-1

typedef struct word_element *word_element_p;

typedef struct word_element
{
   int morpheme, morph_element, function, func_element;
   word_element_p	next;
} word_element_t;

PUBLIC struct word
{
   word_element_t	*list;
   vsid_t		*vsid;
   char			*lexeme;
   char			*realization;
};

PRIVATE void *emalloc (size_t size)
{
   void *p;
   if ((p = (void *) malloc (size)) == NULL)
   {
      bl_seterr ("Not enough memory, when %d requested", (int) size);
      return NULL;
   }
   return p;
}	/* p = *emalloc (size); */
   

PUBLIC word_t *word_create()
{
   word_t	*w;
   if ((w = (word_t *)emalloc (sizeof (word_t))) == NULL)
      return NULL;
   w->list = NULL;
   w->vsid = NULL;
   w->lexeme = NULL;
   w->realization = NULL;
   return w;
}	/* w = word_create (); */


PUBLIC void word_delete
   (word_t *word)
{
   if (word != NULL)
   {
      word_element_t *next;
      word_element_t *we = word->list;
      while (we != NULL)
      {
         next = we->next;
         free (we);
         we = next;
      }
      if (word->vsid != NULL)
         vsid_delete (word->vsid);
      if (word->lexeme != NULL)
	 free (word->lexeme);
      if (word->realization != NULL)
	 free (word->realization);
      free (word);
   }
}	/* word_delete (w); */


PUBLIC void word_set_function
   (word_t *word, int enclitic, int function, int value)
{
   word_element_t *we = word->list;
/* search for old value */
   while (we != NULL)
   {
      if ((we->morpheme == enclitic) && (we->function == function))
      {
	 we->func_element = value;
	 return;
      }
      we = we->next;
   }
/* no old value, create new function */
   we = emalloc (sizeof (word_element_t));
   if (we == NULL)
      exit (WORD_VALUE_ABSENT);
   we->next = word->list;
   word->list = we;
   we->morpheme = enclitic;
   we->morph_element = WORD_NOT_ENCLITIC;
   we->function = function;
   we->func_element = value;
}	/* word_set_function (w, e, f, v); */


PUBLIC int word_get_function
   (word_t *word, int enclitic, int function)
{
   word_element_t *we = word->list;
   while (we != NULL)
   {
      if ((we->morpheme == enclitic) && (we->function == function))
	 return we->func_element;
      we = we->next;
   }
   return WORD_VALUE_ABSENT;
}	/* f_elem = word_get_function (w, WORD_NOT_ENCLITIC, GENDER); */


PUBLIC void word_set_morpheme
   (word_t *word, int morpheme, int value)
{
   word_element_t *we = word->list;
/* search for old values */
   while (we != NULL)
   {
      if ((we->morpheme == morpheme) &&
      (we->function == WORD_VALUE_ABSENT))
      {
	 we->morph_element = value;
	 return;
      }
      we = we->next;
   }
/* no old value, create new morpheme */
   we = emalloc (sizeof (word_element_t));
   if (we == NULL)
      exit (WORD_VALUE_ABSENT);
   we->next = word->list;
   word->list = we;
   we->morpheme = morpheme;
   we->morph_element = value;
   we->function = WORD_VALUE_ABSENT;
   we->func_element = WORD_VALUE_ABSENT;
}	/* word_set_morpheme (w, 3, 4); */


PUBLIC int word_get_morpheme
   (word_t *word, int morpheme)
{
   word_element_t *we = word->list;
   while (we != NULL)
   {
      if ((we->morpheme == morpheme) &&
      (we->function == WORD_VALUE_ABSENT))
	 return we->morph_element;
      we = we->next;
   }
   return WORD_VALUE_ABSENT;
}	/* m_elem = word_get_morpheme (w, 3); */


PUBLIC void word_set_mark
   (word_t *word, int mark, int value)
{
   word_element_t *we = word->list;
/* check for old mark with this value */
   while (we != NULL)
   {
      if ((we->morpheme == mark) &&
      (we->morph_element == value))
	 return;	/* we 've got one already! */
      we = we->next;
   }
/* add new mark and value */
   we = emalloc (sizeof (word_element_t));
   if (we == NULL)
      exit (WORD_VALUE_ABSENT);
   we->next = word->list;
   word->list = we;
   we->morpheme = mark;
   we->morph_element = value;
   we->function = WORD_VALUE_ABSENT;
   we->func_element = WORD_VALUE_ABSENT;
}	/* word_set_mark (w, ENCLITIC, 3); */


PUBLIC int word_get_mark
   (word_t *word, int mark, int value)
{
   word_element_t *we = word->list;
   while (we != NULL)
   {
      if ((we->morpheme == mark) &&
      (we->morph_element == value))
	 return TRUE;
      we = we->next;
   }
   return FALSE;
}	/* bool = word_get_mark (w, VPM, 3); */


PUBLIC void word_set_lexeme
   (word_t *word, char *lexeme)
{
   if (word->lexeme != NULL)
      free (word->lexeme);
   word->lexeme = (char *) strdup (lexeme);
}	/* word_set_lexeme ("H"); */


PUBLIC char *word_get_lexeme
   (word_t *word)
{
   return (char *) strdup (word->lexeme);
}	/* lex = word_get_lexeme (word); */


PUBLIC void word_set_realization
   (word_t *word, char *realization)
{
   if (word->realization != NULL)
      free (word->realization);
   word->realization = (char *) strdup (realization);
}	/* word_set_realization ("H"); */


PUBLIC char *word_get_realization
   (word_t *word)
{
   return (char *) strdup (word->realization);
}	/* real = word_get_realization (word); */


PUBLIC void word_set_vsid
   (word_t *word, vsid_t *vsid)
{
   word->vsid = vsid_dup (vsid);
}	/* word_set_vsid (v); */


PUBLIC vsid_t *word_get_vsid
   (word_t *word)
{
   vsid_t *v;
   v = vsid_dup (word->vsid);
   return v;
}	/* v = word_get_vsid (w); */


PUBLIC int word_next_morpheme
   (word_t *word, int morph_nr)
{
   int m = WORD_VALUE_ABSENT;
   word_element_t *we = word->list;
   while (we != NULL)
   {
      if (we->morpheme > morph_nr)
      {
	 if (m == WORD_VALUE_ABSENT || we->morpheme < m)
	    m = we->morpheme;
      }
      we = we->next;
   }
   return m;
}	/* next = word_next_morpheme (-1); { start like this } */


PUBLIC int word_next_function
   (word_t *word, int morph_nr, int func_nr)
{
   int f = WORD_VALUE_ABSENT;
   word_element_t *we = word->list;
   while (we != NULL)
   {
      if (we->morpheme == morph_nr && we->function > func_nr)
      {
	 if (f == WORD_VALUE_ABSENT || we->function < f)
	    f = we->function;
      }
      we = we->next;
   }
   return f;
}	/* next = word_next_function (5, -1); { start like this } */


PRIVATE void print_functions
   (word_t *word, int morph_nr, int header)
{
   int e, f;
   char *name, *el_name;

   for (f = word_next_function (word, morph_nr, FIRST);
	f != WORD_VALUE_ABSENT;
	f = word_next_function (word, morph_nr, f))
   {
      e = word_get_function (word, morph_nr, f);
      if (e != WORD_VALUE_ABSENT && e != WORD_VALUE_UNKNOWN)
      {
	 name = grammar_function_name (f);
	 if (name != NULL)
	 {
	    if (header)
	       printf (", ");
	    else
	       header = TRUE;
	    printf ("%s: ", name);
	 }
	 else
	    printf ("No name found for function %d.\n", f);
	 el_name = grammar_func_element_name (f,e);
	 if (el_name != NULL)
	    printf ("%s", el_name);
	 else
            printf ("No name found for func elem %d.\n", e);
	 free (name);
	 free (el_name);
      }
   }
}	/* print_functions (word, m); */


PUBLIC void word_test	/* temporary test routine */
   (word_t *word)
{
   int m, e, mark;
   char *name, *el_name;
   printf ("\n");
   if (word == NULL)
      printf ("No word defined.");
   else
   {
      if (word->vsid != NULL)			/* vsid */
	 vsid_fprint (stdout, word->vsid);
      else
	 printf ("No verse id. ");
      if (word->realization != NULL)		/* realization */
	 printf (" Word realization = \"%s\"", word->realization);
      else
	 printf (", No word-realization");
      if (word->lexeme != NULL)			/* lexeme */
	 printf (", lexeme = \"%s\"", word->lexeme);
      else
	 printf (", No lexeme");

      for (m = word_next_morpheme(word, FIRST);
	   m != WORD_VALUE_ABSENT;
	   m = word_next_morpheme (word, m))
      {
	 if (grammar_morph_type (m) != GRAMMAR_MARKER)
	 {
 	    e = word_get_morpheme (word, m);
	    if (e != WORD_VALUE_ABSENT)
	    {
	       name = grammar_morph_name (m);
	       el_name = grammar_morph_paradigm (m,e);
	       printf (" [%s: \"%s\"", name, el_name);
	       print_functions (word, m, TRUE);
	       printf ("]");
	       free (name);
	       free (el_name);
	    }
	    else
	       printf ("Error in word./n");
	 }
	 else
	 {
	    for (mark = 0; mark < 10; mark++)
	    {
	       e = word_get_mark (word, m, mark);
	       if (e)
	       {
		  name = grammar_morph_name (m);
	          el_name = grammar_morph_paradigm (m,mark);
		  printf (" [%s: \"%s\"]", name, el_name);
	          free (name);
	          free (el_name);
	       }
	    }
	 }
      }
      printf (" [");
      print_functions (word, WORD_NOT_ENCLITIC, FALSE);
      printf ("]");
   }
}	/* word_test (word); { writes word to stdout } */
