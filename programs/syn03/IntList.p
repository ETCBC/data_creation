module IntList;

(* ident "@(#)dapro/syn03/IntList.p 1.1 02/16/99" *)

#include <IntList.h>


procedure IntList_Add(l: IntListType; i: integer);
var
   aux: IntNodePointer;
begin
   new(aux);
   with aux^ do begin
      value := i;
      next := nil;
      prior := nil
   end;
   with l^ do begin
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


procedure IntList_Clear(l: IntListType);
var
   aux: IntNodePointer;
begin
   with l^ do begin
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 dispose(aux)
      end;
      current := nil;
      tail := nil;
      length := 0
   end
end;


function IntList_Compare(l1, l2: IntListType):CompareType;
var
   cmp: CompareType;
   aux1, aux2: IntNodePointer;
begin
   aux1 := l1^.head;
   aux2 := l2^.head;
   repeat
      if aux1 = nil then
	 if aux2 = nil then
	    cmp := equal
	 else
	    cmp := less
      else
	 if aux2 = nil then
	    cmp := greater
	 else begin
	    cmp := Compare(aux1^.value, aux2^.value);
	    aux1 := aux1^.next;
	    aux2 := aux2^.next
	 end
   until (cmp <> equal) or (aux1 = aux2);
   IntList_Compare := cmp
end;


procedure IntList_Copy(l1, l2: IntListType);
var
   aux1, aux2: IntNodePointer;
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


procedure IntList_Create(var l: IntListType);
begin
   new(l);
   with l^ do begin
      head := nil;
      current := nil;
      tail := nil;
      length := 0
   end
end;


function IntList_Current(l: IntListType):integer;
begin
   with l^ do begin
      if current = nil then
	 IntList_Current := 0
      else
	 IntList_Current := current^.value
   end
end;


procedure IntList_Cut(l: IntListType);
var
   aux: IntNodePointer;
begin
   with l^ do begin
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
	 length := length - 1;
	 dispose(aux);
	 aux := current
      end;
      current := head
   end
end;


procedure IntList_Delete(var l: IntListType);
var
   aux: IntNodePointer;
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


function IntList_End(l: IntListType):boolean;
begin
   IntList_End := l^.current = nil
end;


procedure IntList_First(l: IntListType);
begin
   l^.current := l^.head
end;


function IntList_Get(l: IntListType; var i: integer):boolean;
begin
   with l^ do
      if current = nil then
	 IntList_Get := false
      else begin
	 i := current^.value;
	 current := current^.next;
	 IntList_Get := true
      end
end;


function IntList_Head(l: IntListType):integer;
begin
   IntList_Head := l^.head^.value
end;


procedure IntList_Join(l1, l2: IntListType);
begin
   if l1^.head = nil then
      l1^.head := l2^.head
   else begin
      if l2^.head <> nil then
	 l2^.head^.prior := l1^.tail;
      l1^.tail^.next := l2^.head
   end;
   l1^.current := l1^.head;
   l1^.tail := l2^.tail;
   l1^.length := l1^.length + l2^.length;
   l2^.head := nil;
   l2^.current := nil;
   l2^.tail := nil;
   l2^.length := 0
end;


procedure IntList_Last(l: IntListType);
begin
   l^.current := l^.tail
end;


function IntList_Length(l: IntListType):integer;
begin
   IntList_Length := l^.length
end;


function IntList_Listed(l: IntListType; i: integer):boolean;
var
   aux: IntNodePointer;
   found: boolean;
begin
   aux := l^.head;
   found := false;
   while (aux <> nil) and not found do begin
      found := aux^.value = i;
      aux := aux^.next
   end;
   IntList_Listed := found
end;


procedure IntList_Next(l: IntListType);
begin
   with l^ do
      if current <> nil then
	 current := current^.next
end;


procedure IntList_Retrieve(l: IntListType; var i: integer);
begin
   i := l^.current^.value
end;


procedure IntList_Split(l1, l2: IntListType; n: integer);
(* precondition: 0 < n < length(l1) *)
var
   p: IntNodePointer;
begin
   with l2^ do begin
      length := l1^.length - n;
      while head <> nil do begin
	 p := head;
	 head := head^.next;
	 dispose(p)
      end
   end;
   with l1^ do begin
      length := n;
      p := head;
      while n > 1 do begin
	 p := p^.next;
	 n := n - 1
      end
   end;
   with l2^ do begin
      head := p^.next;
      head^.prior := nil;
      current := head;
      tail := l1^.tail
   end;
   with l1^ do begin
      current := head;
      tail := p;
      tail^.next := nil;
   end
end;


procedure IntList_Update(l: IntListType; i: integer);
begin
   l^.current^.value := i
end;


function  IntList_Bottom(l: IntListType):boolean;
begin
   with l^ do
      IntList_Bottom := (current = tail) and (length > 0)
end;
