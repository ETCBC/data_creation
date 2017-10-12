#include	<stdio.h>
#include	<vsid.h>
#include	<biblan.h>
#include	"ECA_word.h"
#include	"ps_io.h"

ps_t		*ps;
word_t		*w;
vsid_t		*v;
morph_t		*m;
func_t		*f;
int		ok;
char		*s;
char		ch;
int		words;


#define	TOTAL_WORDS	1000000


word_t	*fill_word (void)
{  word_t	*wd;

   wd = wrd_create ();
   if (wd == NULL) bl_prterr();

   v = vsid_create ();
   vsid_setbook (v, "1Sam");
   vsid_setindex (v, 0, 2);
   vsid_setindex (v, 1, 1);
   ok = wrd_set_vsid (wd, v);
   vsid_delete (v);
   if (!ok) bl_prterr ();

   ok = wrd_set_language (wd, "hebrew");
   if (!ok) bl_prterr ();

   ok = wrd_set_graph (wd, "T.T:P.AL.;70L");
   if (!ok) bl_prterr();

   ok = wrd_set_analysis (wd, "!T=!](HT]PLL[");
   if (!ok) bl_prterr ();

   ok = wrd_set_morph (wd, PS_PREFIX, "subject_tense_prefix",
      1, "T=", "T=");
   if (!ok) bl_prterr();

   ok = wrd_set_morph (wd, PS_PREFIX, "verbal_stem_prefix",
      2, "HT", "T");
   if (!ok) bl_prterr();

   ok = wrd_set_morph (wd, PS_LEXEME, "lexeme",
      1, "PLL[", "PLL[");
   if (!ok) bl_prterr();

   ok = wrd_set_morph (wd, PS_SUFFIX, "subject_tense_suffix",
      1, "", "");
   if (!ok) bl_prterr();

   ok = wrd_set_func (wd, "lexical_part_of_speech", 1, "verb", 1);
   if (!ok) bl_prterr();

   ok = wrd_set_func (wd, "verbal_tense", 2, "ipf", 3);
   if (!ok) bl_prterr();

   ok = wrd_set_func (wd, "verbal_stem", 3, "htp", 5); 
   if (!ok) bl_prterr();

   ok = wrd_set_func (wd, "person", 4, "third", 3);
   if (!ok) bl_prterr();

   ok = wrd_set_func (wd, "number", 5, "singular", 1);
   if (!ok) bl_prterr();

   ok = wrd_set_func (wd, "gender", 6, "feminine", 1);
   if (!ok) bl_prterr();

   return wd;
}


main ()
{
   setbuf (stdout, NULL);
   ps = ps_open ("Genesis");

/* setup a word */

   for (words = 1; words < TOTAL_WORDS; words++)
   {  w = fill_word ();
      if ((words % 1000) == 0) printf ("\b\b\b\b\b\b%6d", words);
      ps->prev_conj = 1;
      ps_putword (ps, w);
      wrd_delete (w);
   }
   ps_close (ps);
   return 0;
}
