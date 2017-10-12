module Item;

(* ident "@(#)dapro/syn03/Item.p	1.4 15/09/14" *)

#include <Error.h>
#include <Item.h>


procedure Item_Add(i: ItemType;
   w_lxs, w_pos, w_sfx: integer;
   c: CondSetType;
   p_sta, p_pos: integer);
begin
   with i^ do begin
      IntList_Add(lxs, w_lxs);
      IntList_Add(pos, w_pos);
      IntList_Add(sfx, w_sfx);
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
      ((Item_Type(i1) = Typ_PP) or (Item_Type(i2) <> Typ_PP))
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
      IntList_Clear(lxs);
      IntList_Clear(pos);
      IntList_Clear(sfx);
      CondSetList_Clear(cnd);
      Atom_Clear(atm)
   end
end;


procedure Item_Copy(i1, i2: ItemType);
begin
   IntList_Copy(i1^.lxs, i2^.lxs);
   IntList_Copy(i1^.pos, i2^.pos);
   IntList_Copy(i1^.sfx, i2^.sfx);
   CondSetList_Copy(i1^.cnd, i2^.cnd);
   Atom_Copy(i1^.atm, i2^.atm)
end;


procedure Item_Create(var i: ItemType);
begin
   new(i);
   with i^ do begin
      IntList_Create(lxs);
      IntList_Create(pos);
      IntList_Create(sfx);
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
      IntList_Cut(lxs);
      IntList_Cut(pos);
      IntList_Cut(sfx);
      CondSetList_Cut(cnd);
      Atom_Cut(atm)
   end
end;


function Item_DefDet(i: ItemType):integer;
begin
   if not Item_Objective(i) then
      Item_DefDet := Det_NA
   else
      if IntList_Listed(i^.sfx, 1) then
	 Item_DefDet := Det_Det
      else
	 Item_DefDet := Atom_DefDet(i^.atm)
end;


function Item_DefTyp(i: ItemType);
(* Post: the current element is undefined. *)
begin
   Item_DefTyp := Atom_DefTyp(i^.atm)
end;


procedure Item_Delete(var i: ItemType);
begin
   with i^ do begin
      IntList_Delete(lxs);
      IntList_Delete(pos);
      IntList_Delete(sfx);
      CondSetList_Delete(cnd);
      Atom_Delete(atm)
   end;
   dispose(i);
   i := nil
end;


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


function Item_End(i: ItemType):boolean;
begin
   Item_End := Atom_End(i^.atm)
end;


procedure Item_First(i: ItemType);
begin
   with i^ do begin
      IntList_First(lxs);
      IntList_First(pos);
      IntList_First(sfx);
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
   IntList_Join(i1^.lxs, i2^.lxs);
   IntList_Join(i1^.pos, i2^.pos);
   IntList_Join(i1^.sfx, i2^.sfx);
   CondSetList_Join(i1^.cnd, i2^.cnd);
   Atom_Join(i1^.atm, i2^.atm)
end;


procedure Item_Last(i: ItemType);
begin
   with i^ do begin
      IntList_Last(lxs);
      IntList_Last(pos);
      IntList_Last(sfx);
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
      IntList_Next(lxs);
      IntList_Next(pos);
      IntList_Next(sfx);
      CondSetList_Next(cnd);
      Atom_Next(atm)
   end;
end;


function Item_Objective(i: ItemType):boolean;
(* An item is objective if it contains a phrase of nominal type *)
begin
   Item_Objective :=
      Atom_Type(i^.atm) in [
	 Typ_NP,
	 Typ_PrNP,
	 Typ_PP,
	 Typ_PPrP,
	 Typ_DPrP,
	 Typ_IPrP
      ]
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
   IntList_Split(i1^.lxs, i2^.lxs, n);
   IntList_Split(i1^.pos, i2^.pos, n);
   IntList_Split(i1^.sfx, i2^.sfx, n);
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
(* Returns whether [i] contains a part of speech transition.
   Pre and post: the first element is current. *)
var
   p0, p1: integer;
   st: integer;
   trans: boolean;
begin
   trans := false;
   with i^ do begin
      assert(pos^.current = pos^.head);
      while not trans and not Atom_End(atm) do begin
	 IntList_Retrieve(pos, p0);
	 Atom_Retrieve(atm, st, p1);
	 trans := p1 <> p0;
	 Atom_Next(atm);
	 IntList_Next(pos)
      end;
      IntList_First(pos);
      Atom_First(atm)
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
(* pre and post: the first element is current *)
var
   inv: boolean;
   p0, p1, st: integer;
begin
   assert(i^.pos^.current = i^.pos^.head);
   inv := false;
   if not Atom_Valid(i^.atm) then
      inv := true
   else begin
      while IntList_Get(i^.pos, p0) and Atom_Get(i^.atm, st, p1) do
	 if not Feature_IsVal(pos, p0) then begin
	    inv := true;
	    Error_Set(ENOPOS)
	 end else if not Pos_Trans(p0, p1) then begin
	    inv := true;
	    Error_Set(ETRPOS)
	 end else if not Pos_State(p0, st) then begin
	    inv := true;
	    Error_Set(ESTPOS)
	 end;
      IntList_First(i^.pos);
      Atom_First(i^.atm)
   end;
   Item_Valid := not inv
end;


function Item_ValTyp(i: ItemType; t: integer):boolean;
begin
   Item_ValTyp := Atom_ValTyp(i^.atm, t)
end;
