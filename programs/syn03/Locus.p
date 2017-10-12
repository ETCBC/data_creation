module Locus;

(* ident "@(#)dapro/syn03/Locus.p	1.3 17/01/11" *)

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


procedure Locus_String(l: LocusType; var s: StringType);
var
   i: VerseLabelIndexType;
   v: VerseLabelIndexType;	(* Start of verse part *)
begin
   i := 1;
   s := '';
   with l^ do begin
      v := verse_index(lab);
      while (i < v) and (lab[i] = ' ') do
	 i := i + 1;
      while (i < v) and (lab[i] <> ' ') do begin
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
