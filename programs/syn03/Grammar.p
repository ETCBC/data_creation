module Grammar;

(* ident "@(#)dapro/syn03/Grammar.p	1.4 15/04/29" *)

#include <Error.h>
#include <Grammar.h>
#include <IO.h>


procedure Grammar_Add(g: GrammarType; p: PatternType);
var
   l: LociType;
begin
   with g^ do
      if not PhraseSet_FindSub(pset, p) then begin
	 Loci_Create(l);
	 while PhraseSet_FindSup(pset, p) do begin
	    Loci_Merge(l, PhraseSet_RefLoci(pset));
	    PhraseSet_Remove(pset)
	 end;
	 PhraseSet_Add(pset, p);
	 PhraseSet_SetLoci(pset, l);
	 Loci_Delete(l)
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


procedure Grammar_WC(g: GrammarType; w0, w1: WordType; c: CondSetType);
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
	    Word_GetFeature(w1, f, v);
	    if MCond_Test(m, v) then
	       CondSet_Add(c, n)
	 end
      end;
      Word_GetLexeme(w1, l2);
      for n := 1 to LCTable_Size(ltab) do begin
	 if LCTable_Exist(ltab, n) then begin
	    LCTable_Retrieve(ltab, l1, n);
	    if Lexeme_Compare(l1, l2) = equal then
	       CondSet_Add(c, n + LC_OFFSET)
	 end
      end;
      Word_GetLexeme(w0, l1);
      if Lexeme_Compare(l1, l2) = equal then
	 CondSet_Add(c, LEX_EQUAL)
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
	 Print_Tag(output, t_set, n, 0);
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


procedure Grammar_Label(g: GrammarType; p: PatternType; l: LocusType);
begin
   with g^ do
      if PhraseSet_FindSub(pset, p) then
	 PhraseSet_Label(pset, l)
      else begin
	 write('WARNING: not matched in grammar: ');
	 Print_Pattern(output, p)
      end
end;


procedure Grammar_Report(g: GrammarType; var f: FileType);
var
   p: PatternType;
   l: LociType;
   freq, line: integer;
begin
   Pattern_Create(p);
   with g^ do begin
      PhraseSet_First(pset);
      line := 0;
      repeat
	 line := line + 1;
	 l := PhraseSet_RefLoci(pset);
	 freq := Loci_Length(l);
	 if freq > 0 then begin
	    PhraseSet_Retrieve(pset, p);
	    Write_ReportPattern(f, p, line, freq);
	    Write_Loci(f, l)
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
