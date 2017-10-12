h53142
s 00012/00014/00431
d D 1.5 13/02/21 16:13:53 const 5 4
c Implemented `ls' as lexical set. Simplified `sp' and `vs'.
e
s 00069/00054/00376
d D 1.4 13/01/31 16:56:06 const 4 3
c Separate passive qal. Adjusted lexical set. Added -e option.
e
s 00009/00005/00421
d D 1.3 04/07/20 11:43:26 const 3 2
c Resolved a few compiler warnings.
e
s 00000/00001/00426
d D 1.2 03/11/06 15:23:11 const 2 1
c Placed under package WIVUq2pro.
e
s 00427/00000/00000
d D 1.1 00/09/19 12:17:50 const 1 0
c "Version
e
u
U
f e 0
f m q2pro/at2ps/at2ps.c
t
T
I 3
#pragma ident "%W% %E%"

E 3
I 1
/* at2ps: reads an AT (analyzed text) in the new format and creates
** a .ps file.
** use as: at2ps [-l languagelib] [-o outputfile] atfile [atfile]...
*/

# include <stdlib.h>
# include <stdio.h>
# include <string.h>
# include <error.h>
# include <biblan.h>
# include <at.h>
# include <lexicon.h>
# include <lemma.h>
# include <vsid.h>
# include <sys/types.h>
D 3
# include "global.h"
# include "ps_io_2.h"
# include "segment.h"
# include "word.h"
# include "wrdgrm.h"
E 3

I 3
#include "error.h"
#include "global.h"
#include "ps_io_2.h"
#include "segment.h"
#include "word.h"
#include "wrdgrm.h"

E 3
#define DEFAULT_EXT	".ps2"
#define DEFAULT_LIB	"/projects/grammar/lib/"
#define	SYN_LEN	50

char *myname;
char *library = NULL;
char *outputfile = NULL;
char *inputfile = NULL;
char *inputname = NULL;
ps_t *ps;
FILE *atfile;
lexicon_t *lexicon = NULL;
vsid_t *vsid = NULL;
int connect;
int first_line = TRUE;
int debug_mode = FALSE;
I 4
int encode_nme = FALSE;
E 4

char *strcadd (char *s, char c)
{
   size_t l = strlen (s);
   char *new = malloc (l+2);
   if (new != NULL)
   {
      strcpy (new, s);
      new [l] = c;
      new [l+1] = '\0';
   }
   else
      bl_seterr ("Unable to add %c to %s.", c, s);
   return new;
}	/* newstr = strcadd (string, 'c'); adds char to string */

char *strsadd (char *s1, char *s2)
{
   char *new;
   if (s1 == NULL)
      return s2;
   if (s2 == NULL)
      return s1;
   new = (char *) malloc (strlen (s1) + strlen (s2) + 1);
   if (new != NULL)
   {
      strcpy (new, s1);
      strcat (new, s2);
   }
   else
      bl_seterr ("Unable to add %s to %s.", s2, s1);
   return new;
}	/* new = strsadd ("/lib/","hebrew"); */

char *make_lib (char *lib)
{
   int l = strlen (lib);
   if (lib[l-1] == '/')
      return (char *) strdup (lib);
   else
      return strcadd (lib, '/');
}	/* s = make_lib (lib); */

void open_library (char *lib_name)
{
   if (library != NULL)
   {
      free (library);
   }
   library = make_lib (lib_name);
   if (library == NULL)
      bl_prterr ();
}	/* open_library (char *lib_name); */

void open_ps (char *out_name)
{
   if (outputfile != NULL)
   {
      ps_close (ps);
      free (outputfile);
   }
   outputfile = out_name;
   ps = ps_open (outputfile);
   if (ps == NULL)
   {
      error("%s: %s: %s\n", myname, out_name, ERRSTR);
      exit (errno);
   }
}	/* open_ps (char *out_name); */

void close_lexicon (void)
{
   lexicon_close (lexicon);
   lexicon = NULL;
   wrdgrm_close ();
}	/* close_lexicon () */

void new_language (void)
{
   char *language = make_lib (atlang ());
   char *lang_lib = strsadd (library, language);
   char *lex_name = strsadd (lang_lib, "lexicon");
   char *grm_name = strsadd (lang_lib, "word_grammar");
/* clear oll' stuff first */
   if (lexicon != NULL)
      close_lexicon ();
/* try open trivials first */
   if (!bl_init (library, language))	/* character set */
   {
      bl_prterr ();
      exit (1);
   }
/* open hardcore */
   if ((lexicon = lexicon_open (lex_name)) == NULL)
   {
      bl_prterr ();
      exit (1);
   }
   if (!wrdgrm_open (grm_name))
   {
      bl_prterr ();
      exit (1);
   }
   free (language);
   free (lang_lib);
   free (lex_name);
   free (grm_name);
}	/* new_language (); */

I 4
#define SET_POS(A) (strcmp(lemma_st, #A) == EQUAL) pos = wd_ ## A
#define SET_LEXSET(A) (strcmp(lemma_st, #A) == EQUAL) lexset = wd_ ## A

E 4
void lex_add (word_t *word)
{
   char *lemma_st;
   char *lexeme = word_get_lexeme (word);
   if (lexeme != NULL)
   {
      lemma_t *lemma = lexicon_retrieve (lexicon, lexeme);
      if (lemma != NULL)
      {
	 int pos =    WORD_VALUE_ABSENT;
	 int lexset = WORD_VALUE_ABSENT;
	 int gender = WORD_VALUE_ABSENT;
	 int number = WORD_VALUE_ABSENT;
	 int person = WORD_VALUE_ABSENT;
I 4

E 4
	 lemma_st = lemma_get_property (lemma, "sp");
	 if (lemma_st != NULL)
	 {
D 4
	    if (strcmp (lemma_st, "adjv") == EQUAL) pos = wd_adjv;

#define ADD_POS(A) else if (strcmp (lemma_st, #A) == EQUAL) pos= wd_ ## A

	    ADD_POS (advb);
	    ADD_POS (art);
	    ADD_POS (conj);
	    ADD_POS (inrg);
	    ADD_POS (intj);
	    ADD_POS (nega);
	    ADD_POS (nmpr);
	    ADD_POS (prde);
	    ADD_POS (prep);
	    ADD_POS (prin);
	    ADD_POS (prps);
	    ADD_POS (subs);
	    ADD_POS (verb);
	    word_set_function (word, WORD_NOT_ENCLITIC, wd_part_of_speech, pos);
E 4
I 4
	    if SET_POS(adjv);
	    else if SET_POS(advb);
	    else if SET_POS(art);
	    else if SET_POS(conj);
	    else if SET_POS(inrg);
	    else if SET_POS(intj);
	    else if SET_POS(nega);
	    else if SET_POS(nmpr);
	    else if SET_POS(prde);
	    else if SET_POS(prep);
	    else if SET_POS(prin);
	    else if SET_POS(prps);
	    else if SET_POS(subs);
	    else if SET_POS(verb);
	    else
	       pos = WORD_VALUE_UNKNOWN;
	    word_set_function(word, WORD_NOT_ENCLITIC, wd_part_of_speech, pos);
E 4
	 }
I 4

E 4
D 5
	 lemma_st = lemma_get_property (lemma, "sm");
E 5
I 5
	 lemma_st = lemma_get_property (lemma, "ls");
E 5
	 if (lemma_st != NULL)
	 {
D 4
	    if (strcmp (lemma_st, "card") == EQUAL) lexset = wd_card;

#define ADD_SET(A) else if (strcmp (lemma_st, #A) == EQUAL) lexset = wd_ ## A

	    ADD_SET (card);
	    ADD_SET (gens);
	    ADD_SET (gntl);
	    ADD_SET (mult);
	    ADD_SET (nmdi);
	    ADD_SET (nmex);
	    ADD_SET (ordn);
	    ADD_SET (padv);
	    ADD_SET (pcon);
	    ADD_SET (pers);
	    ADD_SET (pinr);
	    ADD_SET (ppde);
	    ADD_SET (ppre);
	    ADD_SET (quot);
	    ADD_SET (topo);
	    ADD_SET (vbex);
	    word_set_function (word, WORD_NOT_ENCLITIC, wd_lexical_set, lexset);
E 4
I 4
D 5
	    if SET_LEXSET(card);
	    else if SET_LEXSET(gens);
	    else if SET_LEXSET(gntl);
	    else if SET_LEXSET(mult);
	    else if SET_LEXSET(nmdi);
	    else if SET_LEXSET(nmex);
	    else if SET_LEXSET(ordn);
E 5
I 5
	    if SET_LEXSET(nmdi);
	    else if SET_LEXSET(nmcp);
E 5
	    else if SET_LEXSET(padv);
D 5
	    else if SET_LEXSET(pcon);
	    else if SET_LEXSET(pers);
	    else if SET_LEXSET(pinr);
	    else if SET_LEXSET(ppde);
E 5
I 5
	    else if SET_LEXSET(afad);
E 5
	    else if SET_LEXSET(ppre);
I 5
	    else if SET_LEXSET(cjad);
	    else if SET_LEXSET(ordn);
	    else if SET_LEXSET(vbcp);
	    else if SET_LEXSET(mult);
	    else if SET_LEXSET(focp);
	    else if SET_LEXSET(ques);
	    else if SET_LEXSET(gntl);
E 5
	    else if SET_LEXSET(quot);
D 5
	    else if SET_LEXSET(topo);
	    else if SET_LEXSET(vbex);
E 5
I 5
	    else if SET_LEXSET(card);
E 5
	    else
	       lexset = WORD_VALUE_UNKNOWN;
	    word_set_function(word, WORD_NOT_ENCLITIC, wd_lexical_set, lexset);
E 4
	 }

	 lemma_st = lemma_get_property (lemma, "gn");
	 if (lemma_st != NULL)
	 {
D 4
	    if (strcmp (lemma_st,"f") == EQUAL)
E 4
I 4
	    if (strcmp (lemma_st, "f") == EQUAL)
E 4
	       gender = wd_feminine;
I 4
	    else if (strcmp (lemma_st, "m") == EQUAL)
	       gender = wd_masculine;
E 4
	    else
D 4
	       if (strcmp (lemma_st, "m") == EQUAL)
		  gender = wd_masculine;
E 4
I 4
	       gender = WORD_VALUE_UNKNOWN;
E 4
	 }
	 if (gender != WORD_VALUE_ABSENT)
	    word_set_function (word, WORD_NOT_ENCLITIC, wd_gender, gender);

	 lemma_st = lemma_get_property (lemma, "nu");
	 if (lemma_st != NULL)
	 {
D 4
	    if (strcmp (lemma_st, "s") == EQUAL) number = wd_singular;
	    else if (lemma_st != NULL &&
		     strcmp (lemma_st, "d") == EQUAL) number = wd_dual;
	    else if (lemma_st != NULL &&
		     strcmp (lemma_st, "p") == EQUAL) number = wd_plural;
E 4
I 4
	    if (strcmp(lemma_st, "s") == EQUAL)
	       number = wd_singular;
	    else if (strcmp(lemma_st, "d") == EQUAL)
	       number = wd_dual;
	    else if (strcmp(lemma_st, "p") == EQUAL)
	       number = wd_plural;
	    else
	       number = WORD_VALUE_UNKNOWN;
E 4
	 }
	 if (number != WORD_VALUE_ABSENT)
	     word_set_function (word, WORD_NOT_ENCLITIC, wd_number, number);

	 lemma_st = lemma_get_property (lemma, "ps");
	 if (lemma_st != NULL)
	 {
D 4
	    if (strcmp (lemma_st, "1") == EQUAL) person = wd_first;
	    else if (lemma_st != NULL && strcmp (lemma_st, "2") == EQUAL) person = wd_second;
	    else if (lemma_st != NULL && strcmp (lemma_st, "3") == EQUAL) person = wd_third;
E 4
I 4
	    if (strcmp(lemma_st, "1") == EQUAL)
	       person = wd_first;
	    else if (strcmp(lemma_st, "2") == EQUAL)
	       person = wd_second;
	    else if (strcmp(lemma_st, "3") == EQUAL)
	       person = wd_third;
	    else
	       person = WORD_VALUE_UNKNOWN;
E 4
	 }
	 if (person != WORD_VALUE_ABSENT)
	    word_set_function (word, WORD_NOT_ENCLITIC, wd_person, person);
D 4

E 4
      }
      free (lexeme);
   }
}	/* lex_add (word); */

int readword (void)
{
   word_t *word = (word_t *) word_create ();
   int OK = FALSE;
   int at_status = atlex ();
   if (at_status != 0)
   {
      if (at_status < 0)
      {
	 bl_prterr ();
	 return (0);
      }
/* dependent actions */
      OK = TRUE;
      if ((uint_t) at_status & BL_NEWLANG)
	 new_language ();
      if ((uint_t) at_status & BL_NEWVERSE)
      {
	 vsid = atvsid ();
	 if (!first_line)
	    fprintf (ps->fp, "%11c*\n", ' ');
	 else
	    first_line = FALSE;
      }
/* regulars */
      word_set_vsid (word, vsid);
      /* morphological analysis */
      if (segmenter (word, atstring) != 0)
      {
	 bl_prterr ();
	 exit(at_status);
      }
      /* grammatical analysis */
      wrdgrm_exec (word);
      if ((uint_t) at_status & BL_CONNECTED)
         connect = TRUE;
      else
	 connect = FALSE;
      /* lexicographical analysis */
      lex_add (word);
      if (debug_mode)
	 word_test (word);
      ps_putword (ps, word, atstring, at_status);
   }
   if (word != NULL)
      word_delete (word);
   return OK;
}	/* readword () */

void readfile (char *inf)
{
   char	*ps_name;
   FILE *synnr;

/* open at-file */
   if (inputfile != NULL)
   {
      fclose (atfile);
   }
   inputfile = inf;
   if (outputfile == NULL)
   {
      ps_name = strsadd (inf, DEFAULT_EXT);
      open_ps (ps_name);
   }
   if (atopen (inputfile))
/* read at-file */
   {
      printf ("reading: %s.\n", inf);
      while (readword () != 0);
      fprintf (ps->fp, "%11c*\n", ' ');
   }
   else
/* try another time */
   {
      bl_prterr ();
      exit (errno);
   }
   close_lexicon ();
   free (ps_name);
   synnr = fopen ("synnr", "w");
   fprintf (synnr, "2 %s\n", inf);
   fclose (synnr);
   if (synnr == NULL) free (synnr);
}	/* readfile (char *inputfile); */


int main (int argc, char *argv[])

{
   int c;
   extern char *optarg;
   extern int optind, opterr, optopt;
   extern int getopt (int, char *const *, const char *);
   int lflag = 0;
   int oflag = 0;
   int errflag = 0;

   opterr = TRUE;
   open_library (DEFAULT_LIB);
D 4
   while ((c = getopt(argc, argv, "dhl:o:")) != EOF)
E 4
I 4
   while ((c = getopt(argc, argv, "dehl:o:")) != EOF)
E 4
   switch (c)
   {
      case 'd':
	 debug_mode = TRUE;
	 break;
I 4
      case 'e':
	 encode_nme = TRUE;
	 break;
E 4
      case 'h':
	 errflag++;
	 break;
      case 'l':
	 if (lflag)
	    errflag++;
	 else
	 {
	    open_library (optarg);
	    lflag++;
	 }
	 break;
D 4
      case 'b':		/* basename */
E 4
I 4
      case 'o':		/* basename */
E 4
	 if (oflag)
	    errflag++;
	 else
	 {
	    c = strlen (optarg);
	    myname = (char *) malloc (c+4);
	    strcpy (myname, optarg);
	    strcat (myname, DEFAULT_EXT);
            open_ps (myname);
	    free (myname);
	    oflag++;
	 }
	 break;
      case '?':
	 fprintf (stderr, "error at %c.\n", (char) optopt);
	 errflag++;
   }
   myname = (char *) strdup (argv[0]);
   if (optind == argc)	/* No further args, try synnr */
   {
      FILE *synnr;
      char line[SYN_LEN];
      synnr = fopen ("synnr", "r");
      if (synnr != NULL)
      {
        fgets (line, SYN_LEN-1, synnr);
	for (c=0;line[c]!='\0';c++)
	   if (line[c] < ' ')
	      line[c]='\0';
        fclose (synnr);
D 2
	if (synnr != NULL) free (synnr);
E 2
	if (line[0] != '0')
	{
	   printf ("Last project was: %s\n", line);
	   exit (1);
	}
	else
           readfile (& line[2]);
      }
      else
      {
	 printf ("Use get_at first.\n");
	 errflag++;
      }
   }
   else for (;optind < argc; optind++)
      readfile (argv[optind]);
   if (errflag)
   {
D 4
      fprintf (stderr, "usage: %s [-dh] [-l library] [-o output] [input]...\n",
E 4
I 4
      fprintf (stderr, "usage: %s [-deh] [-l library] [-o output] [input]...\n",
E 4
	 argv[0]);
      fprintf (stderr, "  -d	debugmode: prints text analysis.\n");
I 4
      fprintf (stderr, "  -e	encode univalent finals in nominal ending.\n");
E 4
      fprintf (stderr, "  -h	prints this help text.\n");
      fprintf (stderr, "  -l	path to language libraries (default: %s).\n", DEFAULT_LIB);
      fprintf (stderr, "  -b	basename: overrules default outputfile name (input.ps2 input.ct)\n");
      fprintf (stderr, "  input...	inputfile(s).\n");
      exit (2);
   }
   ps_close (ps);
   return 0;
}	/* main */
E 1
