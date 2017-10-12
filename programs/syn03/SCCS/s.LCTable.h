h18075
s 00044/00000/00000
d D 1.1 99/02/16 14:13:36 const 1 0
c date and time created 99/02/16 14:13:36 by const
e
u
U
f e 0
f m dapro/syn03/LCTable.h
t
T
I 1
#ifndef	LCTABLE_H
#define	LCTABLE_H

(* ident "%Z%%M% %I% %G%" *)

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
E 1
