#include <alphabet.h>
#include <string.h>
#include "segment.h"
#include "grammar.h"
#include "word.h"

#define	S_BUFSIZ	(100)
#define	ADDITION_MARKER	'&'
#define	ELISION_MARKER	'('

#define	FIRST_MORPH	(-1)

typedef char	charbuf[S_BUFSIZ];

PRIVATE	charbuf	lexeme, morpheme, realization;
PRIVATE int mp, rp, lexed;


PRIVATE int legal_morph_char
   (char c)
{
   if (bl_iscons (c))
      return TRUE;
   if (c == '_')
      return TRUE;
   if (c == ADDITION_MARKER || c == ELISION_MARKER)
      return TRUE;
   return FALSE;
}	/* bool = legal_char (AT[atp]); */


PRIVATE int parse
   (char *AT, int atp)
{
   char ch;
   int equals = FALSE;

   mp = 0;
   while (AT[atp] != '\0')
   {
      ch = AT[atp];
      if (bl_iscons (ch) || ch == '_')	/* normal hebrew char */
      {
	 if (equals)
	    return GRAMMAR_NO_MORPHEME;
	 morpheme[mp++] = realization[rp++] = ch;
	 atp++;
      }
      else if (ch == '=')
      {
         equals = TRUE;
	 morpheme[mp++] = ch;
	 atp++;
      }
      else if (ch == ADDITION_MARKER)	/* & */
      {
         ch = AT[++atp];
         if (bl_iscons (ch) || ch == '_')
            realization[rp++] = ch;
	 else
	    return GRAMMAR_NO_MORPHEME; /* error if no legal char */
	 atp++;
      }
      else if (ch == ELISION_MARKER)	/* ( */
      {
	 ch = AT[++atp];
	 if (bl_iscons (ch) || ch == '_')
	 {
	    morpheme[mp++] = ch;
	    atp++;
	 }
	 else
	    return GRAMMAR_NO_MORPHEME; /* see above */
      }
      else
         break;
   }
   morpheme[mp] = realization[rp] = '\0';
   return atp;
}	/* atp = parse (AT, atp); */


PRIVATE int parse_lexeme
   (char *AT, int atp)
{
   atp = parse (AT,atp);
   strcpy (lexeme, morpheme);
   mp = GRAMMAR_NO_MORPHEME;
   return atp;
}	/* atp = parse_lexeme (AT, atp); */


PRIVATE int parse_prefix
   (char *AT, int morph_nr, int atp)
{
   char	sentinel = grammar_morph_separator (morph_nr);
   if (AT[atp] != sentinel)
      return atp;		/* try next morpheme */
   atp++;
   atp = parse (AT, atp);
   if (atp < 0)			/* error */
   {
      mp = GRAMMAR_NO_MORPHEME;
      return atp;
   }
   if (AT[atp] != sentinel)	/* check ending */
   {
      mp = GRAMMAR_NO_MORPHEME;
      return GRAMMAR_NO_MORPHEME;
   }
   atp++;			/* next morph starts here */
   return atp;
}	/* atp = parse_prefix ("!!<NN[/:d+J", 1, 0); */


PRIVATE int parse_suffix
   (char *AT, int morph_nr, int atp)
{
   char sentinel = grammar_morph_separator (morph_nr);
   if (legal_morph_char (AT[atp]))
   {
      atp = parse_lexeme (AT, atp);
      lexed = TRUE;
   }
   if (AT[atp] != sentinel)
      return atp;
   if (lexed && grammar_get_lexical (morph_nr))
   {
      int l = strlen (lexeme);
      lexeme[l++] = sentinel;
      lexeme[l] = '\0';
      lexed = FALSE;
   }
   atp++;
   atp = parse (AT,atp);
   return atp;
}	/* atp = parse_suffix ("!!<NN[/:d+J", 3, 3); */


PRIVATE int parse_marker
   (word_t *word, char *AT, int morph_nr, int atp)
{
   int me;
   char s[] = "A";
   char sentinel = grammar_morph_separator (morph_nr);
   if (AT[atp] == sentinel)
   {
/*CONSTCOND*/
      while (TRUE)
      {
	 s[0] = AT[++atp];
         me = grammar_morph_element_number (morph_nr, s);
	 if (me != GRAMMAR_NO_MORPHEME)	 /* legal marker found */
	    word_set_mark (word, morph_nr, me);
	 else
	    break;
      }
   }
   mp = GRAMMAR_NO_MORPHEME;
   return atp;
}	/* atp = parse_marker (AT, morph, atp); */


PRIVATE int try_parse
   (word_t *word, char *AT, int morph_nr, int atp)
{
   int type = grammar_morph_type (morph_nr);
   mp = GRAMMAR_NO_MORPHEME;
   switch (type)
   {
      case GRAMMAR_PREFIX:
      case GRAMMAR_INFIX:
	 atp = parse_prefix (AT, morph_nr, atp);
	 break;
      case GRAMMAR_SUFFIX:
	 atp = parse_suffix (AT, morph_nr, atp);
	 break;
      case GRAMMAR_MARKER:
	 atp = parse_marker (word, AT, morph_nr, atp);
	 break;
      case GRAMMAR_ENCLITIC:
	 atp = parse_suffix (AT, morph_nr, atp);
	 break;
      default:
	 return GRAMMAR_NO_MORPHEME;
   }
   return atp;
}	/* err = try_parse ("H", 1); */


PUBLIC int segmenter
   (word_t *word, char *AT)
{
   int me;
   int atp = 0;
   int morph = grammar_next_morpheme (FIRST_MORPH);
   rp = 0;

   while (morph != GRAMMAR_NO_MORPHEME && AT[atp] != '\0')
   {
      atp = try_parse (word, AT, morph, atp);
      if (mp != GRAMMAR_NO_MORPHEME)	/* morpheme found ! */
      {
	 /* check proper morpheme first */
	 me = grammar_morph_element_number (morph, morpheme);
	 if (me == GRAMMAR_NO_MORPHEME)
	 {
	    return me;		/* no legal morpheme */
	 }
         word_set_morpheme (word, morph, me); 
      }
      if (atp < 0)
	 return atp;
      morph = grammar_next_morpheme (morph);
   }
   word_set_lexeme (word, lexeme);
   word_set_realization (word, realization);
   return 0;
}	/* ret = segmenter (w, "!!<NN[/:d+J"); */
