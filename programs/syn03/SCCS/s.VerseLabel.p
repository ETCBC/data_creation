h42444
s 00007/00003/00080
d D 1.4 17/01/11 12:09:34 const 4 3
c Cored on malformed verse label
e
s 00002/00001/00081
d D 1.3 16/04/12 17:05:52 const 3 2
c Verse label " IKON03,01" appeared garbled in ikoningen03.pps.
e
s 00015/00001/00067
d D 1.2 16/02/29 15:19:09 const 2 1
c Verse label " 1QS 01,01" appears garbled in 1QS1.pps
e
s 00068/00000/00000
d D 1.1 99/02/16 14:13:50 const 1 0
c date and time created 99/02/16 14:13:50 by const
e
u
U
f e 0
f m dapro/syn03/VerseLabel.p
t
T
I 1
module VerseLabel;

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
(* ident "%W% %E%" *)
E 2

#include <VerseLabel.h>


procedure VerseLabel_Clear(var v: VerseLabelType);
var
   i: VerseLabelIndexType;
begin
   for i := 1 to VERSELABEL_LENGTH do
      v[i] := ' '
end;


function VerseLabel_Compare(var v1, v2: VerseLabelType):CompareType;
begin
   if v1 < v2 then
      VerseLabel_Compare := less
   else
   if v1 > v2 then
      VerseLabel_Compare := greater
   else
      VerseLabel_Compare := equal
end;


procedure VerseLabel_Copy(var v1, v2: VerseLabelType);
begin
   v1 := v2
end;


function VerseLabel_Empty(var v: VerseLabelType):boolean;
var
   i: VerseLabelIndexType;
begin
   i := 1;
   while (i < VERSELABEL_LENGTH) and (v[i] = ' ') do
      i := i + 1;
   VerseLabel_Empty := v[i] = ' '
end;


function VerseLabel_Read(var f: text; var v: VerseLabelType):boolean;
var
   i: VerseLabelIndexType;
begin
   VerseLabel_Read := true;
   for i := 1 to VERSELABEL_LENGTH do
      if eof(f) then
	 VerseLabel_Read := false
      else
      if eoln(f) then
	 VerseLabel_Read := false
      else
	 read(f, v[i]) (* safe *)
end;

I 2

function VerseLabel_VIndex(var v: VerseLabelType):integer;
(* Return the index where the verse part of the label starts *)
var
   i: VerseLabelIndexType;
begin
   i := VERSELABEL_LENGTH;
   while (i > 1) and (v[i] <> ',') do
      i := i - 1;
I 3
D 4
   i := i - 1;
E 3
   while (i > 1) and Digit(v[i]) do
E 4
I 4
   if i = 1 then
      VerseLabel_VIndex := 0
   else begin
E 4
      i := i - 1;
D 3
   VerseLabel_VIndex := i
E 3
I 3
D 4
   VerseLabel_VIndex := i + 1
E 4
I 4
      while (i > 1) and Digit(v[i]) do
	 i := i - 1;
      VerseLabel_VIndex := i + 1
   end
E 4
E 3
end;

E 2

procedure VerseLabel_Write(var f: text; var v: VerseLabelType);
var
   i: VerseLabelIndexType;
begin
   for i := 1 to VERSELABEL_LENGTH do
      write(f, v[i])
end;
E 1
