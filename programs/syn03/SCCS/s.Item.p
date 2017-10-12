h35304
s 00039/00011/00362
d D 1.4 15/09/14 16:30:51 const 5 4
c Enclitic phrases need to be sticky, when enclitics have word status.
e
s 00023/00006/00350
d D 1.3 14/06/11 17:31:11 const 4 3
c Present patterns constructed with a suffix as determined
e
s 00012/00003/00344
d D 1.2 07/02/08 10:20:31 const 3 1
c Determination applies to all nominal phrase types.
e
s 00012/00003/00344
d R 1.2 07/02/02 17:54:54 const 2 1
c 
e
s 00347/00000/00000
d D 1.1 99/02/16 14:13:36 const 1 0
c date and time created 99/02/16 14:13:36 by const
e
u
U
f e 0
f m dapro/syn03/Item.p
t
T
I 1
module Item;

D 3
(* ident "%Z%%M% %I% %G%" *)
E 3
I 3
(* ident "%W% %E%" *)
E 3

#include <Error.h>
#include <Item.h>


D 4
procedure Item_Add(i: ItemType; w_pos: integer; c: CondSetType; p_sta, p_pos: integer);
E 4
I 4
D 5
procedure Item_Add(i: ItemType; w_pos, w_sfx: integer; c: CondSetType; p_sta, p_pos: integer);
E 5
I 5
procedure Item_Add(i: ItemType;
   w_lxs, w_pos, w_sfx: integer;
   c: CondSetType;
   p_sta, p_pos: integer);
E 5
E 4
begin
   with i^ do begin
I 5
      IntList_Add(lxs, w_lxs);
E 5
      IntList_Add(pos, w_pos);
I 4
      IntList_Add(sfx, w_sfx);
E 4
      CondSetList_Add(cnd, c);
      Atom_Add(atm, p_sta, p_pos)
   end
end;


function Item_Apposition(i: ItemType):boolean;
begin
   Item_Apposition := Atom_Apposition(i^.atm)
end;


function Item_Appositive(i1, i2: ItemType):boolean;
begin
   Item_Appositive :=
      (Item_Objective(i1) and Item_Objective(i2)) and
      (Atom_Determination(i1^.atm) = Atom_Determination(i2^.atm)) and
D 3
      ((Item_Type(i1) = Typ_PreP) or (Item_Type(i2) <> Typ_PreP))
E 3
I 3
      ((Item_Type(i1) = Typ_PP) or (Item_Type(i2) <> Typ_PP))
E 3
end;


function Item_Assign(i: ItemType; a: AtomType):boolean;
begin
   if IntList_Length(i^.pos) <> Atom_Size(a) then
      Panic('Item_Assign');
   Item_Assign := Atom_Assign(i^.atm, a)
end;


function Item_AtmCmp(i1, i2: ItemType):CompareType;
begin
   Item_AtmCmp := Atom_Compare(i1^.atm, i2^.atm)
end;


procedure Item_Clear(i: ItemType);
begin
   with i^ do begin
I 5
      IntList_Clear(lxs);
E 5
      IntList_Clear(pos);
I 4
      IntList_Clear(sfx);
E 4
      CondSetList_Clear(cnd);
      Atom_Clear(atm)
   end
end;


procedure Item_Copy(i1, i2: ItemType);
begin
I 5
   IntList_Copy(i1^.lxs, i2^.lxs);
E 5
   IntList_Copy(i1^.pos, i2^.pos);
I 4
   IntList_Copy(i1^.sfx, i2^.sfx);
E 4
   CondSetList_Copy(i1^.cnd, i2^.cnd);
   Atom_Copy(i1^.atm, i2^.atm)
end;


procedure Item_Create(var i: ItemType);
begin
   new(i);
   with i^ do begin
I 5
      IntList_Create(lxs);
E 5
      IntList_Create(pos);
I 4
      IntList_Create(sfx);
E 4
      CondSetList_Create(cnd);
      Atom_Create(atm)
   end
end;


function Item_CndRef(i: ItemType):CondSetType;
begin
   Item_CndRef := CondSetList_Current(i^.cnd)
end;


function Item_CndSiz(i: ItemType):integer;
begin
   Item_CndSiz := CondSetList_Size(i^.cnd)
end;


procedure Item_Cut(i: ItemType);
begin
   with i^ do begin
I 5
      IntList_Cut(lxs);
E 5
      IntList_Cut(pos);
I 4
      IntList_Cut(sfx);
E 4
      CondSetList_Cut(cnd);
      Atom_Cut(atm)
   end
end;


function Item_DefDet(i: ItemType):integer;
begin
D 4
   Item_DefDet := Atom_DefDet(i^.atm)
E 4
I 4
   if not Item_Objective(i) then
      Item_DefDet := Det_NA
   else
      if IntList_Listed(i^.sfx, 1) then
	 Item_DefDet := Det_Det
      else
	 Item_DefDet := Atom_DefDet(i^.atm)
E 4
end;


function Item_DefTyp(i: ItemType);
I 5
(* Post: the current element is undefined. *)
E 5
begin
   Item_DefTyp := Atom_DefTyp(i^.atm)
end;


procedure Item_Delete(var i: ItemType);
begin
   with i^ do begin
I 5
      IntList_Delete(lxs);
E 5
      IntList_Delete(pos);
I 4
      IntList_Delete(sfx);
E 4
      CondSetList_Delete(cnd);
      Atom_Delete(atm)
   end;
   dispose(i);
   i := nil
end;


I 5
function Item_Enclitic(i: ItemType):boolean;
(* Returns whether the current element is an enclitic *)
var
   ls, sp: integer;
begin
   with i^ do begin
      IntList_Retrieve(lxs, ls);
      IntList_Retrieve(pos, sp);
   end;
   Item_Enclitic := (ls = -1) and (sp = ord(prps))
end;


E 5
function Item_End(i: ItemType):boolean;
begin
   Item_End := Atom_End(i^.atm)
end;


procedure Item_First(i: ItemType);
begin
   with i^ do begin
I 5
      IntList_First(lxs);
E 5
      IntList_First(pos);
I 4
      IntList_First(sfx);
E 4
      CondSetList_First(cnd);
      Atom_First(atm)
   end
end;


function Item_Get(i: ItemType; var w_pos: integer; c: CondSetType; var p_sta, p_pos: integer):boolean;
begin
   with i^ do
      Item_Get :=
	 IntList_Get(pos, w_pos) and
	 CondSetList_Get(cnd, c) and
	 Atom_Get(atm, p_sta, p_pos)
end;


function Item_Determination(i: ItemType):integer;
begin
   Item_Determination := Atom_Determination(i^.atm)
end;


function Item_Head(i: ItemType):PosType;
begin
   Item_Head := Pos(IntList_Head(i^.pos))
end;


procedure Item_Join(i1, i2: ItemType);
begin
I 5
   IntList_Join(i1^.lxs, i2^.lxs);
E 5
   IntList_Join(i1^.pos, i2^.pos);
I 4
   IntList_Join(i1^.sfx, i2^.sfx);
E 4
   CondSetList_Join(i1^.cnd, i2^.cnd);
   Atom_Join(i1^.atm, i2^.atm)
end;


procedure Item_Last(i: ItemType);
begin
   with i^ do begin
I 5
      IntList_Last(lxs);
E 5
      IntList_Last(pos);
I 4
      IntList_Last(sfx);
E 4
      CondSetList_Last(cnd);
      Atom_Last(atm)
   end
end;


function Item_Match(i1, i2: ItemType):boolean;
begin
   Item_Match :=
      (IntList_Compare(i1^.pos, i2^.pos) = equal) and
      CondSetList_Subset(i1^.cnd, i2^.cnd);
end;


procedure Item_Next(i: ItemType);
begin
   with i^ do begin
I 5
      IntList_Next(lxs);
E 5
      IntList_Next(pos);
I 4
      IntList_Next(sfx);
E 4
      CondSetList_Next(cnd);
      Atom_Next(atm)
   end;
end;


function Item_Objective(i: ItemType):boolean;
I 3
(* An item is objective if it contains a phrase of nominal type *)
E 3
begin
   Item_Objective :=
D 3
      Atom_Type(i^.atm) in [Typ_NP, Typ_PrNP, Typ_PreP]
E 3
I 3
      Atom_Type(i^.atm) in [
D 4
	 Typ_AdjP,
	 Typ_DPrP,
	 Typ_IPrP,
E 4
	 Typ_NP,
I 4
	 Typ_PrNP,
E 4
	 Typ_PP,
	 Typ_PPrP,
D 4
	 Typ_PrNP
E 4
I 4
	 Typ_DPrP,
	 Typ_IPrP
E 4
      ]
E 3
end;


function Item_Pos(i: ItemType):integer;
begin
   Item_Pos := IntList_Current(i^.pos)
end;


procedure Item_Retrieve(i: ItemType; var w_pos: integer; c: CondSetType; var p_sta, p_pos: integer);
begin
   with i^ do begin
      IntList_Retrieve(pos, w_pos);
      CondSetList_Retrieve(cnd, c);
      Atom_Retrieve(atm, p_sta, p_pos)
   end
end;


procedure Item_SetApp(i: ItemType; app: boolean);
begin
   Atom_SetApp(i^.atm, app)
end;


procedure Item_SetDet(i: ItemType; det: integer);
begin
   Atom_SetDet(i^.atm, det)
end;


procedure Item_SetTyp(i: ItemType; typ: integer);
begin
   Atom_SetTyp(i^.atm, typ)
end;


function Item_Single(i: ItemType):boolean;
begin
   Item_Single :=
      (IntList_Length(i^.pos) = 1) and
      (CondSetList_Size(i^.cnd) = 0)
end;


function Item_Size(i: ItemType):integer;
begin
   Item_Size := IntList_Length(i^.pos)
end;


procedure Item_Split(i1, i2: ItemType; n: integer);
begin
I 5
   IntList_Split(i1^.lxs, i2^.lxs, n);
E 5
   IntList_Split(i1^.pos, i2^.pos, n);
I 4
   IntList_Split(i1^.sfx, i2^.sfx, n);
E 4
   CondSetList_Split(i1^.cnd, i2^.cnd, n);
   Atom_Split(i1^.atm, i2^.atm, n)
end;


function Item_Subset(i1, i2: ItemType):boolean;
begin
   Item_Subset :=
      (IntList_Compare(i1^.pos, i2^.pos) = equal) and
      CondSetList_Subset(i1^.cnd, i2^.cnd) and
      (Atom_Compare(i1^.atm, i2^.atm) = equal)
end;


function Item_Transitive(i: ItemType):boolean;
I 5
(* Returns whether [i] contains a part of speech transition.
   Pre and post: the first element is current. *)
E 5
var
   p0, p1: integer;
   st: integer;
   trans: boolean;
begin
   trans := false;
   with i^ do begin
D 5
      IntList_First(pos);
      Atom_First(atm);
E 5
I 5
      assert(pos^.current = pos^.head);
E 5
      while not trans and not Atom_End(atm) do begin
	 IntList_Retrieve(pos, p0);
	 Atom_Retrieve(atm, st, p1);
	 trans := p1 <> p0;
	 Atom_Next(atm);
	 IntList_Next(pos)
D 5
      end
E 5
I 5
      end;
      IntList_First(pos);
      Atom_First(atm)
E 5
   end;
   Item_Transitive := trans
end;


function Item_Type(i: ItemType):integer;
begin
   Item_Type := Atom_Type(i^.atm)
end;


function Item_Unconditional(i: ItemType):boolean;
begin
   Item_Unconditional := CondSetList_Size(i^.cnd) = 0
end;


procedure Item_Update(i: ItemType; w_pos: integer; c: CondSetType; p_sta, p_pos: integer);
begin
   with i^ do begin
      IntList_Update(pos, w_pos);
      CondSetList_Update(cnd, c);
      Atom_Update(atm, p_sta, p_pos)
   end
end;


function Item_Valid(i: ItemType):boolean;
I 5
(* pre and post: the first element is current *)
E 5
var
   inv: boolean;
   p0, p1, st: integer;
begin
I 5
   assert(i^.pos^.current = i^.pos^.head);
E 5
   inv := false;
   if not Atom_Valid(i^.atm) then
      inv := true
   else begin
D 5
      IntList_First(i^.pos);
      Atom_First(i^.atm);
      while IntList_Get(i^.pos, p0) and Atom_Get(i^.atm, st, p1) do begin
E 5
I 5
      while IntList_Get(i^.pos, p0) and Atom_Get(i^.atm, st, p1) do
E 5
	 if not Feature_IsVal(pos, p0) then begin
	    inv := true;
	    Error_Set(ENOPOS)
	 end else if not Pos_Trans(p0, p1) then begin
	    inv := true;
	    Error_Set(ETRPOS)
	 end else if not Pos_State(p0, st) then begin
	    inv := true;
	    Error_Set(ESTPOS)
D 5
	 end
      end;
E 5
I 5
	 end;
E 5
      IntList_First(i^.pos);
I 4
D 5
      IntList_First(i^.sfx);
E 4
      CondSetList_First(i^.cnd);
E 5
      Atom_First(i^.atm)
   end;
   Item_Valid := not inv
end;


function Item_ValTyp(i: ItemType; t: integer):boolean;
begin
   Item_ValTyp := Atom_ValTyp(i^.atm, t)
end;
E 1
