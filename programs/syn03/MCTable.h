#ifndef	MCTABLE_H
#define	MCTABLE_H

(* ident "@(#)dapro/syn03/MCTable.h 1.1 02/16/99" *)

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
