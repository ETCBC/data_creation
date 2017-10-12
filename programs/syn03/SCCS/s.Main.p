h08510
s 00004/00002/00552
d D 1.7 15/09/14 16:30:51 const 7 6
c Enclitic phrases need to be sticky, when enclitics have word status.
e
s 00006/00003/00548
d D 1.6 15/04/29 15:38:39 const 6 5
c Needed to generate condition 205 (same lexeme) for parsephrases(1)
e
s 00003/00002/00548
d D 1.5 14/06/11 17:31:10 const 5 4
c Present patterns constructed with a suffix as determined
e
s 00004/00007/00546
d D 1.4 07/05/24 15:27:13 const 4 3
c Fixed exit status.
e
s 00002/00002/00551
d D 1.3 99/04/14 11:05:23 const 3 2
c Bug in Grammar_Label and Pattern_StickyTail. Cleaned up code.
e
s 00034/00004/00519
d D 1.2 99/03/25 10:38:42 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00523/00000/00000
d D 1.1 99/02/16 14:13:41 const 1 0
c date and time created 99/02/16 14:13:41 by const
e
u
U
f e 0
f m dapro/syn03/Main.p
t
T
I 1
program syn03;

D 4
(* ident "%Z%%M% %I% %G%" *)
E 4
I 4
(* ident "%W% %E%" *)
E 4

#include <AtomList.h>
#include <Division.h>
#include <Error.h>
#include <File.h>
#include <Grammar.h>
#include <IO.h>
I 2
#include <Locus.h>
E 2
#include <Surface.h>
#include <User.h>
#include <Verse.h>

D 4
label 0;

E 4
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
D 4
   writeln('syn03: exiting');
   goto 0
E 4
I 4
   message('syn03: exiting with status 1');
   pcexit(1)
E 4
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
D 3
   Write_Word(output, w);
E 3
I 3
   Print_Word(output, w);
E 3
   writeln;
   Quit
end;


procedure DivisionFromVerse(g: GrammarType; v: VerseType; d: DivisionType);
(* pre - [d] is empty *)
var
   condition_set: CondSetType;
   item: ItemType;
   pattern: PatternType;
D 5
   speech, state: integer;
E 5
I 5
D 7
   speech, state, suffix: integer;
E 7
I 7
   lexset, speech, state, suffix: integer;
E 7
E 5
   verse_label: VerseLabelType;
D 6
   word: WordType;
E 6
I 6
   prev, word: WordType;
E 6
begin
I 6
   Word_Create(prev);
E 6
   Word_Create(word);
   Item_Create(item);
   Pattern_Create(pattern);
   CondSet_Create(condition_set);
   Verse_GetLabel(v, verse_label);
   Verse_First(v);
   while not Verse_End(v) do begin
      Verse_Retrieve(v, word);
I 7
      Word_GetFeature(word, lxs, lexset);
E 7
      Word_GetFeature(word, pos, speech);
I 5
      Word_GetFeature(word, sfx, suffix);
E 5
D 6
      Grammar_WC(g, word, condition_set);
E 6
I 6
      Grammar_WC(g, prev, word, condition_set);
E 6
      Word_GetFeature(word, sta, state);
      if Pos_State(speech, state) then
D 5
	 Item_Add(item, speech, condition_set, state, speech)
E 5
I 5
D 7
	 Item_Add(item, speech, ord(suffix > 0), condition_set, state, speech)
E 7
I 7
	 Item_Add(item, lexset, speech, ord(suffix > 0), condition_set, state, speech)
E 7
E 5
      else
	 RejectPos(verse_label, word);
I 6
      Word_Copy(prev, word);
E 6
      Verse_Next(v)
   end;
   CondSet_Delete(condition_set);
   Pattern_Add(pattern, item);
   Division_Add(d, pattern);
   Pattern_Delete(pattern);
   Item_Delete(item);
D 6
   Word_Delete(word)
E 6
I 6
   Word_Delete(word);
   Word_Delete(prev)
E 6
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
I 7
	    Pattern_First(pattern);
E 7
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


D 2
procedure AccountPatterns(g: GrammarType; d: DivisionType);
E 2
I 2
procedure MakeLocus(l: LocusType; s: SurfaceType; n: integer);
E 2
var
I 2
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
E 2
   p: PatternType;
D 2
   l: VerseLabelType;
E 2
I 2
   l: LocusType;
E 2
begin
   Pattern_Create(p);
D 2
   Division_GetLabel(d, l);
E 2
I 2
   Locus_Create(l);
   Surface_First(s);
E 2
   Division_First(d);
   while not Division_End(d) do begin
      Division_Retrieve(d, p);
I 2
      MakeLocus(l, s, Pattern_Size(p));
E 2
      Grammar_Label(g, p, l);
      Division_Next(d)
   end;
I 2
   Locus_Delete(l);
E 2
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
D 2
   AccountPatterns(g, d1);
E 2
I 2
   AccountPatterns(g, s, d1);
E 2
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
D 3
      if not Read_Integer(fp, stage) then begin
E 3
I 3
      if not Scan_Integer(fp, stage) then begin
E 3
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
D 4
   ExitStage(StageFile, TextName, Finished);
0:
E 4
I 4
   ExitStage(StageFile, TextName, Finished)
E 4
end.
E 1
