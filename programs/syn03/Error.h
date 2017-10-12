#ifndef	ERROR_H
#define	ERROR_H

(* ident "@(#)dapro/syn03/Error.h 1.2 07/24/10" *)

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
   EUNSTA = 11;

procedure Error_Set(n: integer);
extern;

function  Error_String:StringType;
extern;

procedure Panic(s: StringType);
extern;

procedure Quit;
extern;

#endif	(* not ERROR_H *)
