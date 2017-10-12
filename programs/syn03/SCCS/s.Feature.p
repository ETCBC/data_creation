h16772
s 00003/00001/00269
d D 1.11 15/03/25 15:51:51 const 12 11
c AdvP was not accepted as phrase type for phrases with a H locale
e
s 00002/00001/00268
d D 1.10 14/06/24 11:50:51 const 11 10
c Need a part of speech transition 8 -> 6 for ZH (GKC $138g)
e
s 00001/00000/00268
d D 1.9 14/06/02 11:43:22 const 10 9
c Need a part of speech transition 2 -> 10 for QWL/ (GKC $146b)
e
s 00007/00005/00261
d D 1.8 14/04/30 17:22:12 const 9 8
c Support for prin -> inrg had disappeared
e
s 00013/00012/00253
d D 1.7 14/01/17 11:52:11 const 8 7
c Add transition from prde to advb (for ZEH `now')
e
s 00002/00002/00263
d D 1.6 13/08/28 15:30:59 const 7 6
c Transition verb->intj is obsolete. Support for prin->inrg.
e
s 00003/00002/00262
d D 1.5 10/07/24 15:04:54 const 6 5
c Adjusted state, determination, and proper noun transitions.
e
s 00018/00018/00246
d D 1.4 07/02/08 10:20:30 const 5 3
c Determination applies to all nominal phrase types.
e
s 00018/00018/00246
d R 1.4 07/02/02 17:54:54 const 4 3
c 
e
s 00005/00005/00259
d D 1.3 06/10/06 17:54:15 const 3 2
c New standard abbreviations for phrase type.
e
s 00026/00024/00238
d D 1.2 02/07/20 16:08:31 const 2 1
c Added handling of emphatic state, necessary for Syriac.
e
s 00262/00000/00000
d D 1.1 99/02/16 14:13:29 const 1 0
c date and time created 99/02/16 14:13:29 by const
e
u
U
f e 0
f m dapro/syn03/Feature.p
t
T
I 1
module Feature;

D 2
(* ident "%Z%%M% %I% %G%" *)
E 2
I 2
(* ident "%W% %E%" *)
E 2

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
D 2
	 Feature_IsVal := (-1 <= i) and (i <= 2);
E 2
I 2
	 Feature_IsVal := (Sta_NA <= i) and (i <= Sta_Emph);
E 2
      pos, pdp:
	 Feature_IsVal := (ord(Pos_First) <= i) and (i <= ord(Pos_Last));
      typ:
D 2
	 Feature_IsVal := (0 <= abs(i)) and (abs(i) <= 13);
E 2
I 2
	 Feature_IsVal := (abs(i) <= Typ_Last);
E 2
      det:
D 2
	 Feature_IsVal := (abs(i) = 1) or (i = 2);
E 2
I 2
	 Feature_IsVal := (abs(i) = 1) or (i = Det_Det);
E 2
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
D 2
	    -1: Feature_StrVal :=  'n/a';
	     0: Feature_StrVal := 'unkn';
	     1: Feature_StrVal := 'cstr';
	     2: Feature_StrVal :=  'abs'
E 2
I 2
	    Sta_Abs:  Feature_StrVal :=  'abs';
	    Sta_Con:  Feature_StrVal := 'cstr';
	    Sta_Emph: Feature_StrVal := 'emph';
	    Sta_NA:   Feature_StrVal :=  'n/a';
	    Sta_Unk:  Feature_StrVal := 'unkn'
E 2
	 end;
      pos, pdp:
	 case i of
D 2
	    ord(dart): Feature_StrVal := 'dart';
	    ord(verb): Feature_StrVal := 'verb';
	    ord(subs): Feature_StrVal := 'subs';
	    ord(nmpr): Feature_StrVal := 'nmpr';
E 2
I 2
	    ord(adjv): Feature_StrVal := 'adjv';
E 2
	    ord(advb): Feature_StrVal := 'advb';
D 2
	    ord(prep): Feature_StrVal := 'prep';
E 2
	    ord(conj): Feature_StrVal := 'conj';
D 2
	    ord(prps): Feature_StrVal := 'prps';
	    ord(prde): Feature_StrVal := 'prde';
	    ord(prin): Feature_StrVal := 'prin';
E 2
I 2
	    ord(dart): Feature_StrVal := 'dart';
	    ord(inrg): Feature_StrVal := 'inrg';
E 2
	    ord(intj): Feature_StrVal := 'intj';
	    ord(nega): Feature_StrVal := 'nega';
D 2
	    ord(inrg): Feature_StrVal := 'inrg';
	    ord(adjv): Feature_StrVal := 'adjv'
E 2
I 2
	    ord(nmpr): Feature_StrVal := 'nmpr';
	    ord(prde): Feature_StrVal := 'prde';
	    ord(prep): Feature_StrVal := 'prep';
	    ord(prin): Feature_StrVal := 'prin';
	    ord(prps): Feature_StrVal := 'prps';
	    ord(subs): Feature_StrVal := 'subs';
	    ord(verb): Feature_StrVal := 'verb'
E 2
	 end;
      typ:
	 case abs(i) of
D 5
	     0: Feature_StrVal := 'none';
	     1: Feature_StrVal :=   'VP';
	     2: Feature_StrVal :=   'NP';
	     3: Feature_StrVal := 'PrNP';
	     4: Feature_StrVal := 'AdvP';
D 3
	     5: Feature_StrVal := 'PreP';
	     6: Feature_StrVal := 'ConP';
	     7: Feature_StrVal := 'PpeP';
	     8: Feature_StrVal := 'PdeP';
	     9: Feature_StrVal := 'PinP';
E 3
I 3
	     5: Feature_StrVal :=   'PP';
	     6: Feature_StrVal :=   'CP';
	     7: Feature_StrVal := 'PPrP';
	     8: Feature_StrVal := 'DPrP';
	     9: Feature_StrVal := 'IPrP';
E 3
	    10: Feature_StrVal := 'InjP';
	    11: Feature_StrVal := 'NegP';
	    12: Feature_StrVal := 'InrP';
	    13: Feature_StrVal := 'AdjP'
E 5
I 5
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
E 5
	 end;
      det:
	 case i of
D 2
	    -1: Feature_StrVal := 'n/a';
	     1: Feature_StrVal := 'und';
	     2: Feature_StrVal := 'det'
E 2
I 2
	    Det_Det: Feature_StrVal := 'det';
	    Det_NA:  Feature_StrVal := 'n/a';
	    Det_Und: Feature_StrVal := 'und'
E 2
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
D 2
	    Pos_State := s in [Sta_Unk, Sta_Con, Sta_Abs];
E 2
I 2
	    Pos_State := s in [Sta_Unk, Sta_Con, Sta_Abs, Sta_Emph];
E 2
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
D 2
	    Pos_State := s in [Sta_Unk, Sta_Con, Sta_Abs]
E 2
I 2
	    Pos_State := Pos_State(ord(subs), s)
E 2
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
D 6
	    trpos := trpos(advb, p2) or trpos(prep, p2) or trpos(nega, p2);
E 6
I 6
D 8
	    trpos := trpos(nmpr, p2) or trpos(advb, p2) or
		     trpos(prep, p2) or trpos(nega, p2);
E 8
I 8
	    trpos := trpos(nmpr, p2) or		(* MIP.AD.@N *)
		     trpos(advb, p2) or		(* <OWD *)
		     trpos(prep, p2) or		(* >AX:AR;J *)
I 10
		     trpos(intj, p2) or		(* QOWL *)
E 10
		     trpos(nega, p2);		(* >;JN *)
E 8
E 6
	 nmpr:
D 6
	    trpos := false;
E 6
I 6
D 8
	    trpos := trpos(advb, p2);
E 8
I 8
	    trpos := trpos(advb, p2);		(* B.@BEL@H *)
E 8
E 6
	 advb:
D 8
	    trpos := trpos(conj, p2);
E 8
I 8
	    trpos := false;
E 8
	 prep:
D 8
	    trpos := trpos(conj, p2);
E 8
I 8
	    trpos := trpos(conj, p2);		(* D.IJ *)
E 8
	 conj:
	    trpos := false;
	 prps:
D 8
	    trpos := trpos(prde, p2);
E 8
I 8
	    trpos := trpos(prde, p2);		(* HW.> *)
E 8
	 prde:
D 8
	    trpos := false;
E 8
I 8
D 11
	    trpos := trpos(advb, p2);		(* ZEH `now' *)
E 11
I 11
	    trpos := trpos(advb, p2) or		(* ZEH `now' *)
		     trpos(conj, p2);		(* ZEH `which' *)
E 11
E 8
	 prin:
D 9
	    trpos := false;
E 9
I 9
	    trpos := trpos(inrg, p2);		(* MAH `how' *)
E 9
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
D 2
	 (s1 = s2) or ((s1 = Sta_Unk) and (s2 in [Sta_Con, Sta_Abs]))
E 2
I 2
	 (s1 = s2) or
	 ((s1 = Sta_Unk) and (s2 in [Sta_Con, Sta_Abs, Sta_Emph]))
E 2
end;


function Typ_Trans(t1, t2: integer):boolean;
begin
   if t1 = t2 then
      Typ_Trans := true
   else begin
      case t1 of
D 7
	 Typ_VP:
	    Typ_Trans := Typ_Trans(Typ_InjP, t2);
E 7
	 Typ_NP:
	    Typ_Trans :=
D 5
	       Typ_Trans(Typ_AdvP, t2) or Typ_Trans(Typ_PreP, t2);
E 5
I 5
D 8
	       Typ_Trans(Typ_AdvP, t2) or Typ_Trans(Typ_PP, t2);
E 8
I 8
D 9
	       Typ_Trans(Typ_AdvP, t2) or	(* <OWD *)
	       Typ_Trans(Typ_PP, t2);		(* >AR:Y@H *)
E 9
I 9
	       Typ_Trans(Typ_AdvP, t2) or	   (* <OWD *)
	       Typ_Trans(Typ_PP, t2);		   (* >AR:Y@H *)
E 9
E 8
E 5
	 Typ_PrNP:
D 5
	    Typ_Trans := Typ_Trans(Typ_PreP, t2);
	 Typ_PreP:
	    Typ_Trans := Typ_Trans(Typ_ConP, t2);
E 5
I 5
D 8
	    Typ_Trans := Typ_Trans(Typ_PP, t2);
E 8
I 8
D 9
	    Typ_Trans := Typ_Trans(Typ_PP, t2);	(* MIY:R@J:M@H *)
E 9
I 9
D 12
	    Typ_Trans := Typ_Trans(Typ_PP, t2);	   (* MIY:R@J:M@H *)
E 12
I 12
	    Typ_Trans :=
	       Typ_Trans(Typ_AdvP, t2) or	   (* MIY:R@J:M@H *)
	       Typ_Trans(Typ_PP, t2);		   (* MIY:R@J:M@H *)
E 12
E 9
E 8
	 Typ_PP:
D 8
	    Typ_Trans := Typ_Trans(Typ_CP, t2);
I 7
	 Typ_IPrP:
	    Typ_Trans := Typ_Trans(Typ_InrP, t2);
E 8
I 8
D 9
	    Typ_Trans := Typ_Trans(Typ_CP, t2);	(* B.:VEREM *)
E 9
I 9
	    Typ_Trans := Typ_Trans(Typ_CP, t2);	   (* B.:VEREM *)
	 Typ_IPrP:
	    Typ_Trans := Typ_Trans(Typ_InrP, t2);  (* MAH Z.O>T *)
E 9
E 8
E 7
E 5
      otherwise
	 Typ_Trans := false
      end
   end
end;
E 1
