h50937
s 00001/00000/00033
d D 1.2 10/07/24 15:04:54 const 2 1
c Adjusted state, determination, and proper noun transitions.
e
s 00033/00000/00000
d D 1.1 99/02/16 14:13:27 const 1 0
c date and time created 99/02/16 14:13:27 by const
e
u
U
f e 0
f m dapro/syn03/Error.h
t
T
I 1
#ifndef	ERROR_H
#define	ERROR_H

(* ident "%Z%%M% %I% %G%" *)

#include <String.h>

const
   ENOERR = 0;
   EHEAPP = 1;
   ENOPOS = 2;
   ETRPOS = 3;
   ENOSTA = 4;
   ENOPDP = 5;
   ENOTYP = 6;
   EPHTYP = 7;
   ENODET = 8;
   ESTPOS = 9;
   ETRSTA = 10;
I 2
   EUNSTA = 11;
E 2

procedure Error_Set(n: integer);
extern;

function  Error_String:StringType;
extern;

procedure Panic(s: StringType);
extern;

procedure Quit;
extern;

#endif	(* not ERROR_H *)
E 1
