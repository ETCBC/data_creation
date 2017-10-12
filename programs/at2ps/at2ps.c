#pragma ident "@(#)q2pro/at2ps/at2ps.c	1.5 13/02/21"

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

#include "error.h"
#include "global.h"
#include "ps_io_2.h"
#include "segment.h"
#include "word.h"
#include "wrdgrm.h"

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
int encode_nme = FALSE;

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

#define SET_POS(A) (strcmp(lemma_st, #A) == EQUAL) pos = wd_ ## A
#define SET_LEXSET(A) (strcmp(lemma_st, #A) == EQUAL) lexset = wd_ ## A

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

	 lemma_st = lemma_get_property (lemma, "sp");
	 if (lemma_st != NULL)
	 {
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
	 }

	 lemma_st = lemma_get_property (lemma, "ls");
	 if (lemma_st != NULL)
	 {
	    if SET_LEXSET(nmdi);
	    else if SET_LEXSET(nmcp);
	    else if SET_LEXSET(padv);
	    else if SET_LEXSET(afad);
	    else if SET_LEXSET(ppre);
	    else if SET_LEXSET(cjad);
	    else if SET_LEXSET(ordn);
	    else if SET_LEXSET(vbcp);
	    else if SET_LEXSET(mult);
	    else if SET_LEXSET(focp);
	    else if SET_LEXSET(ques);
	    else if SET_LEXSET(gntl);
	    else if SET_LEXSET(quot);
	    else if SET_LEXSET(card);
	    else
	       lexset = WORD_VALUE_UNKNOWN;
	    word_set_function(word, WORD_NOT_ENCLITIC, wd_lexical_set, lexset);
	 }

	 lemma_st = lemma_get_property (lemma, "gn");
	 if (lemma_st != NULL)
	 {
	    if (strcmp (lemma_st, "f") == EQUAL)
	       gender = wd_feminine;
	    else if (strcmp (lemma_st, "m") == EQUAL)
	       gender = wd_masculine;
	    else
	       gender = WORD_VALUE_UNKNOWN;
	 }
	 if (gender != WORD_VALUE_ABSENT)
	    word_set_function (word, WORD_NOT_ENCLITIC, wd_gender, gender);

	 lemma_st = lemma_get_property (lemma, "nu");
	 if (lemma_st != NULL)
	 {
	    if (strcmp(lemma_st, "s") == EQUAL)
	       number = wd_singular;
	    else if (strcmp(lemma_st, "d") == EQUAL)
	       number = wd_dual;
	    else if (strcmp(lemma_st, "p") == EQUAL)
	       number = wd_plural;
	    else
	       number = WORD_VALUE_UNKNOWN;
	 }
	 if (number != WORD_VALUE_ABSENT)
	     word_set_function (word, WORD_NOT_ENCLITIC, wd_number, number);

	 lemma_st = lemma_get_property (lemma, "ps");
	 if (lemma_st != NULL)
	 {
	    if (strcmp(lemma_st, "1") == EQUAL)
	       person = wd_first;
	    else if (strcmp(lemma_st, "2") == EQUAL)
	       person = wd_second;
	    else if (strcmp(lemma_st, "3") == EQUAL)
	       person = wd_third;
	    else
	       person = WORD_VALUE_UNKNOWN;
	 }
	 if (person != WORD_VALUE_ABSENT)
	    word_set_function (word, WORD_NOT_ENCLITIC, wd_person, person);
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
   while ((c = getopt(argc, argv, "dehl:o:")) != EOF)
   switch (c)
   {
      case 'd':
	 debug_mode = TRUE;
	 break;
      case 'e':
	 encode_nme = TRUE;
	 break;
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
      case 'o':		/* basename */
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
      fprintf (stderr, "usage: %s [-deh] [-l library] [-o output] [input]...\n",
	 argv[0]);
      fprintf (stderr, "  -d	debugmode: prints text analysis.\n");
      fprintf (stderr, "  -e	encode univalent finals in nominal ending.\n");
      fprintf (stderr, "  -h	prints this help text.\n");
      fprintf (stderr, "  -l	path to language libraries (default: %s).\n", DEFAULT_LIB);
      fprintf (stderr, "  -b	basename: overrules default outputfile name (input.ps2 input.ct)\n");
      fprintf (stderr, "  input...	inputfile(s).\n");
      exit (2);
   }
   ps_close (ps);
   return 0;
}	/* main */
