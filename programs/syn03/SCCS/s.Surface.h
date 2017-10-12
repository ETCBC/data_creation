h22935
s 00002/00000/00074
d D 1.2 99/03/25 10:38:47 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00074/00000/00000
d D 1.1 99/02/16 14:13:46 const 1 0
c date and time created 99/02/16 14:13:46 by const
e
u
U
f e 0
f m dapro/syn03/Surface.h
t
T
I 1
#ifndef	SURFACE_H
#define	SURFACE_H

(* ident "%Z%%M% %I% %G%" *)

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
I 2
(* Returns the length of [s] in words. *)
E 2
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
I 2
(* Returns the string value of the current element, which must exist. *)
E 2
extern;

#endif	(* not SURFACE_H *)
E 1
