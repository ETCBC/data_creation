module MCTable;

(* ident "@(#)dapro/syn03/MCTable.p 1.1 02/16/99" *)

#include <MCTable.h>


procedure MCTable_Create(var t: MCTableType);
var
   i: MCTableIndexType;
begin
   new(t);
   with t^ do begin
      for i := 1 to MCTABLE_SIZE do
	 tbl[i] := nil;
      siz := 0
   end
end;


procedure MCTable_Delete(var t: MCTableType);
var
   i: MCTableIndexType;
begin
   with t^ do
      for i := 1 to siz do
	 if tbl[i] <> nil then
	    MCond_Delete(tbl[i]);
   dispose(t);
   t := nil
end;


function MCTable_Exist(t: MCTableType; n: MCTableIndexType):boolean;
begin
   MCTable_Exist := t^.tbl[n] <> nil
end;


function MCTable_InRange(n: integer):boolean;
begin
   MCTable_InRange := (1 <= n) and (n <= MCTABLE_SIZE)
end;


procedure MCTable_Retrieve(t: MCTableType; c: MCondType; n: MCTableIndexType);
begin
   with t^ do begin
      if tbl[n] <> nil then
	 MCond_Copy(c, tbl[n])
   end
end;


function MCTable_Size(t: MCTableType):MCTableIndexType;
begin
   MCTable_Size := t^.siz
end;


procedure MCTable_Store(t: MCTableType; c: MCondType; n: MCTableIndexType);
begin
   with t^ do begin
      if tbl[n] = nil then
	 MCond_Create(tbl[n]);
      MCond_Copy(tbl[n], c);
      if n > siz then
	 siz := n
   end
end;
