h08157
s 00003/00002/00107
d D 1.2 15/09/14 16:30:50 const 2 1
c Enclitic phrases need to be sticky, when enclitics have word status.
e
s 00109/00000/00000
d D 1.1 99/02/16 14:13:20 const 1 0
c date and time created 99/02/16 14:13:20 by const
e
u
U
f e 0
f m dapro/syn03/Atom.h
t
T
I 1
#ifndef	ATOM_H
#define	ATOM_H

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
(* ident "%W% %E%" *)
E 2

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
D 2
(* Returns the default value for phrase atom type for [a]. *)
E 2
I 2
(* Returns the default value for phrase atom type for [a].
   Post: the current element is undefined. *)
E 2
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
E 1
