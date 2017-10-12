h50200
s 00142/00000/00000
d D 1.1 99/02/16 14:13:47 const 1 0
c date and time created 99/02/16 14:13:47 by const
e
u
U
f e 0
f m dapro/syn03/Surface.p
t
T
I 1
module Surface;

(* ident "%Z%%M% %I% %G%" *)

#include <Surface.h>


procedure Surface_Add(s: SurfaceType; w: StringType);
var
   aux: StringNodePointer;
begin
   new(aux);
   with aux^ do begin
      wrd := w;
      next := nil;
      prior := nil
   end;
   with s^ do begin
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


procedure Surface_Clear(s: SurfaceType);
var
   aux: StringNodePointer;
begin
   with s^ do begin
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


procedure Surface_Create(var s: SurfaceType);
begin
   new(s);
   with s^ do begin
      head := nil;
      current := nil;
      mark := nil;
      tail := nil;
      length := 0
   end
end;


procedure Surface_Delete(var s: SurfaceType);
var
   aux: StringNodePointer;
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


procedure Surface_First(s: SurfaceType);
begin
   s^.current := s^.head
end;


procedure Surface_GetLabel(s: SurfaceType; var l: VerseLabelType);
begin
   l := s^.lab
end;


procedure Surface_Jump(s: SurfaceType);
begin
   s^.current := s^.mark
end;


function Surface_Length(s: SurfaceType):integer;
begin
   Surface_Length := s^.length
end;


procedure Surface_Mark(s: SurfaceType);
begin
   s^.mark := s^.current
end;


procedure Surface_Next(s: SurfaceType);
begin
   with s^ do
      if current <> nil then
	 current := current^.next
end;


procedure Surface_Prior(s: SurfaceType);
begin
   with s^ do
      if current <> nil then
	 current := current^.prior
end;


procedure Surface_Retrieve(s: SurfaceType; var w: StringType);
begin
   w := s^.current^.wrd
end;


procedure Surface_SetLabel(var s: SurfaceType; l: VerseLabelType);
begin
   s^.lab := l
end;


function Surface_String(s: SurfaceType):StringType;
begin
   Surface_String := s^.current^.wrd
end;
E 1
