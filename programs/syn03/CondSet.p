module CondSet;

(* ident "@(#)dapro/syn03/CondSet.p 1.1 02/16/99" *)

#include <CondSet.h>


private
function find_node(var s: CondSetType; c: integer):boolean;
(* If there is an element of [s] with a value equal to [c], it is made
** the current element and true is returned. If no such element is
** found, false is returned and the greatest element of [s] with a
** value smaller than [c] is made the current element. If there is no
** element with a value smaller than or equal to [c], no element is
** marked as the current and false is returned.
*)
var
   done: boolean;
begin
   with s^ do begin
      current := head;
      if current = nil then
	 find_node := false
      else begin
	 done := false;
	 while not done do
	    if current^.next = nil then
	       done := true
	    else if Compare(current^.next^.value, c) = greater then
	       done := true
	    else
	       current := current^.next;
	 case Compare(current^.value, c) of
	    less:
	       find_node := false;
	    equal:
	       find_node := true;
	    greater:
	       begin
		  current := nil;
		  find_node := false
	       end
	 end
      end
   end
end;


procedure CondSet_Add(s: CondSetType; c: integer);
var
   aux: ConditionNodePointer;
begin
   if not find_node(s, c) then begin
      new(aux);
      aux^.value := c;
      with s^ do begin
	 if head = nil then begin	(* [s] is empty *)
	    head := aux;
	    aux^.next := nil
	 end else if current = nil then begin	(* insert before head *)
	    aux^.next := head;
	    head := aux
	 end else begin			(* append after current *)
	    aux^.next := current^.next;
	    current^.next := aux
	 end;
	 current := aux;
	 size := size + 1
      end
   end
end;


procedure CondSet_Clear(s: CondSetType);
var
   aux: ConditionNodePointer;
begin
   with s^ do begin
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 dispose(aux)
      end;
      current := nil;
      size := 0
   end
end;


function CondSet_Compare(s1, s2: CondSetType):CompareType;
var
   cmp: CompareType;
   aux1, aux2: ConditionNodePointer;
begin
   aux1 := s1^.head;
   aux2 := s2^.head;
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
   CondSet_Compare := cmp
end;


procedure CondSet_Copy(s1, s2: CondSetType);
var
   aux1, aux2: ConditionNodePointer;
   tp1: ConditionNodePointer;
begin
   tp1 := nil;
   aux1 := s1^.head;
   aux2 := s2^.head;
   while aux2 <> nil do begin
      if aux1 = nil then begin
	 new(aux1);
	 aux1^.next := nil;
	 if s1^.head = nil then
	    s1^.head := aux1
	 else
	    tp1^.next := aux1
      end;
      aux1^.value := aux2^.value;
      tp1 := aux1;
      aux1 := aux1^.next;
      aux2 := aux2^.next
   end;
   if tp1 = nil then
      while aux1 <> nil do begin
	 s1^.head := aux1^.next;
	 dispose(aux1);
	 aux1 := s1^.head
      end
   else
      while aux1 <> nil do begin
	 tp1^.next := aux1^.next;
	 dispose(aux1);
	 aux1 := tp1^.next
      end;
   s1^.current := s1^.head;
   s1^.size := s2^.size
end;


procedure CondSet_Create(var s: CondSetType);
begin
   new(s);
   with s^ do begin
      head := nil;
      current := nil;
      size := 0
   end
end;


procedure CondSet_Delete(var s: CondSetType);
var
   aux: ConditionNodePointer;
begin
   with s^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 dispose(aux)
      end;
   dispose(s);
   s := nil
end;


procedure CondSet_First(s: CondSetType);
begin
   s^.current := s^.head
end;


procedure CondSet_Next(s: CondSetType);
begin
   with s^ do
      if current <> nil then
	 current := current^.next
end;


procedure CondSet_Retrieve(s: CondSetType; var c: integer);
begin
   c := s^.current^.value
end;


function CondSet_Size(s: CondSetType):integer;
begin
   CondSet_Size := s^.size
end;


function CondSet_Subset(s1, s2: CondSetType):boolean;
(* Checks whether every element of [s1] is also in [s2]. *)
var
   done, success: boolean;
   aux1, aux2: ConditionNodePointer;
begin
   success := true;
   aux1 := s1^.head;
   aux2 := s2^.head;
   while (aux1 <> nil) and success do begin
      done := false;
      while not done and success do begin
	 if aux2 = nil then
	    success := false
	 else begin
	    case Compare(aux1^.value, aux2^.value) of
	       less:
		  success := false;
	       equal:
		  begin
		     done := true;
		     aux2 := aux2^.next
		  end;
	       greater:
		  aux2 := aux2^.next
	    end
	 end
      end;
      aux1 := aux1^.next
   end;
   CondSet_Subset := success
end;
