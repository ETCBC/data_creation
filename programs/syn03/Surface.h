#ifndef	SURFACE_H
#define	SURFACE_H

(* ident "@(#)dapro/syn03/Surface.h 1.2 03/25/99" *)

#include <String.h>
#include <VerseLabel.h>

type
   StringNodePointer =
      ^ StringNode;
   StringNode =
      record
	 wrd:   StringType;
	 next:  StringNodePointer;
	 prior: StringNodePointer
      end;
   SurfaceInstance =
      record
	 head:    StringNodePointer;
	 current: StringNodePointer;
	 mark:    StringNodePointer;
	 tail:    StringNodePointer;
	 lab:     VerseLabelType;
	 length:  integer
      end;
   SurfaceType =
      ^ SurfaceInstance;

procedure Surface_Add(s: SurfaceType; w: StringType);
extern;

procedure Surface_Clear(s: SurfaceType);
extern;

procedure Surface_Create(var s: SurfaceType);
extern;

procedure Surface_Delete(var s: SurfaceType);
extern;

procedure Surface_First(s: SurfaceType);
extern;

procedure Surface_GetLabel(s: SurfaceType; var l: VerseLabelType);
extern;

procedure Surface_Jump(s: SurfaceType);
(* The word last marked becomes the current. *)
extern;

function  Surface_Length(s: SurfaceType):integer;
(* Returns the length of [s] in words. *)
extern;

procedure Surface_Mark(s: SurfaceType);
(* The jump mark is set to the current. *)
extern;

procedure Surface_Next(s: SurfaceType);
extern;

procedure Surface_Prior(s: SurfaceType);
extern;

procedure Surface_Retrieve(s: SurfaceType; var w: StringType);
extern;

procedure Surface_SetLabel(var s: SurfaceType; l: VerseLabelType);
extern;

function  Surface_String(s: SurfaceType):StringType;
(* Returns the string value of the current element, which must exist. *)
extern;

#endif	(* not SURFACE_H *)
