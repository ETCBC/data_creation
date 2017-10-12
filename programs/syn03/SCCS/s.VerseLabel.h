h25803
s 00005/00001/00034
d D 1.2 16/02/29 15:19:09 const 2 1
c Verse label " 1QS 01,01" appears garbled in 1QS1.pps
e
s 00035/00000/00000
d D 1.1 99/02/16 14:13:50 const 1 0
c date and time created 99/02/16 14:13:50 by const
e
u
U
f e 0
f m dapro/syn03/VerseLabel.h
t
T
I 1
#ifndef	VERSELABEL_H
#define	VERSELABEL_H

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
(* ident "%W% %E%" *)
E 2

#include	<Compare.h>

const
   VERSELABEL_LENGTH = 10;
type
   VerseLabelIndexType =
      1 .. VERSELABEL_LENGTH;
   VerseLabelType =
      packed array [VerseLabelIndexType] of char;


procedure VerseLabel_Clear(var v: VerseLabelType);
extern;

function  VerseLabel_Compare(var v1, v2: VerseLabelType):CompareType;
extern;

procedure VerseLabel_Copy(var v1, v2: VerseLabelType);
extern;

function  VerseLabel_Empty(var v: VerseLabelType):boolean;
extern;

function  VerseLabel_Read(var f: text; var v: VerseLabelType):boolean;
extern;

I 2
function  VerseLabel_VIndex(var v: VerseLabelType):integer;
(* Return the index where the verse part of the label starts *)
extern;

E 2
procedure VerseLabel_Write(var f: text; var v: VerseLabelType);
extern;

#endif	(* not VERSELABEL_H *)
E 1
