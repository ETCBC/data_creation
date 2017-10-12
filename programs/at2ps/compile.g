/**********************************************************************/
/*                                                                    */
/*     compile.g  --  LLgen source for compiler                       */
/*                                                                    */
/*                                            Constantijn Sikkel      */
/*                                                                    */
/**********************************************************************/

{
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
}


%token	CHARACTER;
%token	IDENTIFIER;
%token	LITERAL;

/* Reserved words */

%token	ABSENT;
%token	ENCLITIC;
%token	END;
%token	EXIST;
%token	FORMS;
%token	FUNCTIONS;
%token	IN;
%token	INFIX;
%token	LEXICAL;
%token	MARK;
%token	MARKER;
%token	NI;
%token	NOT;
%token	PREFIX;
%token	RULES;
%token	SHARED;
%token	SUFFIX;
%token	UNKNOWN;
%token	WORD;


/* Operators */

%token	ACTION_OPERATOR;
%token	AND;
%token	EQUALITY;
%token	NEQ;
%token	OR;

%start      parser, grammar;

grammar: word [ lexical ] forms functions rules;

word:
      WORD
      [ prefix ]
      [ infix ]
      [ suffix ]
      [ marker ]
      [ enclitic ]
      ;

prefix:
      PREFIX '=' [ prefix_declaration ] * ;

prefix_declaration { char separator; }:
      IDENTIFIER {
	    morpheme_declaration(CLASS_MORPHEME, MorphemeOrdinal);
	 }
      ':' CHARACTER {
	    separator = lex_strval[1];
	 }
      ',' LITERAL {
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
      ;

infix:
      INFIX '=' [ infix_declaration ] * ;

infix_declaration { char separator; }:
      IDENTIFIER {
	    morpheme_declaration(CLASS_MORPHEME, MorphemeOrdinal);
	 }
      ':' CHARACTER {
	    separator = lex_strval[1];
	 }
      ',' LITERAL {
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
      ;

suffix:
      SUFFIX '=' [ suffix_declaration ] * ;

suffix_declaration { char separator; }:
      IDENTIFIER {
	    morpheme_declaration(CLASS_MORPHEME, MorphemeOrdinal);
	 }
      ':' CHARACTER {
	    separator = lex_strval[1];
	 }
      ',' LITERAL {
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
      ;

marker:
      MARKER '=' [ marker_declaration ] * ;

marker_declaration { char separator; }:
      IDENTIFIER {
	    morpheme_declaration(CLASS_MARKER, MorphemeOrdinal);
	 }
      ':' CHARACTER {
	    separator = lex_strval[1];
	 }
      ',' LITERAL {
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
      ;

enclitic:
      ENCLITIC '=' [ enclitic_declaration ] * ;

enclitic_declaration { char separator; }:
      IDENTIFIER {
	    morpheme_declaration(
		  CLASS_MORPHEME|CLASS_ENCLITIC,
		  MorphemeOrdinal
	       );
	 }
      ':' CHARACTER {
	    separator = lex_strval[1];
	 }
      ',' LITERAL {
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
      ;

lexical:
      LEXICAL IDENTIFIER {
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
      [ ',' IDENTIFIER {
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
      ] * ;

forms:
      FORMS [ forms_declaration ] * ;

forms_declaration { int type; int element_ordinal = 1; }:
      IDENTIFIER {
	    symbol_t *sym;

	    if ((sym = symtbl_lookup(Symtbl, lex_strval)) == NULL) {
	       wherr("%s: identifier not declared", lex_strval);
	       SemErr++;
	    } else {
	       type = sym->type;
	       MorphemeOrdinal = sym->value;
	    }
	 }
      '=' LITERAL {
	    morpheme_element(type, MorphemeOrdinal, element_ordinal++);
	 }
      [ ',' LITERAL {
	    morpheme_element(type, MorphemeOrdinal, element_ordinal++);
	 }
      ] * ;

functions:
      FUNCTIONS [ function_declaration ] * ;

function_declaration { symbol_t *f = NULL; }:
      function(&f) '=' values(f) ;

function(symbol_t **f;):
      IDENTIFIER {
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
      function_sharing? ':' LITERAL {
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
      ;

values(symbol_t *f;) { int ord = 1; }:
      value_declaration(f, &ord) [ ',' value_declaration(f, &ord) ] * ;

function_sharing: /* must be an enclitic */
      '[' IDENTIFIER {
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
      [ ',' IDENTIFIER {
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
      ] * ']' ;

value_declaration(symbol_t *f; int *ord;):
      IDENTIFIER
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
      ':' LITERAL
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
      ;

rules:
      RULES rule * {
	    qlist_emit(Qlist, RET, NULL, NULL);
	 }
      ;

rule:
      simple_rule | block ;

simple_rule { expr_t E; }:
      expression(&E) {
	    if (!SemErr) {
	       bplist_patch(E.truelist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.truelist);
	    }
	 }
      ACTION_OPERATOR
      assignment [ ',' assignment ] * {
	    if (!SemErr) {
	       bplist_patch(E.falselist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.falselist);
	    }
	 }
      ;

block { expr_t E; }:
      SHARED
      '{'
      expression(&E) {
	    if (!SemErr) {
	       bplist_patch(E.truelist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.truelist);
	    }
	 }
      ACTION_OPERATOR
      assignment [ ',' assignment ] *
      '}'
      rule+
      END {
	    if (!SemErr) {
	       bplist_patch(E.falselist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	       bplist_delete(E.falselist);
	    }
	 }
      ;

expression(expr_t *E;) {expr_t E1, E2, *LE;}:
      term(&E1) {
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       LE = &E1;
	    }
	 }
      [ OR {
	    if (!SemErr) {
	       bplist_patch(LE->falselist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	    }
	 }
      term(&E2) {
	    if (!SemErr) {
	       E->truelist = bplist_merge(E->truelist, E2.truelist);
	       LE = &E2;
	    }
	 }
      ] * {
	    if (!SemErr) E->falselist = LE->falselist;
	 }
      ;

term(expr_t *E;) { expr_t E1, E2, *LE; }:
      factor (&E1) {
	    if (!SemErr) {
	       E->falselist = E1.falselist;
	       LE = &E1;
	    }
	 }
      [ AND {
	    if (!SemErr) {
	       bplist_patch(LE->truelist, qlist_next(Qlist));
	       quad_label(qlist_next(Qlist));
	    }
	 }
      factor (&E2) {
	    if (!SemErr) {
	       E->falselist = bplist_merge(E->falselist, E2.falselist);
	       LE = &E2;
	    }
	 }
      ] * {
	    if (!SemErr) E->truelist = LE->truelist;
	 }
      ;

factor(expr_t *E;) { expr_t E1; }:
      simple_factor (&E1) {
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       E->falselist = E1.falselist;
	    }
	 }
      |
      negated_factor (&E1) {
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       E->falselist = E1.falselist;
	    }
	 }
      |
      grouped_factor (&E1) {
	    if (!SemErr) {
	       E->truelist = E1.truelist;
	       E->falselist = E1.falselist;
	    }
	 }
      ;

simple_factor(expr_t *E;) { }:
      comparison(E) | existence(E) | marking(E) ;

comparison(expr_t *E;) { int type; symbol_t *sym;}:
      IDENTIFIER {
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
      [
	 literal_comparison(E, type, sym)
      |
	 set_comparison(E, type, sym)
      ] ;

literal_comparison(expr_t *E; int type; symbol_t *sop;)
{ bplist_t **tlp, **flp; }:
      [ EQUALITY {
	    tlp = & E->truelist;
	    flp = & E->falselist;
	 }
      | NEQ {
	    tlp = & E->falselist;
	    flp = & E->truelist;
	 }
      ]
      LITERAL {
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
      ;

set_comparison(expr_t *E; int type; symbol_t *sop;)
{ bplist_t **tlp, **flp; }:
      [ IN {
	    tlp = & E->truelist;
	    flp = & E->falselist;
	 }
      | NI {
	    tlp = & E->falselist;
	    flp = & E->truelist;
	 }
      ]
      '{' LITERAL {
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
      [ ',' LITERAL {
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
      ] * {
	    *flp = bplist_create(qlist_next(Qlist));
	    qlist_emit(Qlist, JMP, NULL, NULL);
	 }
      '}' ;

existence(expr_t *E;):
      EXIST '(' IDENTIFIER {
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
      ')' ;

marking(expr_t *E;) { int type; symbol_t *arg1, *arg2; }:
      MARK '(' IDENTIFIER {
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
      ',' LITERAL {
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
      ')' ;

negated_factor(expr_t *E;) { expr_t E1; }:
      NOT factor(&E1) {
	    E->truelist = E1.falselist;
            E->falselist = E1.truelist;
	 }
      ;

grouped_factor(expr_t *E;) { expr_t E1; }:
      '(' expression(&E1) ')' {
	    E->truelist = E1.truelist;
            E->falselist = E1.falselist;
	 }
      ;

assignment { int type; symbol_t *arg1, *arg2; }:
      IDENTIFIER {
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
      enclitic_function(arg1)?
      '='
      value_identifier(&arg2, type) {
	    if (!SemErr)
	       qlist_emit(Qlist, LDV, arg1, arg2);
	 }
      ;

enclitic_function(symbol_t *f;):
      '[' IDENTIFIER {
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
      ']'
      ;

value_identifier(symbol_t **arg; int type;):
      IDENTIFIER {
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
      | ABSENT {
	    *arg = symtbl_lookup(Symtbl, "absent");
	 }
      | UNKNOWN {
	    *arg = symtbl_lookup(Symtbl, "unknown");
	 }
      ;

{ /* C function declarations */

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

/* End of function declarations */ }
