h25262
s 00008/00005/00216
d D 1.4 15/04/29 15:38:39 const 4 3
c Needed to generate condition 205 (same lexeme) for parsephrases(1)
e
s 00006/00002/00215
d D 1.3 99/04/14 11:05:20 const 3 2
c Bug in Grammar_Label and Pattern_StickyTail. Cleaned up code.
e
s 00010/00010/00207
d D 1.2 99/03/25 10:38:39 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00217/00000/00000
d D 1.1 99/02/16 14:13:32 const 1 0
c date and time created 99/02/16 14:13:32 by const
e
u
U
f e 0
f m dapro/syn03/Grammar.p
t
T
I 1
module Grammar;

D 4
(* ident "%Z%%M% %I% %G%" *)
E 4
I 4
(* ident "%W% %E%" *)
E 4

#include <Error.h>
#include <Grammar.h>
#include <IO.h>


procedure Grammar_Add(g: GrammarType; p: PatternType);
var
D 2
   l: VerseLabelListType;
E 2
I 2
   l: LociType;
E 2
begin
   with g^ do
      if not PhraseSet_FindSub(pset, p) then begin
D 2
	 VerseLabelList_Create(l);
E 2
I 2
	 Loci_Create(l);
E 2
	 while PhraseSet_FindSup(pset, p) do begin
D 2
	    VerseLabelList_Merge(l, PhraseSet_RefVLL(pset));
E 2
I 2
	    Loci_Merge(l, PhraseSet_RefLoci(pset));
E 2
	    PhraseSet_Remove(pset)
	 end;
	 PhraseSet_Add(pset, p);
D 2
	 PhraseSet_SetVLL(pset, l);
	 VerseLabelList_Delete(l)
E 2
I 2
	 PhraseSet_SetLoci(pset, l);
	 Loci_Delete(l)
E 2
      end
end;


procedure Grammar_Create(var g: GrammarType);
begin
   new(g);
   with g^ do begin
      LCTable_Create(ltab);
      MCTable_Create(mtab);
      PhraseSet_Create(pset)
   end
end;


procedure Grammar_Delete(var g: GrammarType);
begin
   with g^ do begin
      LCTable_Delete(ltab);
      MCTable_Delete(mtab);
      PhraseSet_Delete(pset)
   end;
   dispose(g)
end;


D 4
procedure Grammar_WC(g: GrammarType; w: WordType; c: CondSetType);
E 4
I 4
procedure Grammar_WC(g: GrammarType; w0, w1: WordType; c: CondSetType);
E 4
var
   f: FeatureType;
   l1, l2: LexemeType;
   m: MCondType;
   n: integer;
   v: integer;
begin
   MCond_Create(m);
   CondSet_Clear(c);
   with g^ do begin
      for n := 1 to MCTable_Size(mtab) do begin
	 if MCTable_Exist(mtab, n) then begin
	    MCTable_Retrieve(mtab, m, n);
	    MCond_GetFeature(m, f);
D 4
	    Word_GetFeature(w, f, v);
E 4
I 4
	    Word_GetFeature(w1, f, v);
E 4
	    if MCond_Test(m, v) then
	       CondSet_Add(c, n)
	 end
      end;
I 4
      Word_GetLexeme(w1, l2);
E 4
      for n := 1 to LCTable_Size(ltab) do begin
	 if LCTable_Exist(ltab, n) then begin
	    LCTable_Retrieve(ltab, l1, n);
D 4
	    Word_GetLexeme(w, l2);
E 4
	    if Lexeme_Compare(l1, l2) = equal then
	       CondSet_Add(c, n + LC_OFFSET)
	 end
D 4
      end
E 4
I 4
      end;
      Word_GetLexeme(w0, l1);
      if Lexeme_Compare(l1, l2) = equal then
	 CondSet_Add(c, LEX_EQUAL)
E 4
   end;
   MCond_Delete(m)
end;


procedure Grammar_Match(g: GrammarType; p1, p2: PatternType);
var
   p: PatternType;
begin
   Pattern_Create(p);
   Pattern_Copy(p, p1);
   with g^ do begin
      while not PhraseSet_Match(pset, p) do
	 Pattern_Chip(p);
      PhraseSet_Retrieve(pset, p)
   end;
   Pattern_Copy(p2, p);
   Pattern_Delete(p)
end;


procedure Grammar_Read(g: GrammarType; var ps, mc, lc: FileType);
var
   i: PosType;
   n: integer;
   p: PatternType;
   tick: array[PosType] of boolean;
begin
   n := 0;
   Read_LCTable(lc, g^.ltab);
   Read_MCTable(mc, g^.mtab);
   for i := Pos_First to Pos_Last do
      tick[i] := false;
   Pattern_Create(p);
   while not File_EOF(ps) do begin
      n := n + 1;
      Read_Pattern(ps, p, g^.ltab, g^.mtab);
      Pattern_SetTag(p, t_set, n);
      if not Pattern_Valid(p) then begin
	 write('syn03: rejected pattern ');
D 3
	 Write_Tag(output, t_set, n, 0);
E 3
I 3
	 Print_Tag(output, t_set, n, 0);
E 3
	 writeln(': ', Error_String)
      end else begin
	 if Pattern_Single(p) then
	    tick[Pattern_Head(p)] := true;
	 Grammar_Add(g, p)
      end;
      File_ReadLine(ps)
   end;
   Pattern_Delete(p);
   for i := Pos_First to Pos_Last do
      if not tick[i] then begin
	 write('syn03: phrase set lacks single pattern for <');
	 writeln(Feature_StrVal(pos, ord(i)), '>');
	 Quit
      end
end;


function Grammar_Rematch(g: GrammarType; p1, p2: PatternType):boolean;
var
   p: PatternType;
begin
   Pattern_Create(p);
   Pattern_Copy(p, p1);
   with g^ do begin
      while (Pattern_Size(p) > 1) and not PhraseSet_FindPat(pset, p) do
	 (* Overcome joined patterns not in phrase set *)
	 Pattern_Chip(p);
      while (Pattern_Size(p) > 0) and not PhraseSet_Rematch(pset, p) do
	 Pattern_Chip(p);
      if Pattern_Size(p) = 0 then
	 Grammar_Rematch := false
      else begin
	 PhraseSet_Retrieve(pset, p);
	 Grammar_Rematch := true
      end
   end;
   Pattern_Copy(p2, p);
   Pattern_Delete(p)
end;


procedure Grammar_Remove(g: GrammarType; p: PatternType);
begin
   with g^ do
      if not Pattern_Single(p) and PhraseSet_FindPat(pset, p) then
	 PhraseSet_Remove(pset)
end;


D 2
procedure Grammar_Label(g: GrammarType; p: PatternType; l: VerseLabelType);
E 2
I 2
procedure Grammar_Label(g: GrammarType; p: PatternType; l: LocusType);
E 2
begin
   with g^ do
D 3
      if PhraseSet_FindPat(pset, p) then
E 3
I 3
      if PhraseSet_FindSub(pset, p) then
E 3
	 PhraseSet_Label(pset, l)
I 3
      else begin
	 write('WARNING: not matched in grammar: ');
	 Print_Pattern(output, p)
      end
E 3
end;


procedure Grammar_Report(g: GrammarType; var f: FileType);
var
   p: PatternType;
D 2
   l: VerseLabelListType;
E 2
I 2
   l: LociType;
E 2
   freq, line: integer;
begin
   Pattern_Create(p);
   with g^ do begin
      PhraseSet_First(pset);
      line := 0;
      repeat
	 line := line + 1;
D 2
	 l := PhraseSet_RefVLL(pset);
	 freq := VerseLabelList_Length(l);
E 2
I 2
	 l := PhraseSet_RefLoci(pset);
	 freq := Loci_Length(l);
E 2
	 if freq > 0 then begin
	    PhraseSet_Retrieve(pset, p);
	    Write_ReportPattern(f, p, line, freq);
D 2
	    Write_VerseLabelList(f, l)
E 2
I 2
	    Write_Loci(f, l)
E 2
	 end
      until not PhraseSet_Next(pset);
   end;
   Pattern_Delete(p)
end;


procedure Grammar_Write(g: GrammarType; var ps: FileType);
var
   p: PatternType;
begin
   Pattern_Create(p);
   with g^ do begin
      PhraseSet_First(pset);
      repeat
	 PhraseSet_Retrieve(pset, p);
	 Write_Pattern(ps, p)
      until not PhraseSet_Next(pset);
   (* MCTable_Write(mc, mtab); *)
   (* LCTable_Write(lc, ltab); *)
   end;
   Pattern_Delete(p)
end;
E 1
