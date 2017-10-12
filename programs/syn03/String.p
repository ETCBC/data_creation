module String_module;

(* ident "@(#)dapro/syn03/String.p	1.3 15/06/19" *)

#include <String.h>


function String_Compare(var s1, s2: StringType):CompareType;
begin
   if s1 < s2 then
      String_Compare := less
   else if s1 > s2 then
      String_Compare := greater
   else
      String_Compare := equal
end;


function String_End(var s: StringType):char;
begin
   if length(s) = 0 then
      String_End := chr(0)
   else
      String_End := s[length(s)]
end;


procedure String_Pad(var s: StringType);
var
   i: integer;
begin
   for i := length(s) + 1 to STRING_SIZE do
      s[i] := ' '
end;
