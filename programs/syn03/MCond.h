#ifndef	MCOND_H
#define	MCOND_H

(* ident "@(#)dapro/syn03/MCond.h 1.1 02/16/99" *)

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
