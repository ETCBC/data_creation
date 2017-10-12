h26459
s 00016/00001/00106
d D 1.3 17/01/11 12:09:34 const 3 2
c Cored on malformed verse label
e
s 00005/00003/00102
d D 1.2 16/02/29 15:19:09 const 2 1
c Verse label " 1QS 01,01" appears garbled in 1QS1.pps
e
s 00105/00000/00000
d D 1.1 99/03/25 10:32:29 const 1 0
c date and time created 99/03/25 10:32:29 by const
e
u
U
f e 0
f m dapro/syn03/Locus.p
t
T
I 1
module Locus;

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
(* ident "%W% %E%" *)
E 2

#include <Error.h>
#include <Locus.h>


function Locus_Compare(l1, l2: LocusType):CompareType;
var
   cmp: CompareType;
begin
   cmp := VerseLabel_Compare(l1^.lab, l2^.lab);
   if cmp = equal then
      Locus_Compare := String_Compare(l1^.txt, l2^.txt)
   else
      Locus_Compare := cmp
end;


procedure Locus_Copy(l1, l2: LocusType);
begin
   VerseLabel_Copy(l1^.lab, l2^.lab);
   l1^.txt := l2^.txt
end;


procedure Locus_Create(var l: LocusType);
begin
   new(l);
   with l^ do begin
      VerseLabel_Clear(lab);
      txt := ''
   end
end;


procedure Locus_Delete(var l: LocusType);
begin
   dispose(l);
   l := nil
end;


procedure Locus_GetLabel(l: LocusType; var vl: VerseLabelType);
begin
   VerseLabel_Copy(vl, l^.lab)
end;


I 3
private
function verse_index(var l: VerseLabelType):VerseLabelIndexType;
var
   v: integer;
begin
   v := VerseLabel_VIndex(l);
   if v <> 0 then
      verse_index := v
   else begin
      message('syn03: ', l, ': Label does not have a verse part');
      Quit
   end
end;


E 3
procedure Locus_String(l: LocusType; var s: StringType);
var
   i: VerseLabelIndexType;
I 2
   v: VerseLabelIndexType;	(* Start of verse part *)
E 2
begin
   i := 1;
   s := '';
   with l^ do begin
D 2
      while (i < VERSELABEL_LENGTH) and (lab[i] = ' ') do
E 2
I 2
D 3
      v := VerseLabel_VIndex(lab);
E 3
I 3
      v := verse_index(lab);
E 3
      while (i < v) and (lab[i] = ' ') do
E 2
	 i := i + 1;
D 2
      while (i < VERSELABEL_LENGTH) and Letter(lab[i]) do begin
E 2
I 2
      while (i < v) and (lab[i] <> ' ') do begin
E 2
	 s := s + lab[i];
	 i := i + 1;
      end;
      s := s + ' ';
      while (i < VERSELABEL_LENGTH) and (lab[i] = ' ') do
	 i := i + 1;
      while (i < VERSELABEL_LENGTH) and (lab[i] = '0') do
	 i := i + 1;
      while (i < VERSELABEL_LENGTH) and Digit(lab[i]) do begin
	 s := s + lab[i];
	 i := i + 1;
      end;
      if (i < VERSELABEL_LENGTH) and (lab[i] = ',') then
	 i := i + 1;
      s := s + ':';
      while (i < VERSELABEL_LENGTH) and (lab[i] = '0') do
	 i := i + 1;
      while (i < VERSELABEL_LENGTH) and Digit(lab[i]) do begin
	 s := s + lab[i];
	 i := i + 1;
      end;
      if (i = VERSELABEL_LENGTH) and Digit(lab[i]) then
	 s := s + lab[i];
      s := s + ' ';
      if length(s) + length(txt) < STRING_SIZE then
	 s := s + txt
      else begin
	 write('syn03: cannot cope with strings of more than ');
	 writeln(STRING_SIZE:1, ' characters');
	 Quit
      end
   end
end;


procedure Locus_SetLabel(l: LocusType; var vl: VerseLabelType);
begin
   VerseLabel_Copy(l^.lab, vl)
end;


procedure Locus_SetText(l: LocusType; var t: StringType);
begin
   l^.txt := t
end;
E 1
