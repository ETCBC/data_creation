h19637
s 00001/00000/00177
d D 1.2 04/07/20 11:43:28 const 2 1
c Resolved a few compiler warnings.
e
s 00177/00000/00000
d D 1.1 00/09/19 12:20:32 const 1 0
c Version of May 24 1996
e
u
U
f e 0
f m q2pro/at2ps/lexer.l
t
T
I 1
/**********************************************************************/
/*                                                                    */
/*     lexer: lexical analysis of grammar rules                       */
/*                                                                    */
/*                                                 Constantijn Sikkel */
/*                                                                    */
/**********************************************************************/
%{
#pragma ident "%Z%what/%M% %I% %G%"

#include	<stdio.h>
I 2
#include	<string.h>
E 2
#include	<biblan.h>

#include	"Lpars.h"
#include	"lexer.h"

PRIVATE char   *strip_quotes();

PUBLIC  char   *lex_strval;

%}

/* Definitions */

digit		[0-9]
letter		[A-Za-z_]

CHARACTER	'.'
COMMENT		#.*
IDENTIFIER	{letter}({letter}|{digit})*
LITERAL		\"[^\"\n]*\"
LWSP		[ \t\n]

/* Reserved words */

ABSENT		"absent"
ACTION_OPERATOR	"::"
AND		"&&"
ENCLITIC	"enclitic"
END		"end"
EQUALITY	"=="
EXIST		"exist"
FORMS		"forms"
FUNCTIONS	"functions"
IN		"in"
INFIX		"infix"
LEXICAL		"lexical"
MARK		"mark"
MARKER		"marker"
NEQ		"!="
NI		"ni"
NOT		"not"
OR		"||"
PREFIX		"prefix"
RULES		"rules"
SHARED		"shared"
SUFFIX		"suffix"
UNKNOWN		"unknown"
WORD		"word"

%%

{COMMENT}		{}

{LWSP}			{}

{ABSENT}		{ return ABSENT; }

{ACTION_OPERATOR}	{ return ACTION_OPERATOR; }

{AND}			{ return AND; }

{ENCLITIC}		{ return ENCLITIC; }

{END}			{ return END; }

{EQUALITY}		{ return EQUALITY; }

{EXIST}			{ return EXIST; }

{FORMS}			{ return FORMS; }

{FUNCTIONS}		{ return FUNCTIONS; }

{IN}			{ return IN; }

{INFIX}			{ return INFIX; }

{LEXICAL}		{ return LEXICAL; }

{MARK}			{ return MARK; }

{MARKER}		{ return MARKER; }

{NEQ}			{ return NEQ; }

{NI}			{ return NI; }

{NOT}			{ return NOT; }

{OR}			{ return OR; }

{PREFIX}		{ return PREFIX; }

{RULES}			{ return RULES; }

{SHARED}		{ return SHARED; }

{SUFFIX}		{ return SUFFIX; }

{UNKNOWN}		{ return UNKNOWN; }

{WORD}			{ return WORD; }

{LITERAL}	{
      lex_strval = strip_quotes(yytext, (size_t) yyleng);
      return LITERAL;
   }

{IDENTIFIER}	{
      lex_strval = yytext;
      return IDENTIFIER;
   }

{CHARACTER}	{ return CHARACTER; }

.		{ return (int) yytext[0]; }

%%

PRIVATE char *
strip_quotes(string, length)
   char *string;
   size_t length;
{
   static char buffer[BUFSIZ];
   size_t nchars;
   
   if (length > BUFSIZ)
      nchars = BUFSIZ - 1; /* one quote stripped */
   else if (length > 1)
      nchars = length - 2; /* two quotes stripped */
   /*else
      die(__FILE__, __LINE__);*/
   (void) strncpy(buffer, string + 1, nchars);
   buffer[nchars] = EOS;
   return buffer;
}


PUBLIC void
lex_goback()
{
   yyless(0);	/* push it back to yytext[0] */
}


PUBLIC int
lex_lineno()
{
   return yylineno;
}


PUBLIC int
lex_open(fname)
   char *fname;
{
   return (yyin = fopen(fname, "r")) != NULL;
}


PUBLIC int
lex_close(void)
{
   return fclose(yyin) == 0;
}
E 1
