#ifndef	ITEM_H
#define	ITEM_H

(* ident "@(#)dapro/syn03/Item.h	1.3 15/09/14" *)

#include <Atom.h>
#include <CondSetList.h>
#include <Feature.h>
#include <IntList.h>

type
   ItemInstance =
      record
	 lxs: IntListType;
	 pos: IntListType;
	 sfx: IntListType;
	 cnd: CondSetListType;
	 atm: AtomType
      end;
   ItemType =
      ^ ItemInstance;

procedure Item_Add(i: ItemType; w_lxs, w_pos, w_sfx: integer; c: CondSetType; p_sta, p_pos: integer);
extern;

function  Item_Apposition(i: ItemType):boolean;
extern;

function  Item_Appositive(i1, i2: ItemType):boolean;
extern;

function  Item_Assign(i: ItemType; a: AtomType):boolean;
extern;

function  Item_AtmCmp(i1, i2: ItemType):CompareType;
extern;

procedure Item_Clear(i: ItemType);
extern;

procedure Item_Copy(i1, i2: ItemType);
extern;

procedure Item_Create(var i: ItemType);
extern;

function  Item_CndRef(i: ItemType):CondSetType;
(* Returns a pointer to the condition set of the current element. *)
extern;

function  Item_CndSiz(i: ItemType):integer;
extern;

procedure Item_Cut(i: ItemType);
extern;

function  Item_DefDet(i: ItemType):integer;
(* Returns the default value for determination for [i]. *)
extern;

function  Item_DefTyp(i: ItemType):integer;
(* Returns the default value for phrase atom type for [i]. *)
extern;

procedure Item_Delete(var i: ItemType);
extern;

function  Item_Determination(i: ItemType):integer;
extern;

function  Item_Enclitic(i: ItemType):boolean;
(* Returns whether the current element is an enclitic *)
extern;

function  Item_End(i: ItemType):boolean;
extern;

procedure Item_First(i: ItemType);
extern;

function  Item_Get(i: ItemType; var w_pos: integer; c: CondSetType; var p_sta, p_pos: integer):boolean;
extern;

function  Item_Head(i: ItemType):PosType;
extern;

procedure Item_Join(i1, i2: ItemType);
(* Removes the contents from [i2] and appends them to [i1]. *)
extern;

procedure Item_Last(i: ItemType);
extern;

function  Item_Match(i1, i2: ItemType):boolean;
extern;

procedure Item_Next(i: ItemType);
extern;

function  Item_Objective(i: ItemType):boolean;
(* Returns whether the phrase atom type of [i] is nominal or
** prepositional.
*)
extern;

function  Item_Pos(i: ItemType):integer;
extern;

procedure Item_Retrieve(i: ItemType; var w_pos: integer; c: CondSetType; var p_sta, p_pos: integer);
extern;

procedure Item_SetApp(i: ItemType; app: boolean);
extern;

procedure Item_SetDet(i: ItemType; det: integer);
extern;

procedure Item_SetTyp(i: ItemType; typ: integer);
extern;

function  Item_Single(i: ItemType):boolean;
extern;

function  Item_Size(i: ItemType):integer;
extern;

procedure Item_Split(i1, i2: ItemType; n: integer);
extern;

function  Item_Subset(i1, i2: ItemType):boolean;
extern;

function  Item_Transitive(i: ItemType):boolean;
(* Returns whether [i] contains a part of speech transition.
   Pre and post: the first element is current. *)
extern;

function  Item_Type(i: ItemType):integer;
extern;

function  Item_Unconditional(i: ItemType):boolean;
extern;

procedure Item_Update(i: ItemType; w_pos: integer; c: CondSetType; p_sta, p_pos: integer);
extern;

function  Item_Valid(i: ItemType):boolean;
(* Pre and post: the first element is current *)
extern;

function  Item_ValTyp(i: ItemType; t: integer):boolean;
extern;

#endif	(* not ITEM_H *)
