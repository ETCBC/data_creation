#ifndef	WORD_H
#define	WORD_H

(* ident "@(#)dapro/syn03/Word.h 1.1 02/16/99" *)

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
