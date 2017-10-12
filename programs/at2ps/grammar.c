/* grammar.c
** defines the information that is handed over from the compiler
** to the segmentator
*/

#include	<string.h>
#include	<stdlib.h>
#include 	<error.h>
#include	<biblan.h>
#include	"global.h"
#include	"grammar.h"

typedef struct grammar *grammar_p;
typedef struct function *function_p;
typedef struct morpheme *morpheme_p;
typedef struct morph_element *morph_element_p;
typedef struct func_element *func_element_p;
typedef struct func_list *func_list_p;


typedef	struct morpheme
{
   grammar_p	grammar;
   int		type;
   char		lexical;
   char		separator;
   char		*name;
   int		number;
   func_list_p	functions;
   morph_element_p elements;
   morpheme_p	next;
} morpheme_t;

typedef struct morph_element
{
   morpheme_p	morpheme;
   char		*paradigm;
   int		number;
   morph_element_p next;
} morph_element_t;

typedef	struct function
{
   grammar_p	grammar;
   char		*name;
   int		number;
   func_element_p elements;
   function_p	next;
} function_t;

typedef struct func_element
{
   function_p	function;
   char		*name;
   int		number;
   func_element_p next;
} func_element_t;

typedef struct func_list
{
   function_p	function;
   func_list_p	next;
} func_list_t;

typedef	struct grammar
{
/* char		*language; */
   morpheme_p	morphemes;
   function_p	functions;
} grammar_t;


PRIVATE grammar_t	Grammar;


/* For our eyes only */


PRIVATE void *emalloc (size_t size)
{  void *p;
   if ((p = (void *) malloc (size)) == NULL)
   {  bl_seterr ("Not enough memory, when $d requested", (int) size);
      return NULL;
   }
   return p;
}	/* *emalloc (size) */


#define NEW(type,var) type *(var) = (type *) emalloc (sizeof (type))
#define EQSTR(A,B) (strcmp((A),(B)) == EQUAL)


PRIVATE void del_func_elems (function_p func)
{
   func_element_p fe = func->elements;
   func_element_p next;
   while (fe != NULL)
   {
      next = fe->next;
      free (fe->name);
      free (fe);
      fe = next;
   }
}	/* del_func_elems (*f) */


PRIVATE void del_morph_elems
   (morpheme_p morph)
{
   morph_element_p me = morph->elements;
   morph_element_p next;
   while (me != NULL)
   {
      next = me->next;
      free (me->paradigm);
      free (me);
      me = next;
   }
}	/* del_morph_elems (*m) */


PRIVATE void del_funcs
   (function_p func)
{
   function_p next;
   while (func != NULL)
   {
      next = func->next;
      if (func->name != NULL)
	 free (func->name);
      del_func_elems (func);
      free (func);
      func = next;
   }
}	/* del_funcs (first func) */


PRIVATE void del_func_list
   (morpheme_p morph)
{
   func_list_p fl = morph->functions;
   func_list_p next;
   while (fl != NULL)
   {
      next = fl->next;
      free (fl);
      fl = next;
   }
}	/* del_func_list (m) */


PRIVATE void del_morphs
   (void)
{
   morpheme_p morph = Grammar.morphemes;
   morpheme_p next;

   while (morph != NULL)
   {
      next = morph->next;
      free (morph->name);
      del_func_list (morph);
      del_morph_elems (morph);
      free (morph);
      morph = next;
   }
}	/* del_morphs () */


PRIVATE morpheme_p find_morph (int morph_number)
/* return the morpheme with specified number */
{  morpheme_p	morph = Grammar.morphemes;
   while (morph != NULL)
   {  
      if (morph->number == morph_number)
	 return morph;
      morph = morph->next;
   }
   bl_seterr ("Morpheme %d not found", morph_number);
   return NULL;
}	/* find_morph (m#); */


PRIVATE void clear_morph (morpheme_p morph)
{
   morph->grammar = &Grammar;
   morph->type = GRAMMAR_NO_MORPHEME;
   morph->lexical = 'N';
   morph->separator = '\0';
   morph->name = NULL;
   morph->functions = NULL;
   morph->elements = NULL;
}	/* clear_morph (*m); */


PRIVATE morpheme_p add_morph (int morph_number)
{  
   NEW (morpheme_t, m);
   m->next = Grammar.morphemes;
   Grammar.morphemes = m;
   if (m != NULL)
   {
      clear_morph (m);
      m->number = morph_number;
      return m;
   }
   return NULL;
}	/* add_morph (m#); */


PRIVATE morph_element_p find_morph_elem
   (morpheme_p morph, int elem_number)
{
   morph_element_p me = morph->elements;
   while (me != NULL)
   {
      if (me->number == elem_number)
	 return me;
      me = me->next;
   }
   bl_seterr ("Element %d in morpheme %s not found.",
      elem_number, morph->name);
   return NULL;
}	/* find_morph_elem (*m, me#); */


PRIVATE morph_element_p add_morph_elem
   (morpheme_p morph, int elem_number)
{
   NEW (morph_element_t, me);
   if (me != NULL)
   {
      me->next = morph->elements;
      morph->elements = me;
      me->morpheme = morph;
      me->paradigm = NULL;
      me->number = elem_number;
      return me;
   }
   return NULL;
}	/* add_morph_elem (*m, me#); */


PRIVATE function_p find_func
   (int func_number)
{
   function_p func = Grammar.functions;
   while (func != NULL)
   {
      if (func->number == func_number)
	 return func;
      func = func->next;
   }
   bl_seterr ("Function %d not found.", func_number);
   return NULL;
}	/* find_func (f#) */


PRIVATE function_p add_func
   (int func_number)
{
   NEW (function_t, func);
   func->next = Grammar.functions;
   Grammar.functions = func;
   func->grammar = &Grammar;
   func->name = NULL;
   func->number = func_number;
   func->elements = NULL;
   return func;
}	/* add_func (f#) */


PRIVATE func_element_p find_func_elem
   (function_p func, int elem_number)
{
   func_element_p fe = func->elements;
   while (fe != NULL)
   {
      if (fe->number == elem_number)
	 return fe;
      fe = fe->next;
   }
   bl_seterr ("Element %d in function %s not found.",
      elem_number, func->name);
   return NULL;
}	/* find_func_elem (f, fe#); */


PRIVATE func_element_p add_func_elem
   (function_p func, int elem_number)
{
   NEW (func_element_t, fe);
   if (fe != NULL)
   {
      fe->next = func->elements;
      func->elements = fe;
      fe->function = func;
      fe->name = NULL;
      fe->number = elem_number;
      return fe;
   }
   return NULL;
}	/* add_func_elem (f, fe#); */


/* basic setup routines */


PUBLIC void grammar_delete (void)
{
   del_morphs ();
   del_funcs (Grammar.functions);
}	/* grammar_delete () */


PUBLIC void grammar_create (void)

{
   Grammar.morphemes = NULL;
   Grammar.functions = NULL;
}	/* grammar_create () */


PUBLIC int grammar_add_morpheme
   (int type, char separator, char *name, int morph_number)
{
   int	retval;
   morpheme_p morph = find_morph (morph_number);
   if (morph == NULL)
   {
      morph = add_morph (morph_number);
      if (morph == NULL)
	 retval = GRAMMAR_ERROR;
      else
	 retval = GRAMMAR_NEW;
   }
   else
      return GRAMMAR_EXIST;
   morph->type = type;
   morph->separator = separator;
   if (morph->name != NULL)
      free (morph->name);
   morph->name = strdup (name);
   if (morph->name == NULL)
      retval = GRAMMAR_ERROR;
   return retval;
}	/* grammar_add_morpheme (type, '!', "rootformation", 2); */


PUBLIC int grammar_add_morph_element
   (int morph_number, char *paradigm, int elem_number)
{
   morpheme_p morph = find_morph (morph_number);
   morph_element_p morph_elem;
   int retval;

   if (morph == NULL)
      retval = GRAMMAR_NO_MORPHEME; /* no such morpheme to click on */
   else
   {
      morph_elem = find_morph_elem (morph, elem_number);
      retval = GRAMMAR_EXIST;
      if (morph_elem == NULL)
      {
	 retval = GRAMMAR_NEW;
	 morph_elem = add_morph_elem (morph, elem_number);
      }
      if (morph_elem == NULL)
	 retval = GRAMMAR_ERROR;
      else
         if (morph_elem->paradigm != NULL)
	    free (morph_elem->paradigm);
      morph_elem->paradigm = (char *) strdup (paradigm);
      if (morph_elem->paradigm == NULL)
	 retval = GRAMMAR_ERROR;
   }
   return retval;
}	/* grammar_add_morph_element (m#, "paradigm", me#) */


PUBLIC int grammar_add_function
   (char *name, int func_number)
{
   int retval;
   function_p func = find_func (func_number);
   if (func == NULL)
   {
      retval = GRAMMAR_NEW;
      func = add_func (func_number);
   }
   else
   {
      retval = GRAMMAR_EXIST;
      free (func->name);
      del_func_elems (func);
   }
   func->name = (char *) strdup (name);
   if (func->name == NULL)
      retval = GRAMMAR_ERROR;
   return retval;
}	/* grammar_add_function ("name", f#);
	** works only on "word" functions, not on morpheme functions! */


PUBLIC int grammar_add_func_element
   (int func_number, char *name, int elem_number)
{
   function_p func = find_func (func_number);
   func_element_p func_elem;
   int retval;

   if (func == NULL)
      retval = GRAMMAR_ERROR;
   else
   {
      func_elem = find_func_elem (func, elem_number);
      retval = GRAMMAR_EXIST;
      if (func_elem == NULL)
      {
	 retval = GRAMMAR_NEW;
	 func_elem = add_func_elem (func, elem_number);
      }
      if (func_elem == NULL)
	 retval = GRAMMAR_ERROR;
      else
	 if (func_elem->name != NULL)
	    free (func_elem->name);
      func_elem->name = (char *) strdup (name);
      if (func_elem->name == NULL)
	 retval = GRAMMAR_ERROR;
   }
   return retval;
}	/* grammar_add_func_element (f#, "name", fe#); */


PUBLIC int grammar_assign
   (int morph_number, int func_number)
{
   morpheme_p morph;
   function_p func;
   func_list_p fl;

   morph = find_morph (morph_number);
   if (morph == NULL)
      return GRAMMAR_NO_MORPHEME;
   func  = find_func  (func_number);
   if (func == NULL)
      return GRAMMAR_NO_FUNCTION;
   fl = (func_list_p) emalloc (sizeof (func_list_t));
   if (fl == NULL)
      return GRAMMAR_ERROR;
   fl->function = func;
   fl->next = morph->functions;
   morph->functions = fl;
   return GRAMMAR_SUCCES;
}	/* grammar_assign (m#, f#); */


PUBLIC int grammar_has_function
   (int morph_nr, int func_nr)
{
   morpheme_p morph = find_morph (morph_nr);
   function_p f;
   if (morph != NULL)
   {
      func_list_p fl = morph->functions;
      while (fl != NULL)
      {
	 f = fl->function;
	 if (f != NULL)
	 {
	    if (f->number == func_nr)
	       return  TRUE;
	 }
	 fl = fl->next;
      }
   }
   return FALSE;
}	/* bool = grammar_has_function (7,1); */


PUBLIC void grammar_set_lexical
   (int morph_nr)
{
   morpheme_p morph = find_morph (morph_nr);
   morph->lexical = 'Y';
}	/* grammar_set_lexical (3); */


PUBLIC int grammar_get_lexical
   (int morph_nr)
{
   morpheme_p morph = find_morph (morph_nr);
   return (morph->lexical == 'Y');
}	/* add = grammar_get_lexical (3); */


/* retrieval routines */


PUBLIC int grammar_morph_type
   (int morph_number)
{
   morpheme_p morph = find_morph (morph_number);
   if (morph != NULL)
      return morph->type;
   else
      return GRAMMAR_NO_MORPHEME;
}	/* type = grammar_morph_type (3) */
	/* equals type = 3; (SUFFIX) */


PUBLIC char grammar_morph_separator
   (int morph_number)
{
   morpheme_p morph = find_morph (morph_number);
   if (morph != NULL)
      return morph->separator;
   else
      return '\0';
}	/* sep = grammar_morph_separator (3); */
	/* equals sep = '['; */


PUBLIC char *grammar_morph_name
   (int morph_number)
{
   char *name;
   morpheme_p morph = find_morph (morph_number);
   if (morph != NULL)
   {
      name = (char *) strdup (morph->name);
      return name;
   }
   else
      return NULL;
}	/* morph_name = grammar_morph_name (3) */
	/* equals morph_name = "verbal ending"; */


PUBLIC int grammar_morph_number
   (char *morph_name)
{
   morpheme_p morph = Grammar.morphemes;
   while (morph != NULL)
   {
      if (EQSTR (morph_name, morph->name))
	 return morph->number;
      else
	 morph = morph->next;
   }
   return GRAMMAR_NO_MORPHEME;
}	/* mn = grammar_morph_number ("pfm"); */
	/* equals mn = 3; */


PUBLIC char *grammar_morph_paradigm
   (int morph_number, int elem_number)
{
   morpheme_p morph = find_morph (morph_number);
   if (morph != NULL)
   {
      morph_element_p me = find_morph_elem (morph, elem_number);
      if (me != NULL)
	 return (char *) strdup (me->paradigm);
      else
	 return NULL;
   }
   else
      return NULL;
}	/* par = gramar_morph_paradigm (3,1); */
	/* equals par = ">T"HCT; */


PUBLIC int grammar_morph_element_number
   (int morph_number, char *paradigm)
{
   morpheme_p morph = find_morph (morph_number);
   if (morph != NULL)
   {
      morph_element_p me = morph->elements;
      while (me != NULL)
      {
	 if (EQSTR (me->paradigm, paradigm))
	    return me->number;
	 me = me->next;
      }
   }
   return GRAMMAR_NO_MORPHEME;
}	/* mn = grammar_morph_element_number (3,">T"); */
	/* equals mn = 1; */


PUBLIC char *grammar_function_name
   (int func_number)
{
   function_p func = find_func (func_number);
   if (func!= NULL)
   {
      if (func->name == NULL)
	 printf ("\nFunction %d has no name.\n", func_number);
      return (char *) strdup (func->name);
   }
   else
      return NULL;
}	/* fname = grammar_function_name (1); */
	/* equals fname = (char *) strdup ("gender"); */


PUBLIC int grammar_function_number
   (char *function_name)
{
   function_p func = Grammar.functions;
   while (func != NULL)
   {
      if (EQSTR (function_name, func->name))
	 return func->number;
      func = func->next;
   }
   return GRAMMAR_NO_FUNCTION;
}	/* num = grammar_function_number ("gn"); */


PUBLIC char *grammar_func_element_name
   (int func_number, int func_element_number)
{
   function_p func = find_func (func_number);
   if (func != NULL)
   {
      func_element_p fe = find_func_elem (func, func_element_number);
      if (fe != NULL)
      {
	 if (fe->name == NULL)
	    printf ("\nFunction %d has element %d with no no name.\n",
	    func_number, func_element_number);
	 return (char *) strdup (fe->name);
      }
   }
   return NULL;
}	/* fe_name = grammar_func_element_name (1,2); */
	/* equals fe_name = strdup("masculine"); */


PUBLIC int grammar_func_element_number
   (int func_number, char *func_element_name)
{
   function_p func = find_func (func_number);
   if (func != NULL)
   {
      func_element_p fe = func->elements;
      while (fe != NULL)
      {
	 if (EQSTR (fe->name, func_element_name))
	    return fe->number;
	 fe = fe->next;
      }
   }
   return GRAMMAR_NO_FUNCTION;
}	/* fe_num = grammar_func_element_nyumber (1, "masculine"); */
	/* equals fe_num = 2; */


PUBLIC int grammar_next_morpheme
   (int morph_number)
{
   int new, next = GRAMMAR_NO_MORPHEME;
   morpheme_p m = Grammar.morphemes;
   while (m != NULL)
   {
      new = m->number;
      if (new > morph_number)
      {
	 if (next == GRAMMAR_NO_MORPHEME)
	    next = new;
	 else
	    if (new < next)
	       next = new;
      }
      m = m->next;
   }
   return next;
}	/* m_nr = grammar_next_morpheme (-1); { gets first morph } */
