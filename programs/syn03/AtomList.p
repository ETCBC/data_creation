module AtomList;

(* ident "@(#)dapro/syn03/AtomList.p 1.1 02/16/99" *)

#include <AtomList.h>


procedure AtomList_Add(l: AtomListType; a: AtomType);
var
   aux: AtomNodePointer;
begin
   new(aux);
   with aux^ do begin
      Atom_Create(atom);
      Atom_Copy(atom, a);
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
      size := size + Atom_Size(a);
      length := length + 1
   end
end;


procedure AtomList_Cat(l1, l2: AtomListType);
var
   aux1, aux2: AtomNodePointer;
begin
   aux2 := l2^.head;
   while aux2 <> nil do begin
      new(aux1);
      Atom_Create(aux1^.atom);
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
	 tail := aux1;
	 size := size + Atom_Size(aux2^.atom);
	 length := length + 1
      end;
      Atom_Copy(aux1^.atom, aux2^.atom);
      aux2 := aux2^.next
   end
end;


procedure AtomList_Clear(l: AtomListType);
var
   aux: AtomNodePointer;
begin
   with l^ do begin
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Atom_Delete(aux^.atom);
	 dispose(aux)
      end;
      current := nil;
      tail := nil;
      size := 0;
      length := 0
   end
end;


procedure AtomList_Create(var l: AtomListType);
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


procedure AtomList_Delete(var l: AtomListType);
var
   aux: AtomNodePointer;
begin
   with l^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Atom_Delete(aux^.atom);
	 dispose(aux)
      end;
   dispose(l);
   l := nil
end;


function AtomList_End(l: AtomListType):boolean;
begin
   AtomList_End := l^.current = nil
end;


procedure AtomList_First(l: AtomListType);
begin
   l^.current := l^.head
end;


function AtomList_Get(l: AtomListType; a: AtomType):boolean;
begin
   with l^ do
      if current = nil then
	 AtomList_Get := false
      else begin
	 Atom_Copy(a, current^.atom);
	 current := current^.next;
	 AtomList_Get := true
      end
end;


procedure AtomList_GetLabel(l: AtomListType; var v: VerseLabelType);
begin
   VerseLabel_Copy(v, l^.lab)
end;


procedure AtomList_Next(l: AtomListType);
begin
   with l^ do
      if current <> nil then
	 current := current^.next
end;


procedure AtomList_Retrieve(l: AtomListType; a: AtomType);
begin
   Atom_Copy(a, l^.current^.atom)
end;


procedure AtomList_SetLabel(l: AtomListType; var v: VerseLabelType);
begin
   VerseLabel_Copy(l^.lab, v)
end;


function AtomList_Size(l: AtomListType):integer;
begin
   AtomList_Size := l^.size
end;
