#ifndef	LCTABLE_H
#define	LCTABLE_H

(* ident "@(#)dapro/syn03/LCTable.h 1.1 02/16/99" *)

#include <Lexeme.h>

const
   LCTABLE_SIZE = 99;

type
   LCTableIndexType =
      0 .. LCTABLE_SIZE;
   LCTableInstance =
      record
	 tbl: array [1 .. LCTABLE_SIZE] of LexemeType;
	 siz: LCTableIndexType
      end;
   LCTableType =
      ^ LCTableInstance;

procedure LCTable_Create(var t: LCTableType);
extern;

procedure LCTable_Delete(var t: LCTableType);
extern;

function  LCTable_Exist(t: LCTableType; n: LCTableIndexType):boolean;
extern;

function  LCTable_InRange(n: integer):boolean;
(* Returns whether [n] can be used as LCTableIndexType. *)
extern;

procedure LCTable_Retrieve(t: LCTableType; var l: LexemeType; n: LCTableIndexType);
extern;

function  LCTable_Size(t: LCTableType):LCTableIndexType;
extern;

procedure LCTable_Store(t: LCTableType; l: LexemeType; n: LCTableIndexType);
extern;

#endif	(* not LCTABLE_H *)
