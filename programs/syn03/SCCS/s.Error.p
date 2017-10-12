h51661
s 00002/00000/00050
d D 1.3 10/07/24 15:04:54 const 3 2
c Adjusted state, determination, and proper noun transitions.
e
s 00002/00002/00048
d D 1.2 07/05/24 15:27:12 const 2 1
c Fixed exit status.
e
s 00050/00000/00000
d D 1.1 99/02/16 14:13:28 const 1 0
c date and time created 99/02/16 14:13:28 by const
e
u
U
f e 0
f m dapro/syn03/Error.p
t
T
I 1
module Error;

(* ident "%Z%%M% %I% %G%" *)

#include <Error.h>

var
   Errno: integer;


procedure Error_Set(n: integer);
begin
   Errno := n
end;


function Error_String:StringType;
begin
   case Errno of
      ENOERR:
	 Error_String := 'no error';
      EHEAPP:
	 Error_String := 'apposition at head';
      ENOPOS:
	 Error_String := 'not a value for part of speech';
      ETRPOS:
	 Error_String := 'illegal part of speech transition';
      ENOSTA:
	 Error_String := 'not a value for state';
      ENOPDP:
	 Error_String := 'not a value for phrase dependent part of speech';
      ENOTYP:
	 Error_String := 'not a value for phrase type';
      EPHTYP:
	 Error_String := 'incompatible phrase type';
      ENODET:
	 Error_String := 'not a value for determination';
      ESTPOS:
	 Error_String := 'state incompatible with part of speech';
      ETRSTA:
	 Error_String := 'illegal state transition';
I 3
      EUNSTA:
	 Error_String := 'state should not remain unknown';
E 3
   end
end;


procedure Panic(s: StringType);
begin
D 2
   writeln('syn03: unexpected error in ', s, ', ask help.');
   halt
E 2
I 2
   message('syn03: unexpected error in ', s, ', ask help.');
   pcexit(1)
E 2
end;
E 1
