module VerseLabel;

(* ident "@(#)dapro/syn03/VerseLabel.p	1.4 17/01/11" *)

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


function VerseLabel_VIndex(var v: VerseLabelType):integer;
(* Return the index where the verse part of the label starts *)
var
   i: VerseLabelIndexType;
begin
   i := VERSELABEL_LENGTH;
   while (i > 1) and (v[i] <> ',') do
      i := i - 1;
   if i = 1 then
      VerseLabel_VIndex := 0
   else begin
      i := i - 1;
      while (i > 1) and Digit(v[i]) do
	 i := i - 1;
      VerseLabel_VIndex := i + 1
   end
end;


procedure VerseLabel_Write(var f: text; var v: VerseLabelType);
var
   i: VerseLabelIndexType;
begin
   for i := 1 to VERSELABEL_LENGTH do
      write(f, v[i])
end;
