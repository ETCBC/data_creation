#ifndef	INTLIST_H
#define	INTLIST_H

(* ident "@(#)dapro/syn03/IntList.h 1.1 02/16/99" *)

#include <Compare.h>

type
   IntNodePointer =
      ^ IntNode;
   IntNode =
      record
	 value: integer;
	 next:  IntNodePointer;
	 prior: IntNodePointer
      end;
   IntListInstance =
      record
	 head:    IntNodePointer;
	 current: IntNodePointer;
	 tail:    IntNodePointer;
	 length:  integer
      end;
   IntListType =
      ^ IntListInstance;

procedure IntList_Add(l: IntListType; i: integer);
extern;

function  IntList_Bottom(l: IntListType):boolean;
(* [l] is not empty and the last element is current. *)
extern;

procedure IntList_Clear(l: IntListType);
extern;

function  IntList_Compare(l1, l2: IntListType):CompareType;
extern;

procedure IntList_Copy(l1, l2: IntListType);
extern;

procedure IntList_Create(var l: IntListType);
extern;

function  IntList_Current(l: IntListType):integer;
extern;

procedure IntList_Cut(l: IntListType);
extern;

procedure IntList_Delete(var l: IntListType);
extern;

function  IntList_End(l: IntListType):boolean;
extern;

procedure IntList_First(l: IntListType);
extern;

function  IntList_Get(l: IntListType; var i: integer):boolean;
extern;

function  IntList_Head(l: IntListType):integer;
extern;

procedure IntList_Join(l1, l2: IntListType);
extern;

procedure IntList_Last(l: IntListType);
extern;

function  IntList_Length(l: IntListType):integer;
extern;

function  IntList_Listed(l: IntListType; i: integer):boolean; 
extern;

procedure IntList_Next(l: IntListType);
extern;

procedure IntList_Retrieve(l: IntListType; var i: integer);
extern;

procedure IntList_Split(l1, l2: IntListType; n: integer);
extern;

procedure IntList_Update(l: IntListType; i: integer);
extern;

#endif	(* not INTLIST_H *)
