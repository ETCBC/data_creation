h49593
s 00081/00000/00000
d D 1.1 99/02/16 14:13:41 const 1 0
c date and time created 99/02/16 14:13:41 by const
e
u
U
f e 0
f m dapro/syn03/MCond.p
t
T
I 1
module MCond;

(* ident "%Z%%M% %I% %G%" *)

#include <MCond.h>


procedure MCond_Add(var m: MCondType; v: integer);
begin
   IntList_Add(m^.vlst, v)
end;


procedure MCond_Clear(var m: MCondType);
begin
   with m^ do begin
      feat := Feature_First;
      IntList_Clear(vlst)
   end
end;


procedure MCond_Copy(var m1, m2: MCondType);
begin
   m1^.feat := m2^.feat;
   IntList_Copy(m1^.vlst, m2^.vlst)
end;


procedure MCond_Create(var m: MCondType);
begin
   new(m);
   with m^ do begin
      feat := Feature_First;
      IntList_Create(vlst)
   end
end;


procedure MCond_Delete(var m: MCondType);
begin
   with m^ do begin
      (* feat p.m. *)
      IntList_Delete(vlst)
   end;
   dispose(m)
end;


procedure MCond_GetFeature(m: MCondType; var f: FeatureType);
begin
   f := m^.feat
end;


procedure MCond_SetFeature(var m: MCondType; f: FeatureType);
begin
   m^.feat := f
end;


function MCond_Size(m: MCondType):integer;
begin
   MCond_Size := IntList_Length(m^.vlst)
end;


function MCond_Test(m: MCondType; v: integer):boolean;
var
   value: integer;
   matched: boolean;
begin
   matched := false;
   with m^ do
      if IntList_Length(vlst) > 0 then begin
	 IntList_First(vlst);
	 while IntList_Get(vlst, value) and not matched do
	    matched := value = v
      end;
   MCond_Test := matched
end;
E 1
