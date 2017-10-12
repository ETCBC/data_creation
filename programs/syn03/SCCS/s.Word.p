h23155
s 00061/00000/00000
d D 1.1 99/02/16 14:13:53 const 1 0
c date and time created 99/02/16 14:13:53 by const
e
u
U
f e 0
f m dapro/syn03/Word.p
t
T
I 1
module Word_module;

(* ident "%Z%%M% %I% %G%" *)

#include <Word.h>

const
   UNDEFINED = -1;

procedure Word_Copy(var w1, w2: WordType);
var
   f: FeatureType;
begin
   Lexeme_Copy(w1^.lex, w2^.lex);
   for f := Feature_First to Feature_Last do
      w1^.val[f] := w2^.val[f]
end;


procedure Word_Create(var w: WordType);
var
   f: FeatureType;
begin
   new(w);
   with w^ do begin
      Lexeme_Clear(lex);
      for f := Feature_First to Feature_Last do
	 val[f] := UNDEFINED
   end
end;


procedure Word_Delete(var w: WordType);
begin
   dispose(w);
   w := nil
end;


procedure Word_GetFeature(w: WordType; f: FeatureType; var v: integer);
begin
   v := w^.val[f]
end;


procedure Word_GetLexeme(w: WordType; var l: LexemeType);
begin
   Lexeme_Copy(l, w^.lex)
end;


procedure Word_SetFeature(var w: WordType; f: FeatureType; v: integer);
begin
   w^.val[f] := v
end;


procedure Word_SetLexeme(var w: WordType; l: LexemeType);
begin
   Lexeme_Copy(w^.lex, l)
end;
E 1
