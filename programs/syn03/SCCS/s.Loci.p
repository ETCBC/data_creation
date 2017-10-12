h19096
s 00191/00000/00000
d D 1.1 99/03/25 10:32:27 const 1 0
c date and time created 99/03/25 10:32:27 by const
e
u
U
f e 0
f m dapro/syn03/Loci.p
t
T
I 1
module Loci;

(* ident "%Z%%M% %I% %G%" *)

#include <Loci.h>


procedure Loci_Add(l: LociType; p: LocusType);
var
   aux: LocusNodePointer;
   found: boolean;
begin
   new(aux);
   with aux^ do begin
      Locus_Create(value);
      Locus_Copy(value, p)
   end;
   with l^ do begin
      current := tail;
      found := false;
      while (current <> nil) and not found do
	 if Locus_Compare(current^.value, p) <> greater then
	    found := true
	 else
	    current := current^.prior;
      if found then begin
	 aux^.next := current^.next;
	 current^.next := aux
      end else begin
	 aux^.next := head;
	 head := aux
      end;
      if current <> tail then
	 aux^.next^.prior := aux
      else begin
	 aux^.next := nil;
	 tail := aux
      end;
      aux^.prior := current;
      current := aux;
      length := length + 1
   end
end;


procedure Loci_Copy(l1, l2: LociType);
var
   aux1, aux2: LocusNodePointer;
begin
   aux1 := l1^.head;
   aux2 := l2^.head;
   while aux2 <> nil do begin
      if aux1 = nil then begin
	 new(aux1);
	 Locus_Create(aux1^.value);
	 with l1^ do begin
	    if head = nil then
	       begin
		  head := aux1;
		  aux1^.prior := nil;
	       end
	    else
	       begin
		  tail^.next := aux1;
		  aux1^.prior := tail;
	       end;
	    aux1^.next := nil;
	    tail := aux1
	 end
      end;
      Locus_Copy(aux1^.value, aux2^.value);
      aux1 := aux1^.next;
      aux2 := aux2^.next
   end;
   with l1^ do begin
      if aux1 <> nil then begin
	 tail := aux1^.prior;
	 tail^.next := nil
      end;
      while aux1 <> nil do begin
	 current := aux1^.next;
	 Locus_Delete(aux1^.value);
	 dispose(aux1);
	 aux1 := current
      end;
      current := head
   end;
   l1^.length := l2^.length
end;


procedure Loci_Create(var l: LociType);
begin
   new(l);
   with l^ do begin
      head := nil;
      current := nil;
      tail := nil;
      length := 0
   end
end;


function Loci_Current(l: LociType):LocusType;
begin
   with l^ do
      if current = nil then
	 Loci_Current := nil
      else
	 Loci_Current := current^.value
end;


procedure Loci_Delete(var l: LociType);
var
   aux: LocusNodePointer;
begin
   with l^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Locus_Delete(aux^.value);
	 dispose(aux)
      end;
   dispose(l);
   l := nil
end;


function Loci_End(l: LociType):boolean;
begin
   Loci_End := l^.current = nil
end;


procedure Loci_First(l: LociType);
begin
   l^.current := l^.head
end;


function Loci_Length(l: LociType):integer;
begin
   Loci_Length := l^.length
end;


procedure Loci_Merge(l1, l2: LociType);
var
   aux1, aux2: LocusNodePointer;
begin
   aux1 := l1^.head;
   aux2 := l2^.head;
   while (aux1 <> nil) and (aux2 <> nil) do begin
      if Locus_Compare(aux1^.value, aux2^.value) <> greater then
	 aux1 := aux1^.next
      else begin (* insert aux2 before aux1 *)
	 l2^.current := aux2^.next;
	 if aux1 = l1^.head then
	    l1^.head := aux2
	 else
	    aux1^.prior^.next := aux2;
	 aux2^.prior := aux1^.prior;
	 aux1^.prior := aux2;
	 aux2^.next := aux1;
	 aux2 := l2^.current
      end
   end;
   if (aux1 = nil) and (aux2 <> nil) then begin
      if l1^.tail = nil then
	 l1^.head := aux2
      else
	 l1^.tail^.next := aux2;
      aux2^.prior := l1^.tail;
      l1^.tail := l2^.tail
   end;
   l1^.current := l1^.head;
   l1^.length := l1^.length + l2^.length;
   l2^.head := nil;
   l2^.current := nil;
   l2^.tail := nil;
   l2^.length := 0
end;


procedure Loci_Next(l: LociType);
begin
   with l^ do
      if current <> nil then
	 current := current^.next
end;
E 1
