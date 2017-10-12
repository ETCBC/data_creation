#ifndef	VERSELABEL_H
#define	VERSELABEL_H

(* ident "@(#)dapro/syn03/VerseLabel.h	1.2 16/02/29" *)

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

function  VerseLabel_VIndex(var v: VerseLabelType):integer;
(* Return the index where the verse part of the label starts *)
extern;

procedure VerseLabel_Write(var f: text; var v: VerseLabelType);
extern;

#endif	(* not VERSELABEL_H *)
