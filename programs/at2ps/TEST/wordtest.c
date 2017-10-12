/* word tester based on ruleset3 test for "an(n)eni". */

#include <stdio.h>
#include <biblan.h>
#include "word.h"

#define	PREFORMATIVE	(0)
#define	VERBAL_ENDING	(2)
#define	NOMINAL_ENDING	(3)
#define	VOWEL_MARK	(5)
#define	PRONOMINAL_SUFF	(6)

#define	GENDER		(0)
#define	NUMBER		(1)
#define	PERSON		(3)
#define	LEXICAL_SET	(4)
#define	PART_OF_SPEECH	(5)
#define	STATE		(6)
#define	VERBAL_STEM	(7)
#define	VERBAL_TENSE	(8)

#define	PREF_	(0)
#define	VBEND_	(0)
#define NMEND_	(0)
#define	MARK_D	(2)
#define	SUFF_J	(7)

#define	NU_SINGULAR	(0)
#define	PS_FIRST	(0)
#define	SP_VERB		(13)
#define	VS_PIEL		(3)
#define	VT_INFINITIVE	(3)

main ()
{
   int count;
   setbuf (stdout, NULL);

   for (count = 1; count < 100000; count++)
   {
      vsid_t *vsid = vsid_create ();
      word_t *word = word_create ();

/* Gen 9,14 B-!!<NN[/:d+J "in het hen laten verschijnen" */

      vsid_setbook (vsid, "Genesis");
      vsid_setindex (vsid, 1, 9);
      vsid_setindex (vsid, 2, 14);
      word_set_vsid (word, vsid);

      word_set_morpheme (word, PREFORMATIVE, PREF_);
      word_set_morpheme (word, VERBAL_ENDING, VBEND_);
      word_set_morpheme (word, NOMINAL_ENDING, NMEND_);
      word_set_mark (word, VOWEL_MARK, MARK_D);
      word_set_morpheme (word, PRONOMINAL_SUFF, SUFF_J);
      
/* Infinitivi */
      word_set_function (word, WORD_VALUE_ABSENT, PERSON, WORD_VALUE_ABSENT);
      word_set_function (word, WORD_VALUE_ABSENT, NUMBER, WORD_VALUE_ABSENT);
      word_set_function (word, WORD_VALUE_ABSENT, GENDER, WORD_VALUE_ABSENT);
      word_set_function (word, WORD_VALUE_ABSENT, VERBAL_TENSE, VT_INFINITIVE);
/* Verbal stems */
      word_set_function (word, WORD_VALUE_ABSENT, PART_OF_SPEECH, SP_VERB);
      word_set_function (word, WORD_VALUE_ABSENT, VERBAL_STEM, VS_PIEL);
/* Personal pronoun */
      word_set_function (word, PRONOMINAL_SUFF, PERSON, PS_FIRST);
      word_set_function (word, PRONOMINAL_SUFF, NUMBER, NU_SINGULAR);
      word_set_function (word, PRONOMINAL_SUFF, GENDER, WORD_VALUE_UNKNOWN);

      vsid_delete (vsid);
      word_delete (word);

      if (count % 100 == 0)
	 printf ("\r%4d  ", count);
   }
}
