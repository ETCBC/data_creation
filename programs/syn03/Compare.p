module Compare;

(* ident "@(#)dapro/syn03/Compare.p 1.2 03/25/99" *)

#include	<Compare.h>


function Compare(i1, i2: integer):CompareType;
begin
   if i1 < i2 then
      Compare := less
   else if i1 > i2 then
      Compare := greater
   else
      Compare := equal
end;


function Digit(c: char):boolean;
begin
   Digit := c in ['0'..'9']
end;


function Letter(c: char):boolean;
begin
   Letter := c in ['A'..'Z']
end;


function Space(c: char):boolean;
begin
   Space := (c = chr(32)) or (c = chr(9))
end;
