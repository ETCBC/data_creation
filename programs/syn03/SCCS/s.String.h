h13072
s 00002/00002/00024
d D 1.4 16/04/12 16:45:54 const 4 3
c STRING_SIZE should be scaled to MAX_WORDS_PATM
e
s 00001/00001/00025
d D 1.3 99/05/04 17:58:36 const 3 2
c A string size of 128 is not sufficient for Judges 1:27.
e
s 00006/00001/00020
d D 1.2 99/03/25 10:38:46 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00021/00000/00000
d D 1.1 99/02/16 14:13:45 const 1 0
c date and time created 99/02/16 14:13:45 by const
e
u
U
f e 0
f m dapro/syn03/String.h
t
T
I 1
#ifndef	STRING_H
#define	STRING_H

D 4
(* ident "%Z%%M% %I% %G%" *)
E 4
I 4
(* ident "%W% %E%" *)
E 4

I 2
#include        <Compare.h>

E 2
const
D 2
   STRING_SIZE = 80;
E 2
I 2
D 3
   STRING_SIZE = 128;
E 3
I 3
D 4
   STRING_SIZE = 192;
E 4
I 4
   STRING_SIZE = 206;	(* LABEL_LENGTH + 4 * MAX_WORDS_PATM *)
E 4
E 3
E 2

type
   StringType =
      varying [STRING_SIZE] of char;


I 2
function  String_Compare(var s1, s2: StringType):CompareType;
extern;

E 2
function  String_End(var s: StringType):char;
extern;

procedure String_Pad(var s: StringType);
(* Pads the unused part of [s] with spaces *)
extern;

#endif	(* not STRING_H *)
E 1
