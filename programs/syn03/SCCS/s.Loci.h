h29290
s 00059/00000/00000
d D 1.1 99/03/25 10:32:27 const 1 0
c date and time created 99/03/25 10:32:27 by const
e
u
U
f e 0
f m dapro/syn03/Loci.h
t
T
I 1
#ifndef	LOCI_H
#define	LOCI_H

(* ident "%Z%%M% %I% %G%" *)

#include <Compare.h>
#include <Locus.h>

type
   LocusNodePointer =
      ^ LocusNode;
   LocusNode =
      record
	 value: LocusType;
	 next:  LocusNodePointer;
	 prior: LocusNodePointer
      end;
   LociInstance =
      record
	 head:    LocusNodePointer;
	 current: LocusNodePointer;
	 tail:    LocusNodePointer;
	 length:  integer
      end;
   LociType =
      ^ LociInstance;

procedure Loci_Add(l: LociType; p: LocusType);
extern;

procedure Loci_Copy(l1, l2: LociType);
extern;

procedure Loci_Create(var l: LociType);
extern;

function  Loci_Current(l: LociType):LocusType;
extern;

procedure Loci_Delete(var l: LociType);
extern;

function  Loci_End(l: LociType):boolean;
extern;

procedure Loci_First(l: LociType);
extern;

function  Loci_Length(l: LociType):integer;
extern;

procedure Loci_Merge(l1, l2: LociType);
(* Weaves the elements of l2 into l1, leaving l2 behind empty. *)
extern;

procedure Loci_Next(l: LociType);
extern;

#endif	(* not LOCI_H *)
E 1
