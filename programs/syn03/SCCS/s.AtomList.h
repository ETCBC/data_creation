h57479
s 00069/00000/00000
d D 1.1 99/02/16 14:13:21 const 1 0
c date and time created 99/02/16 14:13:21 by const
e
u
U
f e 0
f m dapro/syn03/AtomList.h
t
T
I 1
#ifndef	ATOMLIST_H
#define	ATOMLIST_H

(* ident "%Z%%M% %I% %G%" *)

#include <Atom.h>
#include <VerseLabel.h>

type
   AtomNodePointer =
      ^ AtomNode;
   AtomNode =
      record
	 atom:  AtomType;
	 next:  AtomNodePointer;
	 prior: AtomNodePointer
      end;
   AtomListInstance =
      record
	 head:    AtomNodePointer;
	 current: AtomNodePointer;
	 tail:    AtomNodePointer;
	 lab:     VerseLabelType;
	 size:    integer;
	 length:  integer
      end;
   AtomListType =
      ^ AtomListInstance;

procedure AtomList_Add(l: AtomListType; a: AtomType);
extern;

procedure AtomList_Cat(l1, l2: AtomListType);
extern;

procedure AtomList_Clear(l: AtomListType);
extern;

procedure AtomList_Create(var l: AtomListType);
extern;

procedure AtomList_Delete(var l: AtomListType);
extern;

function  AtomList_End(l: AtomListType):boolean;
extern;

procedure AtomList_First(l: AtomListType);
extern;

function  AtomList_Get(l: AtomListType; a: AtomType):boolean;
extern;

procedure AtomList_GetLabel(l: AtomListType; var v: VerseLabelType);
extern;

procedure AtomList_Next(l: AtomListType);
extern;

procedure AtomList_Retrieve(l: AtomListType; a: AtomType);
extern;

procedure AtomList_SetLabel(l: AtomListType; var v: VerseLabelType);
extern;

function  AtomList_Size(l: AtomListType):integer;
extern;

#endif	(* not ATOMLIST_H *)
E 1
