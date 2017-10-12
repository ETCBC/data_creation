#ifndef	ATOM_H
#define	ATOM_H

(* ident "@(#)dapro/syn03/Atom.h	1.2 15/09/14" *)

#include <IntList.h>
#include <Word.h>

type
   AtomInstance =
      record
	 sta: IntListType;
	 pdp: IntListType;
	 typ: integer;
	 det: integer
      end;
   AtomType =
      ^ AtomInstance;

procedure Atom_Add(a: AtomType; state, speech: integer);
extern;

function  Atom_Apposition(a: AtomType):boolean;
extern;

function  Atom_Assign(a1, a2: AtomType):boolean;
extern;

procedure Atom_Clear(a: AtomType);
extern;

function  Atom_Compare(a1, a2: AtomType):CompareType;
extern;

procedure Atom_Copy(a1, a2: AtomType);
extern;

procedure Atom_Create(var a: AtomType);
extern;

procedure Atom_Cut(a: AtomType);
extern;

function  Atom_DefDet(a: AtomType):integer;
(* Returns the default value for determination for [a]. *)
extern;

function  Atom_DefTyp(a: AtomType):integer;
(* Returns the default value for phrase atom type for [a].
   Post: the current element is undefined. *)
extern;

procedure Atom_Delete(var a: AtomType);
extern;

function  Atom_Determination(a: AtomType):integer;
extern;

function  Atom_End(a: AtomType):boolean;
extern;

procedure Atom_First(a: AtomType);
extern;

function  Atom_Get(a: AtomType; var state, speech: integer):boolean;
extern;

procedure Atom_Join(a1, a2: AtomType);
extern;

procedure Atom_Last(a: AtomType);
extern;

procedure Atom_Next(a: AtomType);
extern;

procedure Atom_Retrieve(a: AtomType; var state, speech: integer);
extern;

procedure Atom_SetApp(a: AtomType; app: boolean);
extern;

procedure Atom_SetDet(a: AtomType; det: integer);
extern;

procedure Atom_SetTyp(a: AtomType; typ: integer);
extern;

function  Atom_Size(a: AtomType):integer;
extern;

procedure Atom_Split(a1, a2: AtomType; n: integer);
extern;

procedure Atom_ToWord(a: AtomType; w: WordType);
extern;

function  Atom_Type(a: AtomType):integer;
extern;

procedure Atom_Update(a: AtomType; state, speech: integer);
extern;

function  Atom_Valid(a: AtomType):boolean;
extern;

function  Atom_ValTyp(a: AtomType; t: integer):boolean;
extern;

#endif	(* not ATOM_H *)
