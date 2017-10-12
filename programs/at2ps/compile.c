/* LLgen generated code from source compile.g */
#include "Lpars.h"
#define LLNOFIRSTS
#define LL_ANSI_C 1
#define LL_LEXI yylex
/* $Id: incl,v 2.13 1997/02/21 15:44:09 ceriel Exp $ */
#ifdef LL_DEBUG
#include <assert.h>
#include <stdio.h>
#define LL_assert(x)	assert(x)
#else
#define LL_assert(x)	/* nothing */
#endif

extern int LLsymb;

#define LL_SAFE(x)	/* Nothing */
#define LL_SSCANDONE(x)	if (LLsymb != x) LLsafeerror(x)
#define LL_SCANDONE(x)	if (LLsymb != x) LLerror(x)
#define LL_NOSCANDONE(x) LLscan(x)
#ifdef LL_FASTER
#define LLscan(x)	if ((LLsymb = LL_LEXI()) != x) LLerror(x)
#endif

extern unsigned int LLscnt[];
extern unsigned int LLtcnt[];
extern int LLcsymb;

#if LL_NON_CORR
extern int LLstartsymb;
#endif

#define LLsdecr(d)	{LL_assert(LLscnt[d] > 0); LLscnt[d]--;}
#define LLtdecr(d)	{LL_assert(LLtcnt[d] > 0); LLtcnt[d]--;}
#define LLsincr(d)	LLscnt[d]++
#define LLtincr(d)	LLtcnt[d]++

#if LL_ANSI_C
extern int LL_LEXI(void);
extern void LLread(void);
extern int LLskip(void);
extern int LLnext(int);
extern void LLerror(int);
extern void LLsafeerror(int);
extern void LLnewlevel(unsigned int *);
extern void LLoldlevel(unsigned int *);
#ifndef LL_FASTER
extern void LLscan(int);
#endif
#ifndef LLNOFIRSTS
extern int LLfirst(int, int);
#endif
#if LL_NON_CORR
extern void LLnc_recover(void);
#endif
#else /* not LL_ANSI_C */
extern LLread();
extern int LLskip();
extern int LLnext();
extern LLerror();
extern LLsafeerror();
extern LLnewlevel();
extern LLoldlevel();
#ifndef LL_FASTER
extern LLscan();
#endif
#ifndef LLNOFIRSTS
extern int LLfirst();
#endif
#if LL_NON_CORR
extern LLnc_recover();
#endif
#endif /* not LL_ANSI_C */
#define LL_LEXI yylex
# line 9 "compile.g"

#pragma ident	"@(#)q2pro/at2ps/compile.g	1.3 07/04/02"

#include	<stdio.h>
#include	<stdarg.h>

#include	<biblan.h>

#include	"global.h"
#include	"error.h"
#include	"lexer.h"
#include	"qlist.h"
#include	"backpatch.h"
#include	"symtbl.h"
#include	"type.h"
#include	"grammar.h"
#include	"exec.h"
#include	"word.h"

#define	MAX_NTOKENS	256
#define	PARSER_SUCCESS	0
#define SYMTBL_SIZE	((size_t)251)


typedef struct expression {
   bplist_t       *truelist;
   bplist_t       *falselist;
}               expr_t;

typedef struct morph_stack {
   int			value;
   struct morph_stack	*next;
}	morph_stack_t;

PRIVATE char   *TokenTable[MAX_NTOKENS];

PRIVATE symtbl_t *Symtbl;

PRIVATE qlist_t *Qlist;

PRIVATE char   *FileName;

PRIVATE int     MorphemeOrdinal;
PRIVATE int     FunctionOrdinal;

PRIVATE int     SemErr;
PRIVATE int     SynErr;

PRIVATE	morph_stack_t	*stack = NULL;

/* wherr() prepends file name and line number to the error message */
PRIVATE void    wherr(char *fmt,...);
PRIVATE morph_stack_t * pop_morph (void);
PRIVATE void push_morph (int value);

PRIVATE void    morpheme_declaration(int class, int ordinal);
PRIVATE void    morpheme_element(int type, int morpheme_ordinal, int element_ordinal);

extern  void    parser();
#if LL_ANSI_C
static void LL1_word(void);
static void LL2_lexical(void);
static void LL3_forms(void);
static void LL4_functions(void);
static void LL5_rules(void);
static void LL6_prefix(void);
static void LL7_infix(void);
static void LL8_suffix(void);
static void LL9_marker(void);
static void LL10_enclitic(void);
static void LL11_prefix_declaration(void);
static void LL12_infix_declaration(void);
static void LL13_suffix_declaration(void);
static void LL14_marker_declaration(void);
static void LL15_enclitic_declaration(void);
static void LL16_forms_declaration(void);
static void LL17_function_declaration(void);
static void LL18_function(
# line 300 "compile.g"
symbol_t **f) ;
static void LL19_values(
# line 339 "compile.g"
symbol_t *f) ;
static void LL20_function_sharing(void);
static void LL21_value_declaration(
# line 375 "compile.g"
symbol_t *f ,int *ord) ;
static void LL22_rule(void);
static void LL23_simple_rule(void);
static void LL24_block(void);
static void LL25_expression(
# line 466 "compile.g"
expr_t *E) ;
static void LL26_assignment(void);
static void LL27_term(
# line 490 "compile.g"
expr_t *E) ;
static void LL28_factor(
# line 514 "compile.g"
expr_t *E) ;
static void LL29_simple_factor(
# line 537 "compile.g"
expr_t *E) ;
static void LL30_negated_factor(
# line 720 "compile.g"
expr_t *E) ;
static void LL31_grouped_factor(
# line 727 "compile.g"
expr_t *E) ;
static void LL32_comparison(
# line 540 "compile.g"
expr_t *E) ;
static void LL33_existence(
# line 654 "compile.g"
expr_t *E) ;
static void LL34_marking(
# line 677 "compile.g"
expr_t *E) ;
static void LL35_literal_comparison(
# line 562 "compile.g"
expr_t *E ,int type ,symbol_t *sop) ;
static void LL36_set_comparison(
# line 597 "compile.g"
expr_t *E ,int type ,symbol_t *sop) ;
static void LL37_enclitic_function(
# line 758 "compile.g"
symbol_t *f) ;
static void LL38_value_identifier(
# line 780 "compile.g"
symbol_t **arg ,int type) ;
#else
static LL1_word();
static LL2_lexical();
static LL3_forms();
static LL4_functions();
static LL5_rules();
static LL6_prefix();
static LL7_infix();
static LL8_suffix();
static LL9_marker();
static LL10_enclitic();
static LL11_prefix_declaration();
static LL12_infix_declaration();
static LL13_suffix_declaration();
static LL14_marker_declaration();
static LL15_enclitic_declaration();
static LL16_forms_declaration();
static LL17_function_declaration();
static LL18_function();
static LL19_values();
static LL20_function_sharing();
static LL21_value_declaration();
static LL22_rule();
static LL23_simple_rule();
static LL24_block();
static LL25_expression();
static LL26_assignment();
static LL27_term();
static LL28_factor();
static LL29_simple_factor();
static LL30_negated_factor();
static LL31_grouped_factor();
static LL32_comparison();
static LL33_existence();
static LL34_marking();
static LL35_literal_comparison();
static LL36_set_comparison();
static LL37_enclitic_function();
static LL38_value_identifier();
#endif
#if LL_ANSI_C
void
#endif
LL0_grammar(
#if LL_ANSI_C
void
#endif
) {
LLsincr(0);
LLsincr(1);
LLsincr(2);
LLsincr(3);
LL1_word();
LLsdecr(0);
LL2_lexical();
LLsdecr(1);
LL3_forms();
LLsdecr(2);
LL4_functions();
LLsdecr(3);
LL5_rules();
}
static
#if LL_ANSI_C
void
#endif
LL1_word(
#if LL_ANSI_C
void
#endif
) {
LLsincr(4);
LLsincr(5);
LLsincr(6);
LLsincr(7);
LLsincr(8);
LL_SCANDONE(WORD);
LLsdecr(4);
LL6_prefix();
LLsdecr(5);
LL7_infix();
LLsdecr(6);
LL8_suffix();
LLsdecr(7);
LL9_marker();
LLsdecr(8);
LL10_enclitic();
}
static
#if LL_ANSI_C
void
#endif
LL6_prefix(
#if LL_ANSI_C
void
#endif
) {
LLtincr(29);
LLtincr(3);
LL_NOSCANDONE(PREFIX);
LLtdecr(29);
LL_NOSCANDONE('=');
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  INFIX  */ 12 : ;
break;
default:{int LL_1=LLnext(259);
;if (!LL_1) {
break;
}
else if (LL_1 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
LL11_prefix_declaration();
LLread();
continue;
}
}
LLtdecr(3);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL11_prefix_declaration(
#if LL_ANSI_C
void
#endif
) {
# line 122 "compile.g"
 char separator; 
LLtincr(2);
LLtincr(31);
LLtincr(4);
LL_SAFE(IDENTIFIER);
# line 123 "compile.g"
{
	    morpheme_declaration(CLASS_MORPHEME, MorphemeOrdinal);
	 }
LL_NOSCANDONE(':');
LLtdecr(2);
LL_NOSCANDONE(CHARACTER);
# line 126 "compile.g"
{
	    separator = lex_strval[1];
	 }
LLtdecr(31);
LL_NOSCANDONE(',');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 129 "compile.g"
{
	    if (grammar_add_morpheme(
		  GRAMMAR_PREFIX,
		  separator,
		  lex_strval,
		  MorphemeOrdinal
	       ) == GRAMMAR_ERROR) {
	       error(ERRSTR);
	       exit(1);
	    }
	    MorphemeOrdinal++;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL7_infix(
#if LL_ANSI_C
void
#endif
) {
LLtincr(29);
LLtincr(3);
LL_SCANDONE(INFIX);
LLtdecr(29);
LL_NOSCANDONE('=');
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  SUFFIX  */ 21 : ;
break;
default:{int LL_2=LLnext(259);
;if (!LL_2) {
break;
}
else if (LL_2 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
LL12_infix_declaration();
LLread();
continue;
}
}
LLtdecr(3);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL12_infix_declaration(
#if LL_ANSI_C
void
#endif
) {
# line 146 "compile.g"
 char separator; 
LLtincr(2);
LLtincr(31);
LLtincr(4);
LL_SAFE(IDENTIFIER);
# line 147 "compile.g"
{
	    morpheme_declaration(CLASS_MORPHEME, MorphemeOrdinal);
	 }
LL_NOSCANDONE(':');
LLtdecr(2);
LL_NOSCANDONE(CHARACTER);
# line 150 "compile.g"
{
	    separator = lex_strval[1];
	 }
LLtdecr(31);
LL_NOSCANDONE(',');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 153 "compile.g"
{
	    if (grammar_add_morpheme(
		  GRAMMAR_INFIX,
		  separator,
		  lex_strval,
		  MorphemeOrdinal
	       ) == GRAMMAR_ERROR) {
	       error(ERRSTR);
	       exit(1);
	    }
	    MorphemeOrdinal++;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL8_suffix(
#if LL_ANSI_C
void
#endif
) {
LLtincr(29);
LLtincr(3);
LL_SCANDONE(SUFFIX);
LLtdecr(29);
LL_NOSCANDONE('=');
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  MARKER  */ 15 : ;
break;
default:{int LL_3=LLnext(259);
;if (!LL_3) {
break;
}
else if (LL_3 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
LL13_suffix_declaration();
LLread();
continue;
}
}
LLtdecr(3);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL13_suffix_declaration(
#if LL_ANSI_C
void
#endif
) {
# line 170 "compile.g"
 char separator; 
LLtincr(2);
LLtincr(31);
LLtincr(4);
LL_SAFE(IDENTIFIER);
# line 171 "compile.g"
{
	    morpheme_declaration(CLASS_MORPHEME, MorphemeOrdinal);
	 }
LL_NOSCANDONE(':');
LLtdecr(2);
LL_NOSCANDONE(CHARACTER);
# line 174 "compile.g"
{
	    separator = lex_strval[1];
	 }
LLtdecr(31);
LL_NOSCANDONE(',');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 177 "compile.g"
{
	    if (grammar_add_morpheme(
		  GRAMMAR_SUFFIX,
		  separator,
		  lex_strval,
		  MorphemeOrdinal
	       ) == GRAMMAR_ERROR) {
	       error(ERRSTR);
	       exit(1);
	    }
	    MorphemeOrdinal++;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL9_marker(
#if LL_ANSI_C
void
#endif
) {
LLtincr(29);
LLtincr(3);
LL_SCANDONE(MARKER);
LLtdecr(29);
LL_NOSCANDONE('=');
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  ENCLITIC  */ 6 : ;
break;
default:{int LL_4=LLnext(259);
;if (!LL_4) {
break;
}
else if (LL_4 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
LL14_marker_declaration();
LLread();
continue;
}
}
LLtdecr(3);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL14_marker_declaration(
#if LL_ANSI_C
void
#endif
) {
# line 194 "compile.g"
 char separator; 
LLtincr(2);
LLtincr(31);
LLtincr(4);
LL_SAFE(IDENTIFIER);
# line 195 "compile.g"
{
	    morpheme_declaration(CLASS_MARKER, MorphemeOrdinal);
	 }
LL_NOSCANDONE(':');
LLtdecr(2);
LL_NOSCANDONE(CHARACTER);
# line 198 "compile.g"
{
	    separator = lex_strval[1];
	 }
LLtdecr(31);
LL_NOSCANDONE(',');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 201 "compile.g"
{
	    if (grammar_add_morpheme(
		  GRAMMAR_MARKER,
		  separator,
		  lex_strval,
		  MorphemeOrdinal
	       ) == GRAMMAR_ERROR) {
	       error(ERRSTR);
	       exit(1);
	    }
	    MorphemeOrdinal++;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL10_enclitic(
#if LL_ANSI_C
void
#endif
) {
LLtincr(29);
LLtincr(3);
LL_SCANDONE(ENCLITIC);
LLtdecr(29);
LL_NOSCANDONE('=');
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  LEXICAL  */ 13 : ;
break;
default:{int LL_5=LLnext(259);
;if (!LL_5) {
break;
}
else if (LL_5 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
LL15_enclitic_declaration();
LLread();
continue;
}
}
LLtdecr(3);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL15_enclitic_declaration(
#if LL_ANSI_C
void
#endif
) {
# line 218 "compile.g"
 char separator; 
LLtincr(2);
LLtincr(31);
LLtincr(4);
LL_SAFE(IDENTIFIER);
# line 219 "compile.g"
{
	    morpheme_declaration(
		  CLASS_MORPHEME|CLASS_ENCLITIC,
		  MorphemeOrdinal
	       );
	 }
LL_NOSCANDONE(':');
LLtdecr(2);
LL_NOSCANDONE(CHARACTER);
# line 225 "compile.g"
{
	    separator = lex_strval[1];
	 }
LLtdecr(31);
LL_NOSCANDONE(',');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 228 "compile.g"
{
	    if (grammar_add_morpheme(
		  GRAMMAR_ENCLITIC,
		  separator,
		  lex_strval,
		  MorphemeOrdinal
	       ) == GRAMMAR_ERROR) {
	       error(ERRSTR);
	       exit(1);
	    }
	    MorphemeOrdinal++;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL2_lexical(
#if LL_ANSI_C
void
#endif
) {
LLtincr(3);
LLtincr(31);
LL_SCANDONE(LEXICAL);
LLtdecr(3);
LL_NOSCANDONE(IDENTIFIER);
# line 243 "compile.g"
{
	    symbol_t *s;

	    if (lex_strval == NULL)
	       /* Then we are recovering from errors */;
	    else if ((s = symtbl_lookup(Symtbl, lex_strval)) == NULL) {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    } else if (!IS_MORPHEME(s->class)) {
	       wherr("%s: not a morpheme", lex_strval);
	    } else {
	       grammar_set_lexical(s->value);
	    }
	 }
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  FORMS  */ 9 : ;
break;
default:{int LL_6=LLnext(44);
;if (!LL_6) {
break;
}
else if (LL_6 & 1) goto L_1;}
case /* ',' */ 31 : ;
LL_SAFE(',');
LL_NOSCANDONE(IDENTIFIER);
# line 257 "compile.g"
{
	    symbol_t *s;

	    if ((s = symtbl_lookup(Symtbl, lex_strval)) == NULL) {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    } else if (!IS_MORPHEME(s->class)) {
	       wherr("%s: not a morpheme", lex_strval);
	    } else {
	       grammar_set_lexical(s->value);
	    }
	 }
LLread();
continue;
}
}
LLtdecr(31);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL3_forms(
#if LL_ANSI_C
void
#endif
) {
LLtincr(3);
LL_SCANDONE(FORMS);
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  FUNCTIONS  */ 10 : ;
break;
default:{int LL_7=LLnext(259);
;if (!LL_7) {
break;
}
else if (LL_7 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
LL16_forms_declaration();
continue;
}
}
LLtdecr(3);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL16_forms_declaration(
#if LL_ANSI_C
void
#endif
) {
# line 274 "compile.g"
 int type; int element_ordinal = 1; 
LLtincr(4);
LLtincr(31);
LL_SAFE(IDENTIFIER);
# line 275 "compile.g"
{
	    symbol_t *sym;

	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) == NULL) {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    } else {
	       type = sym->type;
	       MorphemeOrdinal = sym->value;
	    }
	 }
LL_NOSCANDONE('=');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 286 "compile.g"
{
	    morpheme_element(type, MorphemeOrdinal, element_ordinal++);
	 }
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  IDENTIFIER  */ 3 : ;
case /*  FUNCTIONS  */ 10 : ;
break;
default:{int LL_8=LLnext(44);
;if (!LL_8) {
break;
}
else if (LL_8 & 1) goto L_1;}
case /* ',' */ 31 : ;
LL_SAFE(',');
LL_NOSCANDONE(LITERAL);
# line 289 "compile.g"
{
	    morpheme_element(type, MorphemeOrdinal, element_ordinal++);
	 }
LLread();
continue;
}
}
LLtdecr(31);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL4_functions(
#if LL_ANSI_C
void
#endif
) {
LLtincr(3);
LL_SCANDONE(FUNCTIONS);
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  RULES  */ 19 : ;
break;
default:{int LL_9=LLnext(259);
;if (!LL_9) {
break;
}
else if (LL_9 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
LL17_function_declaration();
continue;
}
}
LLtdecr(3);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL17_function_declaration(
#if LL_ANSI_C
void
#endif
) {
# line 297 "compile.g"
 symbol_t *f = NULL; 
LLtincr(29);
LLsincr(9);
LL18_function(
# line 298 "compile.g"
&f);
LLtdecr(29);
LL_NOSCANDONE('=');
LLsdecr(9);
LL19_values(
# line 298 "compile.g"
f);
}
static
#if LL_ANSI_C
void
#endif
LL18_function(
#if LL_ANSI_C
# line 300 "compile.g"
symbol_t **f)  
#else
# line 300 "compile.g"
 f) symbol_t **f; 
#endif
{
LLtincr(32);
LLtincr(30);
LLtincr(4);
LL_SAFE(IDENTIFIER);
# line 301 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL &&
		IS_FUNCTION(sym->class)
	    ) {
	       wherr("%s: identifier redeclared", lex_strval);
	       SemErr++;
	    } else if ((sym = symtbl_insert(Symtbl, lex_strval)) == NULL)
	       error(ERRSTR);
	    else {
	       sym->type = type_create();
	       sym->class = CLASS_FUNCTION;
	       sym->value = FunctionOrdinal;
	       *f = sym;
	    }
	 }
LLread();
goto L_1;
L_1 : {switch(LLcsymb) {
case /* ':' */ 30 : ;
LLtdecr(32);
break;
default:{int LL_10=LLnext(91);
;if (!LL_10) {
LLtdecr(32);
break;
}
else if (LL_10 & 1) goto L_1;}
case /* '[' */ 32 : ;
LLtdecr(32);
LL20_function_sharing();
LLread();
}
}
LLtdecr(30);
LL_SCANDONE(':');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 317 "compile.g"
{
	    morph_stack_t *ms;
	    if (grammar_add_function(lex_strval, FunctionOrdinal) == GRAMMAR_ERROR) {
	       error(ERRSTR);
	       exit(1);
	    }
	    while ((ms = pop_morph()) != NULL)
	    {
               if (grammar_assign(
		   ms->value,
		   FunctionOrdinal
	          ) == GRAMMAR_ERROR)
	       {
		  error(ERRSTR);
		  exit(1);
	       }
	       free (ms);
	    }
	    FunctionOrdinal++;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL19_values(
#if LL_ANSI_C
# line 339 "compile.g"
symbol_t *f)  
#else
# line 339 "compile.g"
 f) symbol_t *f; 
#endif
{
# line 339 "compile.g"
 int ord = 1; 
LLtincr(31);
LL21_value_declaration(
# line 340 "compile.g"
f, &ord);
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  IDENTIFIER  */ 3 : ;
case /*  RULES  */ 19 : ;
break;
default:{int LL_11=LLnext(44);
;if (!LL_11) {
break;
}
else if (LL_11 & 1) goto L_1;}
case /* ',' */ 31 : ;
LL_SAFE(',');
LL21_value_declaration(
# line 340 "compile.g"
f, &ord);
LLread();
continue;
}
}
LLtdecr(31);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL20_function_sharing(
#if LL_ANSI_C
void
#endif
) {
LLtincr(31);
LLtincr(33);
LL_SAFE('[');
LL_NOSCANDONE(IDENTIFIER);
# line 343 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && ! IS_ENCLITIC(sym->class))
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("%s: not an enclitic", lex_strval);
		  SemErr++;
	       } else
	       push_morph (sym->value);
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /* ']' */ 33 : ;
break;
default:{int LL_12=LLnext(44);
;if (!LL_12) {
break;
}
else if (LL_12 & 1) goto L_1;}
case /* ',' */ 31 : ;
LL_SAFE(',');
LL_NOSCANDONE(IDENTIFIER);
# line 358 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && ! IS_ENCLITIC(sym->class))
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("%s: not an enclitic", lex_strval);
		  SemErr++;
	       } else
	       push_morph (sym->value);
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLread();
continue;
}
}
LLtdecr(31);
break;
}
LLtdecr(33);
LL_SSCANDONE(']');
}
static
#if LL_ANSI_C
void
#endif
LL21_value_declaration(
#if LL_ANSI_C
# line 375 "compile.g"
symbol_t *f ,int *ord)  
#else
# line 375 "compile.g"
 f,ord) symbol_t *f; int *ord; 
#endif
{
LLtincr(30);
LLtincr(4);
LL_NOSCANDONE(IDENTIFIER);
# line 377 "compile.g"
{
	 symbol_t *sym;

	 if (
	 (sym = symtbl_lookup(Symtbl, lex_strval)) != NULL &&
	 f != NULL ? sym->type == f->type : FALSE
	 )
	    wherr("\"%s\": function value repeated", lex_strval);
	 else
	    if (
	    (sym = symtbl_insert(Symtbl, lex_strval)) == NULL
	    )
	       error(ERRSTR);
	    else
	    {
	       sym->type = f != NULL ? f->type : TYPE_ANY;
	       sym->value = *ord;
	    }
      }
LLtdecr(30);
LL_NOSCANDONE(':');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 397 "compile.g"
{
	 if (
	 f != NULL && !SemErr
	 )
	 {
	    if (
	    grammar_add_func_element
	    ( f->value, lex_strval, *ord
	    ) == GRAMMAR_ERROR
	    )
	    {
	       error(ERRSTR);
	       exit(1);
	    }
	 }
	 *ord += 1;
      }
}
static
#if LL_ANSI_C
void
#endif
LL5_rules(
#if LL_ANSI_C
void
#endif
) {
LLsincr(10);
LL_SCANDONE(RULES);
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  EOFILE  */ 0 : ;
break;
default:{int LL_13=LLnext(-50);
;if (!LL_13) {
break;
}
else if (LL_13 & 1) goto L_1;}
case /*  IDENTIFIER  */ 3 : ;
case /*  EXIST  */ 8 : ;
case /*  MARK  */ 14 : ;
case /*  NOT  */ 17 : ;
case /*  SHARED  */ 20 : ;
case /* '(' */ 36 : ;
LLsincr(11);
LL22_rule();
continue;
}
}
LLsdecr(10);
break;
}
# line 417 "compile.g"
{
	    qlist_emit(Qlist, RET, NULL, NULL);
	 }
}
static
#if LL_ANSI_C
void
#endif
LL22_rule(
#if LL_ANSI_C
void
#endif
) {
goto L_2; /* so that the label is used for certain */
L_2: ;
switch(LLcsymb) {
case /*  IDENTIFIER  */ 3 : ;
case /*  EXIST  */ 8 : ;
case /*  MARK  */ 14 : ;
case /*  NOT  */ 17 : ;
case /* '(' */ 36 : ;
goto L_3;
L_3: ;
LLsdecr(11);
LL23_simple_rule();
break;
default: if (LLskip()) goto L_2;
goto L_3;
case /*  SHARED  */ 20 : ;
LLsdecr(11);
LL24_block();
LLread();
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL23_simple_rule(
#if LL_ANSI_C
void
#endif
) {
# line 425 "compile.g"
 expr_t E; 
LLtincr(24);
LLsincr(12);
LLtincr(31);
LL25_expression(
# line 426 "compile.g"
&E);
# line 426 "compile.g"
{
	    if (!SemErr) {
	       bplist_patch(E.truelist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.truelist);
	    }
	 }
LLtdecr(24);
LL_SCANDONE(ACTION_OPERATOR);
LLsdecr(12);
LL26_assignment();
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  EOFILE  */ 0 : ;
case /*  IDENTIFIER  */ 3 : ;
case /*  END  */ 7 : ;
case /*  EXIST  */ 8 : ;
case /*  MARK  */ 14 : ;
case /*  NOT  */ 17 : ;
case /*  SHARED  */ 20 : ;
case /* '(' */ 36 : ;
break;
default:{int LL_14=LLnext(44);
;if (!LL_14) {
break;
}
else if (LL_14 & 1) goto L_1;}
case /* ',' */ 31 : ;
LL_SAFE(',');
LL26_assignment();
LLread();
continue;
}
}
LLtdecr(31);
break;
}
# line 434 "compile.g"
{
	    if (!SemErr) {
	       bplist_patch(E.falselist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.falselist);
	    }
	 }
}
static
#if LL_ANSI_C
void
#endif
LL24_block(
#if LL_ANSI_C
void
#endif
) {
# line 443 "compile.g"
 expr_t E; 
LLsincr(13);
LLtincr(24);
LLsincr(12);
LLtincr(31);
LLtincr(35);
LLsincr(11);
LLtincr(7);
LL_SAFE(SHARED);
LL_NOSCANDONE('{');
LLread();
LLsdecr(13);
LL25_expression(
# line 446 "compile.g"
&E);
# line 446 "compile.g"
{
	    if (!SemErr) {
	       bplist_patch(E.truelist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.truelist);
	    }
	 }
LLtdecr(24);
LL_SCANDONE(ACTION_OPERATOR);
LLsdecr(12);
LL26_assignment();
LLread();
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /* '}' */ 35 : ;
break;
default:{int LL_15=LLnext(44);
;if (!LL_15) {
break;
}
else if (LL_15 & 1) goto L_1;}
case /* ',' */ 31 : ;
LL_SAFE(',');
LL26_assignment();
LLread();
continue;
}
}
LLtdecr(31);
break;
}
LLtdecr(35);
LL_SSCANDONE('}');
LLread();
LLsdecr(11);
LLsincr(10);
for (;;) {
LLsincr(11);
LL22_rule();
goto L_2;
L_2 : {switch(LLcsymb) {
case /*  END  */ 7 : ;
break;
default:{int LL_16=LLnext(-50);
;if (!LL_16) {
break;
}
else if (LL_16 & 1) goto L_2;}
case /*  IDENTIFIER  */ 3 : ;
case /*  EXIST  */ 8 : ;
case /*  MARK  */ 14 : ;
case /*  NOT  */ 17 : ;
case /*  SHARED  */ 20 : ;
case /* '(' */ 36 : ;
continue;
}
}
LLsdecr(10);
break;
}
LLtdecr(7);
LL_SSCANDONE(END);
# line 457 "compile.g"
{
	    if (!SemErr) {
	       bplist_patch(E.falselist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.falselist);
	    }
	 }
}
static
#if LL_ANSI_C
void
#endif
LL25_expression(
#if LL_ANSI_C
# line 466 "compile.g"
expr_t *E)  
#else
# line 466 "compile.g"
 E) expr_t *E; 
#endif
{
# line 466 "compile.g"
expr_t E1, E2, *LE;
LLtincr(28);
LL27_term(
# line 467 "compile.g"
&E1);
# line 467 "compile.g"
{
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       LE = &E1;
	    }
	 }
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  ACTION_OPERATOR  */ 24 : ;
case /* ')' */ 37 : ;
break;
default:{int LL_17=LLnext(284);
;if (!LL_17) {
break;
}
else if (LL_17 & 1) goto L_1;}
case /*  OR  */ 28 : ;
LL_SAFE(OR);
# line 473 "compile.g"
{
	    if (!SemErr) {
	       bplist_patch(LE->falselist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	    }
	 }
LLread();
LL27_term(
# line 479 "compile.g"
&E2);
# line 479 "compile.g"
{
	    if (!SemErr) {
	       E->truelist = bplist_merge(E->truelist, E2.truelist);
	       LE = &E2;
	    }
	 }
continue;
}
}
LLtdecr(28);
break;
}
# line 485 "compile.g"
{
	    if (!SemErr) E->falselist = LE->falselist;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL27_term(
#if LL_ANSI_C
# line 490 "compile.g"
expr_t *E)  
#else
# line 490 "compile.g"
 E) expr_t *E; 
#endif
{
# line 490 "compile.g"
 expr_t E1, E2, *LE; 
LLsincr(14);
LLtincr(25);
LL28_factor(
# line 491 "compile.g"
&E1);
# line 491 "compile.g"
{
	    if (!SemErr) {
	       E->falselist = E1.falselist;
	       LE = &E1;
	    }
	 }
for (;;) {
goto L_1;
L_1 : {switch(LLcsymb) {
case /*  ACTION_OPERATOR  */ 24 : ;
case /*  OR  */ 28 : ;
case /* ')' */ 37 : ;
break;
default:{int LL_18=LLnext(281);
;if (!LL_18) {
break;
}
else if (LL_18 & 1) goto L_1;}
case /*  AND  */ 25 : ;
LLsincr(14);
LL_SAFE(AND);
# line 497 "compile.g"
{
	    if (!SemErr) {
	       bplist_patch(LE->truelist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	    }
	 }
LLread();
LL28_factor(
# line 503 "compile.g"
&E2);
# line 503 "compile.g"
{
	    if (!SemErr) {
	       E->falselist = bplist_merge(E->falselist, E2.falselist);
	       LE = &E2;
	    }
	 }
continue;
}
}
LLtdecr(25);
break;
}
# line 509 "compile.g"
{
	    if (!SemErr) E->truelist = LE->truelist;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL28_factor(
#if LL_ANSI_C
# line 514 "compile.g"
expr_t *E)  
#else
# line 514 "compile.g"
 E) expr_t *E; 
#endif
{
# line 514 "compile.g"
 expr_t E1; 
goto L_2; /* so that the label is used for certain */
L_2: ;
switch(LLcsymb) {
case /*  IDENTIFIER  */ 3 : ;
case /*  EXIST  */ 8 : ;
case /*  MARK  */ 14 : ;
goto L_3;
L_3: ;
LLsdecr(14);
LL29_simple_factor(
# line 515 "compile.g"
&E1);
# line 515 "compile.g"
{
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       E->falselist = E1.falselist;
	    }
	 }
LLread();
break;
default: if (LLskip()) goto L_2;
goto L_3;
case /*  NOT  */ 17 : ;
LLsdecr(14);
LL30_negated_factor(
# line 522 "compile.g"
&E1);
# line 522 "compile.g"
{
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       E->falselist = E1.falselist;
	    }
	 }
break;
case /* '(' */ 36 : ;
LLsdecr(14);
LL31_grouped_factor(
# line 529 "compile.g"
&E1);
# line 529 "compile.g"
{
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       E->falselist = E1.falselist;
	    }
	 }
LLread();
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL29_simple_factor(
#if LL_ANSI_C
# line 537 "compile.g"
expr_t *E)  
#else
# line 537 "compile.g"
 E) expr_t *E; 
#endif
{
# line 537 "compile.g"
 
switch(LLcsymb) {
default:
LL32_comparison(
# line 538 "compile.g"
E);
break;
case /*  EXIST  */ 8 : ;
LL33_existence(
# line 538 "compile.g"
E);
break;
case /*  MARK  */ 14 : ;
LL34_marking(
# line 538 "compile.g"
E);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL32_comparison(
#if LL_ANSI_C
# line 540 "compile.g"
expr_t *E)  
#else
# line 540 "compile.g"
 E) expr_t *E; 
#endif
{
# line 540 "compile.g"
 int type; symbol_t *sym;
LLsincr(15);
LL_SSCANDONE(IDENTIFIER);
# line 541 "compile.g"
{
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && ! IS_MORPHEME(sym->class))
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("%s: not a morpheme identifier", lex_strval);
		  SemErr++;
	       } else {
		  type = sym->type;
	       }
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLread();
goto L_2; /* so that the label is used for certain */
L_2: ;
switch(LLcsymb) {
case /*  EQUALITY  */ 26 : ;
case /*  NEQ  */ 27 : ;
goto L_3;
L_3: ;
LLsdecr(15);
LL35_literal_comparison(
# line 557 "compile.g"
E, type, sym);
break;
default: if (LLskip()) goto L_2;
goto L_3;
case /*  IN  */ 11 : ;
case /*  NI  */ 16 : ;
LLsdecr(15);
LL36_set_comparison(
# line 559 "compile.g"
E, type, sym);
break;
}
}
static
#if LL_ANSI_C
void
#endif
LL35_literal_comparison(
#if LL_ANSI_C
# line 562 "compile.g"
expr_t *E ,int type ,symbol_t *sop)  
#else
# line 562 "compile.g"
 E,type,sop) expr_t *E; int type; symbol_t *sop; 
#endif
{
# line 563 "compile.g"
 bplist_t **tlp, **flp; 
LLtincr(4);
switch(LLcsymb) {
default:
LL_SSCANDONE(EQUALITY);
# line 564 "compile.g"
{
	    tlp = & E->truelist;
	    flp = & E->falselist;
	 }
break;
case /*  NEQ  */ 27 : ;
LL_SAFE(NEQ);
# line 568 "compile.g"
{
	    tlp = & E->falselist;
	    flp = & E->truelist;
	 }
break;
}
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 573 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && sym->type != type)
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("\"%s\": wrong type", lex_strval);
		  SemErr++;
	       } else {
		  if (!SemErr) {
		     qlist_emit(Qlist, CMP, sop, sym);
		     *tlp = bplist_create(qlist_next(Qlist));
		     qlist_emit(Qlist, BNZ, NULL, NULL);
		     *flp = bplist_create(qlist_next(Qlist));
		     qlist_emit(Qlist, JMP, NULL, NULL);
		  }
	       }
	    } else {
	       wherr("\"%s\": morpheme not declared", lex_strval);
	       SemErr++;
	    }
	 }
}
static
#if LL_ANSI_C
void
#endif
LL36_set_comparison(
#if LL_ANSI_C
# line 597 "compile.g"
expr_t *E ,int type ,symbol_t *sop)  
#else
# line 597 "compile.g"
 E,type,sop) expr_t *E; int type; symbol_t *sop; 
#endif
{
# line 598 "compile.g"
 bplist_t **tlp, **flp; 
LLtincr(34);
LLtincr(4);
LLtincr(31);
LLtincr(35);
switch(LLcsymb) {
default:
LL_SAFE(IN);
# line 599 "compile.g"
{
	    tlp = & E->truelist;
	    flp = & E->falselist;
	 }
break;
case /*  NI  */ 16 : ;
LL_SAFE(NI);
# line 603 "compile.g"
{
	    tlp = & E->falselist;
	    flp = & E->truelist;
	 }
break;
}
LLtdecr(34);
LL_NOSCANDONE('{');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 608 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && sym->type != type)
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("\"%s\": wrong type", lex_strval);
		  SemErr++;
	       } else {
		  if (!SemErr) {
		     qlist_emit(Qlist, CMP, sop, sym);
		     *tlp = bplist_create(qlist_next(Qlist));
		     qlist_emit(Qlist, BNZ, NULL, NULL);
		  }
	       }
	    } else {
	       wherr("\"%s\": morpheme not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLread();
for (;;) {
goto L_4;
L_4 : {switch(LLcsymb) {
case /* '}' */ 35 : ;
break;
default:{int LL_19=LLnext(44);
;if (!LL_19) {
break;
}
else if (LL_19 & 1) goto L_4;}
case /* ',' */ 31 : ;
LL_SAFE(',');
LL_NOSCANDONE(LITERAL);
# line 628 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && sym->type != type)
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("\"%s\": wrong type", lex_strval);
		  SemErr++;
	       } else {
		  if (!SemErr) {
		     qlist_emit(Qlist, CMP, sop, sym);
		     *tlp = bplist_merge(*tlp, bplist_create(qlist_next(Qlist)));
		     qlist_emit(Qlist, BNZ, NULL, NULL);
		  }
	       }
	    } else {
	       wherr("\"%s\": morpheme not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLread();
continue;
}
}
LLtdecr(31);
break;
}
# line 648 "compile.g"
{
	    *flp = bplist_create(qlist_next(Qlist));
	    qlist_emit(Qlist, JMP, NULL, NULL);
	 }
LLtdecr(35);
LL_SSCANDONE('}');
}
static
#if LL_ANSI_C
void
#endif
LL33_existence(
#if LL_ANSI_C
# line 654 "compile.g"
expr_t *E)  
#else
# line 654 "compile.g"
 E) expr_t *E; 
#endif
{
LLtincr(3);
LLtincr(37);
LL_SAFE(EXIST);
LL_NOSCANDONE('(');
LLtdecr(3);
LL_NOSCANDONE(IDENTIFIER);
# line 655 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && ! IS_MORPHEME(sym->class))
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("%s: not a morpheme identifier", lex_strval);
		  SemErr++;
	       } else {
		  qlist_emit(Qlist, MOP, sym, NULL);
		  E->truelist = bplist_create(qlist_next(Qlist));
		  qlist_emit(Qlist, BNZ, NULL, NULL);
		  E->falselist = bplist_create(qlist_next(Qlist));
		  qlist_emit(Qlist, JMP, NULL, NULL);
	       }
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLtdecr(37);
LL_NOSCANDONE(')');
}
static
#if LL_ANSI_C
void
#endif
LL34_marking(
#if LL_ANSI_C
# line 677 "compile.g"
expr_t *E)  
#else
# line 677 "compile.g"
 E) expr_t *E; 
#endif
{
# line 677 "compile.g"
 int type; symbol_t *arg1, *arg2; 
LLtincr(3);
LLtincr(31);
LLtincr(4);
LLtincr(37);
LL_SAFE(MARK);
LL_NOSCANDONE('(');
LLtdecr(3);
LL_NOSCANDONE(IDENTIFIER);
# line 678 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && ! IS_MARKER(sym->class))
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("%s: not a marker identifier", lex_strval);
		  SemErr++;
	       } else {
		  type = sym->type;
		  arg1 = sym;
	       }
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLtdecr(31);
LL_NOSCANDONE(',');
LLtdecr(4);
LL_NOSCANDONE(LITERAL);
# line 695 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && sym->type != type)
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("\"%s\": wrong type", lex_strval);
		  SemErr++;
	       } else {
		  arg2 = sym;
		  if (!SemErr) {
		     qlist_emit(Qlist, MRK, arg1, arg2);
		     E->truelist = bplist_create(qlist_next(Qlist));
		     qlist_emit(Qlist, BNZ, NULL, NULL);
		     E->falselist = bplist_create(qlist_next(Qlist));
		     qlist_emit(Qlist, JMP, NULL, NULL);
		  }
	       }
	    } else {
	       wherr("\"%s\": value not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLtdecr(37);
LL_NOSCANDONE(')');
}
static
#if LL_ANSI_C
void
#endif
LL30_negated_factor(
#if LL_ANSI_C
# line 720 "compile.g"
expr_t *E)  
#else
# line 720 "compile.g"
 E) expr_t *E; 
#endif
{
# line 720 "compile.g"
 expr_t E1; 
LLsincr(14);
LL_SAFE(NOT);
LLread();
LL28_factor(
# line 721 "compile.g"
&E1);
# line 721 "compile.g"
{
	    E->truelist = E1.falselist;
            E->falselist = E1.truelist;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL31_grouped_factor(
#if LL_ANSI_C
# line 727 "compile.g"
expr_t *E)  
#else
# line 727 "compile.g"
 E) expr_t *E; 
#endif
{
# line 727 "compile.g"
 expr_t E1; 
LLtincr(37);
LL_SAFE('(');
LLread();
LL25_expression(
# line 728 "compile.g"
&E1);
LLtdecr(37);
LL_SCANDONE(')');
# line 728 "compile.g"
{
	    E->truelist = E1.truelist;
            E->falselist = E1.falselist;
	 }
}
static
#if LL_ANSI_C
void
#endif
LL26_assignment(
#if LL_ANSI_C
void
#endif
) {
# line 734 "compile.g"
 int type; symbol_t *arg1, *arg2; 
LLtincr(32);
LLtincr(29);
LLsincr(16);
LL_NOSCANDONE(IDENTIFIER);
# line 735 "compile.g"
{
	    if ((arg1 = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (arg1 != NULL && ! IS_FUNCTION(arg1->class))
		  arg1 = symtbl_repeat(lex_strval);
	       if (arg1 == NULL) {
		  wherr("%s: not a function identifier", lex_strval);
		  SemErr++;
	       } else {
		  type = arg1->type;
	       }
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLread();
goto L_1;
L_1 : {switch(LLcsymb) {
case /* '=' */ 29 : ;
LLtdecr(32);
break;
default:{int LL_20=LLnext(91);
;if (!LL_20) {
LLtdecr(32);
break;
}
else if (LL_20 & 1) goto L_1;}
case /* '[' */ 32 : ;
LLtdecr(32);
LL37_enclitic_function(
# line 750 "compile.g"
arg1);
LLread();
}
}
LLtdecr(29);
LL_SCANDONE('=');
LL38_value_identifier(
# line 752 "compile.g"
&arg2, type);
# line 752 "compile.g"
{
	    if (!SemErr)
	       qlist_emit(Qlist, LDV, arg1, arg2);
	 }
}
static
#if LL_ANSI_C
void
#endif
LL37_enclitic_function(
#if LL_ANSI_C
# line 758 "compile.g"
symbol_t *f)  
#else
# line 758 "compile.g"
 f) symbol_t *f; 
#endif
{
LLtincr(33);
LL_SAFE('[');
LL_NOSCANDONE(IDENTIFIER);
# line 759 "compile.g"
{
	    symbol_t *s;
	    if ((s = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (s != NULL && ! IS_ENCLITIC(s->class))
		  s = symtbl_repeat(lex_strval);
	       if (s == NULL) {
		  wherr("%s: not an enclitic", lex_strval);
		  SemErr++;
	       } else if (!grammar_has_function(s->value, f->value)) {
		  wherr("%s: not declared for %s", f->name, s->name);
		  SemErr++;
	       } else
		  qlist_emit(Qlist, ENC, s, NULL);
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
LLtdecr(33);
LL_NOSCANDONE(']');
}
static
#if LL_ANSI_C
void
#endif
LL38_value_identifier(
#if LL_ANSI_C
# line 780 "compile.g"
symbol_t **arg ,int type)  
#else
# line 780 "compile.g"
 arg,type) symbol_t **arg; int type; 
#endif
{
LLread();
goto L_2; /* so that the label is used for certain */
L_2: ;
switch(LLcsymb) {
case /*  IDENTIFIER  */ 3 : ;
goto L_3;
L_3: ;
LLsdecr(16);
LL_SSCANDONE(IDENTIFIER);
# line 781 "compile.g"
{
	    symbol_t *sym;
	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) != NULL) {
	       while (sym != NULL && sym->type != type)
		  sym = symtbl_repeat(lex_strval);
	       if (sym == NULL) {
		  wherr("%s: value has wrong type", lex_strval);
		  SemErr++;
	       } else
		  *arg = sym;
	    } else {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    }
	 }
break;
default: if (LLskip()) goto L_2;
goto L_3;
case /*  ABSENT  */ 5 : ;
LLsdecr(16);
LL_SAFE(ABSENT);
# line 796 "compile.g"
{
	    *arg = symtbl_lookup(Symtbl, "absent");
	 }
break;
case /*  UNKNOWN  */ 22 : ;
LLsdecr(16);
LL_SAFE(UNKNOWN);
# line 799 "compile.g"
{
	    *arg = symtbl_lookup(Symtbl, "unknown");
	 }
break;
}
}

# line 804 "compile.g"
 /* C function declarations */

/*VARARGS0*/
PRIVATE void
wherr(char *fmt,...)
{
   va_list         args;

   va_start(args, fmt);
   (void) fprintf(stderr, "%s: line %d: ", FileName, lex_lineno());
   (void) vfprintf(stderr, fmt, args);
   (void) fprintf(stderr, "\n");
   va_end(args);
}

PRIVATE morph_stack_t *
pop_morph (void)
{
   morph_stack_t *old = stack;
   if (old != NULL)
      stack = old->next;
   return old;
}

PRIVATE void
push_morph (int value)
{
   morph_stack_t *new;
   new = malloc (sizeof (morph_stack_t));
   if (new == NULL) {
      wherr ("Cannot push morpheme on stack.\n");
      exit (1);
   }
   new->value = value;
   new->next = stack;
   stack = new;
}

PRIVATE void
init_token_table()
{
   TokenTable[EOFILE - EOFILE] = "end of file";
   TokenTable[ABSENT - EOFILE] = "absent";
   TokenTable[ACTION_OPERATOR - EOFILE] = "::";
   TokenTable[AND - EOFILE] = "&&";
   TokenTable[CHARACTER - EOFILE] = "character";
   TokenTable[ENCLITIC - EOFILE] = "enclitic";
   TokenTable[END - EOFILE] = "end";
   TokenTable[EQUALITY - EOFILE] = "==";
   TokenTable[EXIST - EOFILE] = "exist";
   TokenTable[FORMS - EOFILE] = "forms";
   TokenTable[FUNCTIONS - EOFILE] = "functions";
   TokenTable[IDENTIFIER - EOFILE] = "identifier";
   TokenTable[IN - EOFILE] = "in";
   TokenTable[INFIX - EOFILE] = "infix";
   TokenTable[LEXICAL - EOFILE] = "lexical";
   TokenTable[LITERAL - EOFILE] = "literal";
   TokenTable[MARK - EOFILE] = "mark";
   TokenTable[MARKER - EOFILE] = "marker";
   TokenTable[NEQ - EOFILE] = "!=";
   TokenTable[NI - EOFILE] = "ni";
   TokenTable[NOT - EOFILE] = "not";
   TokenTable[OR - EOFILE] = "||";
   TokenTable[PREFIX - EOFILE] = "prefix";
   TokenTable[RULES - EOFILE] = "rules";
   TokenTable[SHARED - EOFILE] = "shared";
   TokenTable[SUFFIX - EOFILE] = "suffix";
   TokenTable[UNKNOWN - EOFILE] = "unknown";
   TokenTable[WORD - EOFILE] = "word";
}


PRIVATE char   *
token_name(token)
   int             token;
{
   static char     buffer[] = "`a'";

   if (token >= EOFILE)
      return TokenTable[token - EOFILE];
   else {
      buffer[1] = (char) token;
      return buffer;
   }
}


PUBLIC void
LLmessage(token)
   int             token;
{
   SynErr++;
   switch (token) {
   case -1:
      wherr("end of file expected");
      break;
   case 0:
      wherr("%s deleted", token_name(LLsymb));
      break;
   default:
      wherr("%s inserted before %s",
	  token_name(token), token_name(LLsymb)
	 );
      lex_goback();
   }
}


PRIVATE void
morpheme_declaration(class, ordinal)
   int             class;
   int             ordinal;
{
   symbol_t       *sym;

   if (symtbl_lookup(Symtbl, lex_strval) != NULL) {
      wherr("%s: identifier redeclared", lex_strval);
      SemErr++;
      return;
   }
   if ((sym = symtbl_insert(Symtbl, lex_strval)) == NULL) {
      ftlerr(ERRSTR);
   }
   sym->type = type_create();
   sym->class = class;
   sym->value = ordinal;
}


PRIVATE void
morpheme_element(type, morpheme_ordinal, element_ordinal)
   int             type;
   int             morpheme_ordinal;
   int             element_ordinal;
{
   symbol_t       *sym;

   if (
       (sym = symtbl_lookup(Symtbl, lex_strval)) != NULL &&
       sym->type == type
      )
      wherr("\"%s\": morpheme repeated", lex_strval);
   else if ((sym = symtbl_insert(Symtbl, lex_strval)) == NULL)
      error(ERRSTR);
   else {
      sym->type = type;
      sym->value = element_ordinal;
      if (grammar_add_morph_element(
	       morpheme_ordinal,
	       sym->name,
	       element_ordinal
	    ) == GRAMMAR_ERROR) {
	 error(ERRSTR);
	 exit(1);
      }
   }
}


exec_t *
compile(char *fname)
{
   exec_t        *ep = NULL;
   symbol_t      *symbol;

   if (!lex_open(fname)) {
      error("%s: %s", fname, ERRSTR);
      return NULL;
   }
   FileName = fname;
   init_token_table();
   if ((Symtbl = symtbl_create(SYMTBL_SIZE)) == NULL) {
      error("can't create symbol table: %s", ERRSTR);
      return NULL;
   }
   if ((symbol = symtbl_insert(Symtbl, "unknown")) == NULL) {
      error("can't insert symbol: %s", ERRSTR);
      return NULL;
   }
   symbol->value = WORD_VALUE_UNKNOWN;
   if ((symbol = symtbl_insert(Symtbl, "absent")) == NULL) {
      error("can't insert symbol: %s", ERRSTR);
      return NULL;
   }
   symbol->value = WORD_VALUE_ABSENT;
   MorphemeOrdinal = 1;
   FunctionOrdinal = 1;
   SemErr = 0;
   SynErr = 0;
   Qlist = qlist_create();
   parser();
   if (SynErr == 0 && SemErr == 0) {
      if ((ep = exec_create(qlist_size(Qlist))) == NULL)
	 ftlerr("can't create executable: %s", ERRSTR);
      else
	 qlist_asm(Qlist, ep);
   }
   symtbl_delete(Symtbl);
   qlist_delete(Qlist);
   lex_close();
   return ep;
}

/* End of function declarations */ 

