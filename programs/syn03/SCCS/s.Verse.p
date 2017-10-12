h52663
s 00141/00000/00000
d D 1.1 99/02/16 14:13:49 const 1 0
c date and time created 99/02/16 14:13:49 by const
e
u
U
f e 0
f m dapro/syn03/Verse.p
t
T
I 1
module Verse;

(* ident "%Z%%M% %I% %G%" *)

#include <Error.h>
#include <Verse.h>


procedure Verse_Add(v: VerseType; w: WordType);
var
   aux: WordNodePointer;
begin
   new(aux);
   with aux^ do begin
      Word_Create(wrd);
      Word_Copy(wrd, w);
      next := nil;
      prior := nil
   end;
   with v^ do begin
      if head = nil then
	 begin
	    head := aux;
	    tail := aux
	 end
      else
	 begin
	    tail^.next := aux;
	    aux^.prior := tail;
	    tail := aux
	 end;
      current := aux;
      length := length + 1
   end
end;


procedure Verse_Clear(v: VerseType);
var
   p: WordNodePointer;
begin
   with v^ do begin
      while head <> nil do begin
	 p := head;
	 head := head^.next;
	 Word_Delete(p^.wrd);
	 dispose(p)
      end;
      current := nil;
      tail := nil;
      VerseLabel_Clear(lab);
      length := 0
   end
end;


procedure Verse_Create(var v: VerseType);
begin
   new(v);
   with v^ do begin
      head := nil;
      current := nil;
      tail := nil;
      VerseLabel_Clear(lab);
      length := 0
   end
end;


procedure Verse_Delete(var v: VerseType);
var
   aux: WordNodePointer;
begin
   with v^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Word_Delete(aux^.wrd);
	 dispose(aux)
      end;
   dispose(v);
   v := nil
end;


function Verse_End(v: VerseType):boolean;
begin
   Verse_End := v^.current = nil
end;


procedure Verse_First(v: VerseType);
begin
   v^.current := v^.head
end;


procedure Verse_GetLabel(v: VerseType; var l: VerseLabelType);
begin
   VerseLabel_Copy(l, v^.lab)
end;


function Verse_Length(v: VerseType):integer;
begin
   Verse_Length := v^.length
end;


procedure Verse_Next(v: VerseType);
begin
   with v^ do
      if current <> nil then
	 current := current^.next
end;


procedure Verse_Retrieve(v: VerseType; w: WordType);
begin
   with v^ do
      if current <> nil then
	 Word_Copy(w, current^.wrd)
      else
	 Panic('Verse_Retrieve')
end;


procedure Verse_SetLabel(v: VerseType; l: VerseLabelType);
begin
   VerseLabel_Copy(v^.lab, l)
end;


procedure Verse_Update(v: VerseType; w: WordType);
begin
   with v^ do
      if current <> nil then
	 Word_Copy(current^.wrd, w)
      else
	 Panic('Verse_Update')
end;
E 1
