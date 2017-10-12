#ifndef	LOCI_H
#define	LOCI_H

(* ident "@(#)dapro/syn03/Loci.h 1.1 03/25/99" *)

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
