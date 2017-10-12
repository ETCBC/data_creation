h55212
s 00006/00000/00028
d D 1.2 99/03/25 10:38:36 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00028/00000/00000
d D 1.1 99/02/16 14:13:23 const 1 0
c date and time created 99/02/16 14:13:23 by const
e
u
U
f e 0
f m dapro/syn03/Compare.p
t
T
I 1
module Compare;

(* ident "%Z%%M% %I% %G%" *)

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


I 2
function Letter(c: char):boolean;
begin
   Letter := c in ['A'..'Z']
end;


E 2
function Space(c: char):boolean;
begin
   Space := (c = chr(32)) or (c = chr(9))
end;
E 1
