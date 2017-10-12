#ifndef	PHRASESET_H
#define	PHRASESET_H

(* ident "@(#)dapro/syn03/PhraseSet.h	1.3 15/03/05" *)

#include <Loci.h>
#include <Pattern.h>

const
   PHRASESET_SIZE = 12500;
type
   PhraseSetIndexType =
      0 .. PHRASESET_SIZE;
   PhraseSetInstance =
      record
	 current: PhraseSetIndexType;
	 occurrences: array [1 .. PHRASESET_SIZE] of LociType;
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

procedure PhraseSet_Label(s: PhraseSetType; l: LocusType);
(* If there is a current pattern in [s], [l] is added to its
** list of occurences.
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

function  PhraseSet_RefLoci(s: PhraseSetType):LociType;
(* Returns a reference to the loci of the current pattern of [s], or
** nil if there is none.
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

procedure PhraseSet_SetLoci(s: PhraseSetType; l: LociType);
(* Makes [l] the loci of the current pattern of [s], if there is one. *)
extern;

#endif	(* not PHRASESET_H *)
