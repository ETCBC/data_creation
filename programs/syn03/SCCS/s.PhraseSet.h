h07203
s 00002/00002/00120
d D 1.3 15/03/05 14:28:56 const 3 2
c Synchronised phrase set size with parsephrases.p
e
s 00009/00011/00113
d D 1.2 99/03/25 10:38:44 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00124/00000/00000
d D 1.1 99/02/16 14:13:43 const 1 0
c date and time created 99/02/16 14:13:43 by const
e
u
U
f e 0
f m dapro/syn03/PhraseSet.h
t
T
I 1
#ifndef	PHRASESET_H
#define	PHRASESET_H

D 3
(* ident "%Z%%M% %I% %G%" *)
E 3
I 3
(* ident "%W% %E%" *)
E 3

I 2
#include <Loci.h>
E 2
#include <Pattern.h>
D 2
#include <VerseLabelList.h>
E 2

const
D 3
   PHRASESET_SIZE = 8191;
E 3
I 3
   PHRASESET_SIZE = 12500;
E 3
type
   PhraseSetIndexType =
      0 .. PHRASESET_SIZE;
   PhraseSetInstance =
      record
	 current: PhraseSetIndexType;
D 2
	 labels: array [1 .. PHRASESET_SIZE] of VerseLabelListType;
E 2
I 2
	 occurrences: array [1 .. PHRASESET_SIZE] of LociType;
E 2
	 patterns: array [1 .. PHRASESET_SIZE] of PatternType;
	 size: PhraseSetIndexType
      end;
   PhraseSetType =
      ^ PhraseSetInstance;

(* Phrase set integrity:
**
** - Well defined current.
** - Patterns are sorted.
** - All patterns are unique.
**
** We are not bothered here by ensuring that single patterns are
** preserved, that is a job for the Grammar module.
*)

procedure PhraseSet_Add(s: PhraseSetType; p: PatternType);
(* [p] is added to [s] and becomes the current. *)
extern;

procedure PhraseSet_Create(var s: PhraseSetType);
extern;

procedure PhraseSet_Delete(var s: PhraseSetType);
extern;

function  PhraseSet_FindPat(s: PhraseSetType; p: PatternType):boolean;
(* Looks for a pattern in [s] that is identical to [p]. If found then
** that pattern becomes the current pattern in [s], otherwise the
** greatest pattern in [s] smaller than [p] becomes the current pattern.
** If no such pattern exists in [s], no pattern in [s] will be marked as
** the current.
*)
extern;

function  PhraseSet_FindSub(s: PhraseSetType; p: PatternType):boolean;
(* Looks for the smallest pattern in [s] that is a subset of [p].
** If found then that pattern becomes the current pattern of [s].
** [s] remains unchanged otherwise.
** Finding a subset differs from finding a match in that the value of
** the phrase atoms do play a role.
*)
extern;

function  PhraseSet_FindSup(s: PhraseSetType; p: PatternType):boolean;
(* Looks for the greatest pattern in [s] that is a superset of [p].
** If found then that pattern becomes the current pattern of [s].
** [s] remains unchanged otherwise.
*)
extern;

procedure PhraseSet_First(s: PhraseSetType);
(* If [s] is not empty, then the smallest pattern of [s] becomes the
** current. Otherwise, no pattern in [s] will be marked as the current.
*)
extern;

D 2
procedure PhraseSet_Label(s: PhraseSetType; l: VerseLabelType);
E 2
I 2
procedure PhraseSet_Label(s: PhraseSetType; l: LocusType);
E 2
(* If there is a current pattern in [s], [l] is added to its
D 2
** list of verse labels.
E 2
I 2
** list of occurences.
E 2
*)
extern;

function  PhraseSet_Match(s: PhraseSetType; p: PatternType):boolean;
(* Looks for the greatest pattern in [s] that matches [p].
** If found then that pattern becomes the current pattern of [s].
** [s] remains unchanged otherwise.
*)
extern;

function  PhraseSet_Next(s: PhraseSetType):boolean;
(* If [s] has a current pattern which is not the greatest, then the
** smallest pattern greater than the current becomes the current and
** true is returned, otherwise false is returned and [s] remains
** unchanged.
*)
extern;

D 2
function  PhraseSet_RefVLL(s: PhraseSetType):VerseLabelListType;
(* Returns a reference to the verse label list of the current pattern of
** [s], or nil if there is none.
E 2
I 2
function  PhraseSet_RefLoci(s: PhraseSetType):LociType;
(* Returns a reference to the loci of the current pattern of [s], or
** nil if there is none.
E 2
*)
extern;

function  PhraseSet_Rematch(s: PhraseSetType; p: PatternType):boolean;
(* Looks for the greatest pattern in [s] that matches [p] and is smaller
** than the current pattern of [s]. If found then that pattern becomes
** the current pattern of [s]. Otherwise [s] remains unchanged and false
** is returned.
*)
extern;

procedure PhraseSet_Remove(s: PhraseSetType);
(* If there is a current pattern in [s], it is removed. *)
extern;

procedure PhraseSet_Retrieve(s: PhraseSetType; p: PatternType);
(* If there is a current pattern in [s], it is copied to [p]. *)
extern;

D 2
procedure PhraseSet_SetVLL(s: PhraseSetType; l: VerseLabelListType);
(* Makes [l] the verse label list of the current pattern of [s], if
** there is one.
*)
E 2
I 2
procedure PhraseSet_SetLoci(s: PhraseSetType; l: LociType);
(* Makes [l] the loci of the current pattern of [s], if there is one. *)
E 2
extern;

#endif	(* not PHRASESET_H *)
E 1
