#ifndef	LEXEME_H
#define	LEXEME_H

(* ident "@(#)dapro/syn03/Lexeme.h 1.1 02/16/99" *)

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
