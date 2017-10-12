#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
# define U(x) x
# define NLSTATE yyprevious=YYNEWLINE
# define BEGIN yybgin = yysvec + 1 +
# define INITIAL 0
# define YYLERR yysvec
# define YYSTATE (yyestate-yysvec-1)
# define YYOPTIM 1
# ifndef YYLMAX 
# define YYLMAX BUFSIZ
# endif 
#ifndef __cplusplus
# define output(c) (void)putc(c,yyout)
#else
# define lex_output(c) (void)putc(c,yyout)
#endif

#if defined(__cplusplus) || defined(__STDC__)

#if defined(__cplusplus) && defined(__EXTERN_C__)
extern "C" {
#endif
	int yyback(int *, int);
	int yyinput(void);
	int yylook(void);
	void yyoutput(int);
	int yyracc(int);
	int yyreject(void);
	void yyunput(int);
	int yylex(void);
#ifdef YYLEX_E
	void yywoutput(wchar_t);
	wchar_t yywinput(void);
#endif
#ifndef yyless
	int yyless(int);
#endif
#ifndef yywrap
	int yywrap(void);
#endif
#ifdef LEXDEBUG
	void allprint(char);
	void sprint(char *);
#endif
#if defined(__cplusplus) && defined(__EXTERN_C__)
}
#endif

#ifdef __cplusplus
extern "C" {
#endif
	void exit(int);
#ifdef __cplusplus
}
#endif

#endif
# define unput(c) {yytchar= (c);if(yytchar=='\n')yylineno--;*yysptr++=yytchar;}
# define yymore() (yymorfg=1)
#ifndef __cplusplus
# define input() (((yytchar=yysptr>yysbuf?U(*--yysptr):getc(yyin))==10?(yylineno++,yytchar):yytchar)==EOF?0:yytchar)
#else
# define lex_input() (((yytchar=yysptr>yysbuf?U(*--yysptr):getc(yyin))==10?(yylineno++,yytchar):yytchar)==EOF?0:yytchar)
#endif
#define ECHO fprintf(yyout, "%s",yytext)
# define REJECT { nstr = yyreject(); goto yyfussy;}
int yyleng;
#define YYISARRAY
char yytext[YYLMAX];
int yymorfg;
extern char *yysptr, yysbuf[];
int yytchar;
FILE *yyin = {stdin}, *yyout = {stdout};
extern int yylineno;
struct yysvf { 
	struct yywork *yystoff;
	struct yysvf *yyother;
	int *yystops;};
struct yysvf *yyestate;
extern struct yysvf yysvec[], *yybgin;

# line 2 "lexer.l"
/**********************************************************************/

# line 3 "lexer.l"
/*                                                                    */

# line 4 "lexer.l"
/*     lexer: lexical analysis of grammar rules                       */

# line 5 "lexer.l"
/*                                                                    */

# line 6 "lexer.l"
/*                                                 Constantijn Sikkel */

# line 7 "lexer.l"
/*                                                                    */

# line 8 "lexer.l"
/**********************************************************************/
#pragma ident "@(#)what/q2pro/at2ps/lexer.l 1.2 07/20/04"

#include	<stdio.h>
#include	<string.h>
#include	<biblan.h>

#include	"Lpars.h"
#include	"lexer.h"

PRIVATE char   *strip_quotes();

PUBLIC  char   *lex_strval;


# line 25 "lexer.l"
/* Definitions */

# line 36 "lexer.l"
/* Reserved words */
# define YYNEWLINE 10
yylex(){
int nstr; extern int yyprevious;
#ifdef __cplusplus
/* to avoid CC and lint complaining yyfussy not being used ...*/
static int __lex_hack = 0;
if (__lex_hack) goto yyfussy;
#endif
while((nstr = yylook()) >= 0)
yyfussy: switch(nstr){
case 0:
if(yywrap()) return(0); break;
case 1:

# line 64 "lexer.l"
	{}
break;
case 2:

# line 66 "lexer.l"
		{}
break;
case 3:

# line 68 "lexer.l"
	{ return ABSENT; }
break;
case 4:

# line 70 "lexer.l"
{ return ACTION_OPERATOR; }
break;
case 5:

# line 72 "lexer.l"
		{ return AND; }
break;
case 6:

# line 74 "lexer.l"
	{ return ENCLITIC; }
break;
case 7:

# line 76 "lexer.l"
		{ return END; }
break;
case 8:

# line 78 "lexer.l"
	{ return EQUALITY; }
break;
case 9:

# line 80 "lexer.l"
		{ return EXIST; }
break;
case 10:

# line 82 "lexer.l"
		{ return FORMS; }
break;
case 11:

# line 84 "lexer.l"
	{ return FUNCTIONS; }
break;
case 12:

# line 86 "lexer.l"
		{ return IN; }
break;
case 13:

# line 88 "lexer.l"
		{ return INFIX; }
break;
case 14:

# line 90 "lexer.l"
	{ return LEXICAL; }
break;
case 15:

# line 92 "lexer.l"
		{ return MARK; }
break;
case 16:

# line 94 "lexer.l"
	{ return MARKER; }
break;
case 17:

# line 96 "lexer.l"
		{ return NEQ; }
break;
case 18:

# line 98 "lexer.l"
		{ return NI; }
break;
case 19:

# line 100 "lexer.l"
		{ return NOT; }
break;
case 20:

# line 102 "lexer.l"
		{ return OR; }
break;
case 21:

# line 104 "lexer.l"
	{ return PREFIX; }
break;
case 22:

# line 106 "lexer.l"
		{ return RULES; }
break;
case 23:

# line 108 "lexer.l"
	{ return SHARED; }
break;
case 24:

# line 110 "lexer.l"
	{ return SUFFIX; }
break;
case 25:

# line 112 "lexer.l"
	{ return UNKNOWN; }
break;
case 26:

# line 114 "lexer.l"
		{ return WORD; }
break;
case 27:

# line 116 "lexer.l"
{
      lex_strval = strip_quotes(yytext, (size_t) yyleng);
      return LITERAL;
   }
break;
case 28:

# line 121 "lexer.l"
{
      lex_strval = yytext;
      return IDENTIFIER;
   }
break;
case 29:

# line 126 "lexer.l"
{ return CHARACTER; }
break;
case 30:

# line 128 "lexer.l"
	{ return (int) yytext[0]; }
break;
case -1:
break;
default:
(void)fprintf(yyout,"bad switch yylook %d",nstr);
} return(0); }
/* end of yylex */

# line 131 "lexer.l"

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
int yyvstop[] = {
0,

30,
0, 

2,
30,
0, 

2,
0, 

30,
0, 

30,
0, 

1,
30,
0, 

30,
0, 

30,
0, 

30,
0, 

30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

28,
30,
0, 

30,
0, 

17,
0, 

27,
0, 

1,
0, 

5,
0, 

4,
0, 

8,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

12,
28,
0, 

28,
0, 

28,
0, 

18,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

20,
0, 

29,
0, 

28,
0, 

28,
0, 

7,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

19,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

15,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

28,
0, 

26,
28,
0, 

28,
0, 

28,
0, 

9,
28,
0, 

10,
28,
0, 

28,
0, 

13,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

22,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

3,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

16,
28,
0, 

21,
28,
0, 

23,
28,
0, 

24,
28,
0, 

28,
0, 

28,
0, 

28,
0, 

14,
28,
0, 

25,
28,
0, 

6,
28,
0, 

28,
0, 

11,
28,
0, 
0};
# define YYTYPE unsigned char
struct yywork { YYTYPE verify, advance; } yycrank[] = {
0,0,	0,0,	1,3,	0,0,	
7,28,	0,0,	0,0,	0,0,	
0,0,	8,30,	1,4,	1,5,	
7,28,	7,0,	28,0,	30,0,	
0,0,	8,30,	8,0,	0,0,	
10,32,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
10,32,	10,0,	0,0,	0,0,	
0,0,	0,0,	1,6,	1,7,	
1,8,	7,29,	0,0,	1,9,	
1,10,	9,31,	8,30,	32,53,	
0,0,	0,0,	0,0,	0,0,	
0,0,	1,3,	0,0,	7,28,	
0,0,	10,32,	0,0,	2,6,	
8,30,	2,8,	0,0,	1,11,	
2,9,	2,10,	1,12,	6,27,	
11,33,	12,34,	1,13,	10,32,	
7,28,	0,0,	0,0,	0,0,	
0,0,	8,30,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
2,11,	0,0,	0,0,	2,12,	
10,32,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	1,14,	14,36,	
19,43,	48,66,	1,15,	1,16,	
18,42,	41,60,	1,17,	37,55,	
37,56,	1,18,	1,19,	1,20,	
15,37,	1,21,	17,41,	1,22,	
1,23,	21,46,	1,24,	2,14,	
1,25,	22,47,	15,38,	2,15,	
2,16,	1,26,	24,50,	2,17,	
25,51,	16,39,	2,18,	2,19,	
2,20,	26,52,	2,21,	16,40,	
2,22,	2,23,	20,44,	2,24,	
36,54,	2,25,	38,57,	39,58,	
20,45,	23,48,	2,26,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	40,59,	23,49,	42,61,	
43,62,	45,63,	46,64,	47,65,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	49,67,	50,68,	
51,69,	54,70,	13,35,	55,71,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	13,35,	13,35,	
13,35,	13,35,	57,72,	58,73,	
59,74,	60,75,	61,76,	62,77,	
64,78,	65,79,	66,80,	67,81,	
68,82,	69,83,	70,84,	71,85,	
72,86,	73,87,	74,88,	75,89,	
76,90,	77,91,	78,92,	79,93,	
80,94,	81,95,	82,96,	84,97,	
85,98,	88,99,	90,100,	91,101,	
92,102,	94,103,	95,104,	96,105,	
98,106,	99,107,	100,108,	105,109,	
106,110,	107,111,	111,112,	0,0,	
0,0};
struct yysvf yysvec[] = {
0,	0,	0,
yycrank+-1,	0,		0,	
yycrank+-22,	yysvec+1,	0,	
yycrank+0,	0,		yyvstop+1,
yycrank+0,	0,		yyvstop+3,
yycrank+0,	0,		yyvstop+6,
yycrank+2,	0,		yyvstop+8,
yycrank+-3,	0,		yyvstop+10,
yycrank+-8,	0,		yyvstop+12,
yycrank+3,	0,		yyvstop+15,
yycrank+-19,	0,		yyvstop+17,
yycrank+6,	0,		yyvstop+19,
yycrank+4,	0,		yyvstop+21,
yycrank+99,	0,		yyvstop+23,
yycrank+1,	yysvec+13,	yyvstop+26,
yycrank+2,	yysvec+13,	yyvstop+29,
yycrank+18,	yysvec+13,	yyvstop+32,
yycrank+4,	yysvec+13,	yyvstop+35,
yycrank+3,	yysvec+13,	yyvstop+38,
yycrank+3,	yysvec+13,	yyvstop+41,
yycrank+33,	yysvec+13,	yyvstop+44,
yycrank+3,	yysvec+13,	yyvstop+47,
yycrank+4,	yysvec+13,	yyvstop+50,
yycrank+41,	yysvec+13,	yyvstop+53,
yycrank+16,	yysvec+13,	yyvstop+56,
yycrank+17,	yysvec+13,	yyvstop+59,
yycrank+9,	0,		yyvstop+62,
yycrank+0,	0,		yyvstop+64,
yycrank+-4,	yysvec+7,	0,	
yycrank+0,	0,		yyvstop+66,
yycrank+-5,	yysvec+8,	yyvstop+68,
yycrank+0,	0,		yyvstop+70,
yycrank+4,	0,		0,	
yycrank+0,	0,		yyvstop+72,
yycrank+0,	0,		yyvstop+74,
yycrank+0,	yysvec+13,	yyvstop+76,
yycrank+25,	yysvec+13,	yyvstop+78,
yycrank+8,	yysvec+13,	yyvstop+80,
yycrank+37,	yysvec+13,	yyvstop+82,
yycrank+29,	yysvec+13,	yyvstop+84,
yycrank+47,	yysvec+13,	yyvstop+86,
yycrank+3,	yysvec+13,	yyvstop+88,
yycrank+39,	yysvec+13,	yyvstop+91,
yycrank+46,	yysvec+13,	yyvstop+93,
yycrank+0,	yysvec+13,	yyvstop+95,
yycrank+45,	yysvec+13,	yyvstop+98,
yycrank+61,	yysvec+13,	yyvstop+100,
yycrank+55,	yysvec+13,	yyvstop+102,
yycrank+4,	yysvec+13,	yyvstop+104,
yycrank+88,	yysvec+13,	yyvstop+106,
yycrank+84,	yysvec+13,	yyvstop+108,
yycrank+78,	yysvec+13,	yyvstop+110,
yycrank+0,	0,		yyvstop+112,
yycrank+0,	0,		yyvstop+114,
yycrank+92,	yysvec+13,	yyvstop+116,
yycrank+87,	yysvec+13,	yyvstop+118,
yycrank+0,	yysvec+13,	yyvstop+120,
yycrank+107,	yysvec+13,	yyvstop+123,
yycrank+114,	yysvec+13,	yyvstop+125,
yycrank+125,	yysvec+13,	yyvstop+127,
yycrank+120,	yysvec+13,	yyvstop+129,
yycrank+121,	yysvec+13,	yyvstop+131,
yycrank+120,	yysvec+13,	yyvstop+133,
yycrank+0,	yysvec+13,	yyvstop+135,
yycrank+126,	yysvec+13,	yyvstop+138,
yycrank+128,	yysvec+13,	yyvstop+140,
yycrank+116,	yysvec+13,	yyvstop+142,
yycrank+129,	yysvec+13,	yyvstop+144,
yycrank+122,	yysvec+13,	yyvstop+146,
yycrank+133,	yysvec+13,	yyvstop+148,
yycrank+124,	yysvec+13,	yyvstop+150,
yycrank+130,	yysvec+13,	yyvstop+152,
yycrank+120,	yysvec+13,	yyvstop+154,
yycrank+122,	yysvec+13,	yyvstop+156,
yycrank+122,	yysvec+13,	yyvstop+158,
yycrank+119,	yysvec+13,	yyvstop+160,
yycrank+141,	yysvec+13,	yyvstop+162,
yycrank+140,	yysvec+13,	yyvstop+164,
yycrank+137,	yysvec+13,	yyvstop+167,
yycrank+128,	yysvec+13,	yyvstop+169,
yycrank+143,	yysvec+13,	yyvstop+171,
yycrank+140,	yysvec+13,	yyvstop+173,
yycrank+135,	yysvec+13,	yyvstop+175,
yycrank+0,	yysvec+13,	yyvstop+177,
yycrank+131,	yysvec+13,	yyvstop+180,
yycrank+132,	yysvec+13,	yyvstop+182,
yycrank+0,	yysvec+13,	yyvstop+184,
yycrank+0,	yysvec+13,	yyvstop+187,
yycrank+144,	yysvec+13,	yyvstop+190,
yycrank+0,	yysvec+13,	yyvstop+192,
yycrank+153,	yysvec+13,	yyvstop+195,
yycrank+137,	yysvec+13,	yyvstop+197,
yycrank+132,	yysvec+13,	yyvstop+199,
yycrank+0,	yysvec+13,	yyvstop+201,
yycrank+153,	yysvec+13,	yyvstop+204,
yycrank+134,	yysvec+13,	yyvstop+206,
yycrank+136,	yysvec+13,	yyvstop+208,
yycrank+0,	yysvec+13,	yyvstop+210,
yycrank+151,	yysvec+13,	yyvstop+213,
yycrank+146,	yysvec+13,	yyvstop+215,
yycrank+150,	yysvec+13,	yyvstop+217,
yycrank+0,	yysvec+13,	yyvstop+219,
yycrank+0,	yysvec+13,	yyvstop+222,
yycrank+0,	yysvec+13,	yyvstop+225,
yycrank+0,	yysvec+13,	yyvstop+228,
yycrank+149,	yysvec+13,	yyvstop+231,
yycrank+161,	yysvec+13,	yyvstop+233,
yycrank+151,	yysvec+13,	yyvstop+235,
yycrank+0,	yysvec+13,	yyvstop+237,
yycrank+0,	yysvec+13,	yyvstop+240,
yycrank+0,	yysvec+13,	yyvstop+243,
yycrank+147,	yysvec+13,	yyvstop+246,
yycrank+0,	yysvec+13,	yyvstop+248,
0,	0,	0};
struct yywork *yytop = yycrank+262;
struct yysvf *yybgin = yysvec+1;
char yymatch[] = {
  0,   1,   1,   1,   1,   1,   1,   1, 
  1,   9,  10,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  9,   1,  34,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
 48,  48,  48,  48,  48,  48,  48,  48, 
 48,  48,   1,   1,   1,   1,   1,   1, 
  1,  65,  65,  65,  65,  65,  65,  65, 
 65,  65,  65,  65,  65,  65,  65,  65, 
 65,  65,  65,  65,  65,  65,  65,  65, 
 65,  65,  65,   1,   1,   1,   1,  65, 
  1,  65,  65,  65,  65,  65,  65,  65, 
 65,  65,  65,  65,  65,  65,  65,  65, 
 65,  65,  65,  65,  65,  65,  65,  65, 
 65,  65,  65,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
0};
char yyextra[] = {
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0};
/*	Copyright (c) 1989 AT&T	*/
/*	  All Rights Reserved  	*/

/*	THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF AT&T	*/
/*	The copyright notice above does not evidence any   	*/
/*	actual or intended publication of such source code.	*/

#pragma ident	"@(#)ncform	6.12	97/12/08 SMI"

int yylineno =1;
# define YYU(x) x
# define NLSTATE yyprevious=YYNEWLINE
struct yysvf *yylstate [YYLMAX], **yylsp, **yyolsp;
char yysbuf[YYLMAX];
char *yysptr = yysbuf;
int *yyfnd;
extern struct yysvf *yyestate;
int yyprevious = YYNEWLINE;
#if defined(__cplusplus) || defined(__STDC__)
int yylook(void)
#else
yylook()
#endif
{
	register struct yysvf *yystate, **lsp;
	register struct yywork *yyt;
	struct yysvf *yyz;
	int yych, yyfirst;
	struct yywork *yyr;
# ifdef LEXDEBUG
	int debug;
# endif
	char *yylastch;
	/* start off machines */
# ifdef LEXDEBUG
	debug = 0;
# endif
	yyfirst=1;
	if (!yymorfg)
		yylastch = yytext;
	else {
		yymorfg=0;
		yylastch = yytext+yyleng;
		}
	for(;;){
		lsp = yylstate;
		yyestate = yystate = yybgin;
		if (yyprevious==YYNEWLINE) yystate++;
		for (;;){
# ifdef LEXDEBUG
			if(debug)fprintf(yyout,"state %d\n",yystate-yysvec-1);
# endif
			yyt = yystate->yystoff;
			if(yyt == yycrank && !yyfirst){  /* may not be any transitions */
				yyz = yystate->yyother;
				if(yyz == 0)break;
				if(yyz->yystoff == yycrank)break;
				}
#ifndef __cplusplus
			*yylastch++ = yych = input();
#else
			*yylastch++ = yych = lex_input();
#endif
#ifdef YYISARRAY
			if(yylastch > &yytext[YYLMAX]) {
				fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
				exit(1);
			}
#else
			if (yylastch >= &yytext[ yytextsz ]) {
				int	x = yylastch - yytext;

				yytextsz += YYTEXTSZINC;
				if (yytext == yy_tbuf) {
				    yytext = (char *) malloc(yytextsz);
				    memcpy(yytext, yy_tbuf, sizeof (yy_tbuf));
				}
				else
				    yytext = (char *) realloc(yytext, yytextsz);
				if (!yytext) {
				    fprintf(yyout,
					"Cannot realloc yytext\n");
				    exit(1);
				}
				yylastch = yytext + x;
			}
#endif
			yyfirst=0;
		tryagain:
# ifdef LEXDEBUG
			if(debug){
				fprintf(yyout,"char ");
				allprint(yych);
				putchar('\n');
				}
# endif
			yyr = yyt;
			if ( (uintptr_t)yyt > (uintptr_t)yycrank){
				yyt = yyr + yych;
				if (yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transitions */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					if(lsp > &yylstate[YYLMAX]) {
						fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
						exit(1);
					}
					goto contin;
					}
				}
# ifdef YYOPTIM
			else if((uintptr_t)yyt < (uintptr_t)yycrank) {	/* r < yycrank */
				yyt = yyr = yycrank+(yycrank-yyt);
# ifdef LEXDEBUG
				if(debug)fprintf(yyout,"compressed state\n");
# endif
				yyt = yyt + yych;
				if(yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transitions */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					if(lsp > &yylstate[YYLMAX]) {
						fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
						exit(1);
					}
					goto contin;
					}
				yyt = yyr + YYU(yymatch[yych]);
# ifdef LEXDEBUG
				if(debug){
					fprintf(yyout,"try fall back character ");
					allprint(YYU(yymatch[yych]));
					putchar('\n');
					}
# endif
				if(yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transition */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					if(lsp > &yylstate[YYLMAX]) {
						fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
						exit(1);
					}
					goto contin;
					}
				}
			if ((yystate = yystate->yyother) && (yyt= yystate->yystoff) != yycrank){
# ifdef LEXDEBUG
				if(debug)fprintf(yyout,"fall back to state %d\n",yystate-yysvec-1);
# endif
				goto tryagain;
				}
# endif
			else
				{unput(*--yylastch);break;}
		contin:
# ifdef LEXDEBUG
			if(debug){
				fprintf(yyout,"state %d char ",yystate-yysvec-1);
				allprint(yych);
				putchar('\n');
				}
# endif
			;
			}
# ifdef LEXDEBUG
		if(debug){
			fprintf(yyout,"stopped at %d with ",*(lsp-1)-yysvec-1);
			allprint(yych);
			putchar('\n');
			}
# endif
		while (lsp-- > yylstate){
			*yylastch-- = 0;
			if (*lsp != 0 && (yyfnd= (*lsp)->yystops) && *yyfnd > 0){
				yyolsp = lsp;
				if(yyextra[*yyfnd]){		/* must backup */
					while(yyback((*lsp)->yystops,-*yyfnd) != 1 && lsp > yylstate){
						lsp--;
						unput(*yylastch--);
						}
					}
				yyprevious = YYU(*yylastch);
				yylsp = lsp;
				yyleng = yylastch-yytext+1;
				yytext[yyleng] = 0;
# ifdef LEXDEBUG
				if(debug){
					fprintf(yyout,"\nmatch ");
					sprint(yytext);
					fprintf(yyout," action %d\n",*yyfnd);
					}
# endif
				return(*yyfnd++);
				}
			unput(*yylastch);
			}
		if (yytext[0] == 0  /* && feof(yyin) */)
			{
			yysptr=yysbuf;
			return(0);
			}
#ifndef __cplusplus
		yyprevious = yytext[0] = input();
		if (yyprevious>0)
			output(yyprevious);
#else
		yyprevious = yytext[0] = lex_input();
		if (yyprevious>0)
			lex_output(yyprevious);
#endif
		yylastch=yytext;
# ifdef LEXDEBUG
		if(debug)putchar('\n');
# endif
		}
	}
#if defined(__cplusplus) || defined(__STDC__)
int yyback(int *p, int m)
#else
yyback(p, m)
	int *p;
#endif
{
	if (p==0) return(0);
	while (*p) {
		if (*p++ == m)
			return(1);
	}
	return(0);
}
	/* the following are only used in the lex library */
#if defined(__cplusplus) || defined(__STDC__)
int yyinput(void)
#else
yyinput()
#endif
{
#ifndef __cplusplus
	return(input());
#else
	return(lex_input());
#endif
	}
#if defined(__cplusplus) || defined(__STDC__)
void yyoutput(int c)
#else
yyoutput(c)
  int c; 
#endif
{
#ifndef __cplusplus
	output(c);
#else
	lex_output(c);
#endif
	}
#if defined(__cplusplus) || defined(__STDC__)
void yyunput(int c)
#else
yyunput(c)
   int c; 
#endif
{
	unput(c);
	}
