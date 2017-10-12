#ifndef	CONDSET_H
#define	CONDSET_H

(* ident "@(#)dapro/syn03/CondSet.h	1.2 15/04/29" *)

#include <Compare.h>

const
   LC_OFFSET = 100;
   LEX_EQUAL = 205;

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
