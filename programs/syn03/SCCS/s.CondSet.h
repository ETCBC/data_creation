h48334
s 00002/00001/00060
d D 1.2 15/04/29 15:38:39 const 2 1
c Needed to generate condition 205 (same lexeme) for parsephrases(1)
e
s 00061/00000/00000
d D 1.1 99/02/16 14:13:23 const 1 0
c date and time created 99/02/16 14:13:23 by const
e
u
U
f e 0
f m dapro/syn03/CondSet.h
t
T
I 1
#ifndef	CONDSET_H
#define	CONDSET_H

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
(* ident "%W% %E%" *)
E 2

#include <Compare.h>

const
   LC_OFFSET = 100;
I 2
   LEX_EQUAL = 205;
E 2

type
   ConditionNodePointer =
      ^ ConditionNode;
   ConditionNode =
      record
	 value: integer;
	 next:  ConditionNodePointer
      end;
   CondSetInstance =
      record
	 head:    ConditionNodePointer;
	 current: ConditionNodePointer;
	 size:    integer
      end;
   CondSetType =
      ^ CondSetInstance;

procedure CondSet_Add(s: CondSetType; c: integer);
extern;

procedure CondSet_Clear(s: CondSetType);
extern;

function  CondSet_Compare(s1, s2: CondSetType):CompareType;
extern;

procedure CondSet_Copy(s1, s2: CondSetType);
extern;

procedure CondSet_Create(var s: CondSetType);
extern;

procedure CondSet_Delete(var s: CondSetType);
extern;

procedure CondSet_First(s: CondSetType);
extern;

procedure CondSet_Next(s: CondSetType);
extern;

procedure CondSet_Retrieve(s: CondSetType; var c: integer);
extern;

function  CondSet_Size(s: CondSetType):integer;
extern;

function  CondSet_Subset(s1, s2: CondSetType):boolean;
extern;

#endif	(* not CONDSET_H *)
E 1
