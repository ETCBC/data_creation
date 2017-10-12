h03537
s 00004/00023/00124
d D 1.4 13/02/21 16:13:53 const 5 4
c Implemented `ls' as lexical set. Simplified `sp' and `vs'.
e
s 00030/00021/00117
d D 1.3 13/01/31 17:02:57 const 4 2
c Separate passive qal. Adjusted lexical set. Added -e option.
e
s 00030/00021/00117
d R 1.3 13/01/31 16:56:05 const 3 2
c Separate passive qal. Adjusted lexical set. Added -e option.
e
s 00001/00001/00137
d D 1.2 07/04/02 16:12:42 const 2 1
c Bug in language switch. Added emphatic state.
e
s 00138/00000/00000
d D 1.1 00/09/19 12:20:35 const 1 0
c Version of Apr 10 1997
e
u
U
f e 0
f m q2pro/at2ps/ps_io_2.h
t
T
I 1
D 5
#pragma ident "%Z%/combinatory/%M% %I% %G%"
E 5
I 5
#pragma ident "%W% %E%"
E 5

#ifndef	_BL_PS_IO_H
#define	_BL_PS_IO_H

D 5
#define	ps_ls_topo	-3
#define	ps_ls_gntl	-2	/* adjective */
#define	ps_ls_ordn	-3

E 5
#include	<stdio.h>
#include	<biblan.h>
#include	"word.h"

/* I/O values */

#define	PS_NOT_RELEVANT	-1
#define	PS_ABSENT	0
#define	PS_READ		0
#define	PS_WRITE	1
#define	PS_PREV_NOCONJ	0
#define PS_PREV_W_CONJ	1
#define PS_PREV_NARR_CONJ 2

typedef struct {
   FILE *fp;
   int  new_verse;      /* TRUE on start of verse */
   int  prev_conj;      /* previous word was conjunction */
}       ps_t;

/* PS file values */

enum	ps_columns {
D 4
	ps_lexset,	ps_part_of_speech, ps_prefix,
	ps_verbal_stem,	ps_verbal_ending, ps_nominal_ending,
	ps_suffix,	ps_verbal_tense,  ps_person,
	ps_number,	ps_gender,	ps_state,
	ps_phrase_POS,	ps_phrase_type,	ps_determination,
	ps_control
E 4
I 4
	ps_lexset,	ps_part_of_speech,	ps_prefix,
	ps_verbal_stem,	ps_verbal_ending,	ps_nominal_ending,
	ps_suffix,	ps_verbal_tense,	ps_person,
	ps_number,	ps_gender,		ps_state
E 4
};

D 5

enum	ps_lexical_POS {
	ps_article,	ps_verb,	ps_substantive,
	ps_proper_name,	ps_adverb,	ps_preposition,
	ps_conjunction,	ps_personal_pronoun, ps_demonstrative_pronoun,
	ps_interrogative_pronoun, ps_interjection, ps_negative_particle,
	ps_interrogative_particle, ps_adjective
};
E 5
I 5
/* ps_lexset is special */
/* ps_part_of_speech is regular */
E 5
enum	ps_prefix {
	ps_pr_ = 1,	ps_pr_j,	ps_pr_t,
	ps_pr_a,	ps_pr_n,	ps_pr_h,
D 4
	ps_pr_m,	ps_pr_t_
E 4
I 4
	ps_pr_m,	ps_pr_t_,	ps_pr_l
E 4
};
D 5
enum	ps_stem {
D 4
	ps_qal,		ps_piel,	ps_hifil,
	ps_nifal,	ps_pual,	ps_hitpael = 6, 
	ps_hofal = 8,	ps_hishtafal = 10, ps_hotpaal,
	ps_nitpael,	ps_etpaal,	ps_tifal
E 4
I 4
	ps_qal,		ps_piel,	ps_hif,
	ps_nif,		ps_pual,	ps_haf,
	ps_hit,		ps_htpe,	ps_hof,
	ps_pasqal,	ps_hst,		ps_hotp,
	ps_nit,		ps_etpa,	ps_tif,
	ps_afel,	ps_saf,		ps_peal,
	ps_pael,	ps_peil,	ps_htpa,
	ps_etpe
E 4
};
E 5
I 5
/* ps_verbal_stem is regular */
E 5
enum	ps_verb_end {
	ps_ve_ = 1,	ps_ve_h,	ps_ve_t,
	ps_ve_th,	ps_ve_t_,	ps_ve_tj,
	ps_ve_w,	ps_ve_tm,	ps_ve_tn,
D 4
	ps_ve_nw,	ps_ve__,	ps_ve_j,
	ps_ve_jn,	ps_ve_wn,	ps_ve_nh,
	ps_ve_nh_,	ps_ve_2,	ps_ve_h_
E 4
I 4
	ps_ve_nw,
	ps_ve_j = 12,	ps_ve_jn,	ps_ve_wn,
	ps_ve_nh,
	ps_ve_h_ = 18,	ps_ve_n,	ps_ve_na,
	ps_ve_t__,	ps_ve_twn
E 4
};
enum	ps_nom_end {
	ps_ne_ = 1,	ps_ne_h,	ps_ne_t,
	ps_ne_jm,	ps_ne_j,	ps_ne_wt,
D 4
	ps_ne_h_,	ps_ne_jm2,	ps_ne_j2,
	ps_ne_2,	ps_nene,	ps_ne_wtj,
	ps_ne_j_,	ps_ne_jm_,	ps_ne_jn,
	ps_ne_tj,	ps_ne_tjm,	ps_ne_th,
	ps_ne_jmh
E 4
I 4
	ps_ne_w_ = 11,	ps_ne_wtj,	ps_ne_j_,
	ps_ne_jm_,	ps_ne_jn,	ps_ne_tj,
	ps_ne_tjm,	ps_ne_w,	ps_ne_jn_,
	ps_ne_n,	ps_ne_t_,	ps_ne_tjn
E 4
};
I 4
enum	ps_uvf_end {
	ps_uf_a = 2,	ps_uf_h,	ps_uf_w,
	ps_uf_j,	ps_uf_n
};
E 4
enum	ps_suffix {
	ps_sf_nj = 2,	ps_sf_j,	ps_sf_k,
	ps_sf_k_,	ps_sf_w,	ps_sf_hw,
	ps_sf_h,	ps_sf_nw,	ps_sf_km,
	ps_sf_kn,	ps_sf_hm,	ps_sf_m,
	ps_sf_mw,	ps_sf_hn,	ps_sf_n,
D 4
	ps_sf_hmh,	ps_sf_hnh
E 4
I 4
	ps_sf_h2 = 19,	ps_sf_h_,	ps_sf_hwn,
	ps_sf_hj,	ps_sf_kwn,	ps_sf_kj,
	ps_sf_na
E 4
};
enum	ps_verb_tense {
	ps_vt_ipf = 1,	ps_vt_pf,	ps_vt_imp,
	ps_vt_infc,	ps_vt_infa,	ps_vt_ptc,
	ps_vt_ipf_cons = 11, ps_vt_we_ipf,
	ps_vt_pas_ptc = 62
};
enum	ps_person {
	ps_ps_first = 1, ps_ps_second,	ps_ps_third
};
enum	ps_number {
	ps_nu_singular = 1, ps_nu_dual,	ps_nu_plural
};
enum	ps_gender {
	ps_gn_feminine = 1, ps_gn_masculine
};
enum	ps_state {
D 2
	ps_st_construct = 1, ps_st_absolute
E 2
I 2
	ps_st_construct = 1, ps_st_absolute, ps_st_emphatic
E 2
};


/* Usage:
      Open ps_file with ps_open.
      repeat
         Fill Word with calls to wrd_set_language,
	 wrd_set_vsid, wrd_set_graph, wrd_set_graph, etc, etc.
	 Do ps_putword;
      until last word of verse.
      Do ps_close.
*/


#if __STDC__

extern	ps_t	*ps_open
   (char *filename);
extern	int	ps_close
   (ps_t *ps);

extern	int	ps_putword
D 4
   (ps_t *ps, word_t *word, char *atform, int at_status);	
E 4
I 4
   (ps_t *ps, word_t *word, char *atform, unsigned at_status);	
E 4

#else				/* __STDC__ */

extern ps_t	*ps_open
   ( /* char *filename */ );
extern int	ps_close
   ( /* ps_t *ps */ );

extern int	ps_putword
   ( /* ps_t *ps, word_t *word, char *atform, int at_status */ ); 

#endif				/* __STDC__ */

#endif				/* _BL_PS_IO_H */
E 1
