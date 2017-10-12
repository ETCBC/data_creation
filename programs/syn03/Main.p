program syn03;

(* ident "@(#)dapro/syn03/Main.p	1.7 15/09/14" *)

#include <AtomList.h>
#include <Division.h>
#include <Error.h>
#include <File.h>
#include <Grammar.h>
#include <IO.h>
#include <Locus.h>
#include <Surface.h>
#include <User.h>
#include <Verse.h>

const
   STAGE = 3;

var
   Finished:  boolean;
   Grammar:   GrammarType;
   NPC_Div: integer;		(* New Pattern Count from file *)
   NPC_Join: integer;		(* New Pattern Count from join *)
   NPC_User: integer;		(* New Pattern Count from user *)
   StageFile: FileType;
   TextName:  StringType;


procedure Quit;
begin
   message('syn03: exiting with status 1');
   pcexit(1)
end;


procedure CheckVerseSurface(v: VerseType; s: SurfaceType);
var
   surface_label, verse_label: VerseLabelType;
begin
   Verse_GetLabel(v, verse_label);
   Surface_GetLabel(s, surface_label);
   if VerseLabel_Compare(verse_label, surface_label) <> equal then begin
      write('syn03: ');
      VerseLabel_Write(output, verse_label);
      writeln(': surface text has a different verse label');
      Quit
   end;
   if Verse_Length(v) <> Surface_Length(s) then begin
      write('syn03: ');
      VerseLabel_Write(output, verse_label);
      writeln(': surface text does not match the verse');
      Quit
   end
end;


procedure RejectPos(l: VerseLabelType; w: WordType);
begin
   writeln('syn03: state incompatible with part of speech');
   VerseLabel_Write(output, l);
   write(' ');
   Print_Word(output, w);
   writeln;
   Quit
end;


procedure DivisionFromVerse(g: GrammarType; v: VerseType; d: DivisionType);
(* pre - [d] is empty *)
var
   condition_set: CondSetType;
   item: ItemType;
   pattern: PatternType;
   lexset, speech, state, suffix: integer;
   verse_label: VerseLabelType;
   prev, word: WordType;
begin
   Word_Create(prev);
   Word_Create(word);
   Item_Create(item);
   Pattern_Create(pattern);
   CondSet_Create(condition_set);
   Verse_GetLabel(v, verse_label);
   Verse_First(v);
   while not Verse_End(v) do begin
      Verse_Retrieve(v, word);
      Word_GetFeature(word, lxs, lexset);
      Word_GetFeature(word, pos, speech);
      Word_GetFeature(word, sfx, suffix);
      Grammar_WC(g, prev, word, condition_set);
      Word_GetFeature(word, sta, state);
      if Pos_State(speech, state) then
	 Item_Add(item, lexset, speech, ord(suffix > 0), condition_set, state, speech)
      else
	 RejectPos(verse_label, word);
      Word_Copy(prev, word);
      Verse_Next(v)
   end;
   CondSet_Delete(condition_set);
   Pattern_Add(pattern, item);
   Division_Add(d, pattern);
   Pattern_Delete(pattern);
   Item_Delete(item);
   Word_Delete(word);
   Word_Delete(prev)
end;


procedure CheckLabels(v: VerseType; a: AtomListType);
var
   la, lv: VerseLabelType;
begin
   Verse_GetLabel(v, lv);
   AtomList_GetLabel(a, la);
   if VerseLabel_Compare(lv, la) <> equal then begin
      write('WARNING: verse label in ps2, "');
      VerseLabel_Write(output, lv);
      write('", does not match "');
      VerseLabel_Write(output, la);
      writeln('" in phd.');
      writeln('WARNING: using the label from ps2 for the new npd.');
      AtomList_SetLabel(a, lv)
   end
end;


procedure AtomsToVerse(v: VerseType; l: AtomListType);
var
   a: AtomType;
   w: WordType;
begin
   Atom_Create(a);
   Word_Create(w);
   if Verse_Length(v) <> AtomList_Size(l) then
      Panic('AtomsToVerse');
   Verse_First(v);
   AtomList_First(l);
   while AtomList_Get(l, a) do begin
      Atom_First(a);
      while not Atom_End(a) do begin
	 Verse_Retrieve(v, w);
	 Atom_ToWord(a, w);
	 Verse_Update(v, w);
	 Atom_Next(a);
	 Verse_Next(v)
      end
   end;
   Word_Delete(w);
   Atom_Delete(a)
end;


function Combination(d0, d1: DivisionType; p0, p1: PatternType):boolean;
begin
   Combination :=
      Pattern_StickyTail(p0) or
      Pattern_StickyHead(p1) or
      Pattern_StickyTail(p1) and
      (Division_Size(d1) + Pattern_Size(p1) = Division_Size(d0))
end;


procedure NewPattern(g: GrammarType; d0, d1: DivisionType; p: PatternType);
(* Pre: [p] is a valid pattern && d1->current == d1->last *)
var
   q: PatternType;
begin
   if (Division_Length(d0) > 1) and (Division_Length(d1) > 0) then begin
      Pattern_Create(q);
      Division_Retrieve(d1, q);
      if Combination(d0, d1, q, p) then begin
	 Pattern_Join(q, p);
	 Division_Prior(d0);
	 Division_Stretch(d0);
	 Division_Cut(d1);
	 Pattern_Copy(p, q)
      end;
      Pattern_Delete(q)
   end;
   Division_Add(d1, p);
   Division_Split(d0, Pattern_Size(p));
   if not (Pattern_StickyHead(p) or Pattern_StickyTail(p)) then
      Grammar_Add(g, p)
end;


procedure FindAllDivisions(g: GrammarType; d0, d1: DivisionType);
(* pre - d0.current = d1.end, d0.current is stretched *)
var
   p, q: PatternType;
begin
   Pattern_Create(p);
   Pattern_Create(q);
   while Division_Size(d1) <> Division_Size(d0) do begin
      Division_Retrieve(d0, p);
      Grammar_Match(g, p, q);
      NewPattern(g, d0, d1, q)
   end;
   Pattern_Delete(q);
   Pattern_Delete(p)
end;


function FindAltPhrase(g: GrammarType; d0, d1: DivisionType; p: PatternType):boolean;
var
   q: PatternType;
begin
   Pattern_Create(q);
   if not Grammar_Rematch(g, p, q) then
      FindAltPhrase := false
   else begin
      NewPattern(g, d0, d1, q);
      FindAltPhrase := true
   end;
   Pattern_Delete(q)
end;


procedure RejectAtom(n: integer);
begin
   write('NOTE: rejected atom ', n:1, 'd: ');
   writeln(Error_String)
end;


procedure UndoDivisions(g: GrammarType; d0, d1: DivisionType; p: PatternType);
begin
   Division_Cut(d1);
   Division_First(d0);
   Division_First(d1);
   while not Division_End(d1) do begin
      Division_Next(d0);
      Division_Next(d1)
   end;
   Division_Stretch(d0);
   Division_Last(d1);
   Grammar_Remove(g, p)
end;


procedure FileDivisions(g: GrammarType; a: AtomListType; d0, d1: DivisionType);
(* Pre: length(d0) == 1 && size(d0) > 0 && length(d1) == 0 *)
var
   atom: AtomType;
   failed: boolean;
   item: ItemType;
   pattern: PatternType;
begin
   Pattern_Create(pattern);
   Item_Create(item);
   Atom_Create(atom);
   failed := false;
   AtomList_First(a);
   while not AtomList_End(a) and not failed do begin
      AtomList_Retrieve(a, atom);
      NPC_Div := NPC_Div + 1;
      Division_Retrieve(d0, pattern);
      if Pattern_Size(pattern) < Atom_Size(atom) then
	 failed := true
      else begin
	 Pattern_Retrieve(pattern, item);
	 while not Atom_End(atom) do begin
	    Atom_Next(atom);
	    Item_Next(item)
	 end;
	 Item_Cut(item);
	 if Item_Assign(item, atom) then begin
	    Pattern_Update(pattern, item);
	    Pattern_SetTag(pattern, t_div, NPC_Div);
	    NewPattern(g, d0, d1, pattern);
	    Pattern_First(pattern);
	    if not Pattern_Valid(pattern) then begin
	       UndoDivisions(g, d0, d1, pattern);
	       RejectAtom(NPC_Div);
	       failed := true
	    end
	 end else begin
	    RejectAtom(NPC_Div);
	    failed := true
	 end
      end;
      AtomList_Next(a)
   end;
   Atom_Delete(atom);
   Item_Delete(item);
   Pattern_Delete(pattern)
end;


procedure UserModification(var g: GrammarType; s: SurfaceType; d0, d1: DivisionType);
var
   p: PatternType;
begin
   Pattern_Create(p);
   User_BadPhrase(d0, d1, p);
   case User_Action of
      'c':
	 begin
	    User_MakePhrase(s, d0, d1, p);
	    NPC_User := NPC_User + 1;
	    Pattern_SetTag(p, t_user, NPC_User);
	    NewPattern(g, d0, d1, p)
	 end;
      'd':
	 begin
	    if Division_Find(d1, p) then begin
	       Division_Cut(d1);
	       Division_First(d0);
	       Division_First(d1);
	       while not Division_End(d1) do begin
		  Division_Next(d0);
		  Division_Next(d1)
	       end;
	       Division_Stretch(d0)
	    end;
	    Division_Last(d1);
	    Grammar_Remove(g, p)
	 end;
      'r':
	 if not FindAltPhrase(g, d0, d1, p) then begin
	    User_MakePhrase(s, d0, d1, p);
	    NPC_User := NPC_User + 1;
	    Pattern_SetTag(p, t_user, NPC_User);
	    NewPattern(g, d0, d1, p)
	 end
   end;
   Pattern_Delete(p)
end;


procedure UserDivisions(g: GrammarType; s: SurfaceType; d0, d1: DivisionType);
var
   done: boolean;
begin
   if not User_Interactive then
      FindAllDivisions(g, d0, d1)
   else begin
      done := false;
      while not done do begin
	 FindAllDivisions(g, d0, d1);
	 if not User_Confirmation(s, d0, d1) then
	    UserModification(g, s, d0, d1)
	 else
	    done := true
      end
   end
end;


procedure MakeLocus(l: LocusType; s: SurfaceType; n: integer);
var
   i: integer;
   dt: integer;
   t: StringType;
   vl: VerseLabelType;
begin
   Surface_GetLabel(s, vl);
   Locus_SetLabel(l, vl);
   t := '';
   for i := 1 to n do begin
      dt := length(' ') + length(Surface_String(s));
      if length(t) + dt > STRING_SIZE then begin
	 write('syn03: cannot cope with strings of more than ');
	 writeln(STRING_SIZE:1, ' characters');
	 Quit
      end;
      if (length(t) > 0) and (String_End(t) <> '-') then
	 t := t + ' ';
      t := t + Surface_String(s);
      Surface_Next(s)
   end;
   Locus_SetText(l, t)
end;


procedure AccountPatterns(g: GrammarType; s: SurfaceType; d: DivisionType);
var
   p: PatternType;
   l: LocusType;
begin
   Pattern_Create(p);
   Locus_Create(l);
   Surface_First(s);
   Division_First(d);
   while not Division_End(d) do begin
      Division_Retrieve(d, p);
      MakeLocus(l, s, Pattern_Size(p));
      Grammar_Label(g, p, l);
      Division_Next(d)
   end;
   Locus_Delete(l);
   Pattern_Delete(p)
end;


procedure MakePhrases(g: GrammarType; v: VerseType; s: SurfaceType; var phd, npd: FileType);
var
   al: AtomListType;
   d0, d1: DivisionType;
   l: VerseLabelType;
begin
   Division_Create(d0);
   Division_Create(d1);
   AtomList_Create(al);
   Verse_GetLabel(v, l);
   Division_SetLabel(d0, l);
   Division_SetLabel(d1, l);
   AtomList_SetLabel(al, l);
   DivisionFromVerse(g, v, d0);
   if File_EOF(phd) then
      UserDivisions(g, s, d0, d1)
   else begin
      Read_AtomList(phd, al);
      CheckLabels(v, al);
      FileDivisions(g, al, d0, d1);
      if Division_Size(d0) <> Division_Size(d1) then
	 UserDivisions(g, s, d0, d1)
   end;
   Division_Atomise(d1, al);
   Write_AtomList(npd, al);
   AtomsToVerse(v, al);
   AccountPatterns(g, s, d1);
   AtomList_Delete(al);
   Division_Delete(d1);
   Division_Delete(d0)
end;


procedure InitStage(var f: FileType; var s: StringType; var complete: boolean);
const
   FNAME_STAGE = 'synnr';
var
   stage:	integer;
begin
   File_Open(f, FNAME_STAGE, false);
   File_Mode(f, file_read);
   with f do begin
      if not Scan_Integer(fp, stage) then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('integer expected (stage)');
	 Quit
      end;
      if stage < STAGE - 1 then begin
	 writeln('syn03: you are at stage ', stage:1, ', proceed to stage ', STAGE - 1:1, ' first');
	 Quit
      end;
      if stage > STAGE - 1 then begin
	 writeln('syn03: stage ', STAGE:1, ' has already been completed');
	 Quit
      end;
      SkipSpace(fp);
      readln(fp, s);
      line := line + 1
   end;
   complete := false
end;


procedure InitPhraseGrammar(var g: GrammarType);
var
   lexcond:  FileType;
   morfcond: FileType;
   phrset:   FileType;
begin
   File_Open(phrset, 'phrset', false);     File_Mode(phrset, file_read);
   File_Open(morfcond, 'morfcond', false); File_Mode(morfcond, file_read);
   File_Open(lexcond, 'lexcond', false);   File_Mode(lexcond, file_read);
   Grammar_Create(g);
   Grammar_Read(g, phrset, morfcond, lexcond);
   File_Close(lexcond);
   File_Close(morfcond);
   File_Close(phrset);
end;


procedure ParseText(g: GrammarType; name: StringType; var complete: boolean);
var
   v: VerseType;
   s: SurfaceType;
   done: boolean;
   npd, phd, pps, ps2, ps3, txt: FileType;
begin
   File_Open(ps2, name + '.ps2', false); File_Mode(ps2, file_read);
   File_Open(txt, name + '.ct', false);  File_Mode(txt, file_read);
   File_Open(ps3, name + '.ps3', true);  File_Mode(ps3, file_write);
   File_Open(phd, name + '.phd', false); File_Mode(phd, file_read);
   File_Open(npd, name + '.npd', true);  File_Mode(npd, file_write);
   File_Open(pps, name + '.pps', true);  File_Mode(pps, file_write);
   Verse_Create(v);
   Surface_Create(s);
   done := File_EOF(ps2);
   while not done do begin
      Read_Verse(ps2, v);
      Read_Surface(txt, s);
      CheckVerseSurface(v, s);
      MakePhrases(g, v, s, phd, npd);
      Write_Verse(ps3, v);
      if File_EOF(ps2) then begin
	 done := true;
	 complete := true
      end
      else if File_EOF(phd) then
	 if not User_Continue then begin
	    done := true;
	    complete := false
	 end
   end;
   Surface_Delete(s);
   Verse_Delete(v);
   Grammar_Report(g, pps);
   File_Close(pps);
   File_Close(npd);
   File_Close(phd);
   File_Close(ps3);
   File_Close(txt);
   File_Close(ps2)
end;


procedure ExitPhraseGrammar(g: GrammarType);
var
   phrset:   FileType;
begin
   File_Open(phrset, 'PHR', true);
   File_Mode(phrset, file_write);
   Grammar_Write(g, phrset);
   Grammar_Delete(g);
   File_Close(phrset)
end;


procedure ExitStage(var f: FileType; s: StringType; complete: boolean);
begin
   writeln;
   if not complete then
      writeln('Session adjourned.')
   else begin
      with f do begin
	 rewrite(fp);
	 writeln(fp, STAGE:1, ' ', s);
      end;
      writeln('Session finished.')
   end;
   writeln;
   File_Close(f)
end;


begin
   User_Init;
   InitStage(StageFile, TextName, Finished);
   InitPhraseGrammar(Grammar);
   ParseText(Grammar, TextName, Finished);
   ExitPhraseGrammar(Grammar);
   ExitStage(StageFile, TextName, Finished)
end.
