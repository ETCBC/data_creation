h07889
s 00005/00002/00029
d D 1.3 15/06/19 12:59:00 const 3 2
c SIGTRAP in String_End
e
s 00011/00000/00020
d D 1.2 99/03/25 10:38:46 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00020/00000/00000
d D 1.1 99/02/16 14:13:45 const 1 0
c date and time created 99/02/16 14:13:45 by const
e
u
U
f e 0
f m dapro/syn03/String.p
t
T
I 1
module String_module;

D 3
(* ident "%Z%%M% %I% %G%" *)
E 3
I 3
(* ident "%W% %E%" *)
E 3

#include <String.h>


I 2
function String_Compare(var s1, s2: StringType):CompareType;
begin
   if s1 < s2 then
      String_Compare := less
   else if s1 > s2 then
      String_Compare := greater
   else
      String_Compare := equal
end;


E 2
function String_End(var s: StringType):char;
begin
D 3
   String_End := s[length(s)]
E 3
I 3
   if length(s) = 0 then
      String_End := chr(0)
   else
      String_End := s[length(s)]
E 3
end;


procedure String_Pad(var s: StringType);
var
   i: integer;
begin
   for i := length(s) + 1 to STRING_SIZE do
      s[i] := ' '
end;
E 1
