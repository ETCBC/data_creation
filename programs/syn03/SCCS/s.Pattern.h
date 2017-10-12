h50798
s 00001/00000/00124
d D 1.2 99/03/25 10:38:43 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00124/00000/00000
d D 1.1 99/02/16 14:13:42 const 1 0
c date and time created 99/02/16 14:13:42 by const
e
u
U
f e 0
f m dapro/syn03/Pattern.h
t
T
I 1
#ifndef	PATTERN_H
#define	PATTERN_H

(* ident "%Z%%M% %I% %G%" *)

#include <AtomList.h>
#include <Item.h>

type
   TagType =
      (t_div, t_join, t_set, t_user);
   ItemNodePointer =
      ^ ItemNode;
   ItemNode =
      record
	 item:  ItemType;
	 next:  ItemNodePointer;
	 prior: ItemNodePointer
      end;
   PatternInstance =
      record
	 tag_t:   TagType;
	 tag_n:   integer;
	 head:    ItemNodePointer;
	 current: ItemNodePointer;
	 tail:    ItemNodePointer;
	 size:    integer;
	 length:  integer
      end;
   PatternType =
      ^ PatternInstance;

procedure Pattern_Add(p: PatternType; i: ItemType);
extern;

procedure Pattern_Atomise(p: PatternType; l: AtomListType);
extern;

procedure Pattern_Chip(p: PatternType);
(* Reduces the size, not necessarily the length, with one by discarding
** the last element of the last item.
*)
extern;

procedure Pattern_Clear(p: PatternType);
extern;

function  Pattern_Compare(p1, p2: PatternType):CompareType;
(* The patterns must not contain empty items. *)
extern;

procedure Pattern_Copy(p1, p2: PatternType);
extern;

procedure Pattern_Create(var p: PatternType);
extern;

procedure Pattern_Delete(var p: PatternType);
extern;

function  Pattern_End(p: PatternType):boolean;
extern;

procedure Pattern_First(p: PatternType);
extern;

function  Pattern_Get(p: PatternType; var i: ItemType):boolean;
extern;

procedure Pattern_GetTag(p: PatternType; var t: TagType; var n: integer);
extern;

function  Pattern_Head(p: PatternType):PosType;
extern;

procedure Pattern_Join(p1, p2: PatternType);
extern;

procedure Pattern_Last(p: PatternType);
extern;

function  Pattern_Match(p1, p2: PatternType):boolean;
extern;

function  Pattern_PosCmp(p1, p2: PatternType):CompareType;
extern;

procedure Pattern_Retrieve(p: PatternType; var i: ItemType);
extern;

procedure Pattern_SetTag(p: PatternType; t: TagType; n: integer);
extern;

function  Pattern_Single(p: PatternType):boolean;
extern;

function  Pattern_Size(p: PatternType):integer;
I 2
(* Returns the size of [p] in words. *)
E 2
extern;

procedure Pattern_Split(p1, p2: PatternType; n: integer);
(* Truncates [p1] to a size of [n] while the remainder is copied to
** [p2]. [n] must be greater than 0 and smaller than the size of [p1].
*)
extern;

function  Pattern_StickyHead(p: PatternType):boolean;
extern;

function  Pattern_StickyTail(p: PatternType):boolean;
extern;

procedure Pattern_Stretch(p: PatternType);
extern;

function  Pattern_Subset(p1, p2: PatternType):boolean;
extern;

procedure Pattern_Update(p: PatternType; i: ItemType);
extern;

function  Pattern_Valid(p: PatternType):boolean;
extern;

#endif	(* not PATTERN_H *)
E 1
