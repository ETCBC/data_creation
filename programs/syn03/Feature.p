module Feature;

(* ident "@(#)dapro/syn03/Feature.p	1.11 15/03/25" *)

#include <Feature.h>


function Feature(n: integer):FeatureType;
(* pre -- (ord(Feature_First) <= n) and (n <= ord(Feature_Last)) *)
begin
   if n = 0 then
      Feature := Feature_First
   else
      Feature := succ(Feature(n - 1))
end;


function  Feature_IsVal(f: FeatureType; i: integer):boolean;
begin
   case f of
      lxs, prf, vbs, vbe, nme, sfx:
	 Feature_IsVal := true;
      vbt, prs, num, gen:
	 Feature_IsVal := true;
      sta:
	 Feature_IsVal := (Sta_NA <= i) and (i <= Sta_Emph);
      pos, pdp:
	 Feature_IsVal := (ord(Pos_First) <= i) and (i <= ord(Pos_Last));
      typ:
	 Feature_IsVal := (abs(i) <= Typ_Last);
      det:
	 Feature_IsVal := (abs(i) = 1) or (i = Det_Det);
   end
end;


function Feature_String(f: FeatureType):StringType;
begin
   case f of
      lxs: Feature_String := 'lexical set';
      pos: Feature_String := 'part of speech';
      prf: Feature_String := 'preformative';
      vbs: Feature_String := 'verbal stem';
      vbe: Feature_String := 'verbal ending';
      nme: Feature_String := 'nominal ending';
      sfx: Feature_String := 'pronominal suffix';
      vbt: Feature_String := 'verbal tense';
      prs: Feature_String := 'person';
      num: Feature_String := 'number';
      gen: Feature_String := 'gender';
      sta: Feature_String := 'state';
      pdp: Feature_String := 'phrase dependent part of speech';
      typ: Feature_String := 'phrase type';
      det: Feature_String := 'phrase determination'
   end
end;


function  Feature_StrVal(f: FeatureType; i: integer):StringType;
begin
   case f of
      lxs, prf, vbs, vbe, nme, sfx:
	 Feature_StrVal := '';
      vbt, prs, num, gen:
	 Feature_StrVal := '';
      sta:
	 case i of
	    Sta_Abs:  Feature_StrVal :=  'abs';
	    Sta_Con:  Feature_StrVal := 'cstr';
	    Sta_Emph: Feature_StrVal := 'emph';
	    Sta_NA:   Feature_StrVal :=  'n/a';
	    Sta_Unk:  Feature_StrVal := 'unkn'
	 end;
      pos, pdp:
	 case i of
	    ord(adjv): Feature_StrVal := 'adjv';
	    ord(advb): Feature_StrVal := 'advb';
	    ord(conj): Feature_StrVal := 'conj';
	    ord(dart): Feature_StrVal := 'dart';
	    ord(inrg): Feature_StrVal := 'inrg';
	    ord(intj): Feature_StrVal := 'intj';
	    ord(nega): Feature_StrVal := 'nega';
	    ord(nmpr): Feature_StrVal := 'nmpr';
	    ord(prde): Feature_StrVal := 'prde';
	    ord(prep): Feature_StrVal := 'prep';
	    ord(prin): Feature_StrVal := 'prin';
	    ord(prps): Feature_StrVal := 'prps';
	    ord(subs): Feature_StrVal := 'subs';
	    ord(verb): Feature_StrVal := 'verb'
	 end;
      typ:
	 case abs(i) of
            Typ_AdjP: Feature_StrVal := 'AdjP';
            Typ_AdvP: Feature_StrVal := 'AdvP';
            Typ_CP:   Feature_StrVal :=   'CP';
            Typ_DPrP: Feature_StrVal := 'DPrP';
            Typ_IPrP: Feature_StrVal := 'IPrP';
            Typ_InjP: Feature_StrVal := 'InjP';
            Typ_InrP: Feature_StrVal := 'InrP';
            Typ_NP:   Feature_StrVal :=   'NP';
            Typ_NegP: Feature_StrVal := 'NegP';
            Typ_PP:   Feature_StrVal :=   'PP';
            Typ_PPrP: Feature_StrVal := 'PPrP';
            Typ_PrNP: Feature_StrVal := 'PrNP';
            Typ_VP:   Feature_StrVal :=   'VP';
            Typ_none: Feature_StrVal := 'none'
	 end;
      det:
	 case i of
	    Det_Det: Feature_StrVal := 'det';
	    Det_NA:  Feature_StrVal := 'n/a';
	    Det_Und: Feature_StrVal := 'und'
	 end
   end
end;


function Feature_Width(f: FeatureType):integer;
begin
   case f of
      pos:
	 Feature_Width := 3;
      vbt:
	 Feature_Width := 4;
      sta:
	 Feature_Width := 5;
   otherwise
      if f < sta then
	 Feature_Width := 2
      else
	 Feature_Width := 3
   end
end;


function Pos(n: integer):PosType;
(* pre -- (ord(Pos_First) <= n) and (n <= ord(Pos_Last)) *)
begin
   if n = 0 then
      Pos := Pos_First
   else
      Pos := succ(Pos(n - 1))
end;


function Pos_State(p: integer; s: integer):boolean;
begin
   if not Feature_IsVal(pos, p) then
      Pos_State := false
   else begin
      case Pos(p) of
	 dart:
	    Pos_State := s = Sta_NA;
	 verb:
	    Pos_State := Feature_IsVal(sta, s);
	 subs:
	    Pos_State := s in [Sta_Unk, Sta_Con, Sta_Abs, Sta_Emph];
	 nmpr:
	    Pos_State := s = Sta_Abs;
	 advb:
	    Pos_State := s = Sta_NA;
	 prep:
	    Pos_State := s = Sta_NA;
	 conj:
	    Pos_State := s = Sta_NA;
	 prps:
	    Pos_State := s = Sta_NA;
	 prde:
	    Pos_State := s = Sta_NA;
	 prin:
	    Pos_State := s = Sta_NA;
	 intj:
	    Pos_State := s = Sta_NA;
	 nega:
	    Pos_State := s = Sta_NA;
	 inrg:
	    Pos_State := s = Sta_NA;
	 adjv:
	    Pos_State := Pos_State(ord(subs), s)
      end
   end
end;


private
function trpos(p1, p2: PosType):boolean;
begin
   if p1 = p2 then
      trpos := true
   else begin
      case p1 of
	 dart:
	    trpos := trpos(conj, p2);
	 verb:
	    trpos := trpos(adjv, p2);
	 subs:
	    trpos := trpos(nmpr, p2) or		(* MIP.AD.@N *)
		     trpos(advb, p2) or		(* <OWD *)
		     trpos(prep, p2) or		(* >AX:AR;J *)
		     trpos(intj, p2) or		(* QOWL *)
		     trpos(nega, p2);		(* >;JN *)
	 nmpr:
	    trpos := trpos(advb, p2);		(* B.@BEL@H *)
	 advb:
	    trpos := false;
	 prep:
	    trpos := trpos(conj, p2);		(* D.IJ *)
	 conj:
	    trpos := false;
	 prps:
	    trpos := trpos(prde, p2);		(* HW.> *)
	 prde:
	    trpos := trpos(advb, p2) or		(* ZEH `now' *)
		     trpos(conj, p2);		(* ZEH `which' *)
	 prin:
	    trpos := trpos(inrg, p2);		(* MAH `how' *)
	 intj:
	    trpos := false;
	 nega:
	    trpos := false;
	 inrg:
	    trpos := false;
	 adjv:
	    trpos := trpos(subs, p2)
      end
   end
end;


function Pos_Trans(n1, n2: integer):boolean;
begin
   if not Feature_IsVal(pos, n1) or not Feature_IsVal(pos, n2) then
      Pos_Trans := false
   else
      Pos_Trans := trpos(Pos(n1), Pos(n2))
end;


function Sta_Trans(s1, s2: integer):boolean;
begin
   if not Feature_IsVal(sta, s1) or not Feature_IsVal(sta, s2) then
      Sta_Trans := false
   else
      Sta_Trans :=
	 (s1 = s2) or
	 ((s1 = Sta_Unk) and (s2 in [Sta_Con, Sta_Abs, Sta_Emph]))
end;


function Typ_Trans(t1, t2: integer):boolean;
begin
   if t1 = t2 then
      Typ_Trans := true
   else begin
      case t1 of
	 Typ_NP:
	    Typ_Trans :=
	       Typ_Trans(Typ_AdvP, t2) or	   (* <OWD *)
	       Typ_Trans(Typ_PP, t2);		   (* >AR:Y@H *)
	 Typ_PrNP:
	    Typ_Trans :=
	       Typ_Trans(Typ_AdvP, t2) or	   (* MIY:R@J:M@H *)
	       Typ_Trans(Typ_PP, t2);		   (* MIY:R@J:M@H *)
	 Typ_PP:
	    Typ_Trans := Typ_Trans(Typ_CP, t2);	   (* B.:VEREM *)
	 Typ_IPrP:
	    Typ_Trans := Typ_Trans(Typ_InrP, t2);  (* MAH Z.O>T *)
      otherwise
	 Typ_Trans := false
      end
   end
end;
