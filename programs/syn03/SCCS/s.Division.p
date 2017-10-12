h49879
s 00252/00000/00000
d D 1.1 99/02/16 14:13:26 const 1 0
c date and time created 99/02/16 14:13:26 by const
e
u
U
f e 0
f m dapro/syn03/Division.p
t
T
I 1
module Division;

(* ident "%Z%%M% %I% %G%" *)

#include <Division.h>
#include <Error.h>


procedure Division_Add(d: DivisionType; p: PatternType);
var
   aux: PatternNodePointer;
begin
   new(aux);
   with aux^ do begin
      Pattern_Create(pat);
      Pattern_Copy(pat, p);
      next := nil;
      prior := nil
   end;
   with d^ do begin
      if head = nil then begin
	 head := aux;
	 tail := aux;
	 length := length + 1
      end else begin
	 aux^.prior := tail;
	 tail^.next := aux;
	 tail := aux;
	 length := length + 1
      end;
      current := tail;
      size := size + Pattern_Size(p)
   end
end;


procedure Division_Atomise(d: DivisionType; l: AtomListType);
var
   a: AtomListType;
   p: PatternNodePointer;
begin
   AtomList_Create(a);
   AtomList_Clear(l);
   with d^ do begin
      p := head;
      while p <> nil do begin
	 Pattern_Atomise(p^.pat, a);
	 AtomList_Cat(l, a);
	 p := p^.next
      end
   end;
   AtomList_Delete(a)
end;


procedure Division_Create(var d: DivisionType);
begin
   new(d);
   with d^ do begin
      head := nil;
      current := nil;
      tail := nil;
      size := 0;
      length := 0
   end
end;


procedure Division_Cut(d: DivisionType);
var
   aux: PatternNodePointer;
begin
   with d^ do begin
      aux := current;
      if aux <> nil then begin
	 tail := aux^.prior;
	 if tail <> nil then
	    tail^.next := nil
	 else
	    head := nil
      end;
      while aux <> nil do begin
	 current := aux^.next;
	 size := size - Pattern_Size(aux^.pat);
	 length := length - 1;
	 Pattern_Delete(aux^.pat);
	 dispose(aux);
	 aux := current
      end;
      current := tail
   end
end;


procedure Division_Delete(var d: DivisionType);
var
   aux: PatternNodePointer;
begin
   with d^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Pattern_Delete(aux^.pat);
	 dispose(aux)
      end;
   dispose(d);
   d := nil
end;


function Division_End(d: DivisionType):boolean;
begin
   Division_End := d^.current = nil
end;


function Division_Find(d: DivisionType; p: PatternType):boolean;
var
   found: boolean;
begin
   found := false;
   with d^ do begin
      current := head;
      while (current <> nil) and not found do begin
	 if Pattern_Compare(current^.pat, p) = equal then
	    found := true
	 else
	    current := current^.next
      end
   end;
   Division_Find := found
end;


procedure Division_First(d: DivisionType);
begin
   d^.current := d^.head
end;


function Division_Get(d: DivisionType; p: PatternType):boolean;
begin
   with d^ do
      if current = nil then
	 Division_Get := false
      else begin
	 Pattern_Copy(p, current^.pat);
	 current := current^.next;
	 Division_Get := true
      end
end;


procedure Division_GetLabel(d: DivisionType; var v: VerseLabelType);
begin
   VerseLabel_Copy(v, d^.lab)
end;


procedure Division_Stretch(d: DivisionType);
var
   aux: PatternNodePointer;
begin
   with d^ do begin
      aux := current^.next;
      while aux <> nil do begin
	 Pattern_Join(current^.pat, aux^.pat);
	 Pattern_Delete(aux^.pat);
	 length := length - 1;
	 aux := aux^.next
      end;
      aux := tail;
      while aux <> current do begin
	 tail := aux^.prior;
	 dispose(aux);
	 aux := tail
      end;
      Pattern_First(current^.pat);
      Pattern_Stretch(current^.pat);
      tail^.next := nil
   end
end;


procedure Division_Last(d: DivisionType);
begin
   with d^ do
      current := tail
end;


function Division_Length(d: DivisionType):integer;
begin
   Division_Length := d^.length
end;


procedure Division_Next(d: DivisionType);
begin
   with d^ do
      if current <> nil then
	 current := current^.next
end;


procedure Division_Prior(d: DivisionType);
begin
   with d^ do
      if current <> nil then
	 current := current^.prior
end;


procedure Division_Retrieve(d: DivisionType; p: PatternType);
begin
   Pattern_Copy(p, d^.current^.pat)
end;


procedure Division_SetLabel(d: DivisionType; var v: VerseLabelType);
begin
   VerseLabel_Copy(d^.lab, v)
end;


function Division_Size(d: DivisionType):integer;
begin
   Division_Size := d^.size
end;


procedure Division_Split(d: DivisionType; n: integer);
var
   aux: PatternNodePointer;
begin
   with d^ do begin
      if Pattern_Size(current^.pat) < n then
	 Panic('Division_Split');
      if Pattern_Size(current^.pat) > n then begin
	 new(aux);
	 Pattern_Create(aux^.pat);
	 Pattern_Split(current^.pat, aux^.pat, n);
	 aux^.next := current^.next;
	 aux^.prior := current;
	 current^.next := aux;
	 if current = tail then
	    tail := aux;
	 current := aux;
	 length := length + 1
      end
   end
end;
E 1
