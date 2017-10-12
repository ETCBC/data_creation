/***************************************************************/
/*							       */
/* ps_io_2 - library routines on ps files 		       */
/*							       */
/* author: Peter Crom					       */
/*							       */
/***************************************************************/

#pragma ident "@(#)q2pro/at2ps/ps_io_2.c	1.8 14/01/13"

#include	<errno.h>
#include	<string.h>
#include	<ctype.h>
#include	<sys/types.h>
#include	<stdlib.h>
#include	<stdio.h>

#include	<biblan.h>
#include	"word.h"
#include	"ps_io_2.h"


#define COLMAX	ps_state+1

#define	N_BOOKS		39

#define eqstr(A,B)	(strcmp((A),(B)) == EQUAL)
#define max(a,b)	((a) > (b) ? (a) : (b))

static struct	bookname	{
   char	*newname;
   char	*ps_name;
} booknames [N_BOOKS] = {
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


extern int     encode_nme;
extern char   *sys_errlist[];

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
   return closed;
}	/* ps_close */


PRIVATE void
put_ct (char *s, unsigned at_status)
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

PRIVATE void
put_ct1 (char *s, unsigned at_status)
{
   fprintf (ct1file, "%s", s);
   if (at_status & BL_CONNECTED)
      fprintf (ct1file, "-");
   else
      fprintf (ct1file, " ");
}	/* put_ct1 (s, at_status); */

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

PUBLIC int
ps_putword (ps_t *ps, word_t *word, char *atform, unsigned at_status)

/* store word information */

{
   int            Column[COLMAX];
   int            acc_sfx;		/* accepts suffix? */
   int            f1;
   int            i;
   int            has_vbe;
   char          *lexeme;
   int            m1, m2;
   int            v1, v2;
   char           verse_id[12];
   vsid_t        *vsid;

/* vers id 1-10*/
   vsid = word_get_vsid (word);
   for (i = 0; i < N_BOOKS; i++)
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

   has_vbe = word_get_morpheme(word, wd_vbe) != WORD_VALUE_ABSENT;

/* lexical set 30-32 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_lexical_set);
   switch (f1) {
   case wd_nmdi:
      Column[ps_lexset] = -6;
      break;
   case wd_nmcp:
      Column[ps_lexset] = -5;
      break;
   case wd_padv:
   case wd_afad:
      Column[ps_lexset] = -4;
      break;
   case wd_ppre:
   case wd_cjad:
   case wd_ordn:
      Column[ps_lexset] = -3;
      break;
   case wd_vbcp:
   case wd_mult:
   case wd_focp:
   case wd_ques:
   case wd_gntl:
      Column[ps_lexset] = -2;
      break;
   case wd_quot:
   case wd_card:
      Column[ps_lexset] = -1;
      break;
   default:
      Column[ps_lexset] = 0;
   }

/* lexical part of speech 34-36 */
   f1 = word_get_function(word, WORD_NOT_ENCLITIC, wd_part_of_speech);
   Column[ps_part_of_speech] = f1 < 1 ? PS_NOT_RELEVANT : f1 - 1;
   acc_sfx = has_vbe ||
      f1 == wd_subs || f1 == wd_adjv ||		/* not nmpr */
      f1 == wd_prep || f1 == wd_intj || f1 == wd_inrg;

/* !! subject tense prefix 38-39 */
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
   }

/* ]] verbal stem 41-42 */
   f1 = word_get_function(word, WORD_NOT_ENCLITIC, wd_verbal_stem);
   Column[ps_verbal_stem] = f1 < 1 ? PS_NOT_RELEVANT : f1 - 1;

/* [ subject tense suffix 44-45 */
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
   }

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
   }
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

/* + pronominal suffix 50-51 */
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
   }

   /* verbal tense 55-56 */
   f1 = word_get_function(word, WORD_NOT_ENCLITIC, wd_verbal_tense);
   switch (f1) {
   case wd_impf:
      /* We have abolished ps_vt_we_ipf, because we are convinced
	 it is not a verbal tense, but a clause type */
      if (ps->prev_conj == PS_PREV_NARR_CONJ)
	 Column[ps_verbal_tense] = ps_vt_ipf_cons;
      else
	 Column[ps_verbal_tense] = ps_vt_ipf;
      break;
   case wd_ptcp:
      Column[ps_verbal_tense] = ps_vt_pas_ptc;
      break;
   default:
      Column[ps_verbal_tense] = f1 < 0 ? PS_NOT_RELEVANT : f1;
   }

/* person 58-59 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_person);
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
   }

/* number 61-62 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_number);
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
   }

/* gender 64-65 */
   f1 = word_get_function (word, WORD_NOT_ENCLITIC, wd_gender);
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
   }

/* status 67-68 */
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

/* print values */

   fprintf (ps->fp, "%3d ", Column [ps_lexset]);
   fprintf (ps->fp, "%3d ", Column [ps_part_of_speech]);
   fprintf (ps->fp, "%2d ", Column [ps_prefix]);
   fprintf (ps->fp, "%2d ", Column [ps_verbal_stem]);
   fprintf (ps->fp, "%2d ", Column [ps_verbal_ending]);
   fprintf (ps->fp, "%2d ", Column [ps_nominal_ending]);
   fprintf (ps->fp, "%2d ", Column [ps_suffix]);
   fprintf (ps->fp, "%4d ", Column [ps_verbal_tense]);
   fprintf (ps->fp, "%2d ", Column [ps_person]);
   fprintf (ps->fp, "%2d ", Column [ps_number]);
   fprintf (ps->fp, "%2d ", Column [ps_gender]);
   fprintf (ps->fp, "%5d\n", Column [ps_state]);

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
