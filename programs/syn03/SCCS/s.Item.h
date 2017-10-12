h13802
s 00009/00002/00145
d D 1.3 15/09/14 16:30:51 const 3 2
c Enclitic phrases need to be sticky, when enclitics have word status.
e
s 00003/00002/00144
d D 1.2 14/06/11 17:31:10 const 2 1
c Present patterns constructed with a suffix as determined
e
s 00146/00000/00000
d D 1.1 99/02/16 14:13:35 const 1 0
c date and time created 99/02/16 14:13:35 by const
e
u
U
f e 0
f m dapro/syn03/Item.h
t
T
I 1
#ifndef	ITEM_H
#define	ITEM_H

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
(* ident "%W% %E%" *)
E 2

#include <Atom.h>
#include <CondSetList.h>
#include <Feature.h>
#include <IntList.h>

type
   ItemInstance =
      record
I 3
	 lxs: IntListType;
E 3
	 pos: IntListType;
I 2
	 sfx: IntListType;
E 2
	 cnd: CondSetListType;
	 atm: AtomType
      end;
   ItemType =
      ^ ItemInstance;

D 2
procedure Item_Add(i: ItemType; w_pos: integer; c: CondSetType; p_sta, p_pos: integer);
E 2
I 2
D 3
procedure Item_Add(i: ItemType; w_pos, w_sfx: integer; c: CondSetType; p_sta, p_pos: integer);
E 3
I 3
procedure Item_Add(i: ItemType; w_lxs, w_pos, w_sfx: integer; c: CondSetType; p_sta, p_pos: integer);
E 3
E 2
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

I 3
function  Item_Enclitic(i: ItemType):boolean;
(* Returns whether the current element is an enclitic *)
extern;

E 3
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
D 3
(* Returns whether [i] contains a part of speech transition *)
E 3
I 3
(* Returns whether [i] contains a part of speech transition.
   Pre and post: the first element is current. *)
E 3
extern;

function  Item_Type(i: ItemType):integer;
extern;

function  Item_Unconditional(i: ItemType):boolean;
extern;

procedure Item_Update(i: ItemType; w_pos: integer; c: CondSetType; p_sta, p_pos: integer);
extern;

function  Item_Valid(i: ItemType):boolean;
I 3
(* Pre and post: the first element is current *)
E 3
extern;

function  Item_ValTyp(i: ItemType; t: integer):boolean;
extern;

#endif	(* not ITEM_H *)
E 1
