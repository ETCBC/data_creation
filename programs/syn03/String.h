#ifndef	STRING_H
#define	STRING_H

(* ident "@(#)dapro/syn03/String.h	1.4 16/04/12" *)

#include        <Compare.h>

const
   STRING_SIZE = 206;	(* LABEL_LENGTH + 4 * MAX_WORDS_PATM *)

type
   StringType =
      varying [STRING_SIZE] of char;


function  String_Compare(var s1, s2: StringType):CompareType;
extern;

function  String_End(var s: StringType):char;
extern;

procedure String_Pad(var s: StringType);
(* Pads the unused part of [s] with spaces *)
extern;

#endif	(* not STRING_H *)
