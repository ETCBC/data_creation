h09612
s 00045/00000/00000
d D 1.1 99/02/16 14:13:40 const 1 0
c date and time created 99/02/16 14:13:40 by const
e
u
U
f e 0
f m dapro/syn03/MCond.h
t
T
I 1
#ifndef	MCOND_H
#define	MCOND_H

(* ident "%Z%%M% %I% %G%" *)

#include <Feature.h>
#include <IntList.h>

type
   MCondInstance =
      record
	 feat: FeatureType;
	 vlst: IntListType
      end;
   MCondType =
      ^ MCondInstance;

procedure MCond_Add(var m: MCondType; v: integer);
extern;

procedure MCond_Clear(var m: MCondType);
extern;

procedure MCond_Copy(var m1, m2: MCondType);
extern;

procedure MCond_Create(var m: MCondType);
extern;

procedure MCond_Delete(var m: MCondType);
extern;

procedure MCond_GetFeature(m: MCondType; var f: FeatureType);
extern;

procedure MCond_SetFeature(var m: MCondType; f: FeatureType);
extern;

function  MCond_Size(m: MCondType):integer;
extern;

function  MCond_Test(m: MCondType; v: integer):boolean;
extern;

#endif	(* not MCOND_H *)
E 1
