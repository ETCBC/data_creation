#ifndef	ATOMLIST_H
#define	ATOMLIST_H

(* ident "@(#)dapro/syn03/AtomList.h 1.1 02/16/99" *)

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
