module Error;

(* ident "@(#)dapro/syn03/Error.p 1.3 07/24/10" *)

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
      EUNSTA:
	 Error_String := 'state should not remain unknown';
   end
end;


procedure Panic(s: StringType);
begin
   message('syn03: unexpected error in ', s, ', ask help.');
   pcexit(1)
end;
