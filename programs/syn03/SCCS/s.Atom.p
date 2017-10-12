h30176
s 00007/00005/00361
d D 1.8 15/09/14 16:30:50 const 9 8
c Enclitic phrases need to be sticky, when enclitics have word status.
e
s 00002/00001/00364
d D 1.7 15/01/26 17:05:23 const 8 7
c Should not accept phrase type 0 for phrases with an article
e
s 00008/00016/00357
d D 1.6 14/06/11 17:31:10 const 7 6
c Present patterns constructed with a suffix as determined
e
s 00001/00000/00372
d D 1.5 13/08/28 15:25:44 const 6 5
c Added support for nominalisation at constituent level
e
s 00009/00000/00363
d D 1.4 10/07/24 15:10:16 const 5 3
c Adjusted state, determination, and proper noun transitions.
e
s 00009/00000/00363
d R 1.4 10/07/24 15:04:54 const 4 3
c Adjusted state, determination, and proper noun transitions.
e
s 00013/00010/00350
d D 1.3 02/07/20 16:08:30 const 3 2
c Added handling of emphatic state, necessary for Syriac.
e
s 00006/00002/00354
d D 1.2 00/11/22 14:59:55 const 2 1
c Added support for determined NP that becomes PrNP.
e
s 00356/00000/00000
d D 1.1 99/02/16 14:13:20 const 1 0
c date and time created 99/02/16 14:13:20 by const
e
u
U
f e 0
f m dapro/syn03/Atom.p
t
T
I 1
module Atom;

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
D 3
(* ident "%Z%%M% %I% %E%" *)
E 3
I 3
(* ident "%W% %E%" *)
E 3
E 2

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
I 7
(* Pre: determination is applicable *)
E 7
begin
   with a^ do begin
D 3
      if (IntList_Length(pdp) > 1) and IntList_Listed(pdp, ord(dart)) then
	 Atom_DefDet := Det_Det
      else if IntList_Listed(pdp, ord(nmpr)) then
	 Atom_DefDet := Det_Det
      else if IntList_Listed(pdp, ord(subs)) then
	 Atom_DefDet := Det_Und
      else if (IntList_Length(pdp) > 1) and IntList_Listed(pdp, ord(prep)) then
	 Atom_DefDet := Det_Und
      else
E 3
I 3
D 7
      if not IntList_Listed(pdp, ord(subs)) and
	 not IntList_Listed(pdp, ord(nmpr)) and
I 5
	 not IntList_Listed(pdp, ord(prps)) and
	 not IntList_Listed(pdp, ord(prde)) and
	 not IntList_Listed(pdp, ord(prin)) and
E 5
	 not IntList_Listed(pdp, ord(adjv))
E 7
I 7
      if IntList_Listed(pdp, ord(dart)) or
	 IntList_Listed(pdp, ord(nmpr)) or
	 IntList_Listed(pdp, ord(prps)) or
	 IntList_Listed(pdp, ord(prde)) or
	 IntList_Listed(sta, Sta_Emph)
E 7
      then
E 3
D 7
	 Atom_DefDet := Det_NA
E 7
I 7
	 Atom_DefDet := Det_Det
E 7
I 3
      else
D 7
	 if not IntList_Listed(pdp, ord(dart)) and
	    not IntList_Listed(pdp, ord(nmpr)) and
I 5
	    not IntList_Listed(pdp, ord(prps)) and
	    not IntList_Listed(pdp, ord(prde)) and
E 5
	    not IntList_Listed(sta, Sta_Emph)
	 then
	    Atom_DefDet := Det_Und
	 else
	    Atom_DefDet := Det_Det
E 7
I 7
	 Atom_DefDet := Det_Und
E 7
E 3
   end
end;


function Atom_DefTyp(a: AtomType):integer;
I 9
(* Post: the current element is undefined *)
E 9
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
I 9
(* Pre and post: the first element is current *)
E 9
var
   inv: boolean;
   p, s: integer;
begin
   inv := false;
D 9
   IntList_First(a^.sta);
   IntList_First(a^.pdp);
E 9
I 9
   assert(a^.sta^.head = a^.sta^.current);
   assert(a^.pdp^.head = a^.pdp^.current);
E 9
   while IntList_Get(a^.sta, s) and IntList_Get(a^.pdp, p) do begin
      if not Feature_IsVal(sta, s) then begin
	 inv := true;
	 Error_Set(ENOSTA)
      end;
I 5
      if s = Sta_Unk then begin
	 inv := true;
	 Error_Set(EUNSTA)
      end;
E 5
      if not Feature_IsVal(pdp, p) then begin
	 inv := true;
	 Error_Set(ENOPDP)
      end
   end;
D 9
   IntList_First(a^.sta);
   IntList_First(a^.pdp);
E 9
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
I 9
   IntList_First(a^.sta);
   IntList_First(a^.pdp);
E 9
   Atom_Valid := not inv
end;


function Atom_ValTyp(a: AtomType; t: integer):boolean;
D 9
(* Pre: [t] is a valid phrase type *)
E 9
I 9
(* Pre: [t] is a valid phrase type; post: current is undefined *)
E 9
I 2
var
   dtyp: integer;	(* default phrase type *)
E 2
begin
I 2
   dtyp := Atom_DefTyp(a);
E 2
D 8
   Atom_ValTyp :=
E 8
I 8
   Atom_ValTyp := (t <> Typ_none) and (
E 8
      IntList_Listed(a^.pdp, t) or
D 2
      Typ_Trans(Atom_DefTyp(a), t)
E 2
I 2
      Typ_Trans(dtyp, t) or
I 6
      (t = Typ_NP) or	(* nominalisation at constituent level *)
E 6
      ((t = Typ_PrNP) and (dtyp = Typ_NP) and (a^.det = Det_Det))
I 8
   )
E 8
E 2
end;
E 1
