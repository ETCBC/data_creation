h04266
s 00039/00000/00000
d D 1.1 99/02/16 14:13:52 const 1 0
c date and time created 99/02/16 14:13:52 by const
e
u
U
f e 0
f m dapro/syn03/Word.h
t
T
I 1
#ifndef	WORD_H
#define	WORD_H

(* ident "%Z%%M% %I% %G%" *)

#include <Feature.h>
#include <Lexeme.h>

type
   WordInstance =
      record
	 lex: LexemeType;
	 val: array [FeatureType] of integer
      end;
   WordType =
      ^ WordInstance;

procedure Word_Copy(var w1, w2: WordType);
extern;

procedure Word_Create(var w: WordType);
extern;

procedure Word_Delete(var w: WordType);
extern;

procedure Word_GetFeature(w: WordType; f: FeatureType; var v: integer);
extern;

procedure Word_GetLexeme(w: WordType; var l: LexemeType);
extern;

procedure Word_SetFeature(var w: WordType; f: FeatureType; v: integer);
extern;

procedure Word_SetLexeme(var w: WordType; l: LexemeType);
extern;

#endif	(* not WORD_H *)
E 1
