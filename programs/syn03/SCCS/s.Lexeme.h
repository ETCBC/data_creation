h62068
s 00034/00000/00000
d D 1.1 99/02/16 14:13:38 const 1 0
c date and time created 99/02/16 14:13:38 by const
e
u
U
f e 0
f m dapro/syn03/Lexeme.h
t
T
I 1
#ifndef	LEXEME_H
#define	LEXEME_H

(* ident "%Z%%M% %I% %G%" *)

#include	<Compare.h>

const
   LEXEME_LENGTH = 18;
type
   LexemeIndexType =
      1 .. LEXEME_LENGTH;
   LexemeType =
      packed array [LexemeIndexType] of char;

procedure Lexeme_Clear(var l: LexemeType);
extern;

function  Lexeme_Compare(var l1, l2: LexemeType):CompareType;
extern;

procedure Lexeme_Copy(var l1, l2: LexemeType);
extern;

function  Lexeme_Empty(var l: LexemeType):boolean;
extern;

function  Lexeme_Read(var f: text; var l: LexemeType):boolean;
extern;

procedure Lexeme_Write(var f: text; var l: LexemeType);
extern;

#endif	(* not LEXEME_H *)
E 1
