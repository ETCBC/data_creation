program parsephrases;

(* ident "@(#)dapro/simple/parsephrases.p	1.26 16/10/26" *)

(*  NOTE: This program MUST be compiled with the -P switch on the Sun
 *  pascal compiler, in order to ensure partial evaluation of boolean
 *  expressions involving 'and' and 'or'. /UP
 *)

{
   Reads nphrset (with phrase function labels) produced by
   analyzephrset; reads a text (.PS3) and adds the function labels in
   PS column 15 - 17 and writes the same text with indication of
   internal phrase hierarchy.
}

#include <hebrew/hebrew.h>
#include <hebrew/syntax.h>

const

(* Scale factors. The maximum number of conditions in the first field
   is the maximum number of morphogical and lexical conditions,
   currently 7 + 1. The maximum number of conditions in the third field
   is also 8, because we need room for part of speech, three subphrase
   relations, and tests for state, lexeme, cardinal and pdp. Because of
   the extra EOI, MAX_CONDITIONS needs to be 9. *)

   MAX_CONDITIONS	   = 8 + 1;
   MAX_PHRASES		   = 12500;
   MAX_PHR_STRUCS	   = 4500;
   MAX_SUGGESTION_PATTERNS = 70;

   EOI			   = 99;
   KO_LS		   = 0;
   KO_SP		   = 1;
   KO_NME		   = 5;
   KO_PRS		   = 6;
   KO_ST		   = 11;
   KO_PDP		   = 12;
   KO_PTY		   = 13;
   KO_DET		   = 14;
   KO_SPR1		   = 15;
   KO_SPR3		   = 17;
   PHRASE_LENGTH	   = 5 * MAX_WORDS_PATM;
   LS_CARD		   = -1;
   LS_FOCP		   = -2;
   LS_SFFX		   = -1;

   NUMBER		   = 0;
   PARAM_APPOSITION	   = -100;
   PARAM_STATE		   = 200;
   PARAM_LEXEME		   = 205;
   PARAM_CARDINAL	   = 206;
   PARAM_PDP		   = 300;
   PHRASE_SEPARATOR	   = 100;
   PSP_INFO		   = 1;
   READ			   = 0;
   SP_ART		   = 0;
   SP_VERB		   = 1;
   SP_SUBS		   = 2;
   SP_PREP		   = 5;
   SP_CONJ		   = 6;
   SP_PRPS		   = 7;
   SP_PRDE		   = 8;
   SP_PRIN		   = 9;
   SP_NEGA		   = 11;
   SP_INRG		   = 12;
   STRUC_SIZE		   = 5 * (MAX_WORDS_PATM + 1);
   UNDEFINED		   = -1;
   WRITE		   = 1;
   FIRST_FUNCTION	   = -1;
   LAST_FUNCTION	   = KO_DET - 1 + MAX_CONDITIONS;
   LP_COND		   = 1;
   LP_HAS_MATCH		   = 2;
   LP_LEXNUM		   = 3;

type
   WordIndexType =
      1..MAX_WORDS;
   FunctionIndexType =
      FIRST_FUNCTION..LAST_FUNCTION;
   LexemeListType =
      array [1..MAX_WORDS] of LexemeType;
   AnalysisListType =
      array [WordIndexType, FunctionIndexType] of integer;
   PAtomType =
      array [1..MAX_CONDITIONS, 0..STRUC_SIZE] of integer;
   PhraseListType =
      array [1..MAX_PHRASES] of PAtomType;
   phraseStrucListType =
      array [1..MAX_PHR_STRUCS, NUMBER..STRUC_SIZE, 0..MAX_CONDITIONS] of integer;
   phraseStrucWordType =
      array [1..MAX_PHR_STRUCS, NUMBER..PHRASE_LENGTH ] of char;
   LongPhrase = array [1..3, 1..100] of integer;
   PhraseSuggestListType =
      array [1..MAX_SUGGESTION_PATTERNS, 0..MAX_WORDS_PATM, 0..MAX_CONDITIONS]
      of integer;
   SuggestionsType =
      array[1..MAX_WORDS, 1..MAX_CONDITIONS] of integer;
   BoundariesType =
      array[1..MAX_WORDS_PATM, 1..3] of
	 record
	    code	       : integer;
	    DistToPlusEnd      : integer;
	    ColOfOther         : integer;
	    DistToBeginning    : integer;
	    PlusHasBeenTaken   : boolean;
	    Level	       : integer;
	 end;
   BoundaryPointersType = array[1..MAX_WORDS_PATM*3] of
   record
      BoundaryIndex : integer;
      ColumnIndex   : integer;
   end;
   FarthestEndingType = array[1..MAX_WORDS_PATM] of integer;



var
   T		       : text;
   Ps		       : text;
   NewPSfile	       : text;
   NPhraseSet	       : text;
   StageFile	       : text;
   MP		       : text;
   NPS		       : text;
   phraseStruc	       : text;
   phraseSuggest       : text;
   report	       : text;
   stop		       : boolean;
   TextName	       : StringType;
   AnalysisList	       : AnalysisListType;
   TextLine	       : LineType;
   p		       : integer;
   missed	       : integer;
   hits		       : integer;
   insert	       : integer;
   PhrTypeCount	       : integer;
   SuggestPatternCount : integer;
   WordCount	       : integer;
   LineCount	       : integer;
   phrase_found	       : integer;
   StrucNum	       : integer;
   Phrase	       : PAtomType;
   PhraseList	       : PhraseListType;
   phraseStrucList     : phraseStrucListType;
   phraseStrucWord     : phraseStrucWordType;
   phraseSuggestList   : PhraseSuggestListType;
   LexemeList	       : LexemeListType;
   VerseLabel	       : LabelType;
   Boundaries	       : BoundariesType;
   BoundaryPointers    : BoundaryPointersType;
   FarthestEnding      : FarthestEndingType;
   Interactive	       : boolean;

   ColumnWidth	       : array [FunctionIndexType] of integer :=
	 [0, 2, 3, 2, 2, 2, 2, 2, 4, 2, 2, 2, 5, 3, 3, 3, 7, 7, 7, 0, 0, 0, 0, 3];

procedure ReadStage(var name: StringType);
var
   error:       integer;
   stage:       integer;
   ch:          char;
begin
   error := 0; { Dummy statement to fool the compiler: error is set before used }
   open(StageFile, 'synnr', 'old', error);
   if error <> 0 then
   begin
      writeln('parsephrases: cannot open synnr');
      halt
   end;
   reset(StageFile);
   read(StageFile, stage, ch, name);
   close(StageFile);
   if stage < 3 then
   begin
      writeln('parsephrases: ', stage:1, ': wrong stage');
      halt
   end
end; { ReadStage }


procedure OpenFile(var f:text; name: StringType; mode: integer);
var
   error: integer;
begin
   error := 0; { Dummy statement to fool the compiler: error is set before used }
   case mode of
     READ:
          begin
             open(f, name, 'old', error);
             if error <> 0 then begin
                writeln('parsephrases: cannot open ', name);
                halt
             end;
             reset(f)
          end;
     WRITE:
           begin
              open(f, name, 'new', error);
              if error <> 0 then begin
                 writeln('parsephrases: cannot create ', name, '.');
                 halt
              end;
              rewrite(f)
           end
   end
end; { OpenFile }


procedure OpenFiles(var text_name: StringType);
begin
   OpenFile(T,  text_name + '.ct', READ);
   OpenFile(Ps, text_name + '.ps3', READ);
   OpenFile(NPhraseSet, 'nphrset', READ);
   OpenFile(phraseStruc, 'phrase.struc', READ);
   OpenFile(phraseSuggest, 'phrase.suggest', READ);

   open(report, text_name + '.report', 'unknown');
   rewrite(report);
   open(MP, text_name + '.MISparse', 'unknown');
   rewrite(MP);
   open(NewPSfile, text_name + '.ps3.p', 'unknown');
   rewrite(NewPSfile);
end; { OpenFiles }


procedure AskInteger(var i: integer);
begin
   while not eof and not ReadInteger(input, i) do begin
      readln;
      write('integer expected, enter an integer: ')
   end;
   readln;
   writeln(report, 'input: ', i:1)
end; { AskInteger }


procedure PhraseClear(var P: PAtomType);
var
   w: integer;	(* word index *)
   c: integer;	(* condition index *)
begin
   for c := 1 to MAX_CONDITIONS do
      for w := 0 to STRUC_SIZE do
	 P[c, w] := EOI
end;


function PhraseLength(var P: PAtomType): integer;
(* Return the length of P including the terminating PHRASE_SEPARATOR.
   Note that P[c, 0] is not used. *)
var
   i: integer;
begin
   i := 1;
   while P[1, i] <> PHRASE_SEPARATOR do
      i := i + 1;
   PhraseLength := i
end;


#ifdef DEBUG
procedure DumpAnalysisList;
var
   i: integer;
   w: integer;	(* word index *)
begin
   for w := 1 to WordCount do begin
      write(LexemeList[w]);
      for i := FIRST_FUNCTION to LAST_FUNCTION do
	 write(' ', AnalysisList[w, i]: ColumnWidth[i]);
      writeln
   end
end;


procedure PhraseWrite(var f: text; var P: PAtomType);
var
   w: integer;	(* word index *)
   c: integer;	(* condition index *)
begin
   w := 1;
   while P[1, w] <> EOI do begin
      c := 1;
      write(f, P[c, w]:1, ' ');
      c := c + 1;
      if P[c, w] = EOI then
	 write(f, '- ')
      else begin
	 write(f, '( ', P[c, w]:1, ' ');
	 c := c + 1;
	 while P[c, w] <> EOI do begin
	    write(f, ', ', P[c, w]:1, ' ');
	    c := c + 1
	 end;
	 write(f, ') ');
      end;
      w := w + 1
   end;
   write(f, EOI:1)
end;
#endif


function Struc_CmpRevPOS(s1, s2: integer): integer;
(* Compare the parts of speech of [s1] and [s2] in reverse order *)
var
   cmp: integer;
   w: integer;	(* word index *)
begin
   cmp := 0;
   w := 1;
   while (cmp = 0) and
      (phraseStrucList[s1, w, 0] <> EOI) and
      (phraseStrucList[s2, w, 0] <> EOI)
   do begin
      cmp := phraseStrucList[s2, w, 0] - phraseStrucList[s1, w, 0];
      w := w + 1
   end;
   if cmp <> 0 then
      Struc_CmpRevPOS := cmp
   else
      Struc_CmpRevPOS :=
	 phraseStrucList[s1, w, 0] - phraseStrucList[s2, w, 0]
end;


function Struc_RealConditions(s: integer): integer;
(* Return the number of real conditions in [s], that is, those which
   are not relations. They are the ones with three digits. *)
var
   r: integer;	(* result *)
   w: integer;	(* word index *)
   c: integer;	(* condition index *)
begin
   r := 0;
   w := 1;
   c := 0;
   while phraseStrucList[s, w, c] <> EOI do begin
      while phraseStrucList[s, w, c] <> EOI do begin
	 if phraseStrucList[s, w, c] div 100 <> 0 then
	    r := r + 1;
	 c := c + 1
      end;
      c := 0;
      w := w + 1
   end;
   Struc_RealConditions := r
end;


function Condition_CmpEOI(c1, c2: integer): integer;
(* Compare the condition codes c1 and c2, when one of them is the
   special value EOI *)
begin
   if c1 <> EOI then
      Condition_CmpEOI := 1
   else if c2 <> EOI then
      Condition_CmpEOI := -1
   else
      Condition_CmpEOI := 0
end;


function Struc_CmpConditions(s1, s2: integer): integer;
(* Compare the `conditions' of [s1] and [s2] *)
var
   r: integer;	(* result *)
   w: integer;	(* word index *)
   c: integer;	(* condition index *)
begin
   r := 0;
   w := 1;
   while (r = 0) and
      (phraseStrucList[s1, w, 0] <> EOI) and
      (phraseStrucList[s2, w, 0] <> EOI)
   do begin
      c := 1;
      while (r = 0) and
	 (phraseStrucList[s1, w, c] <> EOI) and
	 (phraseStrucList[s2, w, c] <> EOI)
      do begin
	 r := phraseStrucList[s1, w, c] - phraseStrucList[s2, w, c];
	 c := c + 1
      end;
      if r = 0 then
	 r := Condition_CmpEOI(phraseStrucList[s1, w, c],
			       phraseStrucList[s2, w, c]);
      w := w + 1
   end;
   if r = 0 then
      r := Condition_CmpEOI(phraseStrucList[s1, w, 0],
			    phraseStrucList[s2, w, 0]);
   Struc_CmpConditions := r
end;


function Struc_Compare(s1, s2: integer): integer;
var
   cmp: integer;
begin
   cmp := phraseStrucList[s1, 1, 0] - phraseStrucList[s2, 1, 0];
   if cmp <> 0 then
      Struc_Compare := cmp
   else begin
      cmp := Struc_CmpRevPOS(s1, s2);
      if cmp <> 0 then
	 Struc_Compare := cmp
      else begin
	 cmp := Struc_RealConditions(s2) - Struc_RealConditions(s1);
	 if cmp <> 0 then
	    Struc_Compare := cmp
	 else
	    Struc_Compare := Struc_CmpConditions(s1, s2)
      end
   end
end;


procedure Struc_Copy(s1, s2: integer);
(* Copy phraseStrucList[s1] to phraseStrucList[s2] *)
var
   w: integer;	(* word index *)
   c: integer;	(* condition index *)
begin
   w := 1;
   c := 0;
   while phraseStrucList[s1, w, c] <> EOI do begin
      while phraseStrucList[s1, w, c] <> EOI do begin
	 phraseStrucList[s2, w, c] := phraseStrucList[s1, w, c];
	 c := c + 1;
      end;
      phraseStrucList[s2, w, c] := EOI;
      c := 0;
      w := w + 1
   end;
   phraseStrucList[s2, w, c] := phraseStrucList[s1, w, c];
   phraseStrucList[s2, w, 5] := phraseStrucList[s1, w, 5];
   while phraseStrucWord[s1, c] <> '*' do begin
      phraseStrucWord[s2, c] := phraseStrucWord[s1, c];
      c := c + 1
   end;
   phraseStrucWord[s2, c] := '*'
end;


function Struc_Length(s: integer): integer;
(* Return the length of phraseStrucList[s] in words including the
   terminating EOI. *)
var
   w: integer;
begin
   w := 1;
   while phraseStrucList[s, w, 0] <> EOI do
      w := w + 1;
   Struc_Length := w
end;


procedure Struc_Write(var f: text; s: integer);
var
   w: integer;	(* word index *)
   c: integer;	(* condition index *)
begin
   w := 1;
   while phraseStrucList[s, w, 0] <> EOI do begin
      c := 0;
      write(f, phraseStrucList[s, w, c]:1, ' ');
      c := c + 1;
      if phraseStrucList[s, w, c] = EOI then
	 write(f, '- ')
      else begin
	 write(f, '( ', phraseStrucList[s, w, c]:1, ' ');
	 c := c + 1;
	 while phraseStrucList[s, w, c] <> EOI do begin
	    write(f, ', ', phraseStrucList[s, w, c]:1, ' ');
	    c := c + 1
	 end;
	 write(f, ') ');
      end;
      w := w + 1
   end;
   write(f, EOI:1, ' ');
   c := 1;	(* character index *)
   while phraseStrucWord[s, c] <> '*' do begin
      write(f, phraseStrucWord[s, c]);
      c := c + 1
   end
end;


procedure StrucList_Clear;
var
   s: integer;	(* struc index *)
begin
   for s := 1 to MAX_PHR_STRUCS do begin
      phraseStrucList[s, 0, 0] := 0;
      phraseStrucList[s, 1, 0] := 99;
      phraseStrucWord[s, 1] := '*'
   end;
   StrucNum := 0
end;


procedure StrucList_Insert(s, x: integer);
(* Insert phraseStrucList[s] in phraseStrucList[1..StrucNum] at index x.
   If x <= StrucNum, phraseStrucList[x..StrucNum] will be shifted up. *)
var
   i: integer;
begin
   assert(s > StrucNum + 1);
   assert(x <= StrucNum + 1);
   for i := StrucNum downto x do
      Struc_Copy(i, i + 1);
   Struc_Copy(s, x);
   StrucNum := StrucNum + 1
end;


function StrucList_Lookup(s: integer; var x: integer): boolean;
(* Return whether phraseStrucList[s] occurs in phraseStrucList[1..StrucNum].
   If so, the index [x] is updated with that of the struc equal to [s],
   or else with that of the smallest struc greater than [s]. *)
var
   i, j, k: integer;
begin
   assert (s > StrucNum);
   i := 0;
   k := StrucNum;
   while i < k do begin
      j := (i + 1 + k) div 2;
      if Struc_Compare(s, j) < 0 then 
	 k := j - 1
      else
	 i := j
   end;
   if (k <> 0) and (Struc_Compare(s, k) = 0) then begin
      x := k;
      StrucList_Lookup := true
   end else begin
      x := k + 1;
      StrucList_Lookup := false
   end
end;


procedure ClearPhraseSuggestList;
var
   x, y, z : integer;
begin
   for x := 1 to MAX_SUGGESTION_PATTERNS do
   begin
      for y := 0  to MAX_WORDS_PATM do
	 for z := 0 to MAX_CONDITIONS do
	    phraseSuggestList[x,y,z] := 99;
   end;
end;


procedure WritePhraseStrucList;
var strucnum: integer;
begin
   open(NPS, 'NewphraseStruc', 'unknown');
   rewrite(NPS);
   writeln(' make NewphraseStruc');
   strucnum := 0;
   while strucnum < StrucNum do begin
      strucnum := strucnum + 1;
      Struc_Write(NPS, strucnum);
      if phraseStrucList[strucnum, Struc_Length(strucnum), 5] = 999 then
	 write(NPS, ' # NEW');
      writeln(NPS)
   end;
   close (NPS);
   writeln(' NewphraseStruc made');
end;


procedure ReadPhraseStrucList(var f               : text;
                              var phraseStrucList : phraseStrucListType;
                              var phraseStrucWord : phraseStrucWordType );
var
   strucnum, postype, condtype : integer;
   condnum, posnum             : integer;
   x                           : integer;
   ch                          : char;
begin
   StrucList_Clear;
   while not eof(f) do
   begin
      strucnum := StrucNum + 2;
      postype := 0; posnum := 0;
      while postype <> 99 do
      begin
         read(f,postype);
         posnum := posnum + 1;
         condnum := 0;
         { write('postype =', postype:5); }
         phraseStrucList[strucnum, posnum, condnum] := postype;
         if postype <> 99
            then
         begin
            repeat read(f,ch)
            until ch in ['-', '(', ',', ')' ];
            if ch = '('
               then
               repeat
                  condnum := condnum +1;
                  read(f, condtype);
                  phraseStrucList[strucnum, posnum, condnum] := condtype;
                  repeat
                     read(f, ch);
                     if ch in ['(','-'] then
                     begin
                        writeln( ' something wrong with brackets in line :',strucnum:5);
                        halt;
                     end
                  until ch in [ ',' , ')' ]
               until ch = ')';
            if condnum < MAX_CONDITIONS then
               phraseStrucList[strucnum, posnum, condnum+1] := 99; { closing symbol }
         end;
      end;
      SkipSpace(f);
      if eoln(f) then
	 for x := 1 to posnum - 1 do
	    phraseStrucWord[strucnum, x] := '='
      else begin
	 x := 1;
	 phraseStrucWord[strucnum, x] := ' ';
	 repeat
	    x := x + 1;
	    read(f, phraseStrucWord[strucnum, x])
	 until (x+1 = PHRASE_LENGTH) or eoln(f);
      end;
      phraseStrucWord[strucnum, x+1] := '*';
      if not StrucList_Lookup(strucnum, x) then
	 StrucList_Insert(strucnum, x);
      readln(f)
   end;
   writeln('number of phrasehierarchy patterns read:',StrucNum:4);
end;

procedure ReadPhraseSuggestions(var f	    : text;
				var ps	    : PhraseSuggestListType;
				var pscount : integer);
var
   suggestnum, postype, condtype : integer;
   condnum, posnum             : integer;
   ch                          : char;
begin
   ClearPhraseSuggestList;
   suggestnum := 0;
   while not eof(f) do
   begin
      suggestnum := suggestnum + 1;
      postype := 0; posnum := 0;
      while postype <> 99 do
      begin
         read(f,postype);
         posnum := posnum + 1;
         condnum := 0;
         ps[suggestnum, posnum, condnum] := postype;
         if postype <> 99
            then
         begin
            repeat read(f,ch)
            until ch in ['-', '(', ',', ')' ];
            if ch = '('
               then
               repeat
                  condnum := condnum +1;
                  read(f, condtype);
                  { writeln(' condtype = ', condtype : 4, ' condnum = ', condnum : 4);}
                  ps[suggestnum, posnum, condnum] := condtype;
                  repeat
                     read(f, ch);
                     if ch in ['(','-'] then
                     begin
			writeln( ' something wrong with brackets in line :',suggestnum:5, ' in file phrase.suggest .');
                        halt;
                     end
                  until ch in [ ',' , ')' ]
               until ch = ')';
            if condnum < MAX_CONDITIONS then
               ps[suggestnum, posnum, condnum+1] := 99; { closing symbol }
	 end;
	 ps[suggestnum, 0, 0] := posnum - 1; { Number of words except 99 }
      end;
      readln(f);
   end;
   pscount := suggestnum;

   writeln('number of phrasehierarchy patterns read:',pscount:4);
end; { ReadPhraseSuggestions }


procedure TestCompoundPhrases;
(* Detect compound phrase atoms (those with subphrase relations) in
   the current verse and mark them as such. The algorithm used here
   reflects that in TestCompoundPhrases.awk of mkqdf(1). *)
var
   pdp: integer;	(* phrase dependent part of speech *)
   ls: integer;		(* lexical set *)
   w: integer;		(* word count within phrase atom *)
   x: integer;		(* word index within verse *)
   cstr, inrg: boolean;
begin
   cstr := false;
   inrg := false;
   w := 0;
   x := 0;
   while x < WordCount do begin
      w := w + 1;
      x := x + 1;
      ls := AnalysisList[x, KO_LS];
      pdp := AnalysisList[x, KO_PDP];
      if inrg and (pdp = SP_PRDE) then
	 w := w - 1;
      if cstr and (pdp in [SP_VERB, SP_PREP, SP_CONJ]) then
	 w := w - 1;
      if (w = 1) and (pdp = SP_INRG) and (ls = LS_FOCP) then
	 w := 0;
      if (w = 1) and (pdp in [SP_ART, SP_PREP, SP_CONJ, SP_NEGA]) then
	 w := 0;
      if AnalysisList[x, KO_PTY] = 0 then begin
	 cstr := AnalysisList[x, KO_ST] = 1;
	 inrg := pdp in [SP_PRIN, SP_INRG]
      end else begin
	 if w > 1 then
	    AnalysisList[x - 1, LAST_FUNCTION] := 999;
	 cstr := false;
	 inrg := false;
	 w := 0
      end
   end
end;


procedure ReadVerse;
var
   y,i:                 integer;
   TLabel,
   current_label:       LabelType;
   word_index:          integer;
begin
   word_index := 0;
   read(T, TLabel);  writeln(' Now processing: ', TLabel);
   SkipSpace(T);
   y := 0;
   while not eoln(T) and (y < LINE_LENGTH) do
   begin
      y := y + 1;
      read(T, TextLine[y])
   end;
   if eoln(T) then
      readln(T)
   else begin
      message('parsephrases: Line too long in ', TextName + '.ct');
      pcexit(1)
   end;
   repeat
      word_index := word_index + 1;
      read(Ps, current_label);
      SkipSpace(Ps);
      if word_index = 1 then
      begin
         VerseLabel := current_label
      end;
      if VerseLabel = current_label then
      begin
         for i := 1 to LEXEME_LENGTH do
            read(Ps, LexemeList[word_index, i]);
         i := FIRST_FUNCTION;
         repeat
            i := i + 1;
            read(Ps, AnalysisList[word_index, i])
         until i = KO_DET;
         repeat i := i+1;
            AnalysisList[word_index, i] := -1
         until i = LAST_FUNCTION;
      end;
      readln(Ps)
   until VerseLabel <> current_label;
    { writeln('Ps-data read'); }
   WordCount := word_index - 1;
   LineCount := LineCount + 1;
   writeln(report, 'verse: ', TLabel, ' [', WordCount:1, ' words]');
   writeln(' Verse ', TLabel, ' read into AnalysisList');
end; { ReadVerse }


procedure WriteLexAnalysis(var f: text; w: integer);
var
   i: integer;
begin
   write(f, VerseLabel, ' ', LexemeList[w]);
   for i := KO_LS to KO_SPR3 do
      write(f, ' ', AnalysisList[w, i]: ColumnWidth[i]);
   writeln(f)
end;


procedure AddCondition(s, w: integer; var c: integer; code: integer);
(* Add condition code to word [w] of struc [s], where [c] is the index
   of the condition, which is incremented by 1. *)
begin
   if (c <= MAX_CONDITIONS) then
      phraseStrucList[s, w, c] := code
   else begin
      message('parsephrases: Too many conditions in struc ', s:1);
      pcexit(1)
   end;
   c := c + 1
end;


procedure CopyWords(s, first, last: integer);
(* Copy the text of the phrase running from word [first..last] in the
   current verse to phraseStrucWord[s] *)
var
   o: integer;	(* offset in TextLine *)
   c: integer;	(* character index *)
   w: integer;	(* word index *)
begin
   w := 1;
   o := 0;
   while w < first do begin
      o := o + 1;
      if TextLine[o] in [' ', '-'] then
	 w := w + 1
   end;
   c := 0;
   while w <= last do begin
      c := c + 1;
      phraseStrucWord[s, c] := TextLine[o+c];
      if TextLine[o+c] in [' ', '-'] then
	 w := w + 1;
   end;
   phraseStrucWord[s, c + 1] := '*'
end;


procedure MakeNewPhraseStruc(first, last: integer);
(* Create a new struc in phraseStrucList/Word[StrucNum + 2] from words
   [first..last] of the current verse *)
var
   x, y, posnum, condnum, strucnum: integer;
begin
   (* Set place of insertion to end of list + 2. *)
   strucnum := StrucNum + 2;

   y := 0;
   x := first-1;
   posnum := 0;
   condnum := 0;
   repeat
      x := x +1;
      posnum := posnum +1;
      condnum := 0;
      phraseStrucList[strucnum, posnum, condnum] := AnalysisList[x, KO_SP];
      y := KO_SPR1 - 1;
      condnum := 1; (* NOTE: outside the if statement *)
      if AnalysisList[x,KO_SPR1] <> -1 then
      begin
	 repeat
	    y := y +1;
	    if (AnalysisList[x, y] <> -1) then
	    begin
	       phraseStrucList[strucnum, posnum, condnum] := AnalysisList[x, y];
	       condnum := condnum + 1
	    end;
	 until (AnalysisList[x, y] = -1) or (y = KO_SPR3);
      end;
      if (AnalysisList[x, KO_PTY] < 0) then
	 AddCondition(strucnum, posnum, condnum, PARAM_APPOSITION);
      if (AnalysisList[x, KO_NME] > 0) then
	 AddCondition(strucnum, posnum, condnum, AnalysisList[x, KO_ST] + PARAM_STATE);
      if (posnum > 1) and (LexemeList[x - 1] = LexemeList[x]) then
	 AddCondition(strucnum, posnum, condnum, PARAM_LEXEME);
      if (AnalysisList[x, KO_LS] = LS_CARD) and (AnalysisList[x, KO_SP] = SP_SUBS) then
	 AddCondition(strucnum, posnum, condnum, PARAM_CARDINAL);
      if (AnalysisList[x, KO_SP] <> AnalysisList[x, KO_PDP]) then
	 AddCondition(strucnum, posnum, condnum, AnalysisList[x, KO_PDP] + PARAM_PDP);
      AddCondition(strucnum, posnum, condnum, EOI);
   until x = last;
   CopyWords(strucnum, first, last);
   phraseStrucList[strucnum, posnum+1, 0] := 99;
   phraseStrucList[strucnum, posnum+1, 5] := 999;
end;


function InSert(first, last: integer): integer;
var
   strucnum: integer;
begin
   MakeNewPhraseStruc(first, last);
   write(report, 'new struc for phrase pattern ', phrase_found:1, ': ');
   Struc_Write(report, StrucNum + 2);
   writeln(report);
   if StrucList_Lookup(StrucNum + 2, strucnum) then begin
      writeln(report,' this pattern is known in file "phrase.struc". Strucnum:',strucnum:6);
      writeln(' this pattern is known in file "phrase.struc". Strucnum:',strucnum:6);
   end else begin
      writeln(report,' this pattern is UNknown in file "phrase.struc". ');
      writeln(' this pattern is UNknown in file "phrase.struc". ');
      StrucList_Insert(StrucNum + 2, strucnum);
      insert := insert + 1;
      writeln(report,' INSERTED at pattern number:',strucnum :5);
      writeln(' INSERTED at pattern number:',strucnum :5);
   end;
   InSert := strucnum
end;


procedure Write_4_Char_PSP(psp : integer);
begin
   case abs(psp) of
     0	: write(' art');
     1	: write('verb');
     2	: write('subs');
     3	: write('nmpr');
     4	: write('advb');
     5	: write('prep');
     6	: write('conj');
     7	: write('prps');
     8	: write('prde');
     9	: write('prin');
     10	: write('intj');
     11	: write('nega');
     12	: write('inrg');
     13	: write('adjv');
     14	: write('....');
   end;
end;


procedure WritePhraseToScreen(first, last, current : integer; writefull : boolean);
var
   z, zz, b, c, condnum : integer;
begin
   (* Write text to screen *)
   z := 0;
   zz := 0;
   if first > 1 then
      repeat
         zz := zz +1;
         if TextLine[zz] in [' ','-'] then
            z := z +1;
      until z = first-1;

   writeln;
   writeln;
   writeln('=================================================================================================');
   writeln;
   writeln(VerseLabel);
   if writefull then
      writeln('  current num   psp   st    phr.type     lexeme               coded text             relations')
   else
      writeln('  num   lexeme                 relations');

   for b := first to last do
   begin
      write(' ');
      if writefull then
	 if (b = current) then
	    write(' ======>')
	 else
	    write('        ');


      (* Write lexnum *)
      write(b : 4,'   ');

      if writefull then
      begin
	 (* Write phrdep_psp *)
	 Write_4_Char_PSP(AnalysisList[b, KO_PDP]);
	 write(' (', AnalysisList[b, KO_ST] : 2, ')');
	 write('   ');

	 (* Write phrase type *)
	 c := AnalysisList[b, KO_PTY];
	 write(PhraseLabel(abs(c)):4);
	 if c < 0 then
	    write(' (app)   ')
	 else
	    write('         ')
      end;
      (* Write lexeme *)
      c := 0;
      repeat
         c := c+1;
         write(LexemeList[b,c])
      until LexemeList[b,c] = ' ';
      while c < LEXEME_LENGTH do
      begin
	 c := c + 1;
	 write(' ')
      end;

      if writefull then
      begin
	 (* Write coded text *)
	 c := 0;
	 write('   ');
	 repeat
	    c := c + 1;
	    zz := zz +1;
	    write(TextLine[zz]);
	 until TextLine[zz] in [' ','-'];
	 while c < LEXEME_LENGTH do
	 begin
	    c := c + 1;
	    write(' ')
	 end;
	 z := z +1;
      end;

      (* Write relations. *)
      write('    ');
      condnum := KO_DET;
      if AnalysisList[b, condnum+1] <> -1
         then write(' ( ');
      repeat
         condnum := condnum + 1;
         if AnalysisList[b, condnum] <> -1
            then
         begin
            write((AnalysisList[b, condnum]):1);
            if AnalysisList[b, condnum+1] <> -1
               then write(' , ')
            else write(' ) ');
         end
      until (AnalysisList[b, condnum+1] = -1) or (condnum = LAST_FUNCTION - 1);
      writeln;
   end;
   writeln;
end;


function ConditionsDoMatch(aw, sg, w: integer): boolean;
(* Check whether word [aw] meets the conditions of word [w] in
   suggestion [sg] *)
var
   app_c: boolean;	(* condition requires apposition *)
   app_t: boolean;	(* phrase type requires apposition *)
   c: integer;		(* condition index *)
   cc: integer;		(* condition code *)
   head: boolean;	(* first word of phrase? *)
   idem: boolean;
   st: integer;		(* state *)
   pdp: integer;	(* phrase dependent part of speech *)
begin
   app_c := false;
   app_t := AnalysisList[aw, KO_PTY] < 0;
   head := (aw = 1) or (AnalysisList[aw - 1, KO_PTY] > 0);
   st := -1;
   pdp := phraseSuggestList[sg, w, 0];
   c := 1;
   cc := phraseSuggestList[sg, w, 1];
   idem := true;
   while idem and (cc <> EOI) do begin
      case cc of
	 -100:
	    app_c := true;
	 201, 202, 203:
	    st := cc - PARAM_STATE;
	 204: (* Not found in phrase.param. Obsolete? *)
	    idem := AnalysisList[aw, KO_PRS] > 0;
	 205:
	    idem := not head and
	       (LexemeList[aw - 1] = LexemeList[aw]);
	 206:
	    idem :=
	       (AnalysisList[aw, KO_LS] = LS_CARD) and
	       (AnalysisList[aw, KO_SP] = SP_SUBS);
	 300, 301, 302, 303, 304, 305, 306,
	 307, 308, 309, 310, 311, 312, 313:
	    pdp := cc - PARAM_PDP;
      otherwise
	 (* ignored *)
      end;
      c := c + 1;
      cc := phraseSuggestList[sg, w, c]
   end;
   ConditionsDoMatch := idem and
      (st = AnalysisList[aw, KO_ST]) and
      (pdp = AnalysisList[aw, KO_PDP]) and
      (app_c = app_t)
end;


procedure MatchSuggPatternWithPhrase(var Sugg	      : SuggestionsType;
					 phr_word     : integer;
					 sugg_pattern : integer;
					 last	      : integer);
var
   sugg_word  : integer;
   nomatch    : boolean;
   suggestion : integer;
   sugg_sugg  : integer;
   found      : boolean;
   a	      : integer;
begin
   (*  Only do something if the length of the suggestion is
    *  smaller than or equal to the remaining length of the phrase. *)
   if (last - phr_word + 1) >= phraseSuggestList[sugg_pattern, 0, 0] then
   begin
      sugg_word := 0;
      nomatch := false;
      repeat
	 sugg_word := sugg_word + 1;
	 if (AnalysisList[phr_word + sugg_word - 1, KO_PDP]
	     <> phraseSuggestList[sugg_pattern, sugg_word, 0]) then
	    nomatch := true
	 else
	    if not ConditionsDoMatch(phr_word + sugg_word - 1,
				     sugg_pattern,
				     sugg_word) then
	       nomatch := true;
      until (sugg_word = phraseSuggestList[sugg_pattern, 0, 0])
      or nomatch;

      (* If we got a match, then copy the suggestions *)
      if not nomatch then
      begin
	 for a := phr_word
	    to (phraseSuggestList[sugg_pattern, 0, 0] + phr_word - 1) do
	 begin
	    suggestion := phraseSuggestList[sugg_pattern, a - phr_word + 1, 1];

	    (* If it is really a suggestion, not a condition *)
	    if (abs(suggestion) <= 13) then
	    begin

	       (* Add suggestion to Sugg *)
	       sugg_sugg := 0;
	       found := false;
	       repeat
		  sugg_sugg := sugg_sugg + 1;

		  (* If this slot is empty, add suggestion *)
		  if (Sugg[a, sugg_sugg] = -1) then
		  begin
		     found := true;
		     Sugg[a, sugg_sugg] := suggestion;
		  end;
	       until found or (sugg_sugg = MAX_CONDITIONS);
	    end;
	 end;
      end;
   end;
end; { MatchSuggPatternWithPhrase }


procedure MakeSuggestionNew(var Sugg	: SuggestionsType;
			    first, last	: integer);
var
   phr_word : integer;
   sugg_pattern		   : integer;
begin
   (* Search through phrase *)
   phr_word := first-1;
   repeat
      phr_word := phr_word + 1;
      sugg_pattern := 0;
      while sugg_pattern < SuggestPatternCount do begin
	 sugg_pattern := sugg_pattern + 1;
	 MatchSuggPatternWithPhrase(Sugg, phr_word, sugg_pattern, last)
      end
   until (phr_word >= (last-1));

   for phr_word := first to last do
      if (AnalysisList[phr_word, KO_PDP] in [2, 3, 4, 7, 8, 9, 12, 13])
	 and (Sugg[phr_word, 1] = -1) then
	 Sugg[phr_word, 1] := 0;
end; { MakeSuggestionNew }

procedure AddToLP(var LP     : LongPhrase;
		      arg    : integer;
		      a	     : integer;
		  var ARGS   : integer;
		  var Numarg : integer);
begin
   if Numarg = 3 then
   begin
      writeln('WARNING!!! Could not add another relation, since there is no room');
      writeln('           in the ps file.');
   end else
   begin
      ARGS := ARGS + 1;
      LP[LP_COND,ARGS] := arg;
      LP[LP_LEXNUM,ARGS] := a;
      Numarg := Numarg + 1;
      AnalysisList[a, KO_DET + Numarg] := arg;
   end;
end;


function FindPhraseBoundaryBegin(first, last, current : integer) : integer;
var
   i	 : integer;
   found : boolean;
begin
   (* Find phrase_first *)
   i := current + 1;
   found := false;
   repeat
      i := i - 1;
      (*  Note: This has to be in the following order, in order to
       *  ensure that the single-word phrase case is dealt with
       *  properly. /UP *)
      if (i = first) then
	 found := true
      else if (AnalysisList[i, KO_PTY] <> 0) then
      begin
	 i := i + 1;
	 found := true;
      end;
   until (found);
   FindPhraseBoundaryBegin := i;
end;

function FindPhraseBoundaryEnd(first, last, current : integer) : integer;
var
   i	 : integer;
   found : boolean;
begin
   (* Find phrase_last *)
   i := current - 1;
   found := false;
   repeat
      i := i + 1;
      if (i = last) or (AnalysisList[i, KO_PTY] <> 0) then
	 found := true;
   until (found);
   FindPhraseBoundaryEnd := i;
end;

procedure MakeSuggestionForAllPhrases(var Suggestions : SuggestionsType;
					  first, last : integer);
var
   phr_first, phr_last : integer;
   phr_word, sugg_cond : integer;
begin
   (* Clear Sugg *)
   for phr_word := 1 to MAX_WORDS do
      for sugg_cond := 1 to MAX_CONDITIONS do
	 Suggestions[phr_word, sugg_cond] := -1;

   phr_first := first;
   repeat
      phr_last := FindPhraseBoundaryEnd(phr_first, last, phr_first);
      MakeSuggestionNew(Suggestions, phr_first, phr_last);
      phr_first := phr_last + 1;
   until phr_last >= last;
end;


procedure TryIt(first, last: integer);
var
   Numarg      : integer;
   condnum     : integer;
   ARGS	       : integer;
   c, sugg     : integer;
   a, b, arg   : integer;
   LP	       : LongPhrase;
   answer      : char;
   AddArg      : boolean;
   found       : boolean;
   forceyes    : boolean;
   forceno     : boolean;
   Suggestions : SuggestionsType;
   sugg_sugg   : integer;


function TestNeg (numArg: integer) : boolean;
var
   c			 : integer;
   PosRelUnmatchedExists : boolean;
begin
   PosRelUnmatchedExists := false;
   c := numArg+1;
   if c >= 2 then
      repeat
         c := c - 1;
         if (LP[LP_HAS_MATCH,c] = 0)
	    and ((LP[LP_COND,c] >= 2)
		 and (LP[LP_COND,c] <=  13))
            then
	 begin
	    writeln;
            write(' WARNING: positive RELATION without negative MATCH');
            writeln(' in lexeme number:',(LP[LP_LEXNUM,c]):4);
            writeln('                         so SUGGESTION = ',-(LP[LP_COND,c]):1);
            PosRelUnmatchedExists := true;
         end
      until c = 1;
   TestNeg := PosRelUnmatchedExists;
end;

function IdLex(a,c : integer) : boolean;
var
   x  : integer;
   id : boolean;
begin
   id := true;
   x := 0;
   repeat
      x := x +1;
      if LexemeList[a,x] <> LexemeList[c,x] then id := false;
   until (id = false) or (LexemeList[a,x] = ' ') or (LexemeList[c,x] = ' ');
   if id then writeln(' lexeme',a:4,' identical to lexeme',c:4,'.');
   IdLex := id;
end;

begin
   writeln(' Please indicate internal phrase hierarchy:');
   (* Clear LP. *)
   for a := 1 to 3 do
      for b := 1 to 100 do
         LP[a,b] := 0;

   (* Clear the phrase internal hierarchy in AnalysisList[first..last,...] *)
   for b := first to last do
   begin
      condnum := KO_SPR1 - 1;
      repeat
         condnum := condnum + 1;
         AnalysisList[b, condnum] := -1
      until (AnalysisList[b, condnum+1] = -1) or (condnum = KO_SPR3);
   end;

   a := first-1;
   ARGS := 0;
   repeat
      a := a + 1;

      MakeSuggestionForAllPhrases(Suggestions, a, last);
      sugg := Suggestions[a, 1];

      if sugg <> -1 then
      begin
	 Numarg := 0;
	 repeat
	    forceyes := false;
	    forceno := false;
	    (* Write to screen *)
	    WritePhraseToScreen(first, last, a, true);

	    if sugg <> 0 then
	       begin
		  write(' SUGGESTION(S):');
		  sugg_sugg := 0;
		  repeat
		     sugg_sugg := sugg_sugg + 1;
		     write (' ', Suggestions[a, sugg_sugg] : 4);
		  until (sugg_sugg = MAX_CONDITIONS)
		  or (Suggestions[a, sugg_sugg + 1] = -1);
		  writeln;
	       end;
	    if (sugg = 0) and (AnalysisList[a, KO_PTY] <> 0) then
	    begin
	       writeln(' END of PHRASE_atom. ');
	       if TestNeg(ARGS) then
		  forceyes := true
	       else if (AnalysisList[a, KO_PTY] <> 0) then
		  forceno := true;
	    end;
	    writeln;
	    if forceyes then
	    begin
	       answer := 'y';
	    end
	    else if forceno then
	    begin
	       answer := 'n';
	       if AnalysisList[a, KO_PTY] < 0 then (* apposition *)
	       begin
		  writeln(' Adding -100 as a phrase-internal parsing, in order to be able to recognize apposition.');
		  AddToLP(LP, -100, a, ARGS, Numarg);
	       end;
	    end
	    else
	    begin
	       repeat
		  answer :=' ';
		  writeln(' Do you want to give a relation (more) for the current word? [y/n/s]: ');
		  readln(answer);
	       until answer in ['y', 'Y', 'j', 'J', 'n', 'N', 's', 'S'];
	       writeln(report, 'input: ', answer)
	    end;
	    writeln;
	    if answer in ['s', 'S'] then
	       stop := true
	    else if answer in ['n', 'N'] then
	    begin
	       (* Do nothing *)
	    end
	    else { Answer was YES, we want to give a relation (more) }
	    begin
	       AddArg := false;
	       (* Get correct integer *)
	       repeat
		  found := true;
		  writeln(' what is the relation?  (-1 for list of possibilities)');
		  AskInteger(arg);
		  if (arg = -1) then
		  begin
		     writeln(' Relations:   0:NONE;  2:GEN;  4:ADV;  5:ADJU;  6:PAR;  8:DEM;  13:ATR');
		     writeln('              or a negative of the positive relations.');
		     found := false;
		  end
		  else if not ((abs(arg) in [0, 2, 4, 5, 6, 8, 13]))
		     then
		  begin
		     writeln('Please, type either 0, 2, 4, 5, 6, 8, 13, -2, -4, -5, -6, -8, or -13. Try again.');
		     found := false;
		  end;
	       until found;

	       (* Process arg *)
	       if arg = 0 then
		  writeln('OK. No harm done :-)')
	       else if arg > 0 then
	       begin
		  (* Take care of UNKNOWN STATE *)
		  if (AnalysisList[a, KO_PDP] in [2,13]) and (AnalysisList[a,KO_ST] = 0) then
		  begin
		     writeln(' WARNING: ABS or CONSTR.STATE unknown !!');
		     writeln(' PLease give code [ 1 : constr  2 : abs ]');
		     AskInteger(AnalysisList[a,KO_ST]);
		  end;

		  if a = last then
		  begin
		     writeln(' This is the LAST Word of the Phrase: only NEGATIVE Relations');
		     writeln(' please try again');
		  end else
		  begin
		     if (arg = 2) and ((AnalysisList[a,KO_ST] = 2) or (AnalysisList[a, KO_PRS] >0)) then
		     begin
			if AnalysisList[a, KO_NME] in [3,5,9,10] then
			begin
			   AnalysisList[a,KO_ST]:= 1;                   { constr }
			   writeln(' Error in "State" recovered; please try again');
			end
                        else if AnalysisList[a, KO_NME] in [1,6] then
			begin
			   AnalysisList[a,KO_ST]:= 1;                   { ambi }
			   writeln(' Error in "State" recovered; please try again');
			end
                        else
			begin
			  writeln(' ERROR: This word is in absolute state. Can''t have regens.');
			  if (AnalysisList[a, KO_LS] = -1) then
			  writeln(' WARNING: lexeme is Cardinal; You should use adjunctive connection.');
			  writeln(' please try again');
			end;
		     end else if (arg = 13) and ((AnalysisList[a,KO_ST] = 1) and
						 (AnalysisList[a, KO_PRS] < 1   )) { no sfx }
			and (AnalysisList[a, KO_PRS] <1)
			and not (((a + 3) <= last)
				 and (AnalysisList[a,KO_PDP] = 2)
				 and (AnalysisList[a+1, KO_PDP] = 3)
				 and (AnalysisList[a+2, KO_PDP] = 0)
				 and (AnalysisList[a+3, KO_PDP] = 13)) then
		     begin
			write  (' ERROR: This word is in construct state. ');
			writeln(' It has no suffix. Can''t have positive attr. relation.');
			writeln(' please make a different choice');
		     end
			else if (arg = 5) and ((AnalysisList[a,KO_ST] = 1) and
					        (AnalysisList[a, KO_PRS] < 1   )) { no sfx }
			then
		     begin
			write  (' ERROR: This word is in construct state. ');
			writeln(' It has no suffix. Can''t have positive adjunct relation.');
			writeln(' Do you want a change of state?');
			repeat
			  readln(answer)
			  until answer in ['y', 'Y', 'J', 'j','n', 'N'];
			  writeln(report, 'input: ', answer);
			  if answer in ['y', 'Y', 'J', 'j'] then
			  begin
			     AnalysisList[a,KO_ST] := 2;                   { absol }
			     writeln(' State has been changed; please try again');
			  end
			  else writeln(' please try again');
		     end
		     else
			AddArg := true;
		  end;
	       end else if (arg <= -2) and (arg >= -13) then
	       begin
		  if a = first then
		  begin
		     writeln(' ERROR: This is the FIRST Word of the Phrase: only POSITIVE Relations');
		     writeln(' please try again');
		  end else
		  begin
		     c := 0;
		     found := false;
		     repeat
			c := c +1;
			if (LP[LP_COND,c] = abs(arg)) and (LP[LP_HAS_MATCH,c] = 0) then
			   found := true;
		     until (c >= ARGS) or found;
		     if found then
		     begin
			LP[LP_HAS_MATCH,c] := 1;    { has negative match }
			writeln(' OK; positive match found in lex: ',LP[LP_LEXNUM,c] );
			AddArg := true;
			if (arg = -2) and (IdLex(a,LP[LP_LEXNUM,c])) and
			   (AnalysisList[a, KO_ST] = AnalysisList[LP[LP_LEXNUM,c], KO_ST] ) and
			   (AnalysisList[a, KO_ST] = 2) then
			begin
			   writeln(' This pair should not be parsed as regens/rectum. ');
			   writeln(' It has identical Lexemes, identical State.');
			   writeln(' I will change your parsing: from code (2,-2) to code (5,-5).');
			   LP[LP_COND,c] := 5; arg := -5;
			end;
		     end else
		     begin writeln(' ERROR: No positive match!');
			writeln(' please try again');
		     end;
		  end;
	       end;
	       if AddArg then
		  AddToLP(LP, arg, a, ARGS, Numarg);
	       sugg := 0;
	    end;
	 until answer in ['s', 'S', 'n', 'N'];
      end;
   until (a = last) or stop
end;


procedure PhraseList_Update(p, s: integer);
(* Copy the conditions from struc [s] to pattern [p] of PhraseList *)
var
   l: integer;	(* pattern length *)
   w: integer;	(* word index *)
   c: integer;	(* condition index *)
begin
   l := PhraseLength(PhraseList[p]);
   w := 1;
   while w < l do begin
      c := 0;
      assert(PhraseList[p, c + 1, w] = phraseStrucList[s, w, c]);
      while phraseStrucList[s, w, c] <> EOI do begin
	 c := c + 1;
	 PhraseList[p, c + 1, 2 * l + w] := phraseStrucList[s, w, c]
      end;
      w := w + 1
   end;
   assert(PhraseList[p, 1, w] = PHRASE_SEPARATOR);
   assert(phraseStrucList[s, w, 0] = EOI)
end;


procedure insertPSinfo(first_but_one, last_word: integer);
var condnum : integer;
   mark,
   x, y, w             : integer;
   Expect,
   PhraseInfo          : boolean;
   answer             : char;

begin
   mark := PhraseLength(Phrase);
   w    := mark*2;
   x    := first_but_one;
   PhraseInfo := false;
   Expect := false;
   repeat
      w := w +1;
      x := x+ 1;
      condnum := 1;
      y := 0;
      for condnum := 2 to MAX_CONDITIONS do
         if (Phrase[condnum, w] <> 99) and
            (Phrase[condnum, w] > -100) and
            (Phrase[condnum, w] < 100) then
         begin
            PhraseInfo := true;
            y := y+1;
            AnalysisList[x, KO_DET + y] := Phrase[condnum, w]
         end;
      if AnalysisList[x, LAST_FUNCTION] = 999 then Expect := true;
   until (w+1 = mark*3) or (x = last_word);
   {
    writeln(' PhraseInfo =',PhraseInfo);
    }

   if Expect then begin
      writeln(report, 'words [', first_but_one + 1:1, '..',
	 last_word:1, '] match phrase pattern ', phrase_found:1);
      if PhraseInfo then
	 hits := hits + 1
      else begin
	 writeln(report, 'this yields a new struc');
         missed := missed + 1;
         AnalysisList[x-1, LAST_FUNCTION] := 666;
         writeln(' missed parsing of phrase pattern:', (AnalysisList[x, LAST_FUNCTION]):5);
         if Interactive then
         begin
            repeat
               TryIt(first_but_one+1, last_word);
	       WritePhraseToScreen(first_but_one+1, last_word, last_word + 1, false);
	       write(MP, VerseLabel, ' ', 'words [', first_but_one+1:1, '..',
		  last_word:1, '], phrase pattern ', phrase_found:1);
	       writeln(MP);
	       writeln;
	       writeln;
	       if stop then
		  answer := 's'
	       else
	       begin
		  answer := 'n';
		  writeln(' Are you satisfied with this parsing?    [y/n/s]');
		  repeat
		     readln(answer)
		  until answer in ['y', 'Y', 'J', 'j', 'n', 'N', 'S', 's'];
		  writeln(report, 'input: ', answer)
               end
            until answer in ['j', 'J', 'y', 'Y', 's', 'S'];
            if answer in ['s', 'S'] then
               stop := true
            else if answer in ['j', 'y', 'J', 'Y'] then
            begin
               writeln(' Insert the new pattern in "phrase.struc" ?');
               answer := 'n';
               repeat
                  readln(answer)
               until answer in ['y', 'Y', 'j', 'J', 'n', 'N', 's', 'S'];
	       writeln(report, 'input: ', answer);
               if answer in ['s', 'S'] then
                  stop := true
               else if answer in ['y', 'Y', 'j', 'J'] then
		  PhraseList_Update(phrase_found, InSert(first_but_one+1, last_word))
            end;
         end;
      end
   end;
end;


function Match_POS(p, w: integer): boolean;
(* Return whether the part of speech of word w matches phrase pattern p *)
begin
   Match_POS := Phrase[PSP_INFO, w] = PhraseList[p, PSP_INFO, w]
end;


function Match_PhraseLevel(p, w, l: integer): boolean;
(* Return whether at word w the four columns of phrase level match
   phrase pattern p, which has a length of l *)
const
   N = KO_DET - KO_ST + 1;	(* Number of columns *)
var
   idem: boolean;
   i: integer;			(* Word index *)
   k: integer;			(* Column *)
begin
   k := 0;
   idem := true;
   while idem and (k < N) do begin
      k := k + 1;
      i := k * l + w;
      idem := Phrase[PSP_INFO, i] = PhraseList[p, PSP_INFO, i]
   end;
   Match_PhraseLevel := idem
end;


function Match_Conditions(p, w, l, x: integer): boolean;
(* Return whether word w meets the conditions of phrase pattern p,
   which has a length of l. The index of w in AnalysisList is x. *)
var
   i: integer;
   head, idem: boolean;
begin
   head := w = 1;
   w := 2 * l + w;
   i := 1;
   idem := true;
   while idem and (PhraseList[p, i, w] <> EOI) do begin
      case PhraseList[p, i, w] of
	 204: (* Not found in phrase.param. Obsolete? *)
	    idem := AnalysisList[x, KO_PRS] > 0;
	 205:
	    idem := not head and (LexemeList[x - 1] = LexemeList[x]);
	 206:
	    idem := (AnalysisList[x, KO_LS] = LS_CARD) and
		    (AnalysisList[x, KO_SP] = SP_SUBS);
      otherwise
	 (* Already checked *)
      end;
      i := i + 1
   end;
   Match_Conditions := idem
end;


function ComparePhrases(var List: PhraseListType; offset: integer): integer;
(* Finds the pattern in the phrase set (List) that matches Phrase.
   The index of the pattern is returned and the conditions of the
   pattern are copied to Phrase. *)
var
   id, ident	: boolean;
   psp_index	: integer;
   mark,w	: integer;
   phrase_index	: integer;
   cond_index	: integer;
begin
   phrase_index := 0;
   psp_index := 1;
   write(' search for', (Phrase[PSP_INFO, psp_index]): 4, ' in Nphrset;');
   repeat
      phrase_index := phrase_index + 1
   until Phrase[PSP_INFO, psp_index] = List[phrase_index, PSP_INFO, psp_index];
     write(' start recogn. at position:',phrase_index:5);  {...}
   phrase_index := phrase_index -1;

   repeat
      phrase_index := phrase_index + 1;
      psp_index := 0;
      repeat
         psp_index := psp_index +1;
      until (Phrase[PSP_INFO, psp_index] = PHRASE_SEPARATOR);
      mark := psp_index;
      { writeln(' test equal range of psp'); }
      psp_index := 1;
      id := true;
      while id and (Phrase[PSP_INFO, psp_index] <> PHRASE_SEPARATOR) do begin
	 id :=
	    Match_POS(phrase_index, psp_index) and
	    Match_PhraseLevel(phrase_index, psp_index, mark) and
	    Match_Conditions(phrase_index, psp_index, mark, offset + psp_index);
         psp_index := psp_index + 1
      end;
      { test equal conditions }
      { STATE }
      ident := id and (List[phrase_index, PSP_INFO, psp_index] = PHRASE_SEPARATOR);
      psp_index := psp_index - 1
   until ident or
      (phrase_index = PhrTypeCount) or
      (Phrase[PSP_INFO, 1] <> List[phrase_index, PSP_INFO, 1]);

   if not ident then begin
      writeln(' [NOT FOUND]');
      ComparePhrases := 0
   end else begin
      writeln(' identified, phrase nm:', phrase_index:5, ' in nphrset');
      { Copy conditions from List to Phrase for all words. }
      mark := psp_index +1;
      w    := mark*2;
      repeat
         cond_index := 1;
         w := w+1;         (* write('[',(Phrase[cond_index,w]):3,']'); *)
         repeat
            cond_index := cond_index +1;
            Phrase[cond_index, w] := List[phrase_index, cond_index, w];
         until cond_index = MAX_CONDITIONS
      until w+1 = mark*3;      {    writeln;  }
      ComparePhrases := phrase_index
  end;
end;

procedure CopyPhrase(StartOfPhrase, LastWordOfPhrase : integer);
var
   psp_index  : integer;
   word_index : integer;
begin
   psp_index := 0;

   for word_index := StartOfPhrase to LastWordOfPhrase do
   begin
      psp_index := psp_index + 1;
      Phrase[PSP_INFO, psp_index] := AnalysisList[word_index, KO_SP];
      if (AnalysisList[word_index, KO_SP] < 0) then
      begin writeln(' part of speech',(AnalysisList[word_index, KO_SP]):3,' in word', word_index:3,' wrong');
	    writeln(' I will try the phrase dependent part of speech');
	    Phrase[PSP_INFO, psp_index] := AnalysisList[word_index, KO_PDP];
	    if AnalysisList[word_index, KO_PDP] < 0 then
	    begin
	    writeln(' part of speech',(AnalysisList[word_index, KO_PDP]):3,' in word', word_index:3,' wrong');
	    halt;
	    end;
      end;
   end;

   word_index := StartOfPhrase-1;
   psp_index := psp_index + 1;               { start next series of info }
   Phrase[PSP_INFO, psp_index] := PHRASE_SEPARATOR;
   repeat
      word_index := word_index + 1;
      psp_index := psp_index + 1;
      Phrase[PSP_INFO, psp_index] := AnalysisList[word_index, KO_ST]
   until (word_index = LastWordOfPhrase);  { STATE }

   word_index := StartOfPhrase-1;
   psp_index := psp_index + 1;
   Phrase[PSP_INFO, psp_index] := PHRASE_SEPARATOR;
   repeat
      word_index := word_index + 1;
      psp_index := psp_index + 1;
      Phrase[PSP_INFO, psp_index] := AnalysisList[word_index, KO_PDP]
   until (word_index = LastWordOfPhrase);

   word_index := StartOfPhrase-1;                           { PHRDEP_PSP }
   psp_index := psp_index + 1;
   Phrase[PSP_INFO, psp_index] := PHRASE_SEPARATOR;
   repeat
      word_index := word_index + 1;
      psp_index := psp_index + 1;
      Phrase[PSP_INFO, psp_index] := AnalysisList[word_index, KO_PTY]
   until (word_index = LastWordOfPhrase);
   { PHRASE_TYPE }
   word_index := StartOfPhrase-1;
   psp_index := psp_index + 1;
   Phrase[PSP_INFO, psp_index] := PHRASE_SEPARATOR;
   repeat
      word_index := word_index + 1;
      psp_index := psp_index + 1;
      Phrase[PSP_INFO, psp_index] := AnalysisList[word_index, KO_DET]
   until (word_index = LastWordOfPhrase);  {DETERMINATION }

   Phrase[PSP_INFO, psp_index + 1] := PHRASE_SEPARATOR;
   { DETERM }
end;


function NextPhraseType(w: integer): integer;
(* Return the phrase type of the phrase atom that follows the phrase
   atom ending at word [w] *)
var
   t: integer;	(* phrase type *)
begin
   t := 0;
   while (t = 0) and (w < WordCount) do begin
      w := w + 1;
      t := AnalysisList[w, KO_PTY]
   end;
   NextPhraseType := t
end;


function PronominalSuffix(w: integer): boolean;
(* Return whether word [w] is a pronominal suffix *)
begin
   PronominalSuffix :=
      (AnalysisList[w, KO_LS] = LS_SFFX) and
      (AnalysisList[w, KO_SP] = SP_PRPS)
end;


procedure FindPhraseLimits(var b, e: integer; l: integer);
(* Find the limits of the next phrase pattern after the pattern that
   begins at word [b] and ends at word [e] in this verse of length [l].
   The variables [b] and [e] are updated with the new limits found. *)
var
   hungry: boolean;
   w: integer;
begin
   w := e;
   hungry := true;
   while hungry and (w < l) do begin
      w := w + 1;
      hungry :=
	 (AnalysisList[w, KO_PTY] = 0)
	 or
	 (NextPhraseType(w) < 0)
	 or
	 (e + 1 = w) and
	 (AnalysisList[w, KO_SP] <> AnalysisList[w, KO_PDP])
	 or
	 (w < l) and
	 PronominalSuffix(w + 1)
	 or
	 (w + 1 = l) and
	 (AnalysisList[l, KO_SP] <> AnalysisList[l, KO_PDP])
   end;
   b := e + 1;
   e := w
end;


procedure IdentifyPhrases(verse_length: integer);
var
   psp_index	    : integer;
   StartOfPhrase    : integer;
   LastWordOfPhrase : integer;
begin
   writeln('start IdentifyPhrases');
   StartOfPhrase := 0;
   LastWordOfPhrase := 0;
   PhraseClear(Phrase);

   (* Repeat for every `phrase' in verse *)
   while (StartOfPhrase < verse_length) and not stop do begin
      psp_index := 0;
      FindPhraseLimits(StartOfPhrase, LastWordOfPhrase, verse_length);
      CopyPhrase(StartOfPhrase, LastWordOfPhrase);
      phrase_found := ComparePhrases(PhraseList, StartOfPhrase-1);
      if phrase_found > 0 then
	 insertPSinfo(StartOfPhrase-1, LastWordOfPhrase)
      else begin
	 message('parsephrases: Phrase set does not match text in ',
	    VerseLabel, ' ', '[', StartOfPhrase:1, '..', LastWordOfPhrase:1, ']');
	 WritePhraseStrucList;
	 pcexit(1)
      end;
      AnalysisList[LastWordOfPhrase, LAST_FUNCTION] := phrase_found;
      if StartOfPhrase < verse_length then
	 PhraseClear(Phrase);
      StartOfPhrase := LastWordOfPhrase;
   end
end;


function CompareBoundaries(A, B : integer) : integer;
var
   result			: integer;
   Adistance, Bdistance		: integer;
   ABoundaryWord, BBoundaryWord	: integer;
   AColumnIndex, BColumnIndex	: integer;
begin
   ABoundaryWord := BoundaryPointers[A].BoundaryIndex;
   BBoundaryWord := BoundaryPointers[B].BoundaryIndex;
   AColumnIndex :=  BoundaryPointers[A].ColumnIndex;
   BColumnIndex :=  BoundaryPointers[B].ColumnIndex;
   if (ABoundaryWord < BBoundaryWord) then
      result := -1
   else if (ABoundaryWord > BBoundaryWord) then
      result := 1
   else
   begin
      (* ABoundaryWord = BBoundaryWord *)
      Adistance := abs(Boundaries[ABoundaryWord, AColumnIndex].DistToPlusEnd);
      Bdistance := abs(Boundaries[BBoundaryWord, BColumnIndex].DistToPlusEnd);
      if (Adistance < Bdistance) then
	 result := -1
      else if (Adistance > Bdistance) then
	 result := 1
      else
      begin
	 result := 0;
      end;
   end;
   CompareBoundaries := result;
end;

function DoNotGoPastEqualAtSameLevel(BoundaryWord		: integer;
				     PosEndWord, ColumnOfPosEnd	: integer;
				     NegEndWord, ColumnOfNegEnd	: integer;
				     LastWordOfPrevPhrAtom	: integer) : boolean;
var
   DoNotGoPast : boolean;
   sp	       : integer;
begin
   sp := 0;
   if BoundaryWord <> PosEndWord then
      DoNotGoPast := false
   else
   begin
      DoNotGoPast := false;
      repeat
	 sp := sp + 1;
	 if (Boundaries[BoundaryWord, sp].code < -1) then
	 begin
	    if (BoundaryWord = PosEndWord) and
	       (Boundaries[PosEndWord, ColumnOfPosEnd].code
		= -Boundaries[BoundaryWord, sp].code) then
	    begin
	       if Boundaries[PosEndWord, ColumnOfPosEnd].Level <=
		  Boundaries[BoundaryWord, sp].Level then
		  DoNotGoPast := true;
	    end;
	 end;
      until DoNotGoPast or (sp = 3);
      if DoNotGoPast and (Boundaries[PosEndWord, ColumnOfPosEnd].code = 6)
	 and(AnalysisList[LastWordOfPrevPhrAtom + PosEndWord, KO_PDP] <>
	     AnalysisList[LastWordOfPrevPhrAtom + NegEndWord +
	     + Boundaries[NegEndWord, ColumnOfNegEnd].DistToBeginning,
	     KO_PDP]) then
      begin
	 DoNotGoPast := false;
      end else
   end;

   DoNotGoPastEqualAtSameLevel := DoNotGoPast;
end; { DoNotGoPastEqualAtSameLevel }

function DoNotGoPastFarthestEnding(PosBeginningWord	  : integer;
				   PosEndWord, NegEndWord : integer) : boolean;
var
   res : boolean;
begin
   res := false;
   if (FarthestEnding[PosBeginningWord] > PosEndWord)
      or (FarthestEnding[PosBeginningWord] > NegEndWord)
      then
      res := true
   else res := false;
   DoNotGoPastFarthestEnding := res;
end; { DoNotGoPastFarthestEnding }

function ThereIsANeg(	 BoundaryWord		    : integer;
		     var sp			    : integer) : boolean;
var
   found	      : boolean;
   GreatestDistToPlus : integer;
   ColOfGreatestDist  : integer;
begin
   found := false;
   sp := 0;
   GreatestDistToPlus := 1;
   repeat
      sp := sp + 1;
      if (Boundaries[BoundaryWord, sp].code < -1) then
      begin
	 found := true;
	 if Boundaries[BoundaryWord, sp].DistToPlusEnd < GreatestDistToPlus
	    then
	 begin
	    GreatestDistToPlus := Boundaries[BoundaryWord, sp].DistToPlusEnd;
	    ColOfGreatestDist := sp;
	 end;
      end;
   until (sp = 3);
   ThereIsANeg := found;
   sp := ColOfGreatestDist;
end; { ThereIsANeg }

function FindPosBoundary(NegEndWord, ColumnOfNegEnd : integer;
			 CodeOfPosEnd		    : integer;
			 PosEndWord, ColumnOfPosEnd : integer;
			 LastWordOfPrevPhrAtom	    : integer) : integer;
var
   PosBeginningWord	    : integer;
   PossiblePosBeginningWord : integer;
   ColumnOfNeg		    : integer;
   ColumnOfPos		    : integer;
   CodeOfPos		    : integer;
   bw			    : integer; (* Bad Word *)
   badfound		    : boolean;
   found		    : boolean;
begin
   if (PosEndWord = 1) then
      PosBeginningWord := 1
   else
   begin
      PosBeginningWord := PosEndWord+1;
      found := false;
      repeat
	 PosBeginningWord := PosBeginningWord - 1;
	 if DoNotGoPastEqualAtSameLevel(PosBeginningWord, PosEndWord, ColumnOfPosEnd, NegEndWord, ColumnOfNegEnd, LastWordOfPrevPhrAtom) then
	 begin
	    found := true;
	 end else if DoNotGoPastFarthestEnding(PosBeginningWord, PosEndWord, NegEndWord) then
	 begin
	    found := true;
	    if  (AnalysisList[LastWordOfPrevPhrAtom + PosBeginningWord, KO_PDP]
		   = 5)
	    and (CodeOfPosEnd <> 6)
	    then
	    begin
	       PosBeginningWord := PosBeginningWord + 1;
	    end
	 end else if (ThereIsANeg(PosBeginningWord, ColumnOfNeg)) then
	 begin
	    PossiblePosBeginningWord := PosBeginningWord +
	    Boundaries[PosBeginningWord, ColumnOfNeg].DistToPlusEnd;
	    CodeOfPos := -Boundaries[PosBeginningWord, ColumnOfNeg].code;
	    ColumnOfPos := Boundaries[PosBeginningWord, ColumnOfNeg].ColOfOther;	       bw := PosBeginningWord + 1;
	    badfound := false;
	    repeat
	       bw := bw - 1;
	       if (FarthestEnding[bw] > PosBeginningWord) then
		  badfound := true;
	    until badfound or (bw = PossiblePosBeginningWord);
	    if not badfound then
	    begin
	       (*  Let's go on with the PossibleBeginingWord.
		*  1 is added because in the next loop,
		*  1 is subtracted. *)
	       PosBeginningWord := PossiblePosBeginningWord + 1;
	    end;
	 end else if (AnalysisList[LastWordOfPrevPhrAtom + PosBeginningWord, KO_PDP]
		      = 6) then
	 begin
	    found := true;
	    PosBeginningWord := PosBeginningWord + 1;
	    if (AnalysisList[LastWordOfPrevPhrAtom + PosBeginningWord, KO_PDP]
		= 5)
	       and (CodeOfPosEnd <> 6)
	       then
	    begin
	       PosBeginningWord := PosBeginningWord + 1;
	    end;
	 end
	 else if  (AnalysisList[LastWordOfPrevPhrAtom + PosBeginningWord, KO_PDP]
		   = 5)
	    and (CodeOfPosEnd <> 6)
	    then
	 begin
	    found := true;
	    PosBeginningWord := PosBeginningWord + 1;
	 end
	 else if (FarthestEnding[PosBeginningWord] <> 0) and (FarthestEnding[PosBeginningWord] <= NegEndWord) then
	 begin
	    if CodeOfPosEnd = 6 then
	    begin
	       if AnalysisList[PosBeginningWord, KO_PDP] =
		  AnalysisList[Boundaries[NegEndWord,ColumnOfNegEnd].DistToBeginning+NegEndWord,KO_PDP] then
	       begin
		  found := true;
	       end;
	    end
	    else
	    begin
	       found := true;
	    end;
	 end;
	 if (PosBeginningWord = 1) then
	 begin
	    found := true;
	 end;
      until found;
   end;
   FindPosBoundary := PosBeginningWord;
end;

procedure FindPosBoundaries(NoOfNegs		  : integer;
			    LastWordOfPrevPhrAtom : integer);
var
   PosBeginningWord	    : integer;
   PosEndWord		    : integer;
   PointerIndex		    : integer;
   CodeOfPosEnd		    : integer;
   NegEndWord		    : integer;
   ColumnOfPosEnd	    : integer;
   ColumnOfNegEnd	    : integer;
begin
   if NoOfNegs > 0 then
   begin
      for PointerIndex := 1 to NoOfNegs do
      begin
	 NegEndWord := BoundaryPointers[PointerIndex].BoundaryIndex;
	 ColumnOfNegEnd := BoundaryPointers[PointerIndex].ColumnIndex;
	 PosEndWord := NegEndWord + Boundaries[NegEndWord, ColumnOfNegEnd].DistToPlusEnd;
	 CodeOfPosEnd := -Boundaries[NegEndWord, ColumnOfNegEnd].code;
	 ColumnOfPosEnd := Boundaries[NegEndWord, ColumnOfNegEnd].ColOfOther;
	 PosBeginningWord := FindPosBoundary(NegEndWord, ColumnOfNegEnd,
					     CodeOfPosEnd, PosEndWord,
					     ColumnOfPosEnd,
					     LastWordOfPrevPhrAtom);
	 Boundaries[PosEndWord, ColumnOfPosEnd].DistToBeginning :=
	 PosBeginningWord - PosEndWord;
	 if (FarthestEnding[PosBeginningWord] < PosEndWord) then
	    FarthestEnding[PosBeginningWord] := PosEndWord;
      end;
   end;
end;

procedure FindNegBoundaries(NoOfNegs		  : integer;
			    LastWordOfPrevPhrAtom : integer);
var
   PointerIndex	    : integer;
   NegEndWord	    : integer;
   PosBoundaryWord  : integer;
   NegBeginningWord : integer;
   DistFromPosEnd   : integer;
   BoundaryWord	    : integer;
   ColumnIndex	    : integer;
begin
   if NoOfNegs > 0 then
   begin
      for PointerIndex := 1 to NoOfNegs do
      begin
	 BoundaryWord := BoundaryPointers[PointerIndex].BoundaryIndex;
	 ColumnIndex := BoundaryPointers[PointerIndex].ColumnIndex;
	 NegEndWord := BoundaryWord;
	 PosBoundaryWord := Boundaries[NegEndWord, ColumnIndex].DistToPlusEnd
	 + NegEndWord;
	 if (AnalysisList[LastWordOfPrevPhrAtom+PosBoundaryWord+1, KO_PDP]
	     = 6) then { "W" } (* NB: Maybe we should check lexeme? *)
	 begin
	    if (AnalysisList[LastWordOfPrevPhrAtom+PosBoundaryWord+2, KO_PDP]
		= 5)
	       and (Boundaries[NegEndWord, ColumnIndex].code <> -6) then
	       DistFromPosEnd := 3
	    else
	       DistFromPosEnd := 2;
	 end
	 else DistFromPosEnd := 1;
	 NegBeginningWord := PosBoundaryWord + DistFromPosEnd;
	 Boundaries[NegEndWord, ColumnIndex].DistToBeginning :=
	 (NegBeginningWord - NegEndWord);
	 if (FarthestEnding[NegBeginningWord]
	     < (NegEndWord)) then
	 begin
	    FarthestEnding[NegBeginningWord]
	    := NegEndWord;
	 end;
      end;
   end;
end;

procedure EnterLevel(NegWord, NegColumn, Level	: integer);
var
   PosBoundaryWord : integer;
   PosColumn	   : integer;
   sp		   : integer;
   PosCode	   : integer;
begin
   Boundaries[NegWord, NegColumn].Level := Level;
   PosBoundaryWord := NegWord +
   Boundaries[NegWord, NegColumn].DistToPlusEnd;
   PosColumn := Boundaries[NegWord, NegColumn].ColOfOther;
   Boundaries[PosBoundaryWord, PosColumn].Level := Level-1;
   sp := 0;
   PosCode := -Boundaries[NegWord, NegColumn].code;
   repeat
      sp := sp + 1;
      if Boundaries[NegWord, sp].code = PosCode then
	 Boundaries[NegWord, sp].Level := Boundaries[NegWord, sp].Level + 1;

   until sp = 3;
end; { EnterLevel }

procedure FindLevels(PhrAtomLength : integer);
var
   BoundaryWord	: integer;
   NegCode	: integer;
   start_index	: integer;
   sp		: integer;
   NoOfNegs	: integer;
   index	: integer;
   search_index	: integer;
   smallest	: integer;
   temp		: integer;
   NegativeCols	: array[1..3] of integer;
   PointerCols	: array[1..3] of integer;
   HasBeenTaken	: array[1..3] of boolean;
begin
   BoundaryWord := PhrAtomLength + 1;
   repeat
      BoundaryWord := BoundaryWord - 1;
      for index := 1 to 3 do
	 HasBeenTaken[index] := false;
      for start_index := 1 to 2 do
      begin
	 if (Boundaries[BoundaryWord, start_index].code < -1)
	    and not HasBeenTaken[start_index] then
	 begin
	    NegCode := Boundaries[BoundaryWord, start_index].code;
	    for index := 1 to 3 do
	    begin
	       NegativeCols[index] := -1;
	       PointerCols[index] := index;
	    end;

	    (* Copy negs of the same kind *)
	    sp := start_index-1;
	    NoOfNegs := 0;
	    repeat
	       sp := sp + 1;
	       if Boundaries[BoundaryWord, sp].code = NegCode then
	       begin
		  NoOfNegs := NoOfNegs + 1;
		  NegativeCols[NoOfNegs] := sp;
	       end;
	    until sp = 3;

	    if NoOfNegs > 1 then
	    begin
	       for index := 1 to NoOfNegs-1 do
	       begin
		  smallest := index;
		  for search_index := index to NoOfNegs do
		     if abs(Boundaries[BoundaryWord, NegativeCols[PointerCols[smallest]]].DistToPlusEnd) >
			abs(Boundaries[BoundaryWord, NegativeCols[PointerCols[search_index]]].DistToPlusEnd) then
			smallest := search_index;
		  temp := PointerCols[smallest];
		  PointerCols[smallest] := PointerCols[index];
		  PointerCols[index] := temp;
	       end;
	    end;
	    for index := 1 to NoOfNegs do
	    begin
	       EnterLevel(BoundaryWord, NegativeCols[PointerCols[index]], index);
	       HasBeenTaken[NegativeCols[PointerCols[index]]] := true;
	    end;
	 end;
      end;
   until BoundaryWord = 1;
end; { FindLevels }

procedure ClearFarthestEndingArray(PhrAtomLength : integer);
var
   BoundaryWord	: integer;
begin
   for BoundaryWord := 1 to PhrAtomLength do
      FarthestEnding[BoundaryWord] := 0;
end;

procedure SortBoundaries(NoOfNegs : integer);
var
   index	: integer;
   search_index	: integer;
   smallest	: integer;

procedure SwapPointers(a, b : integer);
var
   temp	: integer;
begin
   temp := BoundaryPointers[a].BoundaryIndex;
   BoundaryPointers[a].BoundaryIndex := BoundaryPointers[b].BoundaryIndex;
   BoundaryPointers[b].BoundaryIndex := temp;
   temp := BoundaryPointers[a].ColumnIndex;
   BoundaryPointers[a].ColumnIndex := BoundaryPointers[b].ColumnIndex;
   BoundaryPointers[b].ColumnIndex := temp;
end; { SwapPointers }

begin
   for index := 1 to NoOfNegs-1 do
   begin
      smallest := index;
      for search_index := index to NoOfNegs do
	 if CompareBoundaries(smallest, search_index) > 0 then
	    smallest := search_index;
      SwapPointers(smallest, index);
   end;
end;

function FindPointers(PhrAtomLength : integer) : integer;
var
   BoundaryWord	: integer;
   sp		: integer;
   NoOfNegs	: integer;
   StopThis	: boolean;
begin
   NoOfNegs := 0;
   for BoundaryWord := 1 to PhrAtomLength do
   begin
      sp := 0;
      StopThis := false;
      repeat
	 sp := sp + 1;
	 if (Boundaries[BoundaryWord, sp].code = -1) then
	    StopThis := true
	 else
	 begin
	    if (Boundaries[BoundaryWord, sp].code < -1) then
	    begin
	       NoOfNegs := NoOfNegs + 1;
	       BoundaryPointers[NoOfNegs].BoundaryIndex := BoundaryWord;
	       BoundaryPointers[NoOfNegs].ColumnIndex := sp;
	    end;
	 end;
      until (sp = 3) or StopThis;
   end;
   FindPointers := NoOfNegs;
end;

procedure ClearBoundariesArray(max : integer);
var
   p  : integer;
   sp : integer;
begin
   for p := 1 to max do
      for sp := 1 to 3 do
      begin
	 Boundaries[p,sp].code := -1;
	 Boundaries[p,sp].DistToPlusEnd := 0;
	 Boundaries[p,sp].DistToBeginning := 0;
	 Boundaries[p,sp].PlusHasBeenTaken := false;
	 Boundaries[p,sp].Level := 0;
      end;
end;

procedure CopyPhraseParsing(FirstWordOfPhrAtom : integer;
			    LastWordOfPhrAtom  : integer);
var
   Word	    : integer;
   sp	    : integer;
   code	    : integer;
   StopThis : boolean;
begin
   for Word := FirstWordOfPhrAtom to LastWordOfPhrAtom do
   begin
      sp := KO_SPR1 - 1;
      StopThis := false;
      repeat
	 sp := sp + 1;
	 code := AnalysisList[Word, sp];
	 if code = -1 then
	    StopThis := true
	 else
	 begin
	    if code <> -100 then
	       Boundaries[Word - FirstWordOfPhrAtom + 1,
			  sp - KO_SPR1 + 1].code := code;
	 end;
      until (sp = KO_SPR3) or StopThis;
   end;
end; { CopyPhraseParsing }

procedure FindPlus(NegBoundaryWord : integer;
		   Column	   : integer;
		   var STOP        : boolean);
var
   BoundaryWord	 : integer;
   sp		 : integer;
   code		 : integer;
   CodeToLookFor : integer;
   found	 : boolean;
   StopThis	 : boolean;
begin
   BoundaryWord := NegBoundaryWord;
   CodeToLookFor := abs(Boundaries[NegBoundaryWord, Column].code);
   found := false;
   repeat
      BoundaryWord := BoundaryWord - 1;
      sp := 0;
      StopThis := false;

      repeat
	 sp := sp + 1;
	 code := Boundaries[BoundaryWord,sp].code;
	 if code = -1 then
	    StopThis := true
	 else
	 begin
	    if (code = CodeToLookFor)
	       and not (Boundaries[BoundaryWord, sp].PlusHasBeenTaken) then
	       found := true;
	 end;
      until (sp = 3) or StopThis or found;
   until (BoundaryWord = 1) or found;
   if not found then
   begin
      writeln(' ERROR: Plus not found for NegBoundaryWord ', NegBoundaryWord:1);
      writeln('        BoundaryWord =',BoundaryWord,' sp =',sp, ' code =',code);
      writeln(' please CHECK: there could be a wrong pattern in nphrset [ or in phrase.struc]');
      writeln(' < Enter >');
      readln;
      BoundaryWord := NegBoundaryWord ; writeln(' I will try to proceed ...');
      STOP := true;
      { halt;}
   end;
   { else    if (found) or (BoundaryWord = 1) }
   begin
      Boundaries[BoundaryWord, sp].PlusHasBeenTaken := true;
      Boundaries[NegBoundaryWord, Column].DistToPlusEnd :=
      (BoundaryWord - NegBoundaryWord);
      Boundaries[NegBoundaryWord, Column].ColOfOther := sp;
      Boundaries[BoundaryWord, sp].ColOfOther := Column;
   end;
end; { FindPlus }


procedure PairUpPlusAndMinus(PhrAtomLength : integer);
var
   BoundaryWord	: integer;
   sp		: integer;
   code		: integer;
   StopThis	: boolean;
begin
   {writeln(' PhrAtomLength =',PhrAtomLength:3); }
   if PhrAtomLength > 1 then
      (* There should be no negative relations in the first one! *)
      for BoundaryWord := 2 to PhrAtomLength do
      begin
	 sp := 0;
	 StopThis := false;
	 repeat
	    sp := sp + 1;
	    code := Boundaries[BoundaryWord, sp].code;
	    if code = -1 then
	       StopThis := true
	    else
	    begin
	    if ((code < -1) and (code > -9)) or (code = -13) then
	       FindPlus(BoundaryWord, sp, StopThis);
	    end;
	 until (sp = 3) or StopThis;
      end;
end;

function CalculateBoundaryNumber(BoundaryWord : integer;
				 Column	      : integer) : integer;
var
   code		   : integer;
   DistToBeginning : integer;
   DistToPlusEnd   : integer;
   res		   : integer;
begin
   code := Boundaries[BoundaryWord, Column].code;
   if code = -1 then
      res := -1
   else
   begin
      DistToBeginning := Boundaries[BoundaryWord, Column].DistToBeginning;
      DistToPlusEnd := Boundaries[BoundaryWord, Column].DistToPlusEnd;
      if code < 0 then
	 res := -1*(abs(DistToBeginning)*100
		    + abs(DistToPlusEnd)*10000
		    + abs(code))
      else
	 res := abs(DistToBeginning)*100 + code;
      if DistToBeginning > 0 then
      begin
	 writeln(' UP 1010. DistToBeginning = ', DistToBeginning:1,' > 0. BoundaryWord = ', BoundaryWord:1, ' Column = ', Column:1);
{	 halt; }
      end;
   end;
   CalculateBoundaryNumber := res;

end; { CalculateBoundaryNumber }

procedure CopyPhraseBoundariesToAnalysisList(LastWordOfPrevPhrAtom : integer;
					     PhrAtomLength	   : integer);
var
   BoundaryWord	: integer;
   Column	: integer;
begin
   for BoundaryWord := 1 to PhrAtomLength do
      for Column := 1 to 3 do
      begin
	 AnalysisList[BoundaryWord + LastWordOfPrevPhrAtom,
		      KO_SPR1 - 1 + Column] :=
	 CalculateBoundaryNumber(BoundaryWord, Column);
      end;
end;

procedure FindBoundaries(verse_length: integer);
var
   word			 : integer;
   LastWordOfPrevPhrAtom : integer;
   PhrAtomLength	 : integer;
   FirstWordOfPhrAtom	 : integer;
   NoOfNegs	 : integer;
begin
   LastWordOfPrevPhrAtom := 0;
	 write (' verse_length =',verse_length);
   word := 0;
   repeat
      word := word + 1;
      writeln(' wordnr:',word:4);
      if (AnalysisList[word, KO_PTY] <> 0)
	 and
	 (not (    (AnalysisList[word, KO_PTY] <> 0 ) {app of one element}
	       and (word > 1)
	       and (AnalysisList[word-1, KO_PTY] < 0)
	      )
	 )
      then
      begin
	 FirstWordOfPhrAtom := LastWordOfPrevPhrAtom + 1;
	 CopyPhraseParsing(FirstWordOfPhrAtom, word);
	 PhrAtomLength := word - LastWordOfPrevPhrAtom;

	 (* Do pairing up of plusses and minusses *)
	 PairUpPlusAndMinus(PhrAtomLength);

	 (* Sort boundaries *)
	 NoOfNegs := FindPointers(PhrAtomLength);
	 if NoOfNegs > 0 then
	 begin
	    FindLevels(PhrAtomLength);
	    SortBoundaries(NoOfNegs);

	    (* Find Boundaries *)
	    ClearFarthestEndingArray(PhrAtomLength);
	    FindNegBoundaries(NoOfNegs, LastWordOfPrevPhrAtom);
	    FindPosBoundaries(NoOfNegs, LastWordOfPrevPhrAtom);
	 end;
	 (* Put boundaries back in AnalysisList *)
	 CopyPhraseBoundariesToAnalysisList(LastWordOfPrevPhrAtom,
					    PhrAtomLength);

	 (* Prepare for next phrase atom *)
	 ClearBoundariesArray(PhrAtomLength);
	 LastWordOfPrevPhrAtom := word;
      end;
   until word = verse_length;
   writeln(' END_of_FindBoundaries');
end;


procedure ClearAnalysisList(var list: AnalysisListType);
var
   word_index:  WordIndexType;
   func_index:  FunctionIndexType;
begin
   for word_index := 1 to MAX_WORDS do
      for func_index := FIRST_FUNCTION to LAST_FUNCTION do
         list[word_index, func_index] := UNDEFINED
end; { ClearAnalysisList }

procedure ClearPhraseList(var PhraseList: PhraseListType);
var
   phrase_index: integer;
begin
   PhraseClear(PhraseList[1]);
   for phrase_index := 2 to MAX_PHRASES do
      PhraseList[phrase_index] := PhraseList[1];
   for phrase_index := 1 to 14 do begin
      PhraseList[phrase_index, 1, 0] := 0;
      PhraseList[phrase_index, 1, 1] := phrase_index - 1
   end;
   PhrTypeCount := 14
end; { ClearPhraseList }



procedure inleesphrset;
var
ch:char;
   phrase_index, psp_index, psp, condition_index, cond: integer;
begin
   phrase_index := 0;
   psp_index := 0;
   psp := 0;
   while not eof(NPhraseSet) do
   begin
      phrase_index := phrase_index + 1;
      psp_index := 0;
      condition_index := 0;
      while not eoln(NPhraseSet) do
      begin
         psp_index := psp_index + 1;
         read(NPhraseSet, psp);
         PhraseList[phrase_index, 1, psp_index] := psp;
         PhraseList[phrase_index, 2, psp_index] := EOI;
         PhraseList[phrase_index, 1, 0] := 0;
         repeat
            if not eoln(NPhraseSet) then
               read(NPhraseSet, ch)
            until (ch in ['(', '-', '=']) or eoln(NPhraseSet);
         condition_index := 1;
         if ch = '(' then
         begin
            repeat
               read(NPhraseSet, cond);
               repeat
                  read(NPhraseSet, ch)
               until ch in [')', ','];
               if condition_index < MAX_CONDITIONS then begin
                  condition_index := condition_index + 1;
                  PhraseList[phrase_index, condition_index, psp_index] := cond
               end
            until ch = ')';
            if condition_index < MAX_CONDITIONS then
               PhraseList[phrase_index, condition_index + 1, psp_index] := EOI
         end else if ch = '=' then
         begin
            psp_index := psp_index + 1;
            PhraseList[phrase_index, 1, psp_index] := PHRASE_SEPARATOR;
            PhraseList[phrase_index, 2, psp_index] := EOI
         end
      end;
      if phrase_index mod 100 = 0 then writeln(phrase_index:5);

      PhraseList[phrase_index, 1, psp_index + 1] := EOI;
      readln(NPhraseSet)
   end;
   writeln('phrase types from phrset:', phrase_index: 4);
   PhrTypeCount := phrase_index;
end; { inleesphrset }


procedure AskCheck(var check: boolean);
var
   answer: char;
begin
   repeat
      writeln(' Do you want to work interactively?   [y/n] ');
      readln(answer)
   until answer in ['j', 'n', 'y'];;
   writeln(report, 'input: ', answer);
   check := answer in ['j', 'y']
end; { AskCheck }


procedure Initialize;
begin
   LineCount := 0;
   PhrTypeCount := 0;
   ClearAnalysisList(AnalysisList);
   ClearPhraseList(PhraseList)
end; { Initialize }


procedure FinishUp;
begin
   writeln('number of lines in text ', TextName, ' :', LineCount);
   writeln('number of phrase types :', PhrTypeCount);
   writeln('number of phrase types found :', hits:5);
   writeln('number of phrase types missed:', missed:5);
   writeln('number of phrase types inserted:', insert:5);
   writeln;
   writeln(' --------------------------------------------------');
   writeln(' to use new phrase patterns for parsing do:');
   writeln;
   writeln(' *  mv NewphraseStruc phrase.struc ');
   writeln(' *  sortphrset PHR > ophrset ');
   writeln(' *  analyzephrset     [ creates update of "nphrset"] ');
   writeln(' --------------------------------------------------');
   writeln;
end; { FinishUp }


procedure CloseFiles;
begin
   close(NewPSfile);
   writeln(' NewPs closed');
   close(MP);
   writeln(' MP closed');
end; { CloseFiles }


begin
   stop := false;
   Initialize;
   ReadStage(TextName);
   OpenFiles(TextName);
   AskCheck(Interactive);
   inleesphrset;
   ReadPhraseStrucList(phraseStruc, phraseStrucList, phraseStrucWord);
   ReadPhraseSuggestions(phraseSuggest, phraseSuggestList, SuggestPatternCount);
   missed := 0; hits := 0; insert := 0;

   ClearBoundariesArray(MAX_WORDS_PATM);
   while not stop and not eof(Ps) do begin
      ReadVerse;
      TestCompoundPhrases;
      IdentifyPhrases(WordCount);
      if not stop then
	 FindBoundaries(WordCount);
      for p := 1 to WordCount do
         WriteLexAnalysis(NewPSfile, p);
      writeln(NewPSfile,'           *')
   end;

   WritePhraseStrucList;
   CloseFiles;
   FinishUp
end.
