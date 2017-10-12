h21949
s 00044/00000/00000
d D 1.1 99/02/16 14:13:39 const 1 0
c date and time created 99/02/16 14:13:39 by const
e
u
U
f e 0
f m dapro/syn03/MCTable.h
t
T
I 1
#ifndef	MCTABLE_H
#define	MCTABLE_H

(* ident "%Z%%M% %I% %G%" *)

#include <MCond.h>

const
   MCTABLE_SIZE = 99;	(* The maximum number of morphological conditions *)

type
   MCTableIndexType =
      0 .. MCTABLE_SIZE;
   MCTableInstance =
      record
	 tbl: array [1 .. MCTABLE_SIZE] of MCondType;
	 siz: MCTableIndexType
      end;
   MCTableType =
      ^ MCTableInstance;

procedure MCTable_Create(var t: MCTableType);
extern;

procedure MCTable_Delete(var t: MCTableType);
extern;

function  MCTable_Exist(t: MCTableType; n: MCTableIndexType):boolean;
extern;

function  MCTable_InRange(n: integer):boolean;
(* Returns whether [n] can be used as MCTableIndexType. *)
extern;

procedure MCTable_Retrieve(t: MCTableType; c: MCondType; n: MCTableIndexType);
extern;

function  MCTable_Size(t: MCTableType):MCTableIndexType;
extern;

procedure MCTable_Store(t: MCTableType; c: MCondType; n: MCTableIndexType);
extern;

#endif	(* not MCTABLE_H *)
E 1
