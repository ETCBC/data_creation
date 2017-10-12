module CondSetList;

(* ident "@(#)dapro/syn03/CondSetList.p 1.1 02/16/99" *)

#include <CondSetList.h>


procedure CondSetList_Add(l: CondSetListType; s: CondSetType);
var
   aux: CondSetNodePointer;
begin
   new(aux);
   with aux^ do begin
      CondSet_Create(cs);
      CondSet_Copy(cs, s);
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
      size := size + CondSet_Size(s);
      length := length + 1
   end
end;


procedure CondSetList_Clear(l: CondSetListType);
var
   aux: CondSetNodePointer;
begin
   with l^ do begin
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 CondSet_Delete(aux^.cs);
	 dispose(aux)
      end;
      current := nil;
      tail := nil;
      size := 0;
      length := 0
   end
end;


procedure CondSetList_Copy(l1, l2: CondSetListType);
var
   aux1, aux2: CondSetNodePointer;
begin
   aux1 := l1^.head;
   aux2 := l2^.head;
   while aux2 <> nil do begin
      if aux1 = nil then begin
	 new(aux1);
	 CondSet_Create(aux1^.cs);
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
      CondSet_Copy(aux1^.cs, aux2^.cs);
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
	 CondSet_Delete(aux1^.cs);
	 dispose(aux1);
	 aux1 := current
      end;
      current := head
   end;
   l1^.size := l2^.size;
   l1^.length := l2^.length
end;


procedure CondSetList_Create(var l: CondSetListType);
begin
   new(l);
   with l^ do begin
      head := nil;
      current := nil;
      tail := nil;
      size := 0;
      length := 0
   end
end;


function CondSetList_Current(l: CondSetListType):CondSetType;
begin
   with l^ do begin
      if current = nil then
	 CondSetList_Current := nil
      else
	 CondSetList_Current := current^.cs
   end
end;


procedure CondSetList_Cut(l: CondSetListType);
var
   aux: CondSetNodePointer;
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
	 size := size - CondSet_Size(aux^.cs);
	 length := length - 1;
	 CondSet_Delete(aux^.cs);
	 dispose(aux);
	 aux := current
      end;
      current := head
   end
end;


procedure CondSetList_Delete(var l: CondSetListType);
var
   aux: CondSetNodePointer;
begin
   with l^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 CondSet_Delete(aux^.cs);
	 dispose(aux)
      end;
   dispose(l);
   l := nil
end;


procedure CondSetList_First(l: CondSetListType);
begin
   l^.current := l^.head
end;


function CondSetList_Get(l: CondSetListType; var s: CondSetType):boolean;
begin
   with l^ do
      if current = nil then
	 CondSetList_Get := false
      else begin
	 CondSet_Copy(s, current^.cs);
	 current := current^.next;
	 CondSetList_Get := true
      end
end;


procedure CondSetList_Join(l1, l2: CondSetListType);
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
   l1^.size := l1^.size + l2^.size;
   l2^.head := nil;
   l2^.current := nil;
   l2^.tail := nil;
   l2^.length := 0;
   l2^.size := 0
end;


procedure CondSetList_Last(l: CondSetListType);
begin
   with l^ do
      current := tail
end;


procedure CondSetList_Next(l: CondSetListType);
begin
   with l^ do
      if current <> nil then
	 current := current^.next
end;


procedure CondSetList_Retrieve(l: CondSetListType; var s: CondSetType);
begin
   CondSet_Copy(s, l^.current^.cs)
end;


function CondSetList_Size(l: CondSetListType):integer;
begin
   CondSetList_Size := l^.size
end;


procedure CondSetList_Split(l1, l2: CondSetListType; n: integer);
(* precondition: 0 < n < length(l1) *)
var
   s: integer;
   p: CondSetNodePointer;
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
      p := head;
      length := n;
      s := CondSet_Size(p^.cs);
      while n > 1 do begin
	 p := p^.next;
	 s := s + CondSet_Size(p^.cs);
	 n := n - 1
      end
   end;
   with l2^ do begin
      head := p^.next;
      head^.prior := nil;
      current := head;
      tail := l1^.tail;
      size := l1^.size - s
   end;
   with l1^ do begin
      current := head;
      tail := p;
      tail^.next := nil;
      size := s
   end
end;


function CondSetList_Subset(l1, l2: CondSetListType):boolean;
var
   pass: boolean;
   aux1, aux2: CondSetNodePointer;
begin
   pass := true;
   aux1 := l1^.head;
   aux2 := l2^.head;
   while pass and (aux1 <> nil) and (aux2 <> nil) do begin
      if not CondSet_Subset(aux1^.cs, aux2^.cs) then
	 pass := false;
      aux1 := aux1^.next;
      aux2 := aux2^.next
   end;
   CondSetList_Subset := (aux1 = aux2) and pass
end;


procedure CondSetList_Update(l: CondSetListType; s: CondSetType);
begin
   with l^ do begin
      size := size + CondSet_Size(s) - CondSet_Size(current^.cs);
      CondSet_Copy(current^.cs, s)
   end
end;
