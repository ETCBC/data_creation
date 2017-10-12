h26969
s 00080/00000/00000
d D 1.1 99/02/16 14:13:25 const 1 0
c date and time created 99/02/16 14:13:25 by const
e
u
U
f e 0
f m dapro/syn03/CondSetList.h
t
T
I 1
#ifndef	CONDSETLIST_H
#define	CONDSETLIST_H

(* ident "%Z%%M% %I% %G%" *)

#include <CondSet.h>

type
   CondSetNodePointer =
      ^ CondSetNode;
   CondSetNode =
      record
	 cs:    CondSetType;
	 next:  CondSetNodePointer;
	 prior: CondSetNodePointer
      end;
   CondSetListInstance =
      record
	 head:    CondSetNodePointer;
	 current: CondSetNodePointer;
	 tail:    CondSetNodePointer;
	 size:    integer;
	 length:  integer
      end;
   CondSetListType =
      ^ CondSetListInstance;

procedure CondSetList_Add(l: CondSetListType; s: CondSetType);
extern;

procedure CondSetList_Clear(l: CondSetListType);
extern;

procedure CondSetList_Copy(l1, l2: CondSetListType);
extern;

procedure CondSetList_Create(var l: CondSetListType);
extern;

function  CondSetList_Current(l: CondSetListType):CondSetType;
(* Returns a pointer to the current element. *)
extern;

procedure CondSetList_Cut(l: CondSetListType);
extern;

procedure CondSetList_Delete(var l: CondSetListType);
extern;

procedure CondSetList_First(l: CondSetListType);
extern;

function  CondSetList_Get(l: CondSetListType; var s: CondSetType):boolean;
extern;

procedure CondSetList_Join(l1, l2: CondSetListType);
extern;

procedure CondSetList_Last(l: CondSetListType);
extern;

procedure CondSetList_Next(l: CondSetListType);
extern;

procedure CondSetList_Retrieve(l: CondSetListType; var s: CondSetType);
extern;

function  CondSetList_Size(l: CondSetListType):integer;
extern;

procedure CondSetList_Split(l1, l2: CondSetListType; n: integer);
extern;

function  CondSetList_Subset(l1, l2: CondSetListType):boolean;
extern;

procedure CondSetList_Update(l: CondSetListType; s: CondSetType);
extern;

#endif	(* not CONDSETLIST_H *)
E 1
