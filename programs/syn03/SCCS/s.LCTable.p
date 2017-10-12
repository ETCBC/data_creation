h24333
s 00058/00000/00000
d D 1.1 99/02/16 14:13:37 const 1 0
c date and time created 99/02/16 14:13:37 by const
e
u
U
f e 0
f m dapro/syn03/LCTable.p
t
T
I 1
module LCTable;

(* ident "%Z%%M% %I% %G%" *)

#include <LCTable.h>


procedure LCTable_Create(var t: LCTableType);
var
   i: LCTableIndexType;
begin
   new(t);
   with t^ do begin
      for i := 1 to LCTABLE_SIZE do
	 Lexeme_Clear(tbl[i]);
      siz := 0
   end
end;

procedure LCTable_Delete(var t: LCTableType);
begin
   dispose(t);
   t := nil
end;


function LCTable_Exist(t: LCTableType; n: LCTableIndexType):boolean;
begin
   LCTable_Exist := not Lexeme_Empty(t^.tbl[n])
end;


function LCTable_InRange(n: integer):boolean;
begin
   LCTable_InRange := (1 <= n) and (n <= LCTABLE_SIZE)
end;


procedure LCTable_Retrieve(t: LCTableType; var l: LexemeType; n: LCTableIndexType);
begin
   Lexeme_Copy(l, t^.tbl[n])
end;


function LCTable_Size(t: LCTableType):LCTableIndexType;
begin
   LCTable_Size := t^.siz
end;


procedure LCTable_Store(t: LCTableType; l: LexemeType; n: LCTableIndexType);
begin
   with t^ do begin
      Lexeme_Copy(tbl[n], l);
      if n > siz then
	 siz := n
   end
end;
E 1
