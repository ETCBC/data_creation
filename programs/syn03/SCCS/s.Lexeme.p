h42522
s 00075/00000/00000
d D 1.1 99/02/16 14:13:38 const 1 0
c date and time created 99/02/16 14:13:38 by const
e
u
U
f e 0
f m dapro/syn03/Lexeme.p
t
T
I 1
module Lexeme;

(* ident "%Z%%M% %I% %G%" *)

#include <Lexeme.h>


procedure Lexeme_Clear(var l: LexemeType);
var
   i: LexemeIndexType;
begin
   for i := 1 to LEXEME_LENGTH do
      l[i] := ' '
end;


function Lexeme_Compare(var l1, l2: LexemeType):CompareType;
begin
   if l1 < l2 then
      Lexeme_Compare := less
   else if l1 > l2 then
      Lexeme_Compare := greater
   else
      Lexeme_Compare := equal
end;


procedure Lexeme_Copy(var l1, l2: LexemeType);
var
   i: LexemeIndexType;
begin
   for i := 1 to LEXEME_LENGTH do
      l1[i] := l2[i]
end;


function Lexeme_Empty(var l: LexemeType):boolean;
var
   i: integer;
   empty: boolean;
begin
   i := 0;
   empty := true;
   while (i < LEXEME_LENGTH) and empty do begin
      i := i + 1;
      if l[i] <> ' ' then
	 empty := false
   end;
   Lexeme_Empty := empty
end;


function Lexeme_Read(var f: text; var l: LexemeType):boolean;
var
   i: LexemeIndexType;
begin
   Lexeme_Read := true;
   for i := 1 to LEXEME_LENGTH do
      if eof(f) then
	 Lexeme_Read := false
      else
      if eoln(f) then
	 Lexeme_Read := false
      else
	 read(f, l[i]) (* safe *)
end;


procedure Lexeme_Write(var f: text; var l: LexemeType);
var
   i: LexemeIndexType;
begin
   for i := 1 to LEXEME_LENGTH do
      write(f, l[i])
end;
E 1
