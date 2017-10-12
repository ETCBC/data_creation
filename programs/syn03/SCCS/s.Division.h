h38547
s 00002/00000/00103
d D 1.2 99/03/25 10:38:37 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00103/00000/00000
d D 1.1 99/02/16 14:13:26 const 1 0
c date and time created 99/02/16 14:13:26 by const
e
u
U
f e 0
f m dapro/syn03/Division.h
t
T
I 1
#ifndef	DIVISION_H
#define	DIVISION_H

(* ident "%Z%%M% %I% %G%" *)

#include <AtomList.h>
#include <Pattern.h>
#include <VerseLabel.h>

type
   PatternNodePointer =
      ^ PatternNode;
   PatternNode =
      record
	 pat:   PatternType;
	 next:  PatternNodePointer;
	 prior: PatternNodePointer
      end;
   DivisionInstance =
      record
	 head:    PatternNodePointer;
	 current: PatternNodePointer;
	 tail:    PatternNodePointer;
	 lab:     VerseLabelType;
	 size:    integer;
	 length:  integer
      end;
   DivisionType =
      ^ DivisionInstance;

procedure Division_Add(d: DivisionType; p: PatternType);
extern;

procedure Division_Atomise(d: DivisionType; l: AtomListType);
(* Does not care about verse labels. *)
extern;

procedure Division_Create(var d: DivisionType);
extern;

procedure Division_Cut(d: DivisionType);
(* Removes the current up to the last pattern of [d]. The new tail
** becomes the current pattern.
*)
extern;

procedure Division_Delete(var d: DivisionType);
extern;

function  Division_End(d: DivisionType):boolean;
extern;

function  Division_Find(d: DivisionType; p: PatternType):boolean;
(* If true, then the first occurrence of [p] is the current. If false,
** no pattern is the current.
*)
extern;

procedure Division_First(d: DivisionType);
extern;

function  Division_Get(d: DivisionType; p: PatternType):boolean;
extern;

procedure Division_GetLabel(d: DivisionType; var v: VerseLabelType);
extern;

procedure Division_Stretch(d: DivisionType);
(* Joins the patterns from the current to the last into one
** single-itemed pattern, which becomes the current.
*)
extern;

procedure Division_Last(d: DivisionType);
extern;

function  Division_Length(d: DivisionType):integer;
I 2
(* Returns the length of [d] in patterns. *)
E 2
extern;

procedure Division_Next(d: DivisionType);
extern;

procedure Division_Prior(d: DivisionType);
extern;

procedure Division_Retrieve(d: DivisionType; p: PatternType);
extern;

procedure Division_SetLabel(d: DivisionType; var v: VerseLabelType);
extern;

function  Division_Size(d: DivisionType):integer;
I 2
(* Returns the size of [d] in words. *)
E 2
extern;

procedure Division_Split(d: DivisionType; n: integer);
(* Pre: [n] must not be greater than the size of the current pattern of
** [d]. If the size of the current pattern is greater than [n], then
** the current pattern is split into a pattern of size [n] and a second
** part which will become the current pattern of [d].
*)
extern;

#endif	(* not DIVISION_H *)
E 1
