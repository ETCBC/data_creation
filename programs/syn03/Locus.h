#ifndef	LOCUS_H
#define	LOCUS_H

(* ident "@(#)dapro/syn03/Locus.h 1.1 03/25/99" *)

#include <Compare.h>
#include <String.h>
#include <VerseLabel.h>

type
   LocusInstance =
      record
	 lab: VerseLabelType;
	 txt: StringType
      end;
   LocusType =
      ^ LocusInstance;

function  Locus_Compare(l1, l2: LocusType):CompareType;
extern;

procedure Locus_Copy(l1, l2: LocusType);
extern;

procedure Locus_Create(var l: LocusType);
extern;

procedure Locus_Delete(var l: LocusType);
extern;

procedure Locus_GetLabel(l: LocusType; var vl: VerseLabelType);
extern;

procedure Locus_String(l: LocusType; var s: StringType);
extern;

procedure Locus_SetLabel(l: LocusType; var vl: VerseLabelType);
extern;

procedure Locus_SetText(l: LocusType; var t: StringType);
extern;

#endif	(* not LOCUS_H *)
