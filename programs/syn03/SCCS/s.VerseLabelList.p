h56148
s 00155/00000/00000
d D 1.1 99/02/16 14:13:52 const 1 0
c date and time created 99/02/16 14:13:52 by const
e
u
U
f e 0
f m dapro/syn03/VerseLabelList.p
t
T
I 1
module VerseLabelList;

(* ident "%Z%%M% %I% %G%" *)

#include <VerseLabelList.h>


procedure VerseLabelList_Add(l: VerseLabelListType; v: VerseLabelType);
var
   aux: VerseLabelNodePointer;
   found: boolean;
begin
   new(aux);
   VerseLabel_Copy(aux^.value, v);
   with l^ do begin
      current := tail;
      found := false;
      while (current <> nil) and not found do
	 if VerseLabel_Compare(current^.value, v) <> greater then
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


procedure VerseLabelList_Copy(l1, l2: VerseLabelListType);
var
   aux1, aux2: VerseLabelNodePointer;
begin
   aux1 := l1^.head;
   aux2 := l2^.head;
   while aux2 <> nil do begin
      if aux1 = nil then begin
	 new(aux1);
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
      aux1^.value := aux2^.value;
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
	 dispose(aux1);
	 aux1 := current
      end;
      current := head
   end;
   l1^.length := l2^.length
end;


procedure VerseLabelList_Create(var l: VerseLabelListType);
begin
   new(l);
   with l^ do begin
      head := nil;
      current := nil;
      tail := nil;
      length := 0
   end
end;


procedure VerseLabelList_Delete(var l: VerseLabelListType);
var
   aux: VerseLabelNodePointer;
begin
   with l^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 dispose(aux)
      end;
   dispose(l);
   l := nil
end;


function VerseLabelList_Length(l: VerseLabelListType):integer;
begin
   VerseLabelList_Length := l^.length
end;


procedure VerseLabelList_Merge(l1, l2: VerseLabelListType);
var
   aux1, aux2: VerseLabelNodePointer;
begin
   aux1 := l1^.head;
   aux2 := l2^.head;
   while (aux1 <> nil) and (aux2 <> nil) do begin
      if VerseLabel_Compare(aux1^.value, aux2^.value) <> greater then
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
E 1
