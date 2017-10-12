h10171
s 00043/00000/00000
d D 1.1 99/03/25 10:32:28 const 1 0
c date and time created 99/03/25 10:32:28 by const
e
u
U
f e 0
f m dapro/syn03/Locus.h
t
T
I 1
#ifndef	LOCUS_H
#define	LOCUS_H

(* ident "%Z%%M% %I% %G%" *)

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
E 1
