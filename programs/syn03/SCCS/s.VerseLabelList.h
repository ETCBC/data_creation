h35987
s 00047/00000/00000
d D 1.1 99/02/16 14:13:51 const 1 0
c date and time created 99/02/16 14:13:51 by const
e
u
U
f e 0
f m dapro/syn03/VerseLabelList.h
t
T
I 1
#ifndef	VERSELABELLIST_H
#define	VERSELABELLIST_H

(* ident "%Z%%M% %I% %G%" *)

#include <Compare.h>
#include <VerseLabel.h>

type
   VerseLabelNodePointer =
      ^ VerseLabelNode;
   VerseLabelNode =
      record
	 value: VerseLabelType;
	 next:  VerseLabelNodePointer;
	 prior: VerseLabelNodePointer
      end;
   VerseLabelListInstance =
      record
	 head:    VerseLabelNodePointer;
	 current: VerseLabelNodePointer;
	 tail:    VerseLabelNodePointer;
	 length:  integer
      end;
   VerseLabelListType =
      ^ VerseLabelListInstance;

procedure VerseLabelList_Add(l: VerseLabelListType; v: VerseLabelType);
extern;

procedure VerseLabelList_Copy(l1, l2: VerseLabelListType);
extern;

procedure VerseLabelList_Create(var l: VerseLabelListType);
extern;

procedure VerseLabelList_Delete(var l: VerseLabelListType);
extern;

function  VerseLabelList_Length(l: VerseLabelListType):integer;
extern;

procedure VerseLabelList_Merge(l1, l2: VerseLabelListType);
(* Weaves the elements of l2 into l1, leaving l2 behind empty. *)
extern;

#endif	(* not VERSELABELLIST_H *)
E 1
