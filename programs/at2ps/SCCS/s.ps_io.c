h36707
s 00536/00000/00000
d D 1.1 00/09/19 12:18:57 const 1 0
c Version of Dec 9 1994
e
u
U
f e 0
f m q2pro/at2ps/ps_io.c
t
T
I 1
/***************************************************************/
/*							       */
/* ps_io - library routines on ps files 		       */
/*							       */
/* author: Peter Crom					       */
/*							       */
/***************************************************************/

#pragma ident "%Z%/combinatory/%M% %I% %G%"

#include	<errno.h>
#include	<string.h>
#include	<ctype.h>
#include	<sys/types.h>
#include	<stdlib.h>
#include	<stdio.h>

#include	<biblan.h>
#include	"ECA_word.h"
#include	"ps_io.h"


enum	columns	{
	lexset, part_of_speech, prefix, verbal_stem,
	verbal_ending, nominal_ending, suffix,
	verbal_tense, person, number, gender, state,
	phrase_POS, phrase_type, determination, control
};
enum	lexical_POS {
	article, verb, substantive, proper_name, adverb,
	preposition, conjunction, personal_pronoun,
	demonstrative_pronoun, interrogative_pronoun,
	interjection, negative_particle, interrogative_particle,
	adjective
};
enum	stem {
	qal, piel, hifil, nifal, pual, hitpael = 6, 
	hofal = 8, hishtafal = 10, hotpaal, nitpael, etpaal,
	tifal
};

#define COLMAX	control
#define	STRLEN	100
#define	NOT_RELEVANT	-1
#define	ABSENT		0

#define	NO_CONJ		0
#define	W_CONJ		1
#define	NARR_CONJ	2

#define	books		38

#define eqstr(A,B) (strcmp((A),(B)) == EQUAL)

#define strclr(A) if((A)!=NULL) {free(A);A=NULL;}


static struct	bookname	{
   char	*newname;
   char	*ps_name;
} booknames [] = {
   "Amos",	"AMOS ",	/*  0 */
   "Cant",	" CAN ",	/*  1 */
   "1Chr",	" ICHR",	/*  2 */
   "2Chr",	"IICHR",	/*  3 */
   "Dan",	" DAN ",	/*  4 */
   "Deut",	" DEUT",	/*  5 */
   "Eccl",	" QOH ",	/*  6 */
   "Esra",	" ESR ",	/*  7 */
   "Esth",	" EST ",	/*  8 */
   "Exod",	" EXO ",	/*  9 */
   "Ezech",	" EZE ",	/* 10 */
   "Gen",	" GEN ",	/* 11 */
   "Hab",	" HAB ",	/* 12 */
   "Hag",	" HAG ",	/* 13 */
   "Hosea",	" HOS ",	/* 14 */
   "Iob",	" IOB ",	/* 15 */
   "Jer",	" JER ",	/* 16 */
   "Jes",	" JES ",	/* 17 */
   "Joel",	" JOE ",	/* 18 */
   "Jona",	"JONA ",	/* 19 */
   "Jos",	" JOZ ",	/* 20 */
   "Jud",	"RICHT",	/* 21 */
   "Lev",	" LEV ",	/* 22 */
   "Mal",	" MAL ",	/* 23 */
   "Micha",	" MICH",	/* 24 */
   "Nahum",	" NAH ",	/* 25 */
   "Neh",	" NEH ",	/* 26 */
   "Num",	" NUM ",	/* 27 */
   "Obad",	" OBAD",	/* 28 */
   "Prov",	" PRO ",	/* 29 */
   "Psal",	" PS",		/* 30 */
   "1Reg",	" IKON",	/* 31 */
   "2Reg",	"IIKON",	/* 32 */
   "Ruth",	" RUTH",	/* 33 */
   "Sach",	" ZACH",	/* 34 */
   "1Sam",	"ISAM ",	/* 35 */
   "2Sam",	"IISA ",	/* 36 */
   "Thr",	" THR ",	/* 37 */
   "Zeph",	" ZEP "		/* 38 */
};


extern  char * sys_errlist[];


PRIVATE word_t	*PS_word;


PRIVATE void *
emalloc (size)
   size_t	size;
{
   void		*p;

   if ((p = malloc (size)) == NULL)
   {  bl_seterr ("not enough memory, when %d requested",
	 (size_t) size);
      return NULL;
   }
   return p;
}	/* emalloc */


PRIVATE	char *
fget (name)
   char	*name;
{  char *cp = wrd_get_funcvalue (PS_word, name); 
   if (cp != NULL)
      return cp;
   else
      return (char *) strdup ("---");
}	/* fget: get contents of function with certain name */


PRIVATE	char *
mget (name, pst)
   char	*name;
   int	pst;
{  char	*cp = wrd_get_morphparadigm (PS_word, pst, name);
   if (cp != NULL)
      return cp;
   else
      return (char *) strdup ("---");
}	/* mget: get contents of morpheme with certain name */


PUBLIC ps_t *
ps_open (filename)
/* filename must be the name of a book */
char	*filename;
{
   ps_t	*ps;   
   char	string[STRLEN];

   if ((ps = emalloc (sizeof (ps_t))) == NULL)
      return NULL;

   strcpy (string, filename);
   strcat (string, ".ps2");
   if ((ps->fp = fopen (string, "w")) == NULL)
   {  bl_seterr ("ps_open: %s: %s", string, sys_errlist[errno]);
      return NULL;
   }
   ps->new_verse = TRUE;
   ps->prev_conj = NO_CONJ;
   return ps;
}	/* ps_open */


PRIVATE void
ps_verse_end (ps_t *ps)
{  if (ps->new_verse)
      fprintf (ps->fp, "%11s*\n", " ");
   ps->new_verse = TRUE;
}


PUBLIC int
ps_close (ps)
   ps_t	*ps;
{
   int 	closed;

   ps_verse_end (ps);
   closed = fclose (ps->fp);
   free (ps);
   return closed;
}	/* ps_close */


PUBLIC int
ps_putword (ps_t *ps, word_t *word)

/* store word information */

{  char	*str1, *str2, *str3;
   char	*cp, *lexeme;
   int	i, iwid, val;
   int	Column[COLMAX];

   PS_word = word;

/* vers id 1-10*/
   iwid = 2;
   for (i = 0; i < books; i++)
   {  if (eqstr(word->vsid->book, booknames[i].newname))
      {  if (i == 30)	/* psalms */
	    iwid = 3;
         fprintf (ps->fp, "%s%.*i,%.*i ",
	 booknames[i].ps_name,
	 iwid, word->vsid->index[0],
	 iwid, word->vsid->index[1]);
	 break;
      }
   }

/* lexeme 12-28 */
   lexeme = wrd_get_morphparadigm (word, PS_LEXEME, "lexeme");
   fprintf (ps->fp, "%-17s ", lexeme);

/* lexical set 30-32 */
   val = ABSENT;
   cp = wrd_get_funcvalue (word, "lexical_set");
   if (cp != NULL)
   {  if (eqstr (cp, "card")) /* cardinal */
	 val = -1; else
      if (eqstr (cp, "quot")) /* quotation verb */
	 val = -1; else
      if (eqstr (cp, "gntl")) /* gentilic */
	 val = -2; else
      if (eqstr (cp, "mult")) /* nomen multitudines */
	 val = -2; else
      if (eqstr (cp, "vbes")) /* verbum essendi */
	 val = -2; else
      if (eqstr (cp, "ordn")) /* ordinal */
	 val = -3; else
      if (eqstr (cp, "ppre")) /* possible prepos. */
	 val = -3; else
      if (eqstr (cp, "padv")) /* possible adverb */
	 val = -4; else
      if (eqstr (cp, "nmes")) /* nomen essendi */
         val = -5; else
      if (eqstr (cp, "nmdi")) /* nomen distribut. */
	val = -6;
   }
   Column [lexset] = val;
   strclr (cp);

/* lexical part of speech 34-36 */
   cp = wrd_get_funcvalue (word, "lexical_part_of_speech");
   if (cp == NULL)
   {  bl_seterr ("word lacks part of speech");
      return FALSE;
   }
   if (eqstr (cp, "dart")) val = article; else
   if (eqstr (cp, "verb")) val = verb; else
   if (eqstr (cp, "subs")) val = substantive; else
   if (eqstr (cp, "nmpr")) val = proper_name; else
   if (eqstr (cp, "advb")) val = adverb; else
   if (eqstr (cp, "prep")) val = preposition; else
   if (eqstr (cp, "conj")) val = conjunction; else
   if (eqstr (cp, "prps")) val = personal_pronoun; else
   if (eqstr (cp, "prde")) val = demonstrative_pronoun; else
   if (eqstr (cp, "prin")) val = interrogative_pronoun; else
   if (eqstr (cp, "intj")) val = interjection; else
   if (eqstr (cp, "nega")) val = negative_particle; else
   if (eqstr (cp, "inrg")) val = interrogative_particle; else
   if (eqstr (cp, "adjv")) val = adjective;
   Column [part_of_speech] = val;
   strclr (cp);

/* !! subject tense prefix 38-39 */
   val = ABSENT;
   cp = wrd_get_morphparadigm (word, PS_PREFIX,
			       "subject_tense_prefix");
   if (cp != NULL)
   {  if (eqstr (cp, "M")) val = 0; else	/* !M! */
      if (eqstr (cp, "") ) val = 1; else	/* !! empty prefix */
      if (eqstr (cp, "J")) val = 2; else	/* !J! */
      if (eqstr (cp, "T")) val = 3; else	/* !T! */
      if (eqstr (cp, "T=")) val = 3; else	/* !T=! */
      if (eqstr (cp, ">")) val = 4; else	/* !>! */
      if (eqstr (cp, "N")) val = 5; else	/* !N! */
      if (eqstr (cp, "H")) val = 6; 		/* !H! */
   }
   if (Column [part_of_speech] != verb) val = NOT_RELEVANT;
   Column [prefix] = val;
   strclr (cp);

/* ]] verbal stem 41-42 */
   if (Column[part_of_speech] == verb)
   {  cp = wrd_get_funcvalue (word, "verbal_stem");
      if (cp != NULL)
      {  if (eqstr (cp, "qal")) val = qal; else
         if (eqstr (cp, "pql")) val = qal; else
         if (eqstr (cp, "pi")) val = piel; else	/* ]] */
         if (eqstr (cp, "hi")) val = hifil; else /* ]H] */
         if (eqstr (cp, "ni")) val = nifal; else /* ]N] */
         if (eqstr (cp, "pu")) val = pual; else	/* ]2] */
         if (eqstr (cp, "htp")) val = hitpael; else /* ]HT] */
         if (eqstr (cp, "ho")) val = hofal; else /* ]H2] */
         if (eqstr (cp, "hot")) val = hotpaal; else /* ]HT2] */
         if (eqstr (cp, "nt")) val = nitpael; else /* ]NT] */
         if (eqstr (cp, "et")) val = hitpael; else /* ]>T] */
         if (eqstr (cp, "ti")) val = hitpael;	/* ]T] */
      } else
      {  bl_seterr ("missing rootformation");
	 return FALSE;
      }
      if (val == hitpael && eqstr (lexeme, "CXH["))
	 val = hishtafal;
   } else
      val = NOT_RELEVANT;
   Column [verbal_stem] = val;
   strclr (cp);

/* [ subject tense suffix 44-45 */
   if (Column [part_of_speech] == verb)
   {  val = ABSENT;
      str2 = mget ("subject_tense_suffix", PS_SUFFIX);
      str1 = (char *) strdup (str2);
      str3 = mget ("subject_tense_prefix", PS_PREFIX);
      if (eqstr (str2, "H="))
      {  free (str1);
         str1 = (char *) strdup ("H");
      } else
      if (eqstr (str2, "") && eqstr (str3, "T="))
      {  free (str1);
         str1 = (char *) strdup ("=");
      } else
      if (eqstr (str2, "NH") && eqstr (str3, "T"))
      {  free (str1);
         str1 = (char *) strdup ("NH=");
      } else
      {  free (str2);
         free (str3);
         str2 = fget ("verbal_tense");
         str3 = fget ("state");
         if (eqstr (str2, "inf") && eqstr (str3, "a"))
         {  free (str1);
            str1 = (char *) strdup ("2");
	 }
      }

      if (eqstr(str1, "")) val = 1; else		/* [ */
      if (eqstr(str1, "H")) val = 2; else		/* [H */
      if (eqstr(str1, "T")) val = 3; else		/* [T */
      if (eqstr(str1, "TH")) val = 4; else		/* [TH */
      if (eqstr(str1, "T=")) val = 5; else		/* [T= */
      if (eqstr(str1, "TJ")) val = 6; else		/* [TJ */
      if (eqstr(str1, "W")) val = 7; else		/* [W */
      if (eqstr(str1, "TM")) val = 8; else		/* [TM */
      if (eqstr(str1, "TN")) val = 9; else		/* [TN */
      if (eqstr(str1, "NW")) val = 10; else	/* [NW */
      if (eqstr(str1, "=")) val = 11; else		/* [= */
      if (eqstr(str1, "J")) val = 12; else		/* [J */
      if (eqstr(str1, "JN")) val = 13; else	/* [JN */
      if (eqstr(str1, "WN")) val = 14; else	/* [WN */
      if (eqstr(str1, "NH")) val = 15; else	/* [NH */
      if (eqstr(str1, "NH=")) val = 16; else	/* [NH= */
      if (eqstr(str1, "2")) val = 17;		/* [2 */
   }  else
      val = NOT_RELEVANT;
   if (val == ABSENT)
   {  bl_seterr ("Missing verbal morpheme");
      return FALSE;
   }
   Column [verbal_ending] = val;
   free (str1);
   free (str2);
   free (str3);

/* / nominal suffix 47-48 */
   val = NOT_RELEVANT;
   if (Column[part_of_speech] == proper_name) val = 11; else 
   {  str1 = mget ("nominal_suffix", PS_SUFFIX);
      if (eqstr (str1, "---")) val = ABSENT;
      str2 = mget ("locative_state_suffix", PS_SUFFIX);
      if (eqstr (str2, "H")) val = 7;	/* (/H=)  ~H */

      if (eqstr (str1, "")) val = 1; else	/* / */
      if (eqstr (str1, "H")) val = 2; else	/* /H */
      if (eqstr (str1, "T")) val = 3; else	/* /T */
      if (eqstr (str1, "JM")) val = 4; else	/* /JM */
      if (eqstr (str1, "J")) val = 5; else	/* /J */
      if (eqstr (str1, "WT")) val = 6; else	/* /WT */
      if (eqstr (str1, "JM=")) val = 8; else	/* (/JM2) /JM= */ 
      if (eqstr (str1, "TJM")) val = 8; else	/* (/JM2) /TJM */
      if (eqstr (str1, "J=")) val = 9; else	/* (/J2)  /J= */
      if (eqstr (str1, "TJ")) val = 9; else	/* (/J2)  /TJ */
      free (str1);
      free (str2);
   }
   Column [nominal_ending] = val;

/* + pronominal suffix 50-51 */
   switch (Column[part_of_speech])
   {  case article:           case conjunction:      case adverb:
      case negative_particle: case personal_pronoun:
      case demonstrative_pronoun:
	 val = NOT_RELEVANT;
	 break;
      default:
         val = ABSENT;
         str1 = mget ("pronominal_suffix", PS_SUFFIX);
         if (eqstr (str1, "NJ")) val = 2; else	/* +NJ */
         if (eqstr (str1, "J")) val = 3; else	/* +J */
         if (eqstr (str1, "K")) val = 4; else	/* +K */
         if (eqstr (str1, "K=")) val = 5; else	/* +K= */
         if (eqstr (str1, "W")) val = 6; else	/* +W */
         if (eqstr (str1, "HW")) val = 7; else	/* +HW */
         if (eqstr (str1, "H")) val = 8; else	/* +H */
         if (eqstr (str1, "NW")) val = 9; else	/* +NW */
         if (eqstr (str1, "KM")) val = 10; else	/* +KM */
         if (eqstr (str1, "KN")) val = 11; else	/* +KN */
         if (eqstr (str1, "HM")) val = 12; else	/* +HM */
         if (eqstr (str1, "HMH")) val = 12; else	/* +HMH */
         if (eqstr (str1, "M")) val = 13; else	/* +M */
         if (eqstr (str1, "MW")) val = 14; else	/* +MW */
         if (eqstr (str1, "HN")) val = 15; else	/* +HN */
         if (eqstr (str1, "HNH")) val = 15; else	/* +HNH */
         if (eqstr (str1, "N")) val = 16;		/* +N */
	 free (str1);
   }
   Column [suffix] = val;

/* verbal tense 55-56 */
   if (Column[part_of_speech] != verb)
      val = NOT_RELEVANT; else
   {  val = ABSENT;
      str1 = fget ("verbal_tense");
      if (eqstr (str1, "ipf"))
      {  if (ps->prev_conj == NO_CONJ) /* ipf yiqtol */
	    val = 1; else
         if (ps->prev_conj == W_CONJ) /* we-ipf we-yiqtol */
	    val = 11; else
         if (ps->prev_conj == NARR_CONJ) /* ipf-cons way-yiqtol */
	    val = 12;
      } else
      if (eqstr (str1, "pf")) 	/* pf	qatal */
	 val = 2; else
      if (eqstr (str1, "imp")) 	/* imp	qtol */
	 val = 3; else
      if (eqstr (str1, "inf"))
      {  if (wrd_check_mark (word, 'a'))  /* inf abs  qatol */
	    val = 5;
	 else
	    val = 4;		/* inf cstr qetol */
      }  else
      if (eqstr (str1, "ptc"))
      {  if (wrd_check_mark(word, 'p'))  /* pass ptc qatul */
	    val = 62;
         else
	    val = 6;		/* ptc	qotel */
      }
      free (str1);
   }
   Column [verbal_tense] = val;

/* person 58-59 */
   val = wrd_get_funcvalue_index (word, "person");
   Column [person] = val;
   
/* number 61-62 */
   val = wrd_get_funcvalue_index (word, "number");
   Column [number] = val;
   
/* gender 64-65 */
   val = wrd_get_funcvalue_index (word, "gender");
   Column [gender] = val;
   
/* status 67-68 */
   val = NOT_RELEVANT;
   str1 = fget ("state");
   if (eqstr (str1, "?")) val = 0;
   if (eqstr (str1, "c")) val = 1;
   if (eqstr (str1, "a")) val = 2;
   free (str1);
   Column [state] = val;

   val = NOT_RELEVANT;

/* phrase dependent part of speech 74-75 */
   Column [phrase_POS] = val;

/* phrase type 77-78 */
   Column [phrase_type] = val;

/* phrase determination 80-81 */
   Column [determination] = val;

/* control number 83-84 */
   Column [control] = val;

/* print values */

   fprintf (ps->fp, "%3d ", Column [lexset]);
   fprintf (ps->fp, "%3d ", Column [part_of_speech]);
   fprintf (ps->fp, "%2d ", Column [prefix]);
   fprintf (ps->fp, "%2d ", Column [verbal_stem]);
   fprintf (ps->fp, "%2d ", Column [verbal_ending]);
   fprintf (ps->fp, "%2d ", Column [nominal_ending]);
   fprintf (ps->fp, "%2d   ", Column [suffix]);
   fprintf (ps->fp, "%2d ", Column [verbal_tense]);
   fprintf (ps->fp, "%2d ", Column [person]);
   fprintf (ps->fp, "%2d ", Column [number]);
   fprintf (ps->fp, "%2d ", Column [gender]);
   fprintf (ps->fp, "%2d     ", Column [state]);
   fprintf (ps->fp, "%2d ", Column [phrase_POS]);
   fprintf (ps->fp, "%2d ", Column [phrase_type]);
   fprintf (ps->fp, "%2d ", Column [determination]);
   fprintf (ps->fp, "%2d\n", Column [control]);

/* setup last things to remember next time */

   if (eqstr (lexeme, "W"))
   {  if (wrd_check_mark (word, 'n'))
	 ps->prev_conj = NARR_CONJ;
      else
	 ps->prev_conj = W_CONJ;
   }  else
      ps->prev_conj = NO_CONJ;

   ps->new_verse = FALSE;
   free (str1);
   free (lexeme);
   return TRUE;
}	/* ps_putword */


PUBLIC	void
ps_putverse (ps_t *ps)
{
   ps_verse_end (ps);
}	/* ps_putverse */
E 1
