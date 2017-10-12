#ifndef	FEATURE_H
#define	FEATURE_H

(* ident "@(#)dapro/syn03/Feature.h	1.3 07/02/08" *)

#include <String.h>

type
   FeatureType = (
      lxs, pos, prf, vbs, vbe, nme, sfx, vbt, prs, num, gen, sta, pdp,
      typ, det
   );
   PosType = (
      dart, verb, subs, nmpr, advb, prep, conj, prps, prde, prin, intj,
      nega, inrg, adjv
   );

const
   Det_NA = -1;
   Det_Und = 1;
   Det_Det = 2;
   Feature_First = lxs;
   Feature_Last = det;
   Pos_First = dart;
   Pos_Last = adjv;
   Sta_NA = -1;
   Sta_Unk = 0;
   Sta_Con = 1;
   Sta_Abs = 2;
   Sta_Emph = 3;
   Typ_none = 0;
   Typ_First = 1;
   Typ_VP = 1;
   Typ_NP = 2;
   Typ_PrNP = 3;
   Typ_AdvP = 4;
   Typ_PP = 5;
   Typ_CP = 6;
   Typ_PPrP = 7;
   Typ_DPrP = 8;
   Typ_IPrP = 9;
   Typ_InjP = 10;
   Typ_NegP = 11;
   Typ_InrP = 12;
   Typ_AdjP = 13;
   Typ_Last = 13;


function  Feature(n: integer):FeatureType;
extern;

function  Feature_IsVal(f: FeatureType; i: integer):boolean;
extern;

function  Feature_StrVal(f: FeatureType; i: integer):StringType;
extern;

function  Feature_String(f: FeatureType):StringType;
extern;

function  Feature_Width(f: FeatureType):integer;
extern;

function  Pos(n: integer):PosType;
extern;

function  Pos_State(p: integer; s: integer):boolean;
(* Returns true when [p] allows a state [s] *)
extern;

function  Pos_Trans(n1, n2: integer):boolean;
(* Returns true when n1 --> n2 is a valid part of speech transition *)
extern;

function  Sta_Trans(s1, s2: integer):boolean;
(* Returns true when s1 --> s2 is a valid state transition *)
extern;

function  Typ_Trans(t1, t2: integer):boolean;
extern;

#endif	(* not FEATURE_H *)
