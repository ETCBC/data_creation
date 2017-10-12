#ifndef	WORD_H
#define	WORD_H

#pragma ident "@(#)q2pro/at2ps/word.h 1.4 02/21/13"

#include <biblan.h>

#define	WORD_VALUE_UNKNOWN	(-1)
#define	WORD_VALUE_ABSENT	(-2)

#define	WORD_NOT_ENCLITIC	(-1)

typedef struct word word_t;

/* AT word values, based on ruleset3 */

enum	wd_types_t {			/* morphological types */
	wd_prefix = 1,	wd_infix,	wd_suffix,
	wd_marker,	wd_enclitic
};

enum	wd_morph_t {			/* morphemes */
	wd_pfm = 1,	wd_vbs,		wd_vbe,
	wd_nme,		wd_uvf,		wd_vpm,
	wd_prs
};
enum	wd_pfm_t {			/* preformatives !! */
	wd_pf_ = 1,	wd_pf_a,	wd_pf_h,
	wd_pf_j,	wd_pf_l,	wd_pf_m,
	wd_pf_n,	wd_pf_t,	wd_pf_t_
};
enum	wd_vbs_t {			/* verbal stem ]] */
	wd_vs_a = 1,	wd_vs_at,	wd_vs_h,
	wd_vs_ht,	wd_vs_hct,	wd_vs_n,
	wd_vs_nt,	wd_vs_c,	wd_vs_t
};
enum	wd_vbe_t {			/* verbal ending [ */
	wd_vb_ = 1,	wd_vb_h,	wd_vb_h_,
	wd_vb_w,	wd_vb_wn,	wd_vb_j,
	wd_vb_jn,	wd_vb_n,	wd_vb_na,
	wd_vb_nh,	wd_vb_nw,	wd_vb_t,
	wd_vb_t_,	wd_vb_t__,	wd_vb_th,
	wd_vb_twn,	wd_vb_tj,	wd_vb_tm,
	wd_vb_tn
};
enum	wd_nme_t {			/* nominal ending / */
	wd_nm_ = 1,	wd_nm_h,	wd_nm_w,
	wd_nm_w_,	wd_nm_wt,	wd_nm_wtj,
	wd_nm_j,	wd_nm_j_,	wd_nm_jm,
	wd_nm_jm_,	wd_nm_jn,	wd_nm_jn_,
	wd_nm_n,	wd_nm_t,	wd_nm_t_,
	wd_nm_tj,	wd_nm_tjm,	wd_nm_tjn
};
enum	wd_uvf_t {			/* univalent final ~ */
	wd_uf_a = 1,	wd_uf_h,	wd_uf_w,
	wd_uf_j,	wd_uf_n
};
enum	wd_vpm_t {			/* vowel pattern mark : */
	wd_vp_a = 1,	wd_vp_c,	wd_vp_d,
	wd_vp_n,	wd_vp_p
};
enum	wd_prs_t {			/* pronominal suffix + */
	wd_ps_h = 1,	wd_ps_h_,	wd_ps_hw,
	wd_ps_hwn,	wd_ps_hj,	wd_ps_hm,
	wd_ps_hn,	wd_ps_w,	wd_ps_j,
	wd_ps_k,	wd_ps_k_,	wd_ps_kwn,
	wd_ps_kj,	wd_ps_km,	wd_ps_kn,
	wd_ps_m,	wd_ps_mw,	wd_ps_n,
	wd_ps_na,	wd_ps_nw,	wd_ps_nj
};

enum	wd_func_t {				/* functions */
	wd_gender = 1,	wd_number,	wd_person,
	wd_lexical_set,	wd_part_of_speech,	wd_state,
	wd_verbal_stem,	wd_verbal_tense
};
enum	wd_gender_t {
	wd_feminine = 1,	wd_masculine
};
enum	wd_number_t {
	wd_singular = 1,	wd_dual,	wd_plural
};
enum	wd_person_t {
	wd_first = 1,	wd_second,	wd_third
};
enum	wd_lexical_set_t {
	wd_nmdi = 1,	wd_nmcp,	wd_padv,
	wd_afad,	wd_ppre,	wd_cjad,
	wd_ordn,	wd_vbcp,	wd_mult,
	wd_focp,	wd_ques,	wd_gntl,
	wd_quot,	wd_card
};
enum	wd_part_of_speech_t {
	wd_art = 1,	wd_verb,	wd_subs,
	wd_nmpr,	wd_advb,	wd_prep,
	wd_conj,	wd_prps,	wd_prde,
	wd_prin,	wd_intj,	wd_nega,
	wd_inrg,	wd_adjv
};
enum	wd_state_t {
	wd_cons = 1,	wd_abs,         wd_emph
};
enum	wd_verbal_stem_t {
	wd_qal = 1,	wd_piel,	wd_hif,
	wd_nif,		wd_pual,	wd_haf,
	wd_hit,		wd_htpe,	wd_hof,
	wd_pasq,	wd_hsht,	wd_hotp,
	wd_nit,		wd_etpa,	wd_tif,
	wd_afel,	wd_shaf,	wd_peal,
	wd_pael,	wd_peil,	wd_htpa,
	wd_etpe,	wd_esht,	wd_etta
};
enum	wd_verbal_tense_t {
	wd_impf = 1,	wd_perf,	wd_impv,
	wd_infc,	wd_infa,	wd_ptca,
	wd_wayq,	wd_weyq,	wd_ptcp
};


#if __STDC__

extern word_t  *word_create(void);
extern void     word_delete(word_t *w);

extern void
word_set_function (word_t *w, int enclitic, int function, int value);

extern int
word_get_function (word_t *w, int enclitic, int function);

extern void
word_set_morpheme (word_t *w, int morpheme, int value);

extern int
word_get_morpheme (word_t *w, int morpheme);

extern void     word_set_mark(word_t *w, int mark, int value);
extern int      word_get_mark(word_t *w, int mark, int value);
extern void     word_set_vsid(word_t *w, vsid_t *vsid);
extern vsid_t  *word_get_vsid(word_t *w);
extern void	word_set_lexeme (word_t *w, char *lexeme);
extern char    *word_get_lexeme (word_t *w);
extern void	word_set_realization (word_t *w, char *realization);
extern char    *word_get_realization (word_t *w);
extern void	word_test (word_t *w);

#else				/* __STDC__ */

extern word_t  *word_create();
extern void     word_delete();
extern void     word_set_function();
extern int      word_get_function();
extern void     word_set_morpheme();
extern int      word_get_morpheme();
extern void     word_set_mark();
extern int      word_get_mark();
extern void     word_set_vsid();
extern vsid_t  *word_get_vsid();
extern void	word_set_lexeme ();
extern char    *word_get_lexeme ();
extern void	word_set_realization ();
extern char    *word_get_realization ();
extern void	word_test ();

#endif				/* ! __STDC__ */

#endif				/* ! WORD_H */
