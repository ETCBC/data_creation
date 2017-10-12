h45235
s 00003/00000/00020
d D 1.2 99/03/25 10:38:35 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00020/00000/00000
d D 1.1 99/02/16 14:13:22 const 1 0
c date and time created 99/02/16 14:13:22 by const
e
u
U
f e 0
f m dapro/syn03/Compare.h
t
T
I 1
#ifndef	COMPARE_H
#define	COMPARE_H

(* ident "%Z%%M% %I% %G%" *)

type
   CompareType =
      (less, equal, greater);


function  Compare(i1, i2: integer):CompareType;
extern;

function  Digit(c: char):boolean;
extern;

I 2
function  Letter(c: char):boolean;
extern;

E 2
function  Space(c: char):boolean;
extern;

#endif	(* not COMPARE_H *)
E 1
