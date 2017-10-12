module Atom;

(* ident "@(#)dapro/syn03/Atom.p	1.8 15/09/14" *)

#include <Atom.h>
#include <Error.h>


procedure Atom_Add(a: AtomType; state, speech: integer);
begin
   with a^ do begin
      IntList_Add(sta, state);
      IntList_Add(pdp, speech)
   end
end;


function Atom_Apposition(a: AtomType):boolean;
begin
   Atom_Apposition := a^.typ < 0
end;


function Atom_Assign(a1, a2: AtomType):boolean;
var
   failed: boolean;
   v1, v2: integer;
begin
   failed := false;
   IntList_First(a1^.sta);
   IntList_First(a2^.sta);
   while not IntList_End(a1^.sta) and not IntList_End(a2^.sta) do begin
      IntList_Retrieve(a1^.sta, v1);
      IntList_Retrieve(a2^.sta, v2);
      if Sta_Trans(v1, v2) then
	 IntList_Update(a1^.sta, v2)
      else begin
	 Error_Set(ETRSTA);
	 failed := true
      end;
      IntList_Next(a1^.sta);
      IntList_Next(a2^.sta)
   end;
   IntList_First(a1^.sta);
   IntList_First(a2^.sta);
   IntList_First(a1^.pdp);
   IntList_First(a2^.pdp);
   while not IntList_End(a1^.pdp) and not IntList_End(a2^.pdp) do begin
      IntList_Retrieve(a1^.pdp, v1);
      IntList_Retrieve(a2^.pdp, v2);
      if Pos_Trans(v1, v2) then
	 IntList_Update(a1^.pdp, v2)
      else begin
	 Error_Set(ETRPOS);
	 failed := true
      end;
      IntList_Next(a1^.pdp);
      IntList_Next(a2^.pdp)
   end;
   IntList_First(a1^.pdp);
   IntList_First(a2^.pdp);
   a1^.typ := a2^.typ;
   a1^.det := a2^.det;
   Atom_Assign := not failed
end;


procedure Atom_Clear(a: AtomType);
begin
   with a^ do begin
      IntList_Clear(sta);
      IntList_Clear(pdp);
      typ := 0;
      det := -1
   end
end;


function Atom_Compare(a1, a2: AtomType):CompareType;
var
   cmp: CompareType;
begin
   cmp := IntList_Compare(a1^.sta, a2^.sta);
   if cmp = equal then begin
      cmp := IntList_Compare(a1^.pdp, a2^.pdp);
      if cmp = equal then begin
	 cmp := Compare(a1^.typ, a2^.typ);
	 if cmp = equal then begin
	    cmp := Compare(a1^.det, a2^.det)
	 end
      end
   end;
   Atom_Compare := cmp
end;


procedure Atom_Copy(a1, a2: AtomType);
begin
   IntList_Copy(a1^.sta, a2^.sta);
   IntList_Copy(a1^.pdp, a2^.pdp);
   a1^.typ := a2^.typ;
   a1^.det := a2^.det
end;


procedure Atom_Create(var a: AtomType);
begin
   new(a);
   with a^ do begin
      IntList_Create(sta);
      IntList_Create(pdp);
      typ := 0;
      det := -1
   end
end;


procedure Atom_Cut(a: AtomType);
begin
   with a^ do begin
      IntList_Cut(sta);
      IntList_Cut(pdp)
   end
end;


function Atom_DefDet(a: AtomType):integer;
(* Pre: determination is applicable *)
begin
   with a^ do begin
      if IntList_Listed(pdp, ord(dart)) or
	 IntList_Listed(pdp, ord(nmpr)) or
	 IntList_Listed(pdp, ord(prps)) or
	 IntList_Listed(pdp, ord(prde)) or
	 IntList_Listed(sta, Sta_Emph)
      then
	 Atom_DefDet := Det_Det
      else
	 Atom_DefDet := Det_Und
   end
end;


function Atom_DefTyp(a: AtomType):integer;
(* Post: the current element is undefined *)
var
   p: integer;
   done: boolean;
begin
   with a^ do begin
      p := ord(verb);
      if IntList_Listed(pdp, p) then
	 done := true
      else begin
	 IntList_First(pdp);
	 done := false
      end;
      while not done and IntList_Get(pdp, p) do
	 done := p > 0;
      if done then
	 Atom_DefTyp := p
      else
	 Atom_DefTyp := ord(conj)
   end
end;


procedure Atom_Delete(var a: AtomType);
begin
   with a^ do begin
      IntList_Delete(sta);
      IntList_Delete(pdp)
   end;
   dispose(a);
   a := nil
end;


function Atom_End(a: AtomType):boolean;
begin
   Atom_End := IntList_End(a^.sta)
end;


procedure Atom_First(a: AtomType);
begin
   with a^ do begin
      IntList_First(sta);
      IntList_First(pdp)
   end;
end;


function Atom_Get(a: AtomType; var state, speech: integer):boolean;
begin
   with a^ do
      Atom_Get := IntList_Get(sta, state) and IntList_Get(pdp, speech)
end;


function Atom_Determination(a: AtomType):integer;
begin
   Atom_Determination := a^.det
end;


procedure Atom_Join(a1, a2: AtomType);
begin
   IntList_Join(a1^.sta, a2^.sta);
   IntList_Join(a1^.pdp, a2^.pdp);
   with a2^ do begin
      typ := 0;
      det := -1
   end
end;


procedure Atom_Last(a: AtomType);
begin
   with a^ do begin
      IntList_Last(sta);
      IntList_Last(pdp)
   end
end;


procedure Atom_Next(a: AtomType);
begin
   with a^ do begin
      IntList_Next(sta);
      IntList_Next(pdp)
   end
end;


procedure Atom_Retrieve(a: AtomType; var state, speech: integer);
begin
   with a^ do begin
      IntList_Retrieve(sta, state);
      IntList_Retrieve(pdp, speech)
   end
end;


procedure Atom_SetApp(a: AtomType; app: boolean);
begin
   with a^ do
      if app then
	 typ := -abs(typ)
      else
	 typ := abs(typ)
end;


procedure Atom_SetDet(a: AtomType; det: integer);
begin
   a^.det := det
end;


procedure Atom_SetTyp(a: AtomType; typ: integer);
begin
   a^.typ := typ
end;


function Atom_Size(a: AtomType):integer;
begin
   Atom_Size := IntList_Length(a^.sta)
end;


procedure Atom_Split(a1, a2: AtomType; n: integer);
begin
   IntList_Split(a1^.sta, a2^.sta, n);
   IntList_Split(a1^.pdp, a2^.pdp, n);
   a2^.typ := a1^.typ;
   a2^.det := a1^.det
end;


procedure Atom_ToWord(a: AtomType; w: WordType);
var
   n: integer;
begin
   IntList_Retrieve(a^.sta, n);
   Word_SetFeature(w, sta, n);
   IntList_Retrieve(a^.pdp, n);
   Word_SetFeature(w, pdp, n);
   if IntList_Bottom(a^.sta) and IntList_Bottom(a^.pdp) then begin
      Word_SetFeature(w, typ, a^.typ);
      Word_SetFeature(w, det, a^.det)
   end else begin
      Word_SetFeature(w, typ, 0);
      Word_SetFeature(w, det, -1)
   end
end;


function Atom_Type(a: AtomType):integer;
begin
   Atom_Type := abs(a^.typ)
end;


procedure Atom_Update(a: AtomType; state, speech: integer);
begin
   with a^ do begin
      IntList_Update(sta, state);
      IntList_Update(pdp, speech)
   end
end;


function Atom_Valid(a: AtomType):boolean;
(* Pre and post: the first element is current *)
var
   inv: boolean;
   p, s: integer;
begin
   inv := false;
   assert(a^.sta^.head = a^.sta^.current);
   assert(a^.pdp^.head = a^.pdp^.current);
   while IntList_Get(a^.sta, s) and IntList_Get(a^.pdp, p) do begin
      if not Feature_IsVal(sta, s) then begin
	 inv := true;
	 Error_Set(ENOSTA)
      end;
      if s = Sta_Unk then begin
	 inv := true;
	 Error_Set(EUNSTA)
      end;
      if not Feature_IsVal(pdp, p) then begin
	 inv := true;
	 Error_Set(ENOPDP)
      end
   end;
   if not Feature_IsVal(typ, a^.typ) then begin
      inv := true;
      Error_Set(ENOTYP)
   end;
   if not Atom_ValTyp(a, abs(a^.typ)) then begin
      inv := true;
      Error_Set(EPHTYP)
   end;
   if not Feature_IsVal(det, a^.det) then begin
      inv := true;
      Error_Set(ENODET)
   end;
   IntList_First(a^.sta);
   IntList_First(a^.pdp);
   Atom_Valid := not inv
end;


function Atom_ValTyp(a: AtomType; t: integer):boolean;
(* Pre: [t] is a valid phrase type; post: current is undefined *)
var
   dtyp: integer;	(* default phrase type *)
begin
   dtyp := Atom_DefTyp(a);
   Atom_ValTyp := (t <> Typ_none) and (
      IntList_Listed(a^.pdp, t) or
      Typ_Trans(dtyp, t) or
      (t = Typ_NP) or	(* nominalisation at constituent level *)
      ((t = Typ_PrNP) and (dtyp = Typ_NP) and (a^.det = Det_Det))
   )
end;
