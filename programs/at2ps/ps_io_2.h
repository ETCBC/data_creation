#pragma ident "@(#)q2pro/at2ps/ps_io_2.h	1.4 13/02/21"

#ifndef	_BL_PS_IO_H
#define	_BL_PS_IO_H

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
	ps_lexset,	ps_part_of_speech,	ps_prefix,
	ps_verbal_stem,	ps_verbal_ending,	ps_nominal_ending,
	ps_suffix,	ps_verbal_tense,	ps_person,
	ps_number,	ps_gender,		ps_state
};

/* ps_lexset is special */
/* ps_part_of_speech is regular */
enum	ps_prefix {
	ps_pr_ = 1,	ps_pr_j,	ps_pr_t,
	ps_pr_a,	ps_pr_n,	ps_pr_h,
	ps_pr_m,	ps_pr_t_,	ps_pr_l
};
/* ps_verbal_stem is regular */
enum	ps_verb_end {
	ps_ve_ = 1,	ps_ve_h,	ps_ve_t,
	ps_ve_th,	ps_ve_t_,	ps_ve_tj,
	ps_ve_w,	ps_ve_tm,	ps_ve_tn,
	ps_ve_nw,
	ps_ve_j = 12,	ps_ve_jn,	ps_ve_wn,
	ps_ve_nh,
	ps_ve_h_ = 18,	ps_ve_n,	ps_ve_na,
	ps_ve_t__,	ps_ve_twn
};
enum	ps_nom_end {
	ps_ne_ = 1,	ps_ne_h,	ps_ne_t,
	ps_ne_jm,	ps_ne_j,	ps_ne_wt,
	ps_ne_w_ = 11,	ps_ne_wtj,	ps_ne_j_,
	ps_ne_jm_,	ps_ne_jn,	ps_ne_tj,
	ps_ne_tjm,	ps_ne_w,	ps_ne_jn_,
	ps_ne_n,	ps_ne_t_,	ps_ne_tjn
};
enum	ps_uvf_end {
	ps_uf_a = 2,	ps_uf_h,	ps_uf_w,
	ps_uf_j,	ps_uf_n
};
enum	ps_suffix {
	ps_sf_nj = 2,	ps_sf_j,	ps_sf_k,
	ps_sf_k_,	ps_sf_w,	ps_sf_hw,
	ps_sf_h,	ps_sf_nw,	ps_sf_km,
	ps_sf_kn,	ps_sf_hm,	ps_sf_m,
	ps_sf_mw,	ps_sf_hn,	ps_sf_n,
	ps_sf_h2 = 19,	ps_sf_h_,	ps_sf_hwn,
	ps_sf_hj,	ps_sf_kwn,	ps_sf_kj,
	ps_sf_na
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
	ps_st_construct = 1, ps_st_absolute, ps_st_emphatic
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
   (ps_t *ps, word_t *word, char *atform, unsigned at_status);	

#else				/* __STDC__ */

extern ps_t	*ps_open
   ( /* char *filename */ );
extern int	ps_close
   ( /* ps_t *ps */ );

extern int	ps_putword
   ( /* ps_t *ps, word_t *word, char *atform, int at_status */ ); 

#endif				/* __STDC__ */

#endif				/* _BL_PS_IO_H */
