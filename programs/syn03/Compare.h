#ifndef	COMPARE_H
#define	COMPARE_H

(* ident "@(#)dapro/syn03/Compare.h 1.2 03/25/99" *)

type
   CompareType =
      (less, equal, greater);


function  Compare(i1, i2: integer):CompareType;
extern;

function  Digit(c: char):boolean;
extern;

function  Letter(c: char):boolean;
extern;

function  Space(c: char):boolean;
extern;

#endif	(* not COMPARE_H *)
