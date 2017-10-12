h07846
s 00005/00005/00663
d D 1.8 14/01/13 16:33:09 const 8 7
c Removed provision for weyiqtol, as it is no longer a verbal tense.
e
s 00017/00158/00651
d D 1.7 13/02/21 16:13:53 const 7 6
c Implemented `ls' as lexical set. Simplified `sp' and `vs'.
e
s 00515/00388/00294
d D 1.6 13/01/31 16:56:06 const 6 5
c Separate passive qal. Adjusted lexical set. Added -e option.
e
s 00003/00003/00679
d D 1.5 07/04/10 14:30:53 const 5 4
c Verse label Zeph was not recognised.
e
s 00018/00011/00664
d D 1.4 07/04/02 16:12:42 const 4 3
c Bug in language switch. Added emphatic state.
e
s 00001/00000/00674
d D 1.3 04/07/20 11:43:29 const 3 2
c Resolved a few compiler warnings.
e
s 00001/00003/00673
d D 1.2 03/11/06 15:23:12 const 2 1
c Placed under package WIVUq2pro.
e
s 00676/00000/00000
d D 1.1 00/09/19 12:20:34 const 1 0
c Version of May 29 1997
e
u
U
f e 0
f m q2pro/at2ps/ps_io_2.c
t
T
I 1
/***************************************************************/
/*							       */
/* ps_io_2 - library routines on ps files 		       */
/*							       */
/* author: Peter Crom					       */
/*							       */
/***************************************************************/

D 2
#pragma ident "%Z%/combinatory/%M% %I% %G%"
E 2
I 2
#pragma ident "%W% %E%"
E 2

#include	<errno.h>
#include	<string.h>
#include	<ctype.h>
#include	<sys/types.h>
#include	<stdlib.h>
#include	<stdio.h>

#include	<biblan.h>
#include	"word.h"
#include	"ps_io_2.h"


D 6
#define COLMAX	ps_control+1
E 6
I 6
#define COLMAX	ps_state+1
E 6

D 5
#define	books		38
E 5
I 5
#define	N_BOOKS		39
E 5

D 6
#define eqstr(A,B) (strcmp((A),(B)) == EQUAL)
E 6
I 6
#define eqstr(A,B)	(strcmp((A),(B)) == EQUAL)
#define max(a,b)	((a) > (b) ? (a) : (b))
E 6

static struct	bookname	{
   char	*newname;
   char	*ps_name;
D 5
} booknames [] = {
E 5
I 5
} booknames [N_BOOKS] = {
E 5
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


D 6
extern  char * sys_errlist[];
E 6
I 6
extern int     encode_nme;
extern char   *sys_errlist[];
E 6

PRIVATE FILE *ctfile;
PRIVATE FILE *ct1file;
PRIVATE int  ct_start;

PRIVATE void *
emalloc (size)
   size_t	size;
{
   void		*p;

   if ((p = malloc (size)) == NULL)
   {  bl_seterr ("not enough memory, when %d requested",
	 (size_t) size);
   }
   return p;
}	/* emalloc */

#define NEW(type,var) type *(var) = (type *) emalloc (sizeof (type))


PUBLIC ps_t *
ps_open (filename)
/* filename must be the name of a book */
char	*filename;
{
   NEW (ps_t, ps);
   if (ps != NULL)
   {
      if ((ps->fp = fopen (filename, "w")) == NULL)
      {  bl_seterr ("ps_open: %s: %s", "Cannot open ps file:", sys_errlist[errno]);
         return NULL;
      }
      ps->new_verse = TRUE;
      ps->prev_conj = PS_PREV_NOCONJ;
   }
   strcpy (strstr (filename, ".ps2"), ".ct1");
   ct1file = fopen (filename, "w");
   strcpy (strstr (filename, ".ct1"), ".ct");
   ctfile = fopen (filename, "w");
   ct_start = TRUE;
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
   fprintf (ctfile, "*\n");
   fprintf (ct1file, "*\n");
   closed = closed || fclose (ctfile);
   closed = closed || fclose (ct1file);
D 2
   free (ctfile);
   free (ct1file);
E 2
   return closed;
}	/* ps_close */


PRIVATE void
D 6
put_ct (char *s, int at_status)
E 6
I 6
put_ct (char *s, unsigned at_status)
E 6
{
   int i;
   char c = ' ';
   size_t len = strlen (s);
   for (i=0; i<len ; i++)
   {
      while (s[i] == '(')
	 i=i+2;
      if (((i < len) && bl_iscons (s[i]) || s[i]=='_'))
         fprintf (ctfile, "%c", s[i]);
   }
   if (at_status & BL_CONNECTED)
      c = '-';
   fprintf (ctfile, "%c", c);
}	/* put_ct (s, at_status); */

I 3
PRIVATE void
E 3
D 6
put_ct1 (char *s, int at_status)
E 6
I 6
put_ct1 (char *s, unsigned at_status)
E 6
{
   fprintf (ct1file, "%s", s);
   if (at_status & BL_CONNECTED)
      fprintf (ct1file, "-");
   else
      fprintf (ct1file, " ");
}	/* put_ct1 (s, at_status); */

I 6
#define NME_SIZ	24	/* Size of the range of nominal endings */
#define UVF_SIZ	6	/* Size of the range of univalent finals */

#define SKEW	((NME_SIZ - 2) / (UVF_SIZ - 2))

PRIVATE int
nmencode(int n, int u)
{
   if (encode_nme)
      return n + (u == 0 ? 0 :
		  (u - 1) * NME_SIZ - ((u - 3) * (u - 2) / 2) * SKEW);
   else
      return u == ps_uf_h ? ps_ne_wt + max(1, n) : n;
}

E 6
PUBLIC int
D 6
ps_putword (ps_t *ps, word_t *word, char *atform, int at_status)
E 6
I 6
ps_putword (ps_t *ps, word_t *word, char *atform, unsigned at_status)
E 6

/* store word information */

{
D 6
   char	*lexeme;
   char verse_id[12];
   vsid_t *vsid;
   int m1, m2, f1;
   int	i, ps_value;
   int	Column[COLMAX];
E 6
I 6
   int            Column[COLMAX];
D 7
   int            acc_sfx = 0;
E 7
I 7
   int            acc_sfx;		/* accepts suffix? */
E 7
   int            f1;
   int            i;
   int            has_vbe;
   char          *lexeme;
   int            m1, m2;
   int            v1, v2;
   char           verse_id[12];
   vsid_t        *vsid;
E 6

/* vers id 1-10*/
   vsid = word_get_vsid (word);
D 5
   for (i = 0; i < books; i++)
E 5
I 5
   for (i = 0; i < N_BOOKS; i++)
E 5
   {  if (eqstr(vsid->book, booknames[i].newname))
      {  if (i == 30)	/* psalms */
            sprintf (verse_id, "%s%.3d,%.3d ",
	    booknames[i].ps_name,
	    vsid->index[0],
	    vsid->index[1]);
	 else
            sprintf (verse_id, "%s%2.2d,%2.2d ",
	    booknames[i].ps_name,
	    vsid->index[0],
	    vsid->index[1]);
	 break;
      }
   }
   fprintf (ps->fp, "%s", verse_id);
   if (at_status & BL_NEWVERSE)
   {
      if (!ct_start)
      {
	 fprintf (ctfile, "*\n");
	 fprintf (ct1file, "*\n");
      }
      ct_start = FALSE;
      fprintf (ctfile, "%s", verse_id);
      fprintf (ct1file, "%s", verse_id);
   }
   vsid_delete (vsid);

/* lexeme 12-28 */
   lexeme = word_get_lexeme (word);
   fprintf (ps->fp, "%-17s ", lexeme);

   put_ct (atform, at_status);
   put_ct1 (atform, at_status);

I 6
   has_vbe = word_get_morpheme(word, wd_vbe) != WORD_VALUE_ABSENT;

E 6
/* lexical set 30-32 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_lexical_set);
D 6
   switch (f1)
   {
      case wd_card:
      case wd_quot:
      case wd_gens:
	 ps_value = -1; break;
      case wd_gntl:
      case wd_pers:
      case wd_mult:
      case wd_vbex:
	 ps_value = -2; break;
      case wd_ordn:
      case wd_topo:
      case wd_ppre:
	 ps_value = -3; break;
      case wd_padv:
	 ps_value = -4; break;
      case wd_nmex:
	 ps_value = -5; break;
      case wd_nmdi:
	 ps_value = -6; break;
      case WORD_VALUE_ABSENT:
      case wd_pcon:
      case wd_pinr:
      case wd_ppde:
      default:
	 ps_value = 0;
E 6
I 6
   switch (f1) {
   case wd_nmdi:
      Column[ps_lexset] = -6;
      break;
D 7
   case wd_nmex:
E 7
I 7
   case wd_nmcp:
E 7
      Column[ps_lexset] = -5;
      break;
   case wd_padv:
I 7
   case wd_afad:
E 7
      Column[ps_lexset] = -4;
      break;
D 7
   case wd_ordn:
E 7
   case wd_ppre:
D 7
   case wd_topo:
E 7
I 7
   case wd_cjad:
   case wd_ordn:
E 7
      Column[ps_lexset] = -3;
      break;
D 7
   case wd_gntl:
E 7
I 7
   case wd_vbcp:
E 7
   case wd_mult:
D 7
   case wd_pers:
   case wd_vbex:
E 7
I 7
   case wd_focp:
   case wd_ques:
   case wd_gntl:
E 7
      Column[ps_lexset] = -2;
      break;
D 7
   case wd_card:
   case wd_focp:
   case wd_gens:
E 7
   case wd_quot:
I 7
   case wd_card:
E 7
      Column[ps_lexset] = -1;
      break;
   default:
      Column[ps_lexset] = 0;
E 6
   }
D 6
   Column [ps_lexset] = ps_value;
E 6

/* lexical part of speech 34-36 */
D 6
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_part_of_speech);
   switch (f1)
   {
      case wd_adjv:
	 ps_value = ps_adjective; break;
      case wd_advb:
	 ps_value = ps_adverb; break;
      case wd_art:
	 ps_value = ps_article; break;
      case wd_conj:
	 ps_value = ps_conjunction; break;
      case wd_inrg:
	 ps_value = ps_interrogative_particle; break;
      case wd_intj:
	 ps_value = ps_interjection; break;
      case wd_nega:
	 ps_value = ps_negative_particle; break;
      case wd_nmpr:
	 ps_value = ps_proper_name; break;
      case wd_prde:
	 ps_value = ps_demonstrative_pronoun; break;
      case wd_prep:
	 ps_value = ps_preposition; break;
      case wd_prin:
	 ps_value = ps_interrogative_pronoun; break;
      case wd_prps:
	 ps_value = ps_personal_pronoun; break;
      case wd_subs:
	 ps_value = ps_substantive; break;
      case wd_verb:
	 ps_value = ps_verb; break;
      case WORD_VALUE_ABSENT:
      default:
	 ps_value = -1;	break;	/* illegal, but, you never know */
E 6
I 6
   f1 = word_get_function(word, WORD_NOT_ENCLITIC, wd_part_of_speech);
D 7
   switch (f1) {
   case WORD_VALUE_UNKNOWN:
      Column[ps_part_of_speech] = PS_ABSENT;
      break;
   case wd_adjv:
      Column[ps_part_of_speech] = ps_adjective;
      acc_sfx = 1;
      break;
   case wd_advb:
      Column[ps_part_of_speech] = ps_adverb;
      break;
   case wd_art:
      Column[ps_part_of_speech] = ps_article;
      break;
   case wd_conj:
      Column[ps_part_of_speech] = ps_conjunction;
      break;
   case wd_inrg:
      Column[ps_part_of_speech] = ps_interrogative_particle;
      acc_sfx = 1;
      break;
   case wd_intj:
      Column[ps_part_of_speech] = ps_interjection;
      acc_sfx = 1;
      break;
   case wd_nega:
      Column[ps_part_of_speech] = ps_negative_particle;
      break;
   case wd_nmpr:
      Column[ps_part_of_speech] = ps_proper_name;
      break;
   case wd_prde:
      Column[ps_part_of_speech] = ps_demonstrative_pronoun;
      break;
   case wd_prep:
      Column[ps_part_of_speech] = ps_preposition;
      acc_sfx = 1;
      break;
   case wd_prin:
      Column[ps_part_of_speech] = ps_interrogative_pronoun;
      break;
   case wd_prps:
      Column[ps_part_of_speech] = ps_personal_pronoun;
      break;
   case wd_subs:
      Column[ps_part_of_speech] = ps_substantive;
      acc_sfx = 1;
      break;
   case wd_verb:
      Column[ps_part_of_speech] = ps_verb;
      acc_sfx = 1;
      break;
   default:
      Column[ps_part_of_speech] = PS_NOT_RELEVANT;
E 6
   }
E 7
I 7
   Column[ps_part_of_speech] = f1 < 1 ? PS_NOT_RELEVANT : f1 - 1;
   acc_sfx = has_vbe ||
      f1 == wd_subs || f1 == wd_adjv ||		/* not nmpr */
      f1 == wd_prep || f1 == wd_intj || f1 == wd_inrg;
E 7
D 6
   Column [ps_part_of_speech] = ps_value;
E 6

/* !! subject tense prefix 38-39 */
D 6

   if (Column [ps_part_of_speech] != ps_verb)
      ps_value = PS_NOT_RELEVANT;
   else
   {
      f1 = word_get_morpheme (word, wd_pfm);
      switch (f1)
      {
         case wd_pf_:
	    ps_value = ps_pr_; break;
         case wd_pf_a:
	    ps_value = ps_pr_a; break;
         case wd_pf_h:
	    ps_value = ps_pr_h; break;
         case wd_pf_j:
	    ps_value = ps_pr_j; break;
         case wd_pf_m:
	    ps_value = ps_pr_m; break;
         case wd_pf_n:
	    ps_value = ps_pr_n; break;
         case wd_pf_t:
	    ps_value = ps_pr_t; break;
         case wd_pf_t_:
	    ps_value = ps_pr_t_; break;
	 default:
            ps_value = PS_ABSENT;
      }
E 6
I 6
   m1 = word_get_morpheme(word, wd_pfm);
   switch (m1) {
   case wd_pf_:
      Column[ps_prefix] = ps_pr_;
      break;
   case wd_pf_a:
      Column[ps_prefix] = ps_pr_a;
      break;
   case wd_pf_h:
      Column[ps_prefix] = ps_pr_h;
      break;
   case wd_pf_j:
      Column[ps_prefix] = ps_pr_j;
      break;
   case wd_pf_l:
      Column[ps_prefix] = ps_pr_l;
      break;
   case wd_pf_m:
      Column[ps_prefix] = ps_pr_m;
      break;
   case wd_pf_n:
      Column[ps_prefix] = ps_pr_n;
      break;
   case wd_pf_t:
      Column[ps_prefix] = ps_pr_t;
      break;
   case wd_pf_t_:
      Column[ps_prefix] = ps_pr_t_;
      break;
   default:
      Column[ps_prefix] = has_vbe ? PS_ABSENT : PS_NOT_RELEVANT;
E 6
   }
D 6
   Column [ps_prefix] = ps_value;
E 6

/* ]] verbal stem 41-42 */
I 6
   f1 = word_get_function(word, WORD_NOT_ENCLITIC, wd_verbal_stem);
D 7
   switch (f1) {
   case WORD_VALUE_UNKNOWN:
      Column[ps_verbal_stem] = PS_ABSENT;
      break;
   case wd_afel:
      Column[ps_verbal_stem] = ps_afel;
      break;
   case wd_etpa:
      Column[ps_verbal_stem] = ps_etpa;
      break;
   case wd_etpe:
      Column[ps_verbal_stem] = ps_etpe;
      break;
   case wd_haf:
      Column[ps_verbal_stem] = ps_haf;
      break;
   case wd_hif:
      Column[ps_verbal_stem] = ps_hif;
      break;
   case wd_hst:
      Column[ps_verbal_stem] = ps_hst;
      break;
   case wd_htpa:
      Column[ps_verbal_stem] = ps_htpa;
      break;
   case wd_hit:
      Column[ps_verbal_stem] = ps_hit;
      break;
   case wd_htpe:
      Column[ps_verbal_stem] = ps_htpe;
      break;
   case wd_hof:
      Column[ps_verbal_stem] = ps_hof;
      break;
   case wd_hotp:
      Column[ps_verbal_stem] = ps_hotp;
      break;
   case wd_nif:
      Column[ps_verbal_stem] = ps_nif;
      break;
   case wd_nit:
      Column[ps_verbal_stem] = ps_nit;
      break;
   case wd_pael:
      Column[ps_verbal_stem] = ps_pael;
      break;
   case wd_pasqal:
      Column[ps_verbal_stem] = ps_pasqal;
      break;
   case wd_peal:
      Column[ps_verbal_stem] = ps_peal;
      break;
   case wd_peil:
      Column[ps_verbal_stem] = ps_peil;
      break;
   case wd_piel:
      Column[ps_verbal_stem] = ps_piel;
      break;
   case wd_pual:
      Column[ps_verbal_stem] = ps_pual;
      break;
   case wd_qal:
      Column[ps_verbal_stem] = ps_qal;
      break;
   case wd_saf:
      Column[ps_verbal_stem] = ps_saf;
      break;
   case wd_tif:
      Column[ps_verbal_stem] = ps_tif;
      break;
   default:
      Column[ps_verbal_stem] = PS_NOT_RELEVANT;
   }
E 7
I 7
   Column[ps_verbal_stem] = f1 < 1 ? PS_NOT_RELEVANT : f1 - 1;
E 7
E 6

D 6
   if (Column[ps_part_of_speech] == ps_verb)
   {
      f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_verbal_stem);
      switch (f1)
      {
	 case wd_qal:
	 case wd_pasqal:
	    ps_value = ps_qal; break;
	 case wd_niphal:
	    ps_value = ps_nifal; break;
         case wd_nitpael:
	    ps_value = ps_nitpael; break;
	 case wd_piel:
	    ps_value = ps_piel; break;
	 case wd_pual:
	    ps_value = ps_pual; break;
	 case wd_hiphil:
	    ps_value = ps_hifil; break;
	 case wd_hophal:
	    ps_value = ps_hofal; break;
	 case wd_hitp:
	    ps_value = ps_hitpael; break;
	 case wd_hotp:
	    ps_value = ps_hotpaal; break;
	 case wd_etp:
	    ps_value = ps_etpaal; break;
	 case wd_tiphal:
	    ps_value = ps_tifal; break;
	 default:
	    ps_value = PS_NOT_RELEVANT;
      }
   } else
      ps_value = PS_NOT_RELEVANT;
   Column [ps_verbal_stem] = ps_value;

E 6
/* [ subject tense suffix 44-45 */
D 6
   if (Column [ps_part_of_speech] == ps_verb)
   {
      ps_value = PS_ABSENT;
      m1 = word_get_morpheme (word, wd_vbe);
      switch (m1)
      {
	 case wd_vb_:
	    ps_value = ps_ve_; break;
	 case wd_vb_h:
	    ps_value = ps_ve_h; break;
	 case wd_vb_h_:
	    ps_value = ps_ve_h_; break;
	 case wd_vb_w:
	    ps_value = ps_ve_w; break;
	 case wd_vb_wn:
	    ps_value = ps_ve_wn; break;
	 case wd_vb_j:
	    ps_value = ps_ve_j; break;
	 case wd_vb_jn:
	    ps_value = ps_ve_jn; break;
	 case wd_vb_nh:
	    ps_value = ps_ve_nh; break;
	 case wd_vb_nw:
	    ps_value = ps_ve_nw; break;
	 case wd_vb_t:
	    ps_value = ps_ve_t; break;
	 case wd_vb_t_:
	    ps_value = ps_ve_t_; break;
	 case wd_vb_th:
	    ps_value = ps_ve_th; break;
	 case wd_vb_tj:
	    ps_value = ps_ve_tj; break;
	 case wd_vb_tm:
	    ps_value = ps_ve_tm; break;
	 case wd_vb_tn:
	    ps_value = ps_ve_tn; break;
	 default:
	    ps_value = PS_ABSENT;
      }
E 6
I 6
   m1 = word_get_morpheme(word, wd_vbe);
   switch (m1) {
   case wd_vb_:
      Column[ps_verbal_ending] = ps_ve_;
      break;
   case wd_vb_h:
      Column[ps_verbal_ending] = ps_ve_h;
      break;
   case wd_vb_h_:
      Column[ps_verbal_ending] = ps_ve_h_;
      break;
   case wd_vb_w:
      Column[ps_verbal_ending] = ps_ve_w;
      break;
   case wd_vb_wn:
      Column[ps_verbal_ending] = ps_ve_wn;
      break;
   case wd_vb_j:
      Column[ps_verbal_ending] = ps_ve_j;
      break;
   case wd_vb_jn:
      Column[ps_verbal_ending] = ps_ve_jn;
      break;
   case wd_vb_n:
      Column[ps_verbal_ending] = ps_ve_n;
      break;
   case wd_vb_na:
      Column[ps_verbal_ending] = ps_ve_na;
      break;
   case wd_vb_nh:
      Column[ps_verbal_ending] = ps_ve_nh;
      break;
   case wd_vb_nw:
      Column[ps_verbal_ending] = ps_ve_nw;
      break;
   case wd_vb_t:
      Column[ps_verbal_ending] = ps_ve_t;
      break;
   case wd_vb_t_:
      Column[ps_verbal_ending] = ps_ve_t_;
      break;
   case wd_vb_t__:
      Column[ps_verbal_ending] = ps_ve_t__;
      break;
   case wd_vb_th:
      Column[ps_verbal_ending] = ps_ve_th;
      break;
   case wd_vb_twn:
      Column[ps_verbal_ending] = ps_ve_twn;
      break;
   case wd_vb_tj:
      Column[ps_verbal_ending] = ps_ve_tj;
      break;
   case wd_vb_tm:
      Column[ps_verbal_ending] = ps_ve_tm;
      break;
   case wd_vb_tn:
      Column[ps_verbal_ending] = ps_ve_tn;
      break;
   default:
      Column[ps_verbal_ending] = has_vbe ? PS_ABSENT : PS_NOT_RELEVANT;
E 6
   }
D 6
   else
      ps_value = PS_NOT_RELEVANT;
   Column [ps_verbal_ending] = ps_value;
E 6

D 6
/* / nominal suffix 47-48 */
   if (Column[ps_part_of_speech] == ps_verb)
      ps_value = PS_ABSENT;
   else
      ps_value = PS_NOT_RELEVANT;
   m1 = word_get_morpheme (word, wd_nme);
   m2 = word_get_morpheme (word, wd_loc);
   if (m2 == wd_lc_h)
   switch (m1)
   {
      case wd_nm_:
      case WORD_VALUE_ABSENT:
	 ps_value = ps_ne_h_; break;
      case wd_nm_t:
	 ps_value = ps_ne_th; break;
      case wd_nm_jm:
	 ps_value = ps_ne_jmh; break;
    }
    else switch (m1)
    {
      case wd_nm_:
	 ps_value = ps_ne_; break;
      case wd_nm_h:
	 ps_value = ps_ne_h; break;
      case wd_nm_wt:
         ps_value = ps_ne_wt; break;
      case wd_nm_wtj:
	 ps_value = ps_ne_wtj; break;
      case wd_nm_j:
	 ps_value = ps_ne_j; break;
      case wd_nm_j_:
	 ps_value = ps_ne_j_; break;
      case wd_nm_jm:
	 ps_value = ps_ne_jm; break;
      case wd_nm_jm_:
	 ps_value = ps_ne_jm_; break;
      case wd_nm_jn:
	 ps_value = ps_ne_jn; break;
      case wd_nm_t:
	 ps_value = ps_ne_t; break;
      case wd_nm_tj:
	 ps_value = ps_ne_tj; break;
      case wd_nm_tjm:
	 ps_value = ps_ne_tjm; break;
E 6
I 6
/* / nominal suffix 47-48 and ~ univalent final ending 47-48 */
   m1 = word_get_morpheme(word, wd_nme);
   m2 = word_get_morpheme(word, wd_uvf);
   switch (m1) {
   case wd_nm_:
      v1 = ps_ne_;
      break;
   case wd_nm_h:
      v1 = ps_ne_h;
      break;
   case wd_nm_w:
      v1 = ps_ne_w;
      break;
   case wd_nm_w_:
      v1 = ps_ne_w_;
      break;
   case wd_nm_wt:
      v1 = ps_ne_wt;
      break;
   case wd_nm_wtj:
      v1 = ps_ne_wtj;
      break;
   case wd_nm_j:
      v1 = ps_ne_j;
      break;
   case wd_nm_j_:
      v1 = ps_ne_j_;
      break;
   case wd_nm_jm:
      v1 = ps_ne_jm;
      break;
   case wd_nm_jm_:
      v1 = ps_ne_jm_;
      break;
   case wd_nm_jn:
      v1 = ps_ne_jn;
      break;
   case wd_nm_jn_:
      v1 = ps_ne_jn_;
      break;
   case wd_nm_n:
      v1 = ps_ne_n;
      break;
   case wd_nm_t:
      v1 = ps_ne_t;
      break;
   case wd_nm_t_:
      v1 = ps_ne_t_;
      break;
   case wd_nm_tj:
      v1 = ps_ne_tj;
      break;
   case wd_nm_tjm:
      v1 = ps_ne_tjm;
      break;
   case wd_nm_tjn:
      v1 = ps_ne_tjn;
      break;
   default:
      v1 = has_vbe ? PS_ABSENT : PS_NOT_RELEVANT;
E 6
   }
D 6
   Column [ps_nominal_ending] = ps_value;
E 6
I 6
   switch (m2) {
   case wd_uf_a:
      v2 = ps_uf_a;
      break;
   case wd_uf_h:
      v2 = ps_uf_h;
      break;
   case wd_uf_w:
      v2 = ps_uf_w;
      break;
   case wd_uf_j:
      v2 = ps_uf_j;
      break;
   case wd_uf_n:
      v2 = ps_uf_n;
      break;
   default:
      v2 = PS_ABSENT;
   }
   Column[ps_nominal_ending] = nmencode(v1, v2);
E 6

/* + pronominal suffix 50-51 */
D 6
   switch (Column[ps_part_of_speech])
   {  case ps_article:
      case ps_proper_name:
      case ps_adverb:
      case ps_conjunction:
      case ps_personal_pronoun:
      case ps_demonstrative_pronoun:
      case ps_negative_particle:
	 ps_value = PS_NOT_RELEVANT;
	 break;
      default:
         ps_value = PS_ABSENT;
	 m1 = word_get_morpheme (word, wd_prs);
	 switch (m1)
	 {
	    case wd_ps_h:
	       ps_value = ps_sf_h; break;
	    case wd_ps_hw:
	       ps_value = ps_sf_hw; break;
	    case wd_ps_hm:
	       ps_value = ps_sf_hm; break;
	    case wd_ps_hmh:
	       ps_value = ps_sf_hmh; break;
	    case wd_ps_hn:
	       ps_value = ps_sf_hn; break;
	    case wd_ps_hnh:
	       ps_value = ps_sf_hnh; break;
	    case wd_ps_w:
	       ps_value = ps_sf_w; break;
	    case wd_ps_j:
	       ps_value = ps_sf_j; break;
	    case wd_ps_k:
	       ps_value = ps_sf_k; break;
	    case wd_ps_k_:
	       ps_value = ps_sf_k_; break;
	    case wd_ps_km:
	       ps_value = ps_sf_km; break;
	    case wd_ps_kn:
	       ps_value = ps_sf_kn; break;
	    case wd_ps_m:
	       ps_value = ps_sf_m; break;
	    case wd_ps_mw:
	       ps_value = ps_sf_mw; break;
	    case wd_ps_n:
	       ps_value = ps_sf_n; break;
	    case wd_ps_nw:
	       ps_value = ps_sf_nw; break;
	    case wd_ps_nj:
	       ps_value = ps_sf_nj;
	 }
E 6
I 6
   m1 = word_get_morpheme(word, wd_prs);
   switch (m1) {
   case wd_ps_h:
      Column[ps_suffix] =
	 word_get_function(word, wd_prs, wd_gender) == wd_feminine ?
	 ps_sf_h : ps_sf_h2;
      break;
   case wd_ps_h_:
      Column[ps_suffix] = ps_sf_h_;
      break;
   case wd_ps_hw:
      Column[ps_suffix] = ps_sf_hw;
      break;
   case wd_ps_hwn:
      Column[ps_suffix] = ps_sf_hwn;
      break;
   case wd_ps_hj:
      Column[ps_suffix] = ps_sf_hj;
      break;
   case wd_ps_hm:
      Column[ps_suffix] = ps_sf_hm;
      break;
   case wd_ps_hn:
      Column[ps_suffix] = ps_sf_hn;
      break;
   case wd_ps_w:
      Column[ps_suffix] = ps_sf_w;
      break;
   case wd_ps_j:
      Column[ps_suffix] = ps_sf_j;
      break;
   case wd_ps_k:
      Column[ps_suffix] = ps_sf_k;
      break;
   case wd_ps_k_:
      Column[ps_suffix] = ps_sf_k_;
      break;
   case wd_ps_kwn:
      Column[ps_suffix] = ps_sf_kwn;
      break;
   case wd_ps_kj:
      Column[ps_suffix] = ps_sf_kj;
      break;
   case wd_ps_km:
      Column[ps_suffix] = ps_sf_km;
      break;
   case wd_ps_kn:
      Column[ps_suffix] = ps_sf_kn;
      break;
   case wd_ps_m:
      Column[ps_suffix] = ps_sf_m;
      break;
   case wd_ps_mw:
      Column[ps_suffix] = ps_sf_mw;
      break;
   case wd_ps_n:
      Column[ps_suffix] = ps_sf_n;
      break;
   case wd_ps_na:
      Column[ps_suffix] = ps_sf_na;
      break;
   case wd_ps_nw:
      Column[ps_suffix] = ps_sf_nw;
      break;
   case wd_ps_nj:
      Column[ps_suffix] = ps_sf_nj;
      break;
   default:
      Column[ps_suffix] = acc_sfx ? PS_ABSENT : PS_NOT_RELEVANT;
E 6
   }
D 6
   Column [ps_suffix] = ps_value;
E 6

D 6
/* verbal tense 55-56 */
   if (Column[ps_part_of_speech] != ps_verb)
      ps_value = PS_NOT_RELEVANT;
   else
   {  ps_value = PS_ABSENT;
      f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_verbal_tense);
      if (f1 == wd_ipf)
      {
	 if (ps->prev_conj == PS_PREV_NOCONJ) /* ipf yiqtol */
	    ps_value = ps_vt_ipf;
	 else
         if (ps->prev_conj == PS_PREV_W_CONJ) /* we-ipf we-yiqtol */
	    ps_value = ps_vt_we_ipf;
	 else
         if (ps->prev_conj == PS_PREV_NARR_CONJ) /* ipf-cons way-yiqtol */
	    ps_value = ps_vt_ipf_cons;
      }
      else
      if (f1 == wd_pf) 	/* pf	qatal */
	 ps_value = ps_vt_pf;
      else
      if (f1 == wd_imp)	/* imp	qtol */
	 ps_value = ps_vt_imp;
      else
      if (f1 == wd_inf)
      {  if (word_get_mark (word, wd_vpm, wd_vp_a))  /* inf abs  qatol */
	    ps_value = ps_vt_infa;
	 else
	    ps_value = ps_vt_infc;	/* inf cstr qetol */
      }
      else
      if (f1 == wd_ptc)
      {  if (word_get_mark(word, wd_vpm, wd_vp_p)) /* pass ptc qatul */
	    ps_value = ps_vt_pas_ptc;
         else
	    ps_value = ps_vt_ptc;	/* ptc	qotel */
      }
E 6
I 6
   /* verbal tense 55-56 */
   f1 = word_get_function(word, WORD_NOT_ENCLITIC, wd_verbal_tense);
   switch (f1) {
D 7
   case WORD_VALUE_UNKNOWN:
      Column[ps_verbal_tense] = PS_ABSENT;
      break;
   case wd_ipf:
E 7
I 7
   case wd_impf:
E 7
D 8
      if (ps->prev_conj == PS_PREV_NOCONJ)
	 Column[ps_verbal_tense] = ps_vt_ipf;
      else if (ps->prev_conj == PS_PREV_W_CONJ)
	 Column[ps_verbal_tense] = ps_vt_we_ipf;
      else if (ps->prev_conj == PS_PREV_NARR_CONJ)
E 8
I 8
      /* We have abolished ps_vt_we_ipf, because we are convinced
	 it is not a verbal tense, but a clause type */
      if (ps->prev_conj == PS_PREV_NARR_CONJ)
E 8
	 Column[ps_verbal_tense] = ps_vt_ipf_cons;
I 8
      else
	 Column[ps_verbal_tense] = ps_vt_ipf;
E 8
      break;
D 7
   case wd_pf:
      Column[ps_verbal_tense] = ps_vt_pf;
      break;
   case wd_imp:
      Column[ps_verbal_tense] = ps_vt_imp;
      break;
   case wd_infc:
      Column[ps_verbal_tense] = ps_vt_infc;
      break;
   case wd_infa:
      Column[ps_verbal_tense] = ps_vt_infa;
      break;
   case wd_ptc:
      Column[ps_verbal_tense] = ps_vt_ptc;
      break;
E 7
   case wd_ptcp:
      Column[ps_verbal_tense] = ps_vt_pas_ptc;
      break;
   default:
D 7
      Column[ps_verbal_tense] = PS_NOT_RELEVANT;
E 7
I 7
      Column[ps_verbal_tense] = f1 < 0 ? PS_NOT_RELEVANT : f1;
E 7
E 6
   }
D 6
   Column [ps_verbal_tense] = ps_value;
E 6

/* person 58-59 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_person);
D 6
   switch (f1)
   {
      case WORD_VALUE_UNKNOWN:
	 ps_value = PS_ABSENT;
	 break;
      case WORD_VALUE_ABSENT:
	 ps_value = PS_NOT_RELEVANT;
	 break;
      case wd_first:
	 ps_value = ps_ps_first;
	 break;
      case wd_second:
	 ps_value = ps_ps_second;
	 break;
      case wd_third:
	 ps_value = ps_ps_third;
	 break;
E 6
I 6
   switch (f1) {
   case WORD_VALUE_UNKNOWN:
      Column[ps_person] = PS_ABSENT;
      break;
   case wd_first:
      Column[ps_person] = ps_ps_first;
      break;
   case wd_second:
      Column[ps_person] = ps_ps_second;
      break;
   case wd_third:
      Column[ps_person] = ps_ps_third;
      break;
   default:
      Column[ps_person] = PS_NOT_RELEVANT;
E 6
   }
D 6
   Column [ps_person] = ps_value;
   
E 6
I 6

E 6
/* number 61-62 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_number);
D 6
   switch (f1)
   {
      case WORD_VALUE_UNKNOWN:
	 ps_value = PS_ABSENT;
	 break;
      case WORD_VALUE_ABSENT:
	 ps_value = PS_NOT_RELEVANT;
	 break;
      case wd_singular:
	 ps_value = ps_nu_singular;
	 break;
      case wd_dual:
	 ps_value = ps_nu_dual;
	 break;
      case wd_plural:
	 ps_value = ps_nu_plural;
	 break;
E 6
I 6
   switch (f1) {
   case WORD_VALUE_UNKNOWN:
      Column[ps_number] = PS_ABSENT;
      break;
   case wd_singular:
      Column[ps_number] = ps_nu_singular;
      break;
   case wd_dual:
      Column[ps_number] = ps_nu_dual;
      break;
   case wd_plural:
      Column[ps_number] = ps_nu_plural;
      break;
   default:
      Column[ps_number] = PS_NOT_RELEVANT;
E 6
   }
D 6
   Column [ps_number] = ps_value;
   
E 6
I 6

E 6
/* gender 64-65 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_gender);
D 6
   switch (f1)
   {
      case WORD_VALUE_UNKNOWN:
	 ps_value = PS_ABSENT;
	 break;
      case WORD_VALUE_ABSENT:
	 ps_value = PS_NOT_RELEVANT;
	 break;
      case wd_feminine:
	 ps_value = ps_gn_feminine;
	 break;
      case wd_masculine:
	 ps_value = ps_gn_masculine;
	 break;
E 6
I 6
   switch (f1) {
   case WORD_VALUE_UNKNOWN:
      Column[ps_gender] = PS_ABSENT;
      break;
   case wd_feminine:
      Column[ps_gender] = ps_gn_feminine;
      break;
   case wd_masculine:
      Column[ps_gender] = ps_gn_masculine;
      break;
   default:
      Column[ps_gender] = PS_NOT_RELEVANT;
E 6
   }
D 6
   Column [ps_gender] = ps_value;
E 6
D 4
   
E 4
I 4

E 4
/* status 67-68 */
D 4
   ps_value = PS_NOT_RELEVANT;
   if (Column[ps_nominal_ending] > PS_ABSENT)
      ps_value = PS_ABSENT;
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_state);
   if (f1 == wd_cons)
      ps_value = ps_st_construct;
   else
   if (f1 == wd_abs)
      ps_value = ps_st_absolute;
   Column [ps_state] = ps_value;
E 4
I 4
   f1 = word_get_function(word, WORD_NOT_ENCLITIC, wd_state);
   switch (f1) {
   case WORD_VALUE_UNKNOWN:
      Column[ps_state] = PS_ABSENT;
      break;
   case wd_cons:
      Column[ps_state] = ps_st_construct;
      break;
   case wd_abs:
      Column[ps_state] = ps_st_absolute;
      break;
   case wd_emph:
      Column[ps_state] = ps_st_emphatic;
      break;
   default:
      Column[ps_state] = PS_NOT_RELEVANT;
   }
E 4

D 6
   ps_value = PS_NOT_RELEVANT;

/* phrase dependent part of speech 74-75 */
   Column [ps_phrase_POS] = ps_value;

/* phrase type 77-78 */
   Column [ps_phrase_type] = ps_value;

/* phrase determination 80-81 */
   Column [ps_determination] = ps_value;

/* control number 83-84 */
   Column [ps_control] = ps_value;

E 6
/* print values */

   fprintf (ps->fp, "%3d ", Column [ps_lexset]);
   fprintf (ps->fp, "%3d ", Column [ps_part_of_speech]);
   fprintf (ps->fp, "%2d ", Column [ps_prefix]);
   fprintf (ps->fp, "%2d ", Column [ps_verbal_stem]);
   fprintf (ps->fp, "%2d ", Column [ps_verbal_ending]);
   fprintf (ps->fp, "%2d ", Column [ps_nominal_ending]);
D 6
   fprintf (ps->fp, "%2d   ", Column [ps_suffix]);
   fprintf (ps->fp, "%2d ", Column [ps_verbal_tense]);
E 6
I 6
   fprintf (ps->fp, "%2d ", Column [ps_suffix]);
   fprintf (ps->fp, "%4d ", Column [ps_verbal_tense]);
E 6
   fprintf (ps->fp, "%2d ", Column [ps_person]);
   fprintf (ps->fp, "%2d ", Column [ps_number]);
   fprintf (ps->fp, "%2d ", Column [ps_gender]);
D 6
   fprintf (ps->fp, "%2d     ", Column [ps_state]);
   fprintf (ps->fp, "%2d ", Column [ps_phrase_POS]);
   fprintf (ps->fp, "%2d ", Column [ps_phrase_type]);
   fprintf (ps->fp, "%2d ", Column [ps_determination]);
   fprintf (ps->fp, "%2d\n", Column [ps_control]);
E 6
I 6
   fprintf (ps->fp, "%5d\n", Column [ps_state]);
E 6

/* setup last things to remember next time */

   if (eqstr (lexeme, "W"))
   {  if (word_get_mark (word, wd_vpm, wd_vp_n))
	 ps->prev_conj = PS_PREV_NARR_CONJ;
      else
	 ps->prev_conj = PS_PREV_W_CONJ;
   }
   else
      ps->prev_conj = PS_PREV_NOCONJ;
   ps->new_verse = FALSE;
   free (lexeme);
   return TRUE;
}	/* ps_putword */


PUBLIC	void
ps_putverse (ps_t *ps)
{
   ps_verse_end (ps);
}	/* ps_putverse */
E 1
