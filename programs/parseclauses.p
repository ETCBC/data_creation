program parseclauses;

(* ident "@(#)dapro/simple/parseclauses.p	1.70 17/02/03" *)

{
   Assumes a ps3.p file has clause-atoms; made into a ps4.p file.
   Works into two directions:
   reads a clset; adds the <S>, <P>, <O> parsing of clauses to it;
   reads a PS4.p file, picks up parsing proposals from there;
   or adds parsing proposals there taken from the NClset.
}

#include <hebrew/hebrew.h>
#include <hebrew/syntax.h>

#define debug		if argc > 1 then write
#define debugln		if argc > 1 then writeln

const
   NO				= ['N', 'n'];
   YES				= ['J', 'Y', 'j', 'y'];
   YNE				= YES + NO + ['e'];
   TAB				= char(9);
   WORD_SEPARATORS		= [' ', '#', '$', '-'];
   PARSING_CODE_SET	= [
      'A', 'B', 'C', 'E', 'F', 'I', 'J', 'L', 'M', 'N', 'O', 'P', 'Q',
      'R', 'S', 'T', 'U', 'V', 'X', 'a', 'c', 'j', 'o', 'p', 's'
   ];
   SYNNR_FNAME			= 'synnr';
   SYNNR_LEVEL			= 4;
   ALPHABET		= '[>BGDHWZXVJKLMNS<PYQRFCT-';
   MAX_CHAR		= 127;
   START_CLAUSE			= 99;
   CLAUSE_MARKS			= 3;
   PARSE			= 4;
   LAST_WORD			= 2;
   PHRASE			= 1;		(* Phrase is first entry in s-o-c resolver *)
   KO_LS			= 0;
   KO_SP		= 1;
   ROOT_MORPHEME		= 3;
   NOMINAL_ENDING		= 5;
   KO_PRS			= 6;
   KO_VT			= 7;
   PERSON			= 8;
   NUMBER			= 9;
   GENDER			= 10;
   STATE			= 11;
   PHRDEP_PSP			= 12;
   PHRASE_TYPE			= 13;
   DETERMINATION		= 14;
   KO_SPR3			= 17;
   PHRASEdist			= 18;
   CLAUSE_MARKER		= 20;
   CLAUSE_PARSING		= 19;
   ALFSIZ = 25;
   PATOM_SEPARATOR		= ' || ';
   HIGHEST_CONDITION		= 600;
   MAX_OF_STRUCS                = 3500;
   NUMBER_CLAUSE_TYPES		= 15000;

   MAXVBLCL			= 9000;
   MAXVerbs			= 15000;
   MAXcat			= 30;
   SMALLEST_CL_PHRASE_INDEX	= -1;
   SMALLEST_VS_PHRASE_INDEX	= 0;

   CONDITION_LENGTH		= 5;
   PARSPOS			= 6;            { parsing codes in pos 6 !!! }
   MAX_COND_VALUES              = 10;
   FIRST_CONDITION		= -2;
   LAST_CONDITION		= 65;
   NUMBER_OF_PHRASE_INFO	= 4;
   SMALLEST_CLAUSE_TYPE		= -2;
   SMALLEST_APPOSITION		= -30;

   (* Maximum number of lexemes in a file with lexical conditions *)
   MAX_LEXCOND			= 512;

   FIRST_FUNCTION		= -1;
   (* -1 -  0: Lexical information *)
   (*  1 -  6: Morphological information *)
   (*  7 - 11: Word level function values *)
   (* 12 - 14: Phrase level function values *)
   (* 15 - 18: Phrase internal hierarchy *)
   (* 19 - 19: Clause level parsing *)
   (* 20 - 20: Clause marker *)
   LAST_FUNCTION		= 20;

   LEAST_PARSING_CODE		= 500;
   (* End of divisions in division files *)
   EOD				= LEAST_PARSING_CODE - 1;
   (* End of information *)
   EOI				= 99;

(* Verbal Tense *)
   VT_Impf	= 1;
   VT_Perf	= 2;
   VT_Impv	= 3;
   VT_InfC	= 4;
   VT_InfA	= 5;
   VT_PtcA	= 6;
   VT_Wayq	= 11;
   VT_Weyq	= 12;
   VT_PtcP	= 62;

(* Phrase Type *)
   VP	=  1;
   NP	=  2;
   PrNP	=  3;
   AdvP	=  4;
   PP	=  5;
   CP	=  6;
   PPrP	=  7;
   DPrP	=  8;
   IPrP	=  9;
   InjP	= 10;
   NegP	= 11;
   InrP	= 12;
   AdjP	= 13;


(* Phrase Function within Clause *)
   Appo		= 500;
   Pred		= 501;
   Subj		= 502;
   Objc		= 503;
   Cmpl		= 504;
   Adju		= 505;
   Time		= 506;
   Loca		= 507;
   Modi		= 508;
   Conj		= 509;
   Nega		= 510;
   Ques		= 511;
   Intj		= 512;
   Supp		= 515;
   Rela		= 519;
   PreC		= 521;
   IntS		= 522;
   PrcS		= 523;
   PrAd		= 525;
   ModS		= 528;
   PreO		= 531;
   PreS		= 532;
   PtSp		= 533;
   PtcO		= 534;
   Sfxs		= 535;
   NCop		= 540;
   EPPr		= 541;
   NCoS		= 542;
   Exst		= 550;
   ExsS		= 552;
   Voct		= 562;
   Para		= 566;
   Link		= 567;
   Frnt		= 572;
   FrnS		= 573;
   FrnO		= 574;
   FrnC		= 575;
   FrnA		= 576;
   Spec		= 582;
   IrpP		= 591;
   IrpS		= 592;
   IrpO		= 593;
   IrpC		= 594;
   Unkn		= 599;

(* Columns in verblessList *)
   VLL_Sfx	=  1;
   VLL_PrnD	=  2;
   VLL_PrnP	=  3;
   VLL_NPdt	=  4;
   VLL_NPPN	=  5;
   VLL_NPid	=  6;
   VLL_PrnI	=  7;
   VLL_AdjP	=  8;
   VLL_PP	=  9;
   VLL_Irog	= 10;
   VLL_Mod	= 11;
   VLL_Ext	= 12;
   VLL_Inj	= 13;
   VLL_Cpl1	= 14;
   VLL_Time	= 18;
   VLL_Loca	= 19;
   VLL_Adj1	= 20;

(* Columns in verbvalList *)
   VVL_lex	= 1;
   VVL_Root	= VVL_lex  + 1;
   VVL_P123	= VVL_Root + 1;
#ifdef ARAMAIC
   VVL_HWA	= VVL_P123 + 1;
   VVL_Modf	= VVL_HWA  + 1;
#else
   VVL_Modf	= VVL_P123 + 1;
#endif
   VVL_PrCm	= VVL_Modf + 1;
   VVL_NPdt	= VVL_PrCm + 1;
   VVL_PrnP	= VVL_NPdt + 1;
   VVL_sfx	= VVL_PrnP + 1;
   VVL_NPid	= VVL_sfx  + 1;
   VVL_ET	= VVL_NPid + 1;
   VVL_Cpl1	= VVL_ET   + 1;
   VVL_Cpl2	= VVL_Cpl1 + 1;
   VVL_Cpl3	= VVL_Cpl2 + 1;
   VVL_Cpl4	= VVL_Cpl3 + 1;
   VVL_Cpl5	= VVL_Cpl4 + 1;
   VVL_Adj1	= VVL_Cpl5 + 1;
   VVL_Adj2	= VVL_Adj1 + 1;
   VVL_Adj3	= VVL_Adj2 + 1;
   VVL_Adj4	= VVL_Adj3 + 1;
   VVL_Adj5	= VVL_Adj4 + 1;
   VVL_Adj6	= VVL_Adj5 + 1;

type
   CharSet = set of char;
   ConstituentSet = set of Appo..Unkn;
   PhraseInfo_IndexType =
      0 .. NUMBER_OF_PHRASE_INFO;
   Function_IndexType =
      FIRST_FUNCTION .. LAST_FUNCTION;
   ValueIndexType =
      1 .. MAX_COND_VALUES;
   ValueListType =
      array [ValueIndexType] of integer;
   Word_IndexType =
      1 .. MAX_WORDS;
   ConditionIndexType =
      FIRST_CONDITION .. LAST_CONDITION;
   ConditionType =
      record
	 FunctionIndex:      Function_IndexType;
	 ValueList:          ValueListType
      end;
   LexCondListType = array [1..MAX_LEXCOND] of LexemeType;
   MorfCondListType =
      array [ConditionIndexType] of ConditionType;
   Phrases_And_Conditions_Type =
      SMALLEST_APPOSITION .. HIGHEST_CONDITION;
   ClauseType_IndexType =
      SMALLEST_CLAUSE_TYPE .. NUMBER_CLAUSE_TYPES;
   Vs_PhraseType_IndexType =
      SMALLEST_VS_PHRASE_INDEX .. MAX_PATMS;
   Cl_PhraseType_IndexType =
      SMALLEST_CL_PHRASE_INDEX .. MAX_PATMS_CATM;
   Condition_IndexType =
      0 .. PARSPOS;
   ResolverType =
      packed array
      [ClauseType_IndexType, Cl_PhraseType_IndexType, Condition_IndexType]
      of Phrases_And_Conditions_Type;
   LexemeListType =
      array [Word_IndexType] of LexemeType;
   StartOfClauseResolverType =
      array [PhraseInfo_IndexType, Vs_PhraseType_IndexType, Condition_IndexType] of integer;
   Gram_Anal_ListType =
      array [Word_IndexType, Function_IndexType] of integer;
   LabType =
      packed array [1..5] of char;
   PredValType =
      array [0 .. MAXVerbs, 1 .. MAXcat, 1..2] of LabType;
   ConstpresentType =
      array [0 .. MAXVerbs, 1 .. MAXcat] of char;
   ConstlineType =
      array [ 1 .. MAXcat] of char;
   OneLineVal =
      array [ 1 .. MAXcat, 1..2] of LabType;
   Structype =
      packed array
      [0 .. MAX_OF_STRUCS, Cl_PhraseType_IndexType, Condition_IndexType]
      of integer;
   Alfabtype = array[0..ALFSIZ] of char;
   PhrasePositionType = array [1..MAX_PATMS] of integer;
   CocoType =
      record
	 pars: integer;		(* parsing code *)
	 dist: integer		(* distance code *)
      end;
   CAtomType =
      record
	 coco:	array [1..MAX_PATMS_CATM] of CocoType;
	 next:	integer;	(* word number next clause atom *)
	 size:	integer		(* number of phrase atoms *)
      end;
   InstructionsType =
      record
	 atm:	array [1..MAX_CATMS] of CAtomType;
	 lab:	LabelType;
	 size:	integer;	(* number of clause atoms *)
      end;

var
   AnalysisList			 : Gram_Anal_ListType;
   PhrPosList			 : PhrasePositionType;
   NumberMorfCond		 : ConditionIndexType;
   synnr			 : text;
   nclsort			 : text;
   ClauseDivisions		 : text;	  (* Input file x.div *)
   Instructions		 : text;	  (* Temporary x.div.p *)
   ClauseDivisParse		 : text;	  (* Output file x.div.p *)
   MorfCondFile		 : text;
   LexCondFile		 : text;
   Text				 : text;	  (* Input file x.ct *)
   NewText			 : text;	  (* Output file x.ct4.p *)
   Tref, Lref			 : text;
   Clstruc, NClstruc		 : text;
   NEW				 : text;
   NCL				 : text;
   MorfCondList		 : MorfCondListType;
   Strucs			 : Structype;
   LexemeList			 : LexemeListType;
   TimeRefList			 : LexCondListType;
   LocRefList			 : LexCondListType;
   LexCondList			 : LexCondListType;
   VerbVal			 : PredValType;
   VerbLess			 : PredValType;
   Constpresent			 : ConstpresentType;
   ConstVBLpresent		 : ConstpresentType;
   Constline			 : ConstlineType;
   VerseLabel			 : LabelType;
   NumberOfClauseStruc		 : integer;
   NumberOfClauseTypes		 : integer;
   NumberOfDivisions		 : integer;
   NumberOfNDivisions		 : integer;
   NumberOfVerbLessPat		 : integer;
   NumberOfVerbValPat		 : integer;
   NumberOfVerses		 : integer;
   NumberOfWordsInVerse		 : integer;
   newlines			 : integer;
   newVBLlines			 : integer;
   MAXcolV, MAXcolN		 : integer;
   NumberTimeLex,   NumberLocLex : integer;
   firstPhrLex, lastPhrLex	 : integer;
   lines_on_screen		 : integer;
   NumberLexCond		 : integer;
   parsed, nopars		 : integer;
   ambipars			 : integer;
   PericopeName			 : StringType;
   Alfabet			 : Alfabtype;
   Ps3p				 : text;       (* Input file  x.Ps3p *)
   Ps3pV				 : text;
   Ps4				 : text;       (* Output file x.ps4 *)
   Ps3pED			 : text;       (* update of x.Ps3p EDIT*)
   noparses			 : text;       (* list of new clauses *)
   VVL				 : text;       (* list of verbal valency *)
   VBL				 : text;       (* list of verbless clauses*)
   Resolver			 : ResolverType;
   StartOfClauseResolver	 : StartOfClauseResolverType;
   Stop				 : boolean;
   noroom			 : boolean;
   Interactive			 : boolean;
   Oldparsing			 : boolean;
   TimeLocRef			 : boolean;
   VerseCount			 : integer;
   Changed			 : boolean;
   GOON				 : boolean;
   CldName			 : StringType;

   ColumnWidth: array [Function_IndexType] of integer :=
   [18, 2, 3, 2, 2, 2, 2, 2, 4, 2, 2, 2, 5, 3, 3, 3, 7, 7, 7, 4, 4, 5];

(* Constituent Sets. These are really constants, but the Sun Compiler
   does not handle a set constant passed as an argument correctly
   (neither as an identifier nor as a define). *)

   AdvbSet: ConstituentSet := [Adju, Loca, Modi, Time];
   CmplSet: ConstituentSet := [Cmpl];
   CopuSet: ConstituentSet := [Exst, ExsS, NCop, NCoS];
   IntjSet: ConstituentSet := [Intj, IntS];
   ObjcSet: ConstituentSet := [Objc, PreO, PtcO];
   PreCSet: ConstituentSet := [PrcS, PreC, PtcO];
   PredSet: ConstituentSet := [Pred, PreO, PreS];
   QuesSet: ConstituentSet := [Ques];
   SubSSet: ConstituentSet := [ExsS, IntS, ModS, NCoS, PrcS, PreS];
   SubjSet: ConstituentSet := [Subj];

   (* The set of all parsings that do not represent an independent
      constituent and therefore require a phrase atom relation. *)
   DeptSet: ConstituentSet := [Appo, Para, Link, Sfxs, Spec];

   (* The set of constituents that refer to an other constituent and
      therefore require a phrase relation. *)
   RefrSet: ConstituentSet := [PrAd];

   (* The set of all parsings that require a relation and hence a
      distance. *)
   DistSet: ConstituentSet;	(* DeptSet + RefrSet *)

#ifdef DEBUG
procedure dumpAnalysisList(s, e: Word_IndexType); forward;
procedure dumpOneLineVal(var o: OneLineVal); forward;
procedure dumpSOCR2(s, e, c: integer); forward;
procedure dumpStartOfClauseResolver(p, s, e: integer); forward;
#endif

#define Parsing(p)	StartOfClauseResolver[PARSE, (p), 0]
#define Distance(p)	StartOfClauseResolver[PARSE, (p), 1]


function GetChar:char;
var
   c: char;
begin
   c := chr(0);
   if eof then
      begin
	 writeln;
	 reset(input)
      end
   else
   if eoln then
      readln
   else
      readln(c);
   GetChar := c
end;


function Sign(i: integer):integer;
(* pre - i <> 0 *)
begin
   if i > 0 then
      Sign := 1
   else
      Sign := -1
end;


function FiniteVerb(w: integer): boolean;
begin
   FiniteVerb := AnalysisList[w, KO_VT] in
      [VT_Impf, VT_Perf, VT_Impv, VT_Wayq, VT_Weyq]
end;


procedure PaR_Cod2Dis(c: integer; var d: integer; var u: char);
(* phrase atom relation: code to distance and unit *)
begin
   if c div 100 <> 0 then begin
      d := c - Sign(c) * 100;
      u := 'W'
   end else if c div 10 <> 0 then begin
      d := c - Sign(c) * 10;
      u := 'P'
   end else if c div 1 <> 0 then begin
      d := c - Sign(c) * 1;
      u := 'C'
   end else begin
      d := 0;
      u := '.'
   end
end;


function PaR_Dis2Cod(d: integer; u: char): integer;
(* phrase atom relation: distance and unit to code *)
begin
   case u of
      'W':
	 PaR_Dis2Cod := d + Sign(d) * 100;
      'P':
	 PaR_Dis2Cod := d + Sign(d) * 10;
      'C':
	 PaR_Dis2Cod := d + Sign(d) * 1;
      '.':
	 PaR_Dis2Cod := 0
   end
end;


procedure OpenFile(var f: text; path: StringType; mode: alfa);
(* mode: StringType triggers a compiler bug in open() *)
var
   error: integer32;
begin
   error := 0;
   open(f, path, mode, error);
   if error <> 0 then begin
      writeln(path, ': unable to open file');
      pcexit(1)
   end
end;


procedure OpenReset(var f: text; path: StringType; mode: alfa);
begin
   OpenFile(f, path, mode);
   writeln(' ... reading: ', path);
   reset(f)
end;


procedure OpenRewrite(var f: text; path: StringType; mode: alfa);
begin
   OpenFile(f, path, mode);
   writeln(' ... writing: ', path);
   rewrite(f)
end;


procedure ReadSynnr(var f: text; var name: StringType);
var
   n: integer;
begin
   reset(f);
   if not ReadInteger(f, n) then begin
      writeln(SYNNR_FNAME, ': integer expected');
      pcexit(1)
   end;
   if n < SYNNR_LEVEL then begin
      writeln(SYNNR_FNAME, ': level ', SYNNR_LEVEL:1, ' or higher expected');
      pcexit(1)
   end;
   SkipSpace(f);
   if not eof(f) and not eoln(f) then
      read(f, name)
   else begin
      writeln(SYNNR_FNAME, ': pericope name expected');
      pcexit(1)
   end
end;


procedure PrepareFiles;
begin
   OpenFile(synnr, SYNNR_FNAME, 'old');
   ReadSynnr(synnr, PericopeName);
   CldName := PericopeName + '.div';
   OpenReset(Ps3p, PericopeName + '.ps3.p', 'old');
   OpenReset(Text, PericopeName + '.ct', 'old');
   OpenReset(ClauseDivisions, CldName, 'old');
   OpenReset(Clstruc, 'clause.struc', 'old');
   OpenReset(MorfCondFile, 'morfcondcl', 'old');
   OpenReset(LexCondFile, 'lexcondcl', 'old');
   OpenReset(Lref, 'loc.ref', 'old');
   OpenReset(Tref, 'time.ref', 'old');
   OpenReset(VBL, 'verblessList', 'old');
   OpenReset(VVL, 'verbvalList', 'old');
   OpenReset(ClauseDivisParse, CldName + '.p', 'unknown');
   OpenRewrite(Ps4, PericopeName + '.ps4.p', 'unknown');
   OpenRewrite(NewText, PericopeName + '.ct4.p', 'unknown');
   OpenRewrite(NCL, PericopeName + '.Nclauses', 'unknown');
   OpenRewrite(nclsort, 'NCLsort', 'unknown');
   OpenRewrite(NClstruc, 'Nclause.struc', 'unknown');
   OpenRewrite(NEW, 'NEW', 'unknown');
   OpenRewrite(noparses, 'noparses', 'unknown');
   OpenRewrite(Ps3pED, PericopeName + '.Ps3pED', 'unknown');
   OpenRewrite(Ps3pV, 'Ps3pV', 'unknown')
end;


procedure CloseFiles;
(* Closes the files opened in PrepareFiles *)
begin
   close(Ps3pV);
   close(Ps3pED);
   close(noparses);
   close(NEW);
   close(NClstruc);
   close(nclsort);
   close(NCL);
   close(ClauseDivisParse);
   close(NewText);
   close(Ps4);
   close(VVL);
   close(VBL);
   close(Tref);
   close(Lref);
   close(LexCondFile);
   close(MorfCondFile);
   close(Clstruc);
   close(ClauseDivisions);
   close(Text);
   close(Ps3p);
   close(synnr)
end;


procedure CheckVerse(n: integer);
(* Sanity check of PS input *)
var
   w: integer;
begin
   w := 1;
   while w <= n do begin
      if (AnalysisList[w, PHRASE_TYPE] = VP) and
	 (AnalysisList[w, KO_VT] < 1)
      then begin
	 write(VerseLabel, ' Word ', w:1, ': Error in ', PericopeName + '.ps3.p', ': ');
	 writeln('The last word of a verbal phrase must have verbal tense.');
	 pcexit(1)
      end;
      w := w + 1
   end
end;


procedure CheckVerbVal;
var
   p: integer;
begin
   p := 1;
   while p <= NumberOfVerbValPat do begin
      if Constpresent[p, 1] = '+' then begin
	 writeln(' A "+" on line:', p: 4);
	 pcexit(1)
      end;
      p := p + 1
   end
end;


function CountLines(var f: text): integer;
var
   n: integer;
begin
   n := 0;
   reset(f);
   while not eof(f) do
   begin
      readln(f);
      n := n + 1
   end;
   reset(f);
   CountLines := n
end;


function AltSuffix(w: Word_IndexType; v0, v1: integer): integer;
(* Return alternative value in case of a suffix *)
begin
   if AnalysisList[w, KO_PRS] > 0 then
      AltSuffix := v1
   else
      AltSuffix := v0
end;


function Copula(w: Word_IndexType): boolean;
begin
   Copula :=
      ((AnalysisList[w, KO_LS] = -5) and		(* nmcp *)
	 (AnalysisList[w, KO_SP] = 2))
      or
      ((AnalysisList[w, KO_LS] = -2) and		(* vbcp *)
	 (AnalysisList[w, KO_SP] = 1))
end;


function Negation(w: Word_IndexType): boolean;
begin
   Negation :=
#ifdef ARAMAIC
      trim(LexemeList[w]) = 'L>'
#else
      (trim(LexemeList[w]) = '>L=') or
      (trim(LexemeList[w]) = 'BL') or
      (trim(LexemeList[w]) = 'L>')
#endif
end;


function ObjectMarker(w: Word_IndexType): boolean;
begin
   ObjectMarker :=
#ifdef ARAMAIC
      trim(LexemeList[w]) = 'JT'
#else
      trim(LexemeList[w]) = '>T'
#endif
end;


function Relative(w: Word_IndexType): boolean;
begin
   Relative :=
#ifdef ARAMAIC
      (trim(LexemeList[w]) = 'D') or
      (trim(LexemeList[w]) = 'DJ')
#else
      (trim(LexemeList[w]) = '>CR') or
      (trim(LexemeList[w]) = 'H') or
      (trim(LexemeList[w]) = 'ZW') or
      (trim(LexemeList[w]) = 'C')
#endif
end;


function ActiveParticiple(w: Word_IndexType): boolean;
begin
   ActiveParticiple := AnalysisList[w, KO_VT] = VT_PtcA
end;


function PassiveParticiple(w: Word_IndexType): boolean;
begin
   PassiveParticiple := AnalysisList[w, KO_VT] = VT_PtcP
end;


function Participle(w: Word_IndexType): boolean;
begin
   Participle := ActiveParticiple(w) or PassiveParticiple(w)
end;


function InfinitiveConstruct(w: Word_IndexType): boolean;
begin
   InfinitiveConstruct := AnalysisList[w, KO_VT] = VT_InfC
end;


function Enclitic(w: Word_IndexType): boolean;
begin
   Enclitic :=
      (AnalysisList[w, KO_SP] = 7) and
      (AnalysisList[w, KO_LS] = -1)
end;


function PronSuffix(w: Word_IndexType): boolean;
begin
   PronSuffix := AnalysisList[w, KO_PRS] > 0
end;


function LexCondList_In(var l: LexCondListType; n: integer; k: LexemeType): boolean;
var
   i: integer;
   found: boolean;
begin
   i := 1;
   found := false;
   while not found and (i <= n) do
      if l[i] = k then
	 found := true
      else
	 i := i + 1;
   LexCondList_In := found
end;


procedure WordSetPhraseType(w0, w1: Word_IndexType);
(* Set Phrase Type for the phrase atom [w0..w1] *)
var
   i: integer;
begin
   for i := w0 to w1 - 1 do
      AnalysisList[i, PHRASE_TYPE] := 0;
   if AnalysisList[w1, PHRDEP_PSP] = 0 then
      AnalysisList[w1, PHRASE_TYPE] := CP
   else if AnalysisList[w1, PHRDEP_PSP] = 1 then
      AnalysisList[w1, PHRASE_TYPE] := VP
   else if AnalysisList[w0, PHRDEP_PSP] = 5 then
      AnalysisList[w1, PHRASE_TYPE] := PP
   else
      AnalysisList[w1, PHRASE_TYPE] := AnalysisList[w1, PHRDEP_PSP]
end;


procedure WordSetDetermination(w0, w1: Word_IndexType);
(* Set Determination for the phrase atom [w0..w1] *)
var
   i: integer;
begin
   for i := w0 to w1 - 1 do
      AnalysisList[i, DETERMINATION] := -1;
   case AnalysisList[w1, PHRASE_TYPE] of
      IPrP:
	 AnalysisList[w1, DETERMINATION] := 1;
      PPrP, DPrP:
	 AnalysisList[w1, DETERMINATION] := 2;
      NP, PrNP, PP:
	 if PronSuffix(w1) or
	    (AnalysisList[w1, STATE] = 3) or
	    (AnalysisList[w1, PHRDEP_PSP] = 3) or
	    ((w0 < w1) and (AnalysisList[w1 - 1, PHRDEP_PSP] = 0))
	 then
	    AnalysisList[w1, DETERMINATION] := 2
	 else
	    AnalysisList[w1, DETERMINATION] := 1;
   otherwise
      AnalysisList[w1, DETERMINATION] := -1
   end
end;


function WordPrecSuffix(w: Word_IndexType): integer;
(* Return the word index within the clause atom of the first
   pronominal suffix equal to or preceding word w *)
var
   bound: boolean;	(* we hit a clause atom boundary *)
   found: boolean;
begin
   bound := false;
   found := false;
   while not found and not bound do begin
      if Enclitic(w) or PronSuffix(w) then
	 found := true
      else
	 w := w - 1;
      bound :=
	 (AnalysisList[w, CLAUSE_MARKER] = START_CLAUSE) or (w = 1)
   end;
   if found then
      WordPrecSuffix := w
   else
      WordPrecSuffix := 0
end;


function WordIndex_PhrDis(w: Word_IndexType; d: integer): integer;
(* Returns the word index of the last word of the phrase atom at a
   distance of d phrase atoms from w *)
var
   i: integer;
begin
   i := Sign(d);
   while (d <> 0) and (1 < w) and (w < MAX_WORDS) do begin
      w := w + i;
      if AnalysisList[w, PHRASE_TYPE] <> 0 then
	 d := d - i
   end;
   if d = 0 then
      WordIndex_PhrDis := w
   else
      WordIndex_PhrDis := -1
end;


procedure PhraseInfoClear(p: Vs_PhraseType_IndexType);
var
   i: PhraseInfo_IndexType;
   c: Condition_IndexType;
begin
   for i := 0 to NUMBER_OF_PHRASE_INFO do
      for c := 0 to PARSPOS do
	 StartOfClauseResolver[i, p, c] := 0
end;


procedure PhraseInfoCopy(p1, p0: Vs_PhraseType_IndexType);
var
   i: PhraseInfo_IndexType;
   c: Condition_IndexType;
begin
   for i := 0 to NUMBER_OF_PHRASE_INFO do
      for c := 0 to PARSPOS do
	 StartOfClauseResolver[i, p1, c] :=
	 StartOfClauseResolver[i, p0, c]
end;


procedure PhraseInfoMove(p, dp: integer);
const
   N = MAX_PATMS;
var
   i: integer;
begin
   if dp < 0 then begin
      for i := p to N do
	 PhraseInfoCopy(i + dp, i);
      for i := N + dp + 1 to N do
	 PhraseInfoClear(i)
   end else begin
      for i := N downto p + dp do
	 PhraseInfoCopy(i, i - dp);
      for i := p + dp - 1 downto p do
	 PhraseInfoClear(i)
   end
end;


function PAtomByWord(w: Word_IndexType): Vs_PhraseType_IndexType;
var
   p: integer;
   found: boolean;
begin
   p := SMALLEST_VS_PHRASE_INDEX;
   found := false;
   while not found and (p < MAX_PATMS) do begin
      p := p + 1;
      found :=
	 (StartOfClauseResolver[LAST_WORD, p, 0] = 0) or
	 (w <= StartOfClauseResolver[LAST_WORD, p, 0])
   end;
   if found then
      PAtomByWord := p
   else
      PAtomByWord := 0
end;


function PAtomParsed(p: Vs_PhraseType_IndexType): boolean;
begin
   PAtomParsed := (Appo <= Parsing(p)) and (Parsing(p) < Unkn)
end;


function PAtomWordFirst(p: Vs_PhraseType_IndexType): Word_IndexType;
begin
   if p = 1 then
      PAtomWordFirst := 1
   else
      PAtomWordFirst := StartOfClauseResolver[LAST_WORD, p - 1, 0] + 1
end;


function PAtomWordLast(p: Vs_PhraseType_IndexType): Word_IndexType;
begin
   PAtomWordLast := StartOfClauseResolver[LAST_WORD, p, 0]
end;


function PAtomDetermined(p: Vs_PhraseType_IndexType): boolean;
begin
   PAtomDetermined := AnalysisList[PAtomWordLast(p), DETERMINATION] = 2
end;


function PAtomPerson(p: Vs_PhraseType_IndexType): integer;
(* Returns the value for person of the first word in [p] that is
   explicitly marked for person *)
var
   w: integer;
   found: boolean;
begin
   w := PAtomWordFirst(p);
   found := false;
   while not found and (w <= PAtomWordLast(p)) do
      if AnalysisList[w, PERSON] <> -1 then
	 found := true
      else
	 w := w + 1;
   if not found then
      PAtomPerson := -1
   else
      PAtomPerson := AnalysisList[w, PERSON]
end;


function PAtomType(p: Vs_PhraseType_IndexType): integer;
begin
   PAtomType := AnalysisList[PAtomWordLast(p), PHRASE_TYPE]
end;


function PAtomTimeCheck(p: integer): boolean;
(* Returns whether phrase atom [p] has a lexeme with time reference *)
var
   w: integer;
   found: boolean;
begin
   w := PAtomWordFirst(p);
   found := false;
   while not found and (w <= PAtomWordLast(p)) do
      if LexCondList_In(TimeRefList, NumberTimeLex, LexemeList[w]) then
	 found := true
      else
	 w := w + 1;
   PAtomTimeCheck := found
end;


function PAtomLocaCheck(p: integer): boolean;
(* Returns whether phrase atom [p] has a lexeme with place reference *)
var
   w: integer;
   found: boolean;
begin
   w := PAtomWordFirst(p);
   found := false;
   while not found and (w <= PAtomWordLast(p)) do
      if LexCondList_In(LocRefList, NumberLocLex, LexemeList[w]) then
	 found := true
      else
	 w := w + 1;
   PAtomLocaCheck := found
end;


function PAtomAgree(p1, p2: integer): boolean;
(* Return whether [p1] and [p2] agree (in person) *)
var
   v1, v2: integer;
begin
   v1 := PAtomPerson(p1);
   v2 := PAtomPerson(p2);
   PAtomAgree :=
      not (
	 ((v1 in [1, 2]) and (v1 <> v2)) or
	 ((v2 in [1, 2]) and (v2 <> v1))
      )
end;


procedure PAtomSetDetermination(p: integer);
begin
   WordSetDetermination(PAtomWordFirst(p), PAtomWordLast(p))
end;


procedure PAtomSetPhraseType(p: integer);
begin
   WordSetPhraseType(PAtomWordFirst(p), PAtomWordLast(p));
   StartOfClauseResolver[PHRASE, p, 0] := PAtomType(p)
end;


function CAtomPAtomFirst(c: integer): integer;
(* Return the PAtom number of the first PAtom of CAtom number c *)
var
   p: integer;
begin
   assert(c > 0);
   p := 1;
   while c <> 1 do begin
      p := p + 1;
      if StartOfClauseResolver[CLAUSE_MARKS, p, 0] = START_CLAUSE then
	 c := c - 1
   end;
   CAtomPAtomFirst := p
end;


function CAtomPAtomLast(c: integer): integer;
(* Return the PAtom number of the last PAtom of CAtom number c *)
var
   p: integer;
begin
   assert(c > 0);
   p := 0;
   while c <> 0 do begin
      p := p + 1;
      if StartOfClauseResolver[CLAUSE_MARKS, p, 0] = START_CLAUSE then
	 c := c - 1
   end;
   CAtomPAtomLast := p - 1
end;


function CAtomPAtomByConst(c: integer; s: ConstituentSet): integer;
var
   found: boolean;
   p1, p2: integer;
begin
   p1 := CAtomPAtomFirst(c);
   p2 := CAtomPAtomLast(c);
   found := Parsing(p1) in s;
   while not found and (p1 < p2) do begin
      p1 := p1 + 1;
      found := Parsing(p1) in s
   end;
   if not found then
      CAtomPAtomByConst := 0
   else
      CAtomPAtomByConst := p1
end;


function CAtomPAtomByType(c: integer; t: integer): integer;
var
   found: boolean;
   p1, p2: integer;
begin
   p1 := CAtomPAtomFirst(c);
   p2 := CAtomPAtomLast(c);
   found := PAtomType(p1) = t;
   while not found and (p1 < p2) do begin
      p1 := p1 + 1;
      found := PAtomType(p1) = t
   end;
   if not found then
      CAtomPAtomByType := 0
   else
      CAtomPAtomByType := p1
end;


function NormalSeparator(c: char): char;
begin
   case c of
      '#': NormalSeparator := ' ';
      '$': NormalSeparator := '-';
   otherwise
      NormalSeparator := c
   end
end;


function CAtomConstCount(p: Vs_PhraseType_IndexType): integer;
(* Return the number of constituents in the clause atom starting
   at phrase atom number p *)
var
   n: integer;
begin
   n := 1;
   while StartOfClauseResolver[CLAUSE_MARKS, p + 1, 0] <> START_CLAUSE do begin
      p := p + 1;
      if not (Parsing(p) in DeptSet) then
	 n := n + 1
   end;
   CAtomConstCount := n
end;


function CAtomPAtomCount(c: integer): integer;
(* Return the number of PAtoms in CAtom number c *)
var
   p1, p2: integer;
begin
   assert(c > 0);
   p1 := 1;
   p2 := 1;
   while c <> 0 do begin
      p2 := p2 + 1;
      if StartOfClauseResolver[CLAUSE_MARKS, p2, 0] = START_CLAUSE
      then begin
	 c := c - 1;
	 if c <> 0 then
	    p1 := p2
      end
   end;
   CAtomPAtomCount := p2 - p1
end;


function CAtomParsed(c: integer): boolean;
var
   ok: boolean;
   p1, p2: integer;
begin
   p1 := CAtomPAtomFirst(c);
   p2 := CAtomPAtomLast(c);
   ok := PAtomParsed(p1);
   while ok and (p1 < p2) do begin
      p1 := p1 + 1;
      ok := PAtomParsed(p1);
   end;
   CAtomParsed := ok
end;


function CAtomTextStart(c: integer): integer;
begin
   CAtomTextStart :=
      StartOfClauseResolver[LAST_WORD, CAtomPAtomFirst(c), 1]
end;


function PNG_Word(w: integer): integer;
begin
   PNG_Word :=
      100 * AnalysisList[w, PERSON] +
       10 * AnalysisList[w, NUMBER] +
        1 * AnalysisList[w, GENDER]
end;


function PNG_Suffix(w: integer): integer;
begin
   case AnalysisList[w, KO_PRS] of
      2, 3:
	 PNG_Suffix := 110;
      9, 25:
	 PNG_Suffix := 130;
      5, 24:
	 PNG_Suffix := 211;
      4:
	 PNG_Suffix := 212;
      11:
	 PNG_Suffix := 231;
      10, 23:
	 PNG_Suffix := 232;
      8, 20:
	 PNG_Suffix := 311;
      6, 7, 19, 22:
	 PNG_Suffix := 312;
      15, 16:
	 PNG_Suffix := 331;
      12, 13, 14, 21:
	 PNG_Suffix := 332;
      otherwise
	 PNG_Suffix := 0
   end
end;


function PAtomAdjunct(c, p: integer): integer;
var
   m: integer;	(* mother *)
begin
   if PAtomTimeCheck(p) then
      PAtomAdjunct := Time
   else if PAtomLocaCheck(p) then
      PAtomAdjunct := Loca
   else if PAtomType(p) = AdvP then
      PAtomAdjunct := AltSuffix(PAtomWordLast(p), Modi, ModS)
   else if PAtomType(p) <> NP then
      PAtomAdjunct := Adju
   else begin
      m := CAtomPAtomByConst(c, SubjSet);
      if m = 0 then
	 m := CAtomPAtomByConst(c, ObjcSet);
      if m = 0 then
	 PAtomAdjunct := Adju
      else begin
	 Distance(p) := PaR_Dis2Cod(m - p, 'P');
	 PAtomAdjunct := PrAd
      end
   end
end;


function PAtomParseLabel(p: integer): StringType;
begin
   PAtomParseLabel := '<' + ParseLabel2(Parsing(p)) + '>'
end;


function PAtomSupplementary(c, p: integer): integer;
(* Return Supp, if possible, otherwise Unkn *)
var
   v: integer;		(* verb phrase *)
   w: integer;		(* word L+suffix *)
   png: integer;
begin
   w := PAtomWordFirst(p);
   v := CAtomPAtomByConst(c, PredSet);
   if (AnalysisList[w, KO_PRS] > 0) and (v <> 0) and
      (trim(LexemeList[w]) = 'L') and (w = PAtomWordLast(p))
   then
      png := PNG_Suffix(w)
   else
      png := 0;
   if (0 < png) and (png < 300) and
      (png = PNG_Word(PAtomWordFirst(v)))
   then
      PAtomSupplementary := Supp
   else
      PAtomSupplementary := Unkn
end;


function PAtomTypeLabel(p: integer): StringType;
var
   t: integer;	(* Phrase type *)
begin
   t := StartOfClauseResolver[PHRASE, p, 0];
   if t = 0 then
      PAtomTypeLabel := 'none'
   else
      PAtomTypeLabel := PhraseLabel(abs(t))
end;


function PAtomTextWidth(p: Vs_PhraseType_IndexType; v: LineType): integer;
const
   MIN_WIDTH = length('Subj');
var
   w0, w1: integer;
begin
   assert(p > 0);
   w0 := StartOfClauseResolver[LAST_WORD, p, 1];
   w1 := StartOfClauseResolver[LAST_WORD, p + 1, 1];
   assert(w0 < w1);
   if Space(NormalSeparator(v[w1 - 1])) then
      PAtomTextWidth := max(MIN_WIDTH, w1 - w0 - 1)
   else
      PAtomTextWidth := max(MIN_WIDTH, w1 - w0)
end;


function PAtomWordCount(p: Vs_PhraseType_IndexType): integer;
(* Return the number of words in phrase atom number p *)
begin
   assert(p > 0);
   PAtomWordCount :=
      StartOfClauseResolver[LAST_WORD, p, 0] -
      StartOfClauseResolver[LAST_WORD, p - 1, 0]
end;


function VerseParseCount: integer;
(* Return the number of phrase atoms in the current verse *)
var
   p: integer;
begin
   p := 1;
   while Parsing(p) <> 0 do
      p := p + 1;
   VerseParseCount := p - 1
end;


function VersePAtomCount: integer;
(* Return the number of phrase atoms in the current verse *)
var
   p: integer;
begin
   p := 1;
   while StartOfClauseResolver[PHRASE, p, 0] <> 0 do
      p := p + 1;
   VersePAtomCount := p - 1
end;


function VerseCAtomCount: integer;
(* Return the number of clause atoms in the current verse *)
var
   n: integer;
   p: Vs_PhraseType_IndexType;
begin
   n := 0;
   p := 1;
   while StartOfClauseResolver[LAST_WORD, p, 0] <> 0 do begin
      if StartOfClauseResolver[CLAUSE_MARKS, p, 0] = START_CLAUSE then
	 n := n + 1;
      p := p + 1
   end;
   VerseCAtomCount := n + 1
end;


function VerseCAtomFirstUnparsed: integer;
var
   ok: boolean;
   c1, c2: integer;
begin
   c1 := 1;
   c2 := VerseCAtomCount;
   ok := CAtomParsed(c1);
   while ok and (c1 < c2) do begin
      c1 := c1 + 1;
      ok := CAtomParsed(c1)
   end;
   if ok then
      VerseCAtomFirstUnparsed := 0
   else
      VerseCAtomFirstUnparsed := c1
end;


function AltUnique(c: integer; s: ConstituentSet; v0, v1: integer): integer;
(* Return alternative value if clause atom `c' contains a constituent
   from the set `s' *)
begin
   if CAtomPAtomByConst(c, s) = 0 then
      AltUnique := v0
   else
      AltUnique := v1
end;


function Instructions_CheckPAtom
(var i: InstructionsType; n, c, p: integer): boolean;
(* Check the instruction for phrase atom [n] in clause atom [c], with
   absolute phrase atom index [p] *)
var
   d: integer;		(* distance *)
   u: char;		(* unit *)
   w: integer;		(* word *)
   ok: boolean;
begin
   d := 0;
   ok := true;
   with i.atm[c], coco[n] do begin
      if (pars < Appo) or (Unkn < pars) then begin
	 writeln(i.lab, ' ', 'Invalid constituent code: ', pars:1);
	 ok := false
      end;
      if dist <> 0 then begin
	 PaR_Cod2Dis(dist, d, u);
	 w := PAtomWordLast(p);
	 if not
	    ( (u = 'C') and (0 < c + d) and (c + d <= i.size) or
	      (u = 'P') and
		 (0 < p + d) and (p + d <= VersePAtomCount) or
	      (u = 'W') and
		 ((0 < w + d) and (w + d <= PAtomWordLast(p)) or
		  (w < w + d) and (w + d <= NumberOfWordsInVerse)) )
	 then begin
	    writeln(i.lab, ' ', ParseLabel4(pars),
	       ': Unusual distance ', dist:1);
	    ok := ok and (u <> '.')
	 end
      end;
      if (pars in DistSet) and (d = 0) then begin
	 writeln(i.lab, ' ', ParseLabel4(pars),
	    ': Distance missing');
	 ok := false
      end;
      if (pars in DeptSet) and (d > 0) then begin
	 writeln(i.lab, ' ', ParseLabel4(pars),
	    ': Forward reference ', dist:1);
	 ok := false
      end
   end;
   Instructions_CheckPAtom := ok
end;


function Instructions_CheckCAtom
   (var i: InstructionsType; c, p, w: integer): boolean;
(* Check the instructions for clause atom c, which starts at phrase p
   and word w within the verse *)
var
   n: integer;
   ok: boolean;
begin
   n := 0;
   ok := true;
   with i.atm[c] do begin
      if next <= w then begin
	 writeln(i.lab, ' Clause atom ', c:1, ' is not consecutive.');
	 ok := false
      end;
      while ok and (n < size) do begin
	 n := n + 1;
	 ok := ok and Instructions_CheckPAtom(i, n, c, p);
	 p := p + 1;
	 w := PAtomWordFirst(p);
      end
   end;
   Instructions_CheckCAtom := ok
end;


procedure Instructions_CheckVerse(var i: InstructionsType);
var
   c, p, w: integer;
begin
   with i do begin
      w := 1;
      p := 1;
      for c := 1 to size do begin
	 if not Instructions_CheckCAtom(i, c, p, w) then begin
	    writeln(lab, ' Error in div/div.p');
	    pcexit(1)
	 end;
	 w := atm[c].next;
	 p := p + atm[c].size
      end
   end
end;


function InstructionsCompatible(var i1, i2: InstructionsType): boolean;
var
   a: integer;
begin
   if i1.lab <> i2.lab then
      InstructionsCompatible := false
   else begin
      a := 1;
      while
	 (a <= MAX_CATMS) and
	 (i1.atm[a].next <> EOD) and (i2.atm[a].next <> EOD) and
	 (i1.atm[a].next = i2.atm[a].next)
      do
	 a := a + 1;
      InstructionsCompatible :=
	 (a <= MAX_CATMS) and
	 (i1.atm[a].next = EOD) and (i2.atm[a].next = EOD)
   end
end;


function Instructions_PSize(var i: InstructionsType): integer;
(* Return the number of phrase atoms in i *)
var
   c: integer;		(* clause atom index *)
   r: integer;		(* result *)
begin
   r := 0;
   with i do
      for c := 1 to size do
	 r := r + atm[c].size;
   Instructions_PSize := r
end;


procedure ReadInstructions(var f: text; var i: InstructionsType);
var
   a: integer;		(* clause atom index *)
   p: integer;		(* phrase atom index *)
   n: integer;		(* number read from div file *)
   dist: boolean;	(* need a distance *)
begin
   dist := false;
   if not eoln(f) then
      read(f, i.lab)
   else begin
      writeln('Empty line in div/div.p file');
      pcexit(1)
   end;
   a := 1;
   p := 0;
   while not eoln(f) and ReadInteger(f, n) do begin
      assert((a <= MAX_CATMS) and (p < MAX_PATMS_CATM));
      if (0 < n) and (n < EOD) and not dist or (n = EOD) then begin
	 (* boundary next atom *)
	 i.atm[a].next := n;
	 i.atm[a].size := p;
	 a := a + 1;
	 p := 0
      end else begin	(* constituent code *)
	 if (n < Appo) and (p > 0) then
	    i.atm[a].coco[p].dist := n
	 else begin
	    p := p + 1;
	    i.atm[a].coco[p].pars := n;
	    i.atm[a].coco[p].dist := 0
	 end;
	 dist := n in RefrSet (* not DistSet, because positive
	 distances only make sense for phrase relations *)
      end
   end;
   if n = EOD then
      i.size := a - 1
   else begin
      writeln(i.lab, ' Improperly terminated line in div/div.p file');
      pcexit(1)
   end;
   readln(f)
end;


procedure WriteInstructions(var f: text; var i: InstructionsType);
(* Writes the instructions for one verse to the divisions file *)
var
   a: integer;	(* clause atom index *)
   p: integer;	(* phrase atom index *)
begin
   write(f, i.lab);
   a := 0;
   repeat
      a := a + 1;
      with i.atm[a] do begin
	 assert((a <= MAX_CATMS) and (size <= MAX_PATMS_CATM));
	 for p := 1 to size do
	    with coco[p] do begin
	       write(f, ' ', pars:3);
	       if (dist < -1) or (1 < dist) then
		  write(f, ' ', dist:3)
	    end;
	 write(f, ' ', next:3);
      end
   until i.atm[a].next = EOD;
   writeln(f)
end;


procedure MergeInstructions(var f, d, p: text);
(* Merges the instructions from d (div) and p (div.p) into f *)
var
   id, ip: InstructionsType;
begin
   while not eof(p) do begin
      if not eof(d) then
	 ReadInstructions(d, id)
      else begin
	 writeln('Error: The div is shorter than the div.p');
	 pcexit(1)
      end;
      ReadInstructions(p, ip);
      if InstructionsCompatible(id, ip) then
	 WriteInstructions(f, ip)
      else begin
	 writeln('Error: The div and div.p are incompatible');
	 pcexit(1)
      end
   end;
   while not eof(d) do begin
      ReadInstructions(d, id);
      WriteInstructions(f, id)
   end
end;


procedure CheckDivisions;
begin
   writeln('Number of lines in ', CldName + '.p', ': ', NumberOfNDivisions: 1);
   writeln('Number of lines in ', CldName, ': ', NumberOfDivisions: 1);
   if NumberOfDivisions < NumberOfVerses then begin
      writeln(CldName, ' (= file with clause-divisions) is INcomplete.');
      writeln(' Please run syn04 first to complete clause divisions ');
      writeln(' Sorry, I cannot continue this programme ');
      pcexit(1)
   end;
   rewrite(Instructions);
   MergeInstructions(Instructions, ClauseDivisions, ClauseDivisParse);
   reset(Instructions);
   rewrite(ClauseDivisParse)
end;


procedure WriteLexeme(var LexemeList: LexemeListType; WordIndex: integer);
begin
   write(Ps4, VerseLabel, ' ');
   write(Ps3pED, VerseLabel, ' ');
   write(Ps4, LexemeList[WordIndex]);
   write(Ps3pED, LexemeList[WordIndex])
end; { WriteLexeme }


procedure WritePTYpe(var f: text; typ: integer; det: boolean);
begin
   if typ < 0 then
      write(f, '(ap)')
   else
      write(f, PhraseLabel(typ):4);
   if det then
      write(f, 'dt')
   else
      write(f, '  ')
end;


procedure WriteValues(var f: text; w, k: integer);
(* Write the values of word [w] in columns 0..k to file [f] *)
var
   i: integer;
begin
   for i := 0 to k do
      write(f, ' ', AnalysisList[w, i]: ColumnWidth[i]);
   writeln(f)
end;


procedure clear_arrays;
var
   word_index:	Word_IndexType;
   func_index:	Function_IndexType;
   type_index:	Vs_PhraseType_IndexType;
begin
   for word_index := 1 to MAX_WORDS do
   begin
      for func_index := FIRST_FUNCTION to LAST_FUNCTION do
	 AnalysisList[word_index, func_index] := -1;
      AnalysisList[word_index, PHRASEdist] := 0;
   end;
   for type_index := 1 to MAX_PATMS do
      PhraseInfoClear(type_index)
end; { clear_arrays }

procedure LocateStruc(pos1, pos2 : integer);
var i, p, cn : integer;
   location,
   posit    : boolean;
   phr, pos : integer;
begin
   phr := 0;
   pos := 0;
   p := pos1;
   repeat phr := phr + 1
   until (Strucs[phr, 1, 0] = StartOfClauseResolver[PHRASE, p, 0]) or
   (phr = NumberOfClauseStruc);
   if phr < NumberOfClauseStruc
      then
   begin
      phr := phr - 1;
      location := false;

      repeat
	 phr := phr + 1;
	 pos := 1;
	 p := pos1;
	 posit := false;
	 repeat
	    pos := pos + 1;
	    p := p + 1;

	    if (Strucs[phr, pos, 0] = 99) and ( p <= pos2)
	       then posit := true
	    else if Strucs[phr, pos, 0] > StartOfClauseResolver[PHRASE, p, 0]
	       then p := pos2
	    else if Strucs[phr, pos, 0] < StartOfClauseResolver[PHRASE, p, 0]
	       then posit := true;
	 until ((posit = true  )
		or  (p = pos2));
	 if posit then
	    location := true
	 until ((location)
		or (Strucs[phr, 1, 0]
		<> StartOfClauseResolver[PHRASE, pos1, 0]));
      if Strucs[phr, 1, 0] <> StartOfClauseResolver[PHRASE, pos1, 0] { too late   }
	 then
      begin
	 phr := phr - 1;
	 location := true;
      end;

      if location then
      begin                 { move internal data Strucs }
	 for i := NumberOfClauseStruc downto phr do
	 begin pos := 0;
	    for pos := 1 to MAX_PATMS_CATM do
	       for cn := 0 to PARSPOS do
	       begin
		  Strucs[i + 1, pos, cn ] := 0;
		  Strucs[i + 1, pos, cn ] := Strucs[i, pos, cn];
	       end;
	 end;
	 { insert }
	 p := pos1 - 1;
	 pos := 0;
	 repeat
	    pos := pos + 1;
	    p := p + 1;
	    for cn := 0 to CONDITION_LENGTH do
	       Strucs[phr, pos, cn] := StartOfClauseResolver[PHRASE, p, cn];
	    Strucs[phr, pos, PARSPOS] := Parsing(p);
	 until p = pos2;
	 pos := pos + 1; Strucs[ phr, pos, 0] := 99;
	 pos := pos + 1; Strucs[ phr, pos, 0] := 999;  { sign: inserted parsing }


	 writeln(' inserted before clause.struc number',phr:4);
	 NumberOfClauseStruc := NumberOfClauseStruc + 1;
	 writeln(' number of clause.struc             ',phr:4);
      end;
   end;
end;


procedure WriteToDivP(var f: text; size: integer);
var
   d: integer;		(* distance code *)
   p: integer;		(* phrase atom *)
begin
   write(f, VerseLabel, ' ');
   for p := 1 to size do begin
      if StartOfClauseResolver[CLAUSE_MARKS, p, 0] = START_CLAUSE then
	 write(f, ' ', 1 + StartOfClauseResolver[LAST_WORD, p - 1, 0]:3);
      assert(Parsing(p) <> 0);
      write(f, ' ', Parsing(p):3);
      d := Distance(p);
      if (d < -1) or (1 < d) then
	 write(f, ' ', d:3)
   end;
   writeln(f,' ', EOD:3)
end;


procedure ToNoParses(pos1, pos2 : integer);
var
   p,cn : integer;
begin
   write(noparses, VerseLabel, ' ');
   for p := pos1 to pos2-1 do
   begin
      write(noparses, (StartOfClauseResolver[PHRASE, p,0]):3);
      if StartOfClauseResolver[PHRASE, p, 1] <> 0 then
      begin
	 write(noparses,' ( ',(StartOfClauseResolver[PHRASE, p,1]):4);
	 for cn := 2 to 6 do
	    if StartOfClauseResolver[PHRASE, p,cn] <> 0 then
	       write(noparses,' ,',(StartOfClauseResolver[PHRASE, p,cn]):4);
	 if Parsing(p) >= LEAST_PARSING_CODE then
	    write(noparses,' ,',(Parsing(p)):4);
	 write(noparses,' ) ');
      end
      else
	 if Parsing(p) >= LEAST_PARSING_CODE then
	 begin
	    write(noparses,' ( ',(Parsing(p)):4);
	    write(noparses, ' ) ');
	 end
	 else
	    write(noparses, ' - ');

   end;
   writeln(noparses, '99');
   writeln(' pattern written to "noparses"');

end;

procedure LocateClauses(var pos1, pos2, phrase: integer);
var
   id, anyparsing,
   someparsing,
   identical_phrase_types:	boolean;
   clause_type_index:		integer;
   cnr, cond, pos :		integer;
   phrasepos :			integer;
   phrase_position:		integer;	{ phrase_position = plaats phrase in clause }
   phrase_type_index:		integer;

begin
   clause_type_index := 0;
   repeat
      clause_type_index := clause_type_index + 1
   until (Resolver[clause_type_index, 1, 0] = phrase) or
   (clause_type_index = NumberOfClauseTypes);
   identical_phrase_types := Resolver[clause_type_index, 1, 0] = phrase;

   if identical_phrase_types then
   begin
      clause_type_index := clause_type_index - 1;
      identical_phrase_types := true;
      someparsing := false;
      anyparsing := false;

      repeat
	 clause_type_index := clause_type_index + 1;
	 phrase_position := pos1 - 1;
	 phrase_type_index := 0;			{ locate phrase in array       }
	 repeat
	    phrase_position := phrase_position + 1;
	    phrase_type_index := phrase_type_index + 1;
	    identical_phrase_types :=
	    StartOfClauseResolver[PHRASE, phrase_position,0] =
	    Resolver[clause_type_index, phrase_type_index, 0]
	 until not identical_phrase_types or
	 (phrase_position = pos2);
	 identical_phrase_types :=
	 (Resolver[clause_type_index, phrase_type_index, 0] = START_CLAUSE)
	 and
	 (StartOfClauseResolver[CLAUSE_MARKS, phrase_position, 0] = START_CLAUSE);

	 {  conditions  }
	 if identical_phrase_types
	    then
	 begin
	    phrasepos := 0;
	    anyparsing := true;
	    someparsing := false;
	    id := true;
	    for pos := pos1 to pos2 -1 do
	    begin
	       phrasepos := phrasepos + 1;
	       cnr := 0;
	       repeat
		  cnr := cnr + 1;

		  if Resolver[clause_type_index, phrasepos, cnr] <> 0
		     then
		  begin
		     id := false;
		     cond := 0;
		     repeat
			cond := cond + 1;
			if StartOfClauseResolver[PHRASE, pos, cond] =
			   Resolver[clause_type_index, phrasepos, cnr]
			   then id := true;
		     until (id) or (cond = CONDITION_LENGTH);
		  end

	       until (cnr = CONDITION_LENGTH) or (id=false);
	       if not id
		  then
	       begin
		  identical_phrase_types := false;anyparsing := false;
	       end
	       else
	       begin
		  Parsing(pos) :=
		  Resolver[clause_type_index, phrasepos, PARSPOS];
		  if Parsing(pos) >= LEAST_PARSING_CODE
		     then
		  begin
		     someparsing := true;
		     anyparsing := false;
		  end;
	       end;
	       if StartOfClauseResolver[PHRASE, pos, 0] <>
		  Resolver[clause_type_index, phrasepos, 0]
		  then writeln(' something wrong in comparison of phrases and conditions');
	    end;

	 end;

	 if identical_phrase_types and
	    (Resolver[clause_type_index, phrase_type_index, 0] = START_CLAUSE)
	    then
	 begin
	    {  writeln(pos1, pos2, phrase_position);  }
	    phrase_position := phrase_position - 1;
	 end
      until (identical_phrase_types) or
      (clause_type_index = NumberOfClauseTypes) or
      (Resolver[clause_type_index + 1, 1, 0] <> phrase);

      if not Interactive then
      begin
	 if not someparsing
	    then
	 begin
	    nopars := nopars + 1;
	 end
	 else parsed := parsed + 1;
	 if (identical_phrase_types)
	    and (anyparsing) then ambipars := ambipars + 1;
      end;
   end;

end; { LocateClauses }


function ValueList_In(var v: ValueListType; x: integer): boolean;
var
   i: integer;
   found: boolean;
begin
   i := 1;
   found := false;
   while not found and (v[i] <> EOI) do begin
      found := v[i] = x;
      i := i + 1;
      assert(i <= MAX_COND_VALUES)
   end;
   ValueList_In := found
end;


function ConditionList_In(var l: MorfCondListType;
   f: Function_IndexType; v: integer;
   var c: ConditionIndexType): boolean;
var
   i: integer;
   found: boolean;
begin
   i := FIRST_CONDITION;
   found := false;
   while not found and (i <= NumberMorfCond) do
      with l[i] do begin
	 if (FunctionIndex <> f) or not ValueList_In(ValueList, v) then
	    i := i + 1
	 else begin
	    found := true;
	    c := i
	 end
      end;
   ConditionList_In := found
end;


function FindWordIndexStartPAtm(w: Word_IndexType): Word_IndexType;
var
   found: boolean;
   i: integer;
begin
   found := false;
   i := w - 1;
   while not found and (i > 0) do
      if AnalysisList[i, PHRASE_TYPE] <> 0 then
	 found := true
      else
	 i := i - 1;
   FindWordIndexStartPAtm := i + 1
end;


procedure findconditions(first_word, word_index, phrase_type_index: integer);
var
   pr: Word_IndexType;
   col,
   TypeOfCondition: ConditionIndexType;
   gram_value        :  integer;
   TimeLocCod        :  integer;

procedure compare(col, gram_value: integer);
(* local to findconditions *)
var
   cond_index: integer;
begin
   if ConditionList_In(MorfCondList, col, gram_value, TypeOfCondition)
   then begin
      { writeln(' morph.condition:', TypeOfCondition); }
      cond_index := 0;
      repeat
	 cond_index := cond_index + 1
      until StartOfClauseResolver[PHRASE, phrase_type_index, cond_index] = 0;
      StartOfClauseResolver[PHRASE, phrase_type_index, cond_index] := TypeOfCondition
   end
   { writeln(' condition_index:', cond_index:3); }
end;

procedure findlexeme(word_index: integer );
var
   TypeOfCondition,
   cond_index,
   pos     : integer;
   hit     : boolean;

begin
   pos := 0;
   hit := false;
   repeat
      pos := pos + 1;
      if LexemeList[word_index] = LexCondList[pos]
	 then
      begin { writeln(' lex.condition:',(pos + 100));  }
	 TypeOfCondition := pos + 100;
	 hit := true;
	 cond_index := 0;
	 repeat
	    cond_index := cond_index + 1
	 until StartOfClauseResolver[PHRASE, phrase_type_index,cond_index] = 0;
	 StartOfClauseResolver[PHRASE, phrase_type_index,cond_index] :=
	 TypeOfCondition;
      end
   until (pos = NumberLexCond) or (hit = true);
end;

procedure findTimeLoc(first_word, word_index : integer);
var p,q, cond_index : integer;
   Timeref, Locref : boolean;

begin
   Timeref := false;
   Locref := false;
   TimeLocCod := 0;
   for p := first_word to word_index do
   begin q := 0;
      repeat
	 q := q + 1;
	 if LexemeList[p] = TimeRefList[q]
	    then Timeref := true;
      until (Timeref) or (q = NumberTimeLex);
   end;

   if not Timeref then
      for p := first_word to word_index do
      begin q := 0;
	 repeat
	    q := q + 1;
	    if LexemeList[p] = LocRefList[q]
	       then Locref := true;
	 until (Locref) or (q = NumberLocLex);
      end;
   if Timeref then TimeLocCod := 401
   else
      if Locref then TimeLocCod := 402;

   if TimeLocCod > 400 then
   begin
      cond_index := 0;
      repeat
	 cond_index := cond_index + 1
      until StartOfClauseResolver[PHRASE, phrase_type_index,cond_index] = 0;
      StartOfClauseResolver[PHRASE, phrase_type_index,cond_index] := TimeLocCod;
   end;
end;


{ findconditions }
begin   {searches in AnalysisList(Ps3p) and compares with }
   TypeOfCondition := 0;                    {morfcond.cl and lexcond.cl }
   if AnalysisList[word_index,PHRASE_TYPE] = 1      { VERB }
      then
   begin
      { writeln ( LexemeList[word_index]);
       writeln (' rootf.morph. =', AnalysisList[word_index,3]);
       }
      col := 3;
      gram_value := AnalysisList[word_index, col];
      compare(col, gram_value);
      if PronSuffix(word_index) then
      begin
	 { writeln (' pronom.sfx.  =', AnalysisList[word_index,6]);
	  }
	 col := 6;
	 gram_value := AnalysisList[word_index, col];
	 compare(col, gram_value);
      end;
      if Participle(word_index) then
      begin
	 { writeln(' vbform      =', AnalysisList[word_index,KO_VT]);
	  }
	 col := KO_VT;
	 gram_value := AnalysisList[word_index, col];
	 compare(col, gram_value);
      end;
      col := 9; gram_value := AnalysisList[word_index,col];
      compare(col, gram_value);               { number }

   end else if ((AnalysisList[word_index,PHRASE_TYPE] = 2)       { NP }
		or (AnalysisList[word_index,PHRASE_TYPE] = -2))  { NPapp}
	    then
   begin
      { writeln ( AnalysisList[word_index,14],' determination');
       }
      col := 14;
      gram_value := AnalysisList[word_index, col];
      compare(col, gram_value);
      if PronSuffix(word_index) then
      begin
	 { writeln (' pronom.sfx.  =', AnalysisList[word_index,6]);
	  }
	 col := 6;
	 gram_value := AnalysisList[word_index, col];
	 compare(col, gram_value);
      end;
      findTimeLoc(first_word, word_index);
   end else if AnalysisList[word_index,PHRASE_TYPE] = 3           { NPPr }
      then
   begin
      findTimeLoc(first_word, word_index);
   end else if AnalysisList[word_index,PHRASE_TYPE] = 4           { AdvP }
      then
   begin
      findTimeLoc(first_word, word_index);
   end else if AnalysisList[word_index,PHRASE_TYPE] = 5           { PP }
      then
   begin
      pr := FindWordIndexStartPAtm(word_index);
      { writeln ( LexemeList[pr],' prep of PP'); }
      if AnalysisList[pr,1] = 5 then
	 findlexeme(pr)
      else
      begin
	 col := 5;
	 gram_value := AnalysisList[word_index,col];
	 compare(col, gram_value);
      end;
      if PronSuffix(pr) then
      begin
	 { writeln (' pronom.sfx.  =', AnalysisList[pr,6]);
	  }
	 col := 6;
	 gram_value := AnalysisList[pr, col];
	 compare(col, gram_value);
      end;
      findTimeLoc(first_word, word_index);
   end else if AnalysisList[word_index,PHRASE_TYPE] = 6          { CP }
      then
   begin
      { writeln ( LexemeList[word_index]);
       }
      findlexeme(word_index);
   end else if AnalysisList[word_index,PHRASE_TYPE] = 7
      then
   begin { writeln ( LexemeList[word_index]);
	  }
      findlexeme(word_index);
      col := 8;      { person }
      gram_value := AnalysisList[word_index,col];
      compare(col, gram_value);
   end else if AnalysisList[word_index,PHRASE_TYPE] = 13         { AdjP }
      then
   begin
      { writeln ( LexemeList[word_index]);
       }
      col := 9;
      gram_value := AnalysisList[word_index,col];
      compare(col, gram_value);          { number }
   end;
end;


procedure WriteLabel(c: integer; var f: text);
begin
   write(f, '<', ParseLabel2(c), '>')
end;


procedure AskInteger(var i: integer);
var
   n: integer;		(* number of trials *)
   ok: boolean;
begin
   n := 1;
   ok := false;
   repeat
      if n > 1 then
	 write('Integer expected. Enter an integer: ');
      if eof then begin
	 writeln;
	 reset(input)
      end else begin
	 ok := ReadInteger(input, i);
	 readln
      end;
      n := n + 1
   until ok
end;


procedure WriteParsingCodeMenu;
begin
   writeln('Phrase atom relations:');
   writeln('<ap> a  | <cj> j  | <pa> p  | <sp> s  | <ss> o');
   writeln;
   writeln('Parsing codes allowed:');
   writeln('<Aj> A  | <Cj> J  | <Co> C  | <Ep> E  | <eX> X');
   writeln('<Fr> F  | <Ij> I  | <Lo> L  | <Mo> M  | <Ng> N');
   writeln('<Ob> O  | <Pj> B  | <Pr> P  | <Qu> Q  | <Re> R');
   writeln('<sc> c  | <Su> S  | <Ti> T  | <Vo> V  | <..> U');
   writeln;
   write('Please enter a single character (e = edit): ')
end;


function AskParsingCode(var NON: boolean): char;
var
   c: char;
   n: integer;		(* number of trials *)
   ok: boolean;
begin
   n := 1;
   ok := false;
   repeat
      if n > 1 then
	 WriteParsingCodeMenu;
      if eof then begin
	 writeln;
	 reset(input)
      end else begin
	 SkipSpace(input);
	 if input^ <> '-' then
	    NON := false
	 else begin
	    get(input);
	    NON := true
	 end;
	 c := GetChar;
	 ok := c in PARSING_CODE_SET + ['e']
      end;
      n := n + 1
   until ok;
   AskParsingCode := c
end;


function AskValidChar(q: StringType; s: CharSet): char;
(* Returns a character from set s as answer to question q *)
var
   c: char;
   i: integer;
begin
   c := chr(0);
   repeat
      write(q, ' [');
      for i := 1 to MAX_CHAR do
	 if chr(i) in s then
	    write(chr(i));
      write(']: ');
      c := GetChar
   until c in s;
   AskValidChar := c
end;


function YesNoQuestion(q: StringType): boolean;
var
   c: char;
begin
   repeat
      write(q, ' [y/n]: ');
      c := GetChar
   until c in YES + NO;
   YesNoQuestion := c in YES
end;


procedure findreason(	 ref	     : char;
		     var NumberTLLex : integer;
		     var RefList     : LexCondListType;
			 firstPhrLex : integer;
			 lastPhrLex  : integer);
var
   p, r , num : integer;
   id	      : boolean;
begin
   TimeLocRef := false; id := false;
   p := firstPhrLex - 1;
   repeat
      p := p + 1;
      if AnalysisList[p , PHRDEP_PSP] in [2,3,4]
	 then
      begin
	 num := 0;
	 repeat
	    num := num + 1;
	 until (RefList[num,1] = LexemeList[p,1]) or
	 (num = NumberTLLex);
	 if RefList[num] = LexemeList[p]
	    then id := true
	 else
	 begin
	    id := false;
	    repeat
	       if RefList[num] = LexemeList[p]
		  then id := true
	       else num := num + 1;
	    until (id=true) or (num >= NumberTLLex) or
	    (RefList[num,1] <> LexemeList[p,1]);
	 end;
	 if id then
	 begin
	    p := lastPhrLex;
	    writeln(RefList[num], id);
	 end;
      end
   until p = lastPhrLex;
   if not id then
   begin
      write (' I don''t know which lexeme gives the ');
      if ref = 't' then writeln('"time reference"? ')
      else if ref = 'l' then writeln('"loc. reference" ');

      p := firstPhrLex - 1;
      repeat
	 p := p + 1;
	 if AnalysisList[p , PHRDEP_PSP] in [2,3,4]
	    then
	 begin
	    if (ref = 't')
	       then write(LexemeList[p], 'gives this lexeme the "time reference"')
	    else if ref = 'l'
	       then write(LexemeList[p], 'gives this lexeme the "loc. reference"');
	    if YesNoQuestion('?') then begin
	       for r := NumberTLLex downto num do
		  RefList[r + 1] := RefList[r];
	       RefList[num] := LexemeList[p];
	       NumberTLLex := NumberTLLex + 1;
	       writeln('inserted ',RefList[num]);
	       p := lastPhrLex;
	       id := true;
	    end;
	 end
      until p = lastPhrLex;
   end;
   TimeLocRef := id;
end;


function ParsLab(var lab: LabType): integer;
var
   s: StringType;
begin
   s := substr(lab, 3, 2);
   ParsLab := ParseCode2(s)
end;


function Parselabel(content: integer): LabType;
begin
   case content of
      -1:
	 Parselabel := ' ----';
      0:
	 Parselabel := ' ....';
      otherwise
	 Parselabel := ' ' + '<' + ParseLabel2(content) + '>'
   end
end;


function AlfOrd(c: char): integer;
var
   i: integer;
begin
   i := 0;
   while (i <= ALFSIZ) and (c <> Alfabet[i]) do
      i := i + 1;
   AlfOrd := i
end;


function AbeforeB(c1, c2: char): boolean;
var
   i1, i2: integer;
begin
   i1 := AlfOrd(c1);
   i2 := AlfOrd(c2);
   if (i1 in [0..ALFSIZ]) or (i2 in [0..ALFSIZ]) then
      AbeforeB := i1 < i2
   else
      AbeforeB := c1 < c2
end;


procedure CalcPAtomTextIndices(var v: LineType);
(* Calculate the index in v of the start of the surface text of every
   phrase atom in the verse and store it in SOCR[LAST_WORD, p, 1] *)
var
   p, s, w: integer;
begin
   p := 1;	(* phrase atom index *)
   s := 1;	(* string index *)
   w := 1;	(* word index *)
   while StartOfClauseResolver[LAST_WORD, p, 0] <> 0 do begin
      StartOfClauseResolver[LAST_WORD, p, 1] := s;
      while w <= StartOfClauseResolver[LAST_WORD, p, 0] do begin
	 if v[s] in WORD_SEPARATORS then
	    w := w + 1;
	 s := s + 1
      end;
      p := p + 1
   end;
   StartOfClauseResolver[LAST_WORD, p, 1] := s
end;


procedure CompareVerbVal(var line: integer;
			 var LineVal: OneLineVal;
			 var Constline: ConstlineType;
			 var pattern: boolean);
var
   pos		    : integer;
   x, y		    : integer;
   lab		    : LabType;
   lab1, lab2	    : LabType;
   id, okline, stop : boolean;
begin
   stop := false;
   x := line - 1;
   CheckVerbVal;
   debugln(' check before start from line:', line:4);
   repeat
      x := x + 1;
      {  writeln(LineVal[VVL_lex,2], VerbVal[x, VVL_lex,2],' = LineVal and VerbVal[x ..]');
       }
      okline := true;
      if (LineVal[VVL_lex,1] <> VerbVal[x, VVL_lex,1])                           {other verb}
	 or (LineVal[VVL_Root,1] <> VerbVal[x, VVL_Root,1])                           {other rtf }
	 {PO?}
	 then
      begin
	 okline := false;
	 stop := true;
      end;
      if Constpresent[x,1] = '+' then
	 writeln('line:',x:4,' "+" in pos 1 !!!');
      for  y := 3 to MAXcolV do
	 if okline then
	 begin
	    id := true;
	    lab1 := LineVal[y,1];
	    lab2 := LineVal[y,2];
	    if y < VVL_Cpl1 then begin
	       if Constpresent[x, y] = '+' then
	       begin
		  if (VerbVal[x,y, 2] <> lab2)
		     then id := false;
		  if (VerbVal[x,y,2] <> '     ') and (lab2[2] = '.')
		     then
		  begin
		     id := true;      { new }
		     lab2 := VerbVal[x,y,2];
		  end;
	       end
	       else if Constline[y] = '+' then
	       begin
		  if Constpresent[x,y] = '.'
		     then id := false;
	       end
	    end else begin
	       if Constline[y] = '+' then       { present in actual line }
	       begin
		  if (VerbVal[x,y, 1] <> lab1)
		     then id := false
		  else
		  begin
		     if lab2[2] in [ '.','<'] then                { parsing new  }
		     begin
			if lab2 = ' ....' then
			begin
			   lab2 := VerbVal[x,y,2];     { copy parsing }
			   id := true;
			end
			else if lab2 <> VerbVal[x,y,2] then
			   id := false;
		     end else id := false;
		  end;
	       end
	       (*
		  else if Constpresent[x, y] = '+' then
		       begin
		if Constline[y] = '.'
		then id := false;
		       end
		*)                       { no obligation ? }
	    end;

	    if (LineVal[VVL_lex,2] = ' <PC>')
	       and (VerbVal[x, VVL_lex,2] <> ' <PC>') {<Pr> <> <PC>}
	       then id := false;
	    (*  *)
	    if id = false then
	    begin
	       {  writeln ('pattern line',x:3,' cat',y:3,' <> newcat',y:3);
		}
	       lab := VerbVal[x,y, 1];
	       lab := VerbVal[x,y, 2];
	    end;
	    (*   *)

	    if not id then okline := false;
	 end;
      if okline then stop := true;
   until stop;
   if okline then
   begin
      writeln(' pattern matches pattern nr.',x:3);
      for y := 1 to MAXcolV
	 do
      begin
	 Constline[y] := Constpresent[x,y];
	 LineVal[y,1] := VerbVal[x,y,1];
	 LineVal[y,2] := VerbVal[x,y,2];
	 pos := 0; lab2 := LineVal[y,2];
	 repeat
	    pos := pos + 1
	 until (PhrPosList[pos] = y) or (pos = MAX_PATMS);
	 if pos < MAX_PATMS then
	 debugln(' Phrase pos.:',pos:3,'=',lab2);
#ifdef DEAD_CODE
	 if ParsLab(lab2) > 0 then
	    { again? }                       Parsing(pos) := ParsLab(lab2);
	 {correctie ?? }
#endif
	 if not (Constline[y] in ['.','+','0'])
	    then
	 begin
	    writeln(' funny code in verb:',x:3);
	    if lab2 <> '     '
	       then
	    begin
	       Constline[y] := '+';
	       Constpresent[x,y] := '+';
	       if y < 4 then Constline[y] := '.';
	       if y < 4 then Constpresent[x,y] := '.';
	    end
	    else
	    begin
	       Constline[y] := '.';
	       Constpresent[x,y] := '.';
	    end;
	 end;
      end;
      for y := 1 to MAXcolV
	 do
      begin
	 lab1 := LineVal[y,1];
	 write(Constline[y],lab1);
      end; writeln;
      for y := 1 to MAXcolV
	 do
      begin
	 lab2 := LineVal[y,2];
	 write(Constline[y],lab2);
      end; writeln;
   end;
   line := x; pattern := id;
   writeln('pattern=',pattern);
   CheckVerbVal; write(' check after ');
end;

procedure InsertVerbVal(var line, maxlines: integer;
			var LineVal: OneLineVal;
			var Constline: ConstlineType);
var
   x, y	: integer;
   lab2	: LabType;
   lab	: LabType;
begin
   writeln;
   writeln;
   CheckVerbVal;
   writeln('check before insertion');
   for x := maxlines downto line do
   begin
      for y := 1 to MAXcolV do
      begin
	 lab := VerbVal[x,y,1]; VerbVal[x + 1, y, 1] := lab;
	 lab := VerbVal[x,y,2]; VerbVal[x + 1, y, 2] := lab;
	 Constpresent[x + 1, y] := Constpresent[x, y];
	 if Constpresent[x, 1] = '+' then
	 begin
	    writeln(' "+" in line',x + 1,' !!!');
	    pcexit(1);
	 end;
      end;
   end;
   for y := 1 to MAXcolV do
   begin
      if Constline[y] = ' ' then
      begin
	 writeln(' funny label in line:',line:4);
	 if (LineVal[y,1] <> '     ') or (LineVal[y,2] <> '     ')
	    then Constline[y] := '+'
	 else Constline[y] := '.';
	 if y < 4 then Constline[y] := '.';
      end;
      lab := LineVal[y,1];
      lab2 := LineVal[y,2];
      if (lab2 <> ' <ap>') and (lab2 <> ' <sp>') then
      begin
	 Constpresent[line, y] := Constline[y];
	 VerbVal[line,y, 1] := lab;
	 write(NEW,Constpresent[line, y],lab);
	 write(Constpresent[line, y],lab);
	 VerbVal[line,y, 2] := lab2;
      end else
      begin
	 write(NEW, 'something wrong:', lab2,' omitted');
      end;
   end;
   for y := 1 to MAXcolV do
   begin
      lab2 := VerbVal[line,y,2];
      if lab2 <> '     ' then
      begin
	 write(NEW,lab2); write(lab2);
      end;
   end;
   writeln(NEW); writeln;
   newlines := newlines + 1;
   maxlines := maxlines + 1;
   CheckVerbVal; writeln('check after');
end;


procedure InsertVerbLess(var line, maxlines : integer;
			 var LineVal	    : OneLineVal;
			 var Constline	    : ConstlineType);
var
   x, y	: integer;
   lab	: LabType;
begin
   writeln;
   writeln;
   if line < maxlines then
   begin
      for x := maxlines downto line do
      begin for y := 1 to MAXcolN do
      begin lab := VerbLess[x,y,1]; VerbLess[x + 1, y, 1] := lab;
	 lab := VerbLess[x,y,2]; VerbLess[x + 1, y, 2] := lab;
	 ConstVBLpresent[x + 1, y] := ConstVBLpresent[x, y];
      end;
      end;
   end;
   for y := 1 to MAXcolN do
   begin
      if Constline[y] = ' ' then
      begin writeln(' funny label in line:',line:4);
	 if (LineVal[y,1] <> '     ') or (LineVal[y,2] <> '     ')
	    then Constline[y] := '+'
	 else Constline[y] := '.';
      end;
      ConstVBLpresent[line, y] := Constline[y];
      lab := LineVal[y,1]; VerbLess[line,y, 1] := lab;
      write(NEW,ConstVBLpresent[line, y],lab);
      write(ConstVBLpresent[line, y],lab);
      lab := LineVal[y,2]; VerbLess[line,y, 2] := lab;

   end;
   for y := 1 to MAXcolN do
   begin
      lab := VerbLess[line,y,2];
      if lab <> '     ' then
      begin
	 write(NEW,lab); write(lab);
      end;
   end;
   writeln(NEW); writeln;

   newVBLlines := newVBLlines + 1;
   maxlines := maxlines + 1;
end;


procedure SetLineVal(var v: OneLineVal; i: integer; l: LabType; p: integer; t: integer);
begin
   v[i, 1] := l;
   v[i, 2] := Parselabel(p);
   if i = VVL_lex then
      Constline[i] := '.'
   else
      Constline[i] := '+';
   PhrPosList[t] := i
end;


procedure FindVerbLess(	   startphr, stopphr : integer;
		       var search	     : boolean;
			   verse_line	     : LineType );
var
   phrase_type_index : integer;
   pos		     : integer;
   i, p, q, ca	     : integer;
   lab2		     : LabType;
   lab		     : LabType;
   CompareLV	     : OneLineVal;
   LineVal	     : OneLineVal;
   partpos, FirstCat : integer;
   SUpos, PRpos	     : integer;
   parsing	     : integer;
   EndofCat	     : boolean;
   SU, PR	     : boolean;
   determS, determP  : boolean;
   ident	     : boolean;
begin
   for i := 1 to MAXcat do
   begin
      CompareLV[i,1] := '     '; LineVal[i,1] := '     ';
      CompareLV[i,2] := '     '; LineVal[i,2] := '     ';
      Constline[i] := '.';
   end;
   writeln(' verbless clause : FindVerbLess');
   LineVal[VLL_Sfx,1] := '     ';
   for i := 1 to MAX_PATMS do
      PhrPosList[i] := 0;
   phrase_type_index := startphr - 1;

   repeat
      phrase_type_index := phrase_type_index + 1;
      parsing := Parsing(phrase_type_index);
      if parsing in DeptSet then
	 if phrase_type_index < stopphr then
	    phrase_type_index := phrase_type_index + 1;
      parsing := Parsing(phrase_type_index);
      lastPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index, 0];
      if phrase_type_index = 1 then
	 firstPhrLex := 1
      else
	 firstPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index-1, 0] + 1;

      if (AnalysisList[lastPhrLex, PHRASE_TYPE] in [4,13])
	 and (parsing = Modi) {Mod}
	 then
	 SetLineVal(LineVal, VLL_Mod, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex, PHRASE_TYPE] in [2,3,4,5]) and (parsing = Time) {Time}
	 then
	 SetLineVal(LineVal, VLL_Time, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex, PHRASE_TYPE] in [2,3,4,5]) and (parsing = Loca) {Loc }
	 then
	 SetLineVal(LineVal, VLL_Loca, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex, PHRASE_TYPE] = 13 )                          { 8 Adj}
	 then
      begin
	 for i := 1 to 5 do lab[i] := (LexemeList[firstPhrLex,i]);
	 SetLineVal(LineVal, VLL_AdjP, lab, parsing, phrase_type_index);
      end else if (AnalysisList[lastPhrLex, PHRASE_TYPE] = 8 )                          { 2 pronD}
	 then
	 SetLineVal(LineVal, VLL_PrnD, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex, PHRASE_TYPE] = 7 )                          { 3 pronP}
	 then
	 SetLineVal(LineVal, VLL_PrnP, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex, PHRASE_TYPE] = 9 )                          { 7 pronI}
	 then
	 SetLineVal(LineVal, VLL_PrnI, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex, PHRASE_TYPE] = 3 )                          { 5 PrNP }
	 then
	 SetLineVal(LineVal, VLL_NPPN, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex,PHRASE_TYPE ] = 2)                           { 4, 6 NP }
	 then
      begin
	 if AnalysisList[lastPhrLex,DETERMINATION] = 2 then
	 begin
	    if parsing = PreC then
	       LineVal[VLL_Sfx,1] := '     ';
	    SetLineVal(LineVal, VLL_NPdt, '     ', parsing, phrase_type_index)
	 end else begin
	    if Copula(lastPhrLex) then
	       SetLineVal(LineVal, VLL_Ext, '     ', parsing, phrase_type_index)
	    else
	       SetLineVal(LineVal, VLL_NPid, '     ', parsing, phrase_type_index)
	 end
      end else if (AnalysisList[lastPhrLex,PHRASE_TYPE ] = 11)                           { 12 Ext.N}
	 and Copula(lastPhrLex) then
	    SetLineVal(LineVal, VLL_Ext, '     ', parsing, phrase_type_index)
      else if AnalysisList[lastPhrLex,PHRASE_TYPE ] = 12 then  { 10 Irog }
	 SetLineVal(LineVal, VLL_Irog, '     ', parsing, phrase_type_index)
      else if (AnalysisList[lastPhrLex,PHRASE_TYPE ] = 4)                            { 11 Mod  }
	 then
      begin                                        {<WD}
	 { nog testen op poss. Ti en Loc?}
	 for i := 1 to 5 do lab[i] := (LexemeList[firstPhrLex,i]);
	 SetLineVal(LineVal, VLL_Mod, lab, parsing, phrase_type_index)
      end
      else if (AnalysisList[lastPhrLex,PHRASE_TYPE ] = 10)                           { 13 Intj }
	 then
	 SetLineVal(LineVal, VLL_Inj, '     ', parsing, phrase_type_index)
      else if AnalysisList[lastPhrLex,PHRASE_TYPE ] = 5 then { 9 PP }
      begin
	 for i := 1 to 5 do lab[i] := (LexemeList[firstPhrLex,i]);
	 {PP}
	 i := 0;
	 if (parsing = 0) or (parsing = Unkn) then i := VLL_PP
	 else if parsing = Adju then i := VLL_Adj1
	 else if parsing = Time then i := VLL_Time
	 else	if parsing = Loca then i := VLL_Loca
	 else if parsing = Appo then i := VLL_Cpl1          { TEST apposition}
	 else if parsing = Para then i := VLL_Cpl1          { TEST parallel}
	 else if parsing = Link then i := VLL_Cpl1          { TEST cjp parallel}
	 else if parsing = Spec then i := VLL_Cpl1          { TEST specific }
	 else if parsing = Cmpl then i := VLL_Cpl1
	 else if parsing = PreC then i := VLL_PP;
	 if Constline[VLL_PP] = '+' then i := VLL_Cpl1;
	 if i in [VLL_Cpl1,VLL_Adj1] then
	 begin
	    i := i - 1;
	    repeat
	       i := i + 1;
	       if LineVal[i,1] = '     ' then
		  SetLineVal(LineVal, i, lab, parsing, phrase_type_index);
	    until (LineVal[i,1] = lab) or (i > 20);
	 end else begin
	    if i = 0 then begin
	      writeln(' funny parsing for a PP in a nominal clause');
	      writeln(' are you sure ?');
	      i := VLL_Cpl1
	    end;
	    SetLineVal(LineVal, i, lab, parsing, phrase_type_index);
	 end;
      end;                                                     {CmAj }
      debugln(' found phrasetype:',(AnalysisList[lastPhrLex,PHRASE_TYPE ]):4);
      { yet Quest, Interj, Adv, if no other <P> }

   until phrase_type_index = stopphr;


   for i := 1 to MAXcolN do
   begin
      lab := LineVal[i,1];
      debug(Constline[i],lab);
   end;
   debugln('.');
   for i := 1 to MAXcolN do
   begin
      if LineVal[i,2] = ' <PC>' then
	 lab := LineVal[i,2];
      if LineVal[i,2] <>'     ' then
	 debug(LineVal[i,2]);
   end;
   writeln;
   i := NumberOfVerbLessPat;
   {indien nog onbekend?}
   FirstCat := 1;
   p := 0;
   repeat
      p := p + 1
   until (Constline[p] = '+') or (p > 13);   { first categ }
   FirstCat := p;
   debugln(' first "+" category in this line on pos.',FirstCat:3);
   if FirstCat > 13 then
      i := NumberOfVerbLessPat
   else
   begin
      p := 0;
      ident := false;
      EndofCat := false;
      repeat
	 p := p + 1;
	 ca := 0;
	 repeat
	    ca := ca + 1
	 until (ConstVBLpresent[p,ca] = '+') or (ca > 13);
	 if ca > FirstCat then
	    EndofCat := true
	 else if ca = FirstCat then
	 begin
	    EndofCat := false;
	    ident := false;
	    if p < NumberOfVerbLessPat then
	       debugln(' Start of proper category verbless clauses found in line:',p:3);
	    p := p - 1;
	    q := 1;
	    repeat
	       p := p + 1;
	       q := 1;
	       ident := true;
	       repeat
		  q := q + 1;
		  if (ConstVBLpresent[p,q] <> '+') and (q = FirstCat)
		     then EndofCat := true;
		  if not search                           { labels need to fit }
		     then
		  begin
		     if (LineVal[q,1] <> VerbLess[p,q,1]) or
			(LineVal[q,2] <> VerbLess[p,q,2]) or
			(ConstVBLpresent[p, q] <> Constline[q])
			then
			ident := false
		  end else if search                                { labels not yet known }
		     then
		  begin
		     if (ConstVBLpresent[p, q] <> Constline[q])
			then ident := false
		  end;
	       until (q = MAXcolN ) or (ident = false)
	    until (ident = true)
	    or (p = NumberOfVerbLessPat)
	    or (EndofCat);
	    if ident then
	       debugln(' Verbless Clause identified in List, line nr:',p:5);
	 end;
      until (EndofCat) or (p = NumberOfVerbLessPat) or (ident);
      if p < NumberOfVerbLessPat then i := p
      else i := NumberOfVerbLessPat - 1;
   end;
   if ident and search then begin
      debugln(' Verbless Clause identified in List, line nr:',p:5);
      q := 1;
      repeat
	 q := q + 1;
	 if Constline[q] = '+' then
	 begin
	    lab2 := VerbLess[p,q,2];
	    if lab2 = '     ' then
	       lab2 := LineVal[q,2];
	    pos := 0;
	    repeat
	       pos := pos + 1
	    until (PhrPosList[pos] = q) or (pos = MAX_PATMS);
	    if pos < MAX_PATMS then
	    begin
	       debugln(' Phrase pos.:',pos:3,'=',lab2);
	       Parsing(pos) := ParsLab(lab2);
	       if Parsing(pos) in DeptSet then
		  Distance(pos) := PaR_Dis2Cod(-1, 'P')
	    end;
	 end
      until q = MAXcolN;
   end;
   if not search and not ident then
   begin
      debugln(' insert newpattern in verblessList after number:',i:4);
      InsertVerbLess(i, NumberOfVerbLessPat, LineVal, Constline);
   end;
   if not search then
   begin
      phrase_type_index := startphr - 1;
      SU := false;
      PR := false;
      determS := false;
      determP := false;
      SUpos := 0;
      PRpos := 0;
      repeat
	 phrase_type_index := phrase_type_index + 1;
	 lastPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index, 0];
	 if Parsing(phrase_type_index) in PreCSet
	    then
	 begin
	    PR := true;
	    PRpos := phrase_type_index;
	    if AnalysisList[lastPhrLex,DETERMINATION] = 2
	       then determP := true;
	 end;
	 if Parsing(phrase_type_index) in SubjSet
	    then
	 begin
	    SU := true;
	    SUpos := phrase_type_index;
	    if AnalysisList[lastPhrLex,DETERMINATION] = 2
	       then determS := true;
	 end;
	 if not PR and (Parsing(phrase_type_index)
			     in AdvbSet + CopuSet + IntjSet + QuesSet)
	    then
	 begin
	    if (Parsing(phrase_type_index) in QuesSet)
	       and ((LexemeList[lastPhrLex] = '>JH    ') or
		    (LexemeList[lastPhrLex] = '>J     ') )
	       then
	    begin
	       PR := true;
	       PRpos := phrase_type_index;
	       if Parsing(phrase_type_index) = Ques
		  then Parsing(phrase_type_index) := PreC; {Qu = P}
	    end else if (Parsing(phrase_type_index) in IntjSet)
	       and (LexemeList[lastPhrLex] = 'HWJ    ')
	       then
	    begin
	       PR := true;
	       PRpos := phrase_type_index;
	    end else if (Parsing(phrase_type_index) in CopuSet)
	       and Copula(lastPhrLex)
	       then
	    begin
	       PR := true;
	       PRpos := phrase_type_index;
	    end else if (Parsing(phrase_type_index) in AdvbSet)
	       and ((LexemeList[lastPhrLex] = 'CM     ') or
		    (LexemeList[lastPhrLex] = 'CMH=   ') )
	       then
	    begin
	       PR := true;
	       PRpos := phrase_type_index;
	    end;
	 end;
      until phrase_type_index = stopphr;    { twee posities; sorteren }
      if not SU then
	 write(NCL,' SU??    ')
      else
      begin
	 write(NCL,Parselabel(Parsing(SUpos)));
	 if Parsing(SUpos) = Subj then
	    WritePTYpe(NCL,(StartOfClauseResolver[PHRASE, SUpos , 0]),determS)
	 else write(NCL,'SFX ');
      end;
      if not PR then
	 write(NCL,' PC??    ')
      else
      begin
	 write(NCL,Parselabel(Parsing(PRpos)));
	 WritePTYpe(NCL,(StartOfClauseResolver[PHRASE, PRpos , 0]),determP);
      end;
      if SUpos > PRpos then write(NCL,'  << ') else
	 write(NCL,' >>  ');

      write(NCL,'  ',VerseLabel, ' ');
      phrase_type_index := startphr - 1;
      repeat
	 phrase_type_index := phrase_type_index + 1;
	 lastPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index, 0];
	 if phrase_type_index = 1 then
	    firstPhrLex := 1
	 else
	    firstPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index-1, 0] + 1;
	 p := 0;
	 partpos := 0;

	 repeat
	    p := p + 1;
	    if verse_line[p] in ['-',' ','#','$']
	    then partpos := partpos + 1;
	    if (partpos>= firstPhrLex-1) and (partpos <= lastPhrLex)
	       then
	    begin
	       if verse_line[p] = '$' then write(NCL,'-')
	       else if verse_line[p] = '#' then write(NCL,' ')
	       else
		     write(NCL,verse_line[p])
	    end
	 until partpos = lastPhrLex;
	 write(NCL,Parselabel(Parsing(phrase_type_index)))
      until phrase_type_index = stopphr;
      writeln(NCL);

   end
end;


procedure SetRootFormation(var l: LabType; r: integer);
(* See Section 2.19 of Description of Quest II Data File Format *)
begin
   case r of
      0:
	 l := 'qal  ';
      1:
	 l := 'pi   ';
      2:
	 l := 'hif  ';
      3:
	 l := 'nif  ';
      4:
	 l := 'pu   ';
      5:
	 l := 'hafel';
      6:
	 l := 'hitp ';
      7:
	 l := 'hitpe';
      8:
	 l := 'hof  ';
      9:
	 l := 'etta ';
      10:
	 l := 'hst  ';
      11:
	 l := 'hotp ';
      12:
	 l := 'nit  ';
      13:
	 l := 'etpa ';
      14:
	 l := 'tifal';
      15:
	 l := 'afel ';
      16:
	 l := 'shaf ';
      17:
	 l := 'peal ';
      18:
	 l := 'pael ';
      19:
	 l := 'peil ';
      20:
	 l := 'hitpa';
      21:
	 l := 'etpe ';
      22:
	 l := 'eshta';
      otherwise
	 l := ' ----'
   end
end;


procedure FindParsing(startphr, stopphr: integer; search: boolean;
   verse_line: LineType);
var
   phrase_type_index: integer;
   lab2, labn2, lab, labn: LabType;
   CompareLV, LineVal: OneLineVal;
   i, x, pers: integer;
   verbline, xc: integer;
   maxcompl, maxadj: integer;
   parsing: integer;
#ifdef ARAMAIC
   HWA: integer;
#endif
   k1, k2: char;
   NoVerb, found, pattern: boolean;
   fullyP, hitv, hitr: boolean;
begin
   for i := 1 to MAXcat do begin
      CompareLV[i, 1] := '     ';
      LineVal[i, 1] := '     ';
      CompareLV[i, 2] := '     ';
      LineVal[i, 2] := '     ';
      Constline[i] := '.'
   end;
#ifdef ARAMAIC
   HWA := 0;
#endif
   for i := 1 to MAX_PATMS do
      PhrPosList[i] := 0;
   phrase_type_index := startphr - 1;
   if search then
      writeln(' search for parsing data in file:')
   else
      debugln(' store parsing data in file:');
   parsing := 0;
   fullyP := true;
   NoVerb := true;				{ assume verbless clause }
   repeat
      phrase_type_index := phrase_type_index + 1;
      lastPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index, 0];
      if AnalysisList[lastPhrLex, PHRASE_TYPE] = VP then
#ifdef ARAMAIC
	 if LexemeList[lastPhrLex] = 'HW>[       ' then begin
	    if NoVerb = false then
	       HWA := 4
	    else
	       HWA := 1;
	    writeln(' "FindParsing" HWA =', HWA: 4)
	 end else begin
	    NoVerb := false;
	    if HWA = 1 then
	       HWA := 4;
	    writeln(' "FindParsing" HWA =', HWA: 4)
	 end
#else
	 NoVerb := false
#endif
   until phrase_type_index = stopphr;
   if NoVerb then FindVerbLess(startphr, stopphr, search, verse_line)
   else
   begin
      phrase_type_index := startphr - 1;
      repeat
	 phrase_type_index := phrase_type_index + 1;
	 {
	  write(StartOfClauseResolver[PHRASE, phrase_type_index, 0]);
	  }
	 parsing := Parsing(phrase_type_index);
	 if (parsing in DeptSet) or (AnalysisList[lastPhrLex, PHRASE_TYPE] < 0)
	    then
	 begin
	    if AnalysisList[lastPhrLex, PHRASEdist] > -1 then
	       AnalysisList[lastPhrLex, PHRASEdist] :=
	       Distance(phrase_type_index);
	    if phrase_type_index < stopphr then
	       phrase_type_index := phrase_type_index + 1;
	 end;
	 parsing := Parsing(phrase_type_index);
	 lastPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index, 0];
	 if phrase_type_index = 1 then firstPhrLex := 1
	 else
	    firstPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index-1, 0] + 1;

	 if (parsing < Appo) or (parsing = Unkn) then
	 begin fullyP := false;
	    if search = false then
	    begin
	       writeln(' This clause_atom has not been fully parsed');
	       writeln(' It will not be stored into "verbvalList" ');
	       if not YesNoQuestion(' Should I continue the parsing process?') then begin
		  Stop := true;
		  write  (' If you restart the programme you will have');
		  writeln(' occasion to correct the parsing of this verse.');
		  search := true; { no storing}
	       end;
	    end;
	 end;

	 if PronSuffix(lastPhrLex) and
	    (AnalysisList[lastPhrLex, PHRASE_TYPE] = 1) then
	    SetLineVal(LineVal, VVL_sfx, '     ', parsing, phrase_type_index);

	 if AnalysisList[lastPhrLex, PHRASE_TYPE] in [2,3] then begin
	    if parsing = PreC then
	       SetLineVal(LineVal, VVL_PrCm, '     ', parsing, phrase_type_index)
	    else
	       if AnalysisList[lastPhrLex, DETERMINATION] = 2 then
		  SetLineVal(LineVal, VVL_NPdt, '     ', parsing, phrase_type_index)
	       else
		  SetLineVal(LineVal, VVL_NPid, '     ', parsing, phrase_type_index)
	 end;

	 if (AnalysisList[lastPhrLex, PHRASE_TYPE] in [4,13]) and (parsing = Modi) {Mod}
	    then
	    SetLineVal(LineVal, VVL_Modf, '     ', parsing, phrase_type_index);

	 if AnalysisList[lastPhrLex, PHRASE_TYPE] = VP then begin
	    NoVerb := false;
	    if
#ifdef ARAMAIC
	       (HWA < 4) or (HWA = 4) and (LexemeList[lastPhrLex] <> 'HW>[       ')
#else
	       true
#endif
	    then begin
	       for i := 1 to 5 do
		  lab[i] := LexemeList[lastPhrLex, i];
#ifdef ARAMAIC
	       if HWA = 4 then
		  SetLineVal(LineVal, VVL_HWA, '     ', Pred, phrase_type_index);
#endif
	       SetLineVal(LineVal, VVL_lex, lab, parsing, phrase_type_index)
	    end;
	    if LineVal[VVL_PrCm,2] = LineVal[VVL_lex,2] { PC} then
	    begin
	       LineVal[VVL_PrCm,2] := '     ';
	       Constline[VVL_PrCm] := '.';
	    end;

	    if parsing in PredSet * ObjcSet then begin
	       SetLineVal(LineVal, VVL_sfx, '     ', Objc, phrase_type_index);
	       PhrPosList[phrase_type_index] := VVL_lex
	    end else if parsing in PredSet * SubjSet then begin
	       SetLineVal(LineVal, VVL_sfx, '     ', Subj, phrase_type_index);
	       PhrPosList[phrase_type_index] := VVL_lex
	    end;


	    SetRootFormation(LineVal[VVL_Root, 1], AnalysisList[lastPhrLex, ROOT_MORPHEME]);
	    pers := AnalysisList[lastPhrLex,PERSON];
	    case pers of
	      0	: lab := '     ';
	      1	: lab := '1/2  ';
	      2	: lab := '1/2  ';
	      3	: lab := '3    ';
	      -1: lab := '     ';
	    end;
	    if Constline[VVL_NPid] = '+' then
	       LineVal[VVL_P123,1] := lab;       { with NPidet only }
	 end;

	 if AnalysisList[lastPhrLex,PHRASE_TYPE ] = 5 then                   { PP }
	 begin
	    for i := 1 to 5 do lab[i] := (LexemeList[firstPhrLex,i]);
	    if lab = '>T   ' then
	       SetLineVal(LineVal, VVL_ET, '     ', parsing, phrase_type_index)
	    else if parsing = PreC then
	       SetLineVal(LineVal, VVL_PrCm, '     ', parsing, phrase_type_index)
	    else
	    begin                                 {PP}
	       i := 0;
	       if (parsing = 0) or (parsing = Unkn) then
		  i := VVL_ET
	       else if parsing in AdvbSet then
		  i := VVL_Cpl5
	       else  if parsing = Cmpl then
		  i := VVL_ET;
	       if i >= VVL_ET then
		  repeat
		     i := i + 1;
		     if LineVal[i,1] = '     ' then
			SetLineVal(LineVal, i, lab, parsing, phrase_type_index)
		  until (LineVal[i,1] = lab) or (i > 20);
	    end;                                                     {CmAj }
	 end;
	 write(Parselabel(Parsing(phrase_type_index)));

      until phrase_type_index = stopphr;
      writeln;

      for i := 1 to MAXcolV do
      begin
	 lab := LineVal[i,1];
	 write(Constline[i],lab);
      end;
      writeln;
      for i := 1 to MAXcolV do
      begin
	 lab := LineVal[i,2];
	 write('.',lab);
      end;
      writeln;
      hitv := false;
      hitr := false;

      if LineVal[VVL_lex,1] <> '     ' then                                     { verbal clause }
      begin
	 verbline := 0;
	 repeat
	    verbline := verbline + 1;
	    if (LineVal[VVL_lex,1] = VerbVal[verbline, VVL_lex,1])    {verb.lex}
	       then hitv := true;
	 until (hitv) or (verbline = NumberOfVerbValPat);
	 if LineVal[VVL_Root,1] <> VerbVal[verbline, VVL_Root,1] then
	    hitr := false
	 else
	    hitr := true;
	 while (hitr = false)
	    and (LineVal[VVL_lex,1] = VerbVal[verbline, VVL_lex,1]) do
	 begin
	    verbline := verbline + 1;
	    if (LineVal[VVL_Root,1] = VerbVal[verbline, VVL_Root,1])    {root.frm}
	       then hitr := true;
	 end;
	 if LineVal[VVL_lex,1] <> VerbVal[verbline, VVL_lex,1] then
	 begin
	    hitv := false;
	    hitr := false;
	 end;
	 if hitv then
	 begin
	    lab := LineVal[VVL_lex,1];
	    pattern := true;
	    if hitr then
	    begin
	       write(' Verb ',lab);
	       CompareLV[1,1] := lab;
	       lab := LineVal[VVL_Root,1];
	       CompareLV[2,1] := lab;
	       writeln(' Root ',lab, 'found in line:',verbline:4);
	       writeln; lab := LineVal[VVL_lex,1];
	       i := verbline-1;                         {establish pattern of verb + PP }
	       repeat
		  i := i + 1;
		  xc := VVL_Cpl1 - 1;
		  repeat
		     xc := xc + 1;
		     lab := VerbVal[i,xc,1];       {copy Compl+Adju}
		     if lab <> '     ' then
			CompareLV[xc,1] := lab;
		  until xc = VVL_Adj6;
	       until (VerbVal[i + 1, VVL_Root,1] <> LineVal[VVL_Root,1]) or {rootf}
	       (VerbVal[i + 1, VVL_lex,1] <> LineVal[VVL_lex,1]);   {verbl}
	       maxcompl := VVL_Cpl1 - 1;
	       repeat
		  maxcompl := maxcompl + 1
	       until (CompareLV[maxcompl,1] = '     ') or (maxcompl = VVL_Cpl5);
	       maxadj := VVL_Adj1 - 1;
	       repeat
		  maxadj := maxadj + 1
	       until (CompareLV[maxadj,1] = '     ') or (maxadj = VVL_Adj6);
	       lab := LineVal[VVL_lex,1];
	       debugln('Cumulative Pattern of verb:',lab,' :');
	       for i := 1 to MAXcolV do
	       begin
		  lab := CompareLV[i,1];
		  debug('.',lab); end;
	          debugln();
	       if (maxcompl >= VVL_Cpl5) or (maxadj >= VVL_Adj6) then
		  debugln(' !!!! maxcompl:',maxcompl:3,' maxadj:',maxadj:3);


	       xc := VVL_Cpl1 - 1; found := false;                         { find position Compl }
	       repeat
		  xc := xc + 1;
		  lab := CompareLV[xc,1];
		  i := VVL_Cpl1 - 1;
		  repeat
		     i := i + 1;
		     labn := LineVal[i,1];
		  until (i= VVL_Cpl5)
		  or ((lab = labn) and (lab <> '     ') );
		  if ((lab = labn) and (lab <> '     ') )
		     then found := true;
		  if LineVal[i,2] = ' <Aj>' then
		     found := false;
		  { in case of not-search }
	       until (xc = VVL_Cpl5) or (lab = '     ') or (found);
	       if found then
	       begin
		  debugln('found in pos',xc:3,'nr.',i:3);
		  if LineVal[i,2] = ' ....' then
		     LineVal[i,2] := ' <Co>';
		  CompareLV[xc,2] := LineVal[i,2]; { function present}
		  {find same position in PhrPosList}
		  x := 0;
		  repeat
		     x := x + 1
		  until (PhrPosList[x] = i) or (x=MAX_PATMS);  {old pos.}
		  PhrPosList[x] := xc;                  {new pos }
	       end;

	       if not found then                      { new Compl? search in Adju first}
	       begin
		  debugln(' Complement not found; I try Adjunct');
		  xc := VVL_Adj1 - 1;
		  repeat
		     xc := xc + 1;
		     lab := CompareLV[xc,1];
		     i := VVL_Cpl1 - 1;
		     repeat
			i := i + 1;
			labn := LineVal[i,1];
		     until (i= VVL_Cpl5)
		     or ((lab = labn) and (LineVal[i,2] <> '     ')
			 and (lab <> '     ') );
		     if ((lab = labn) and (lab <> '     '))
			then
			found := true;
		     if LineVal[i,2] = ' <Co>' then
			found := false;
		     { in case of not-search }
		  until (xc = VVL_Adj6) or (lab = '     ') or (found);
		  if found then
		  begin
		     debugln('found in pos',xc:3,'nr.',i:3);
		     if LineVal[i,2] = ' ....' then
			LineVal[i,2] := ' <Aj>';
		     CompareLV[xc,2] := LineVal[i,2]; {present}
		     {find same position in PhrPosList}
		     x := 0; repeat x := x + 1
		     until (PhrPosList[x] = i) or (x=MAX_PATMS);  {old pos.}
		     PhrPosList[x] := xc;                  {new pos }
		  end
	       end;
	       if not found then               { assume it is/should be a Compl}
	       begin
		  debugln('also not found with Adjuncts');
		  xc := VVL_Cpl1 - 1;
		  repeat
		     xc := xc + 1;
		     lab := LineVal[xc,2];
		     labn := LineVal[xc,1];
		     debugln(labn,'= {',lab, '}');
		     if (lab[2] in ['<', '.']) and (labn <> '     ') {new Compl}
			then
		     begin
			if lab[2] = '.' then lab := ' <Co>';
			CompareLV[maxcompl,1] := LineVal[xc,1];
			CompareLV[maxcompl,2] := lab;
			Constline[maxcompl] := '+';
			maxcompl := maxcompl + 1;
			debugln(' new complement:',labn, lab);
		     end;
		  until xc = VVL_Cpl5;                   {put new ones into CompareLV }
		  CheckVerbVal; writeln(' CheckVV after adjustements');
	       end;
	       xc := VVL_Cpl1 - 1;                                  { change position }
	       repeat
		  xc := xc + 1;lab := CompareLV[xc,1];
		  LineVal[xc,1] := '     ';
		  LineVal[xc,2] := '     ';
		  Constline[xc] := '.';
		  if CompareLV[xc,2] <> '     '
		     then
		  begin
		     LineVal[xc,1] := lab;
		     LineVal[xc,2] := CompareLV[xc,2];
		     Constline[xc] := '+';
		  end;
	       until xc = VVL_Cpl5;

	       xc := VVL_Adj1 - 1;
	       found := false;                          { find position Adju }
	       repeat
		  xc := xc + 1;
		  lab := CompareLV[xc,1];
		  i := VVL_Adj1 - 1;
		  repeat
		     i := i + 1;
		     labn := LineVal[i,1];
		  until (i= VVL_Adj6) or ((lab = labn) and (lab <> '     ') );
		  if (lab = labn) and (lab <> '     ') then
		  begin
		     CompareLV[xc,2] := LineVal[i,2];   {present}
		     LineVal[i,2] := '     ';
		     {find same position in PhrPosList}
		     x := 0; repeat x := x + 1
		     until (PhrPosList[x] = i) or (x=MAX_PATMS);  {old pos.}
		     PhrPosList[x] := xc;                  {new pos }
		     found := true;
		     debugln('const.',labn,' is adjunct')
		  end
	       until (xc = VVL_Adj6) or (found);
	       xc := VVL_Adj1 - 1;
	       repeat
		  xc := xc + 1;                                {new Adju }
		  labn := LineVal[xc,1];
		  lab := LineVal[xc,2]; if lab[2] = '<'
		     then
		  begin
		     CompareLV[maxadj,1] := LineVal[xc,1];
		     CompareLV[maxadj,2] := lab;
		     maxadj := maxadj + 1;
		     writeln(' new adjunct:',labn, lab);
		  end;
	       until xc = VVL_Adj6;               {put new ones into CompareLV }

	       xc := VVL_Adj1 - 1;                                  { change position }
	       repeat
		  xc := xc + 1;
		  lab := CompareLV[xc,1];
		  LineVal[xc,1] := '     ';  { make empty }
		  LineVal[xc,2] := '     ';
		  Constline[xc] := '.';
		  if CompareLV[xc,2] <> '     '
		     then
		  begin
		     LineVal[xc,1] := lab;
		     LineVal[xc,2] := CompareLV[xc,2];
		     Constline[xc] := '+';
		  end;
	       until xc = VVL_Adj6;
	       writeln;
	       debugln('Pattern of line adjusted:');
	       for i := 1 to MAXcolV do
	       begin
		  lab := LineVal[i,1];
		  write(Constline[i],lab);
	       end;
	       writeln;
	       for i := 1 to MAXcolV do
	       begin
		  lab := LineVal[i,2];
		  write('.',lab);
	       end;
	       writeln;

	       CompareVerbVal(verbline, LineVal, Constline, pattern);
	    end
	    else
	    begin
	       debugln(' Verb ',lab, 'found in line:',verbline:4);
	       pattern := false;
	    end;
	 end;
	 if not hitv then
	    writeln(' Verb not found in verb list')
	 else if not hitr then writeln(' Rootf not found in verb list');
	 if (hitv = false) or (hitr = false) or (pattern = false) then
	 begin
	    i := 0;
	    labn := LineVal[VVL_lex,1];
	    k1 := labn[1];
	    labn2 := LineVal[VVL_Root,1];            {rootf}

	    if not hitv then                       {VERB UNknown}
	    begin
	       repeat
		  i := i + 1;
		  lab := VerbVal[i, VVL_lex,1];
		  lab2 := VerbVal[i, VVL_Root,1];          {rootf}
		  k2 := lab[1];
	       until (AbeforeB(k1, k2)) or             {count until next Verb}
	       (  (k1 = k2) and (AbeforeB(labn[2] ,lab[2]))   ) or
	       (  (k1 = k2) and (labn[2] = lab[2]) and (AbeforeB(labn[3] ,lab[3]))  )  or
	       (i = NumberOfVerbValPat);
	    end else if (hitv) and (hitr) then               {VERB known; rootf know}
	    begin
	       repeat
		  i := i + 1;
		  lab := VerbVal[i, VVL_lex,1];
		  lab2 := VerbVal[i, VVL_Root,1]           {rootf}
	       until (lab = labn) and (lab2 = labn2);
	       repeat
		  i := i + 1;
		  lab := VerbVal[i, VVL_lex,1];
		  lab2 := VerbVal[i, VVL_Root,1]           {rootf}
	       until (lab <> labn) or (lab2 <> labn2) or (i = NumberOfVerbValPat);
	    end else if (hitv) and not hitr then          {VERB known; rootf UNknown}
	    begin
	       repeat
		  i := i + 1;
		  lab := VerbVal[i, VVL_lex,1]
	       until (lab = labn);
	       repeat
		  i := i + 1;                      {count until next Verb}
		  lab := VerbVal[i, VVL_lex,1]
	       until (lab <> labn) or (i = NumberOfVerbValPat);
	    end;

	    if not search then
	    begin
	       if i = NumberOfVerbValPat
		  then writeln(' insert at end of file, after line:',i:5);
	       if LineVal[VVL_Root,1] = 'funny' then
		  writeln(' Rootf = FUNNY')
	       else
		  InsertVerbVal(i, NumberOfVerbValPat, LineVal, Constline);
	       writeln(' inserted before line:',i:5);
	    end;
	 end;
      end else
      begin
	 writeln(' verbless clause ');
      end;
   end;
   for i := startphr to stopphr do
      write(Parselabel(Parsing(i)));
   writeln(' end-of-FindParsing');

end;


function AltDeterm(p: Vs_PhraseType_IndexType; v0, v1: integer): integer;
(* Return alternative value in case of a determined phrase *)
begin
   if AnalysisList[PAtomWordLast(p), DETERMINATION] = 2 then
      AltDeterm := v1
   else
      AltDeterm := v0
end;


function Guess_AdjP_Function(c: integer; p: integer): integer;
var
   v: integer;
begin
   assert((c > 0) and (p > 0));
   v := CAtomPAtomByType(c, VP);
   if (v = 0) or Copula(PAtomWordLast(v)) then
      Guess_AdjP_Function := AltUnique(c, PreCSet, PreC, Unkn)
   else
      Guess_AdjP_Function := PrAd
end;


function VC_Guess_NP(c: integer; p: integer): integer;
var
   v: integer;
begin
   v := CAtomPAtomByType(c, VP);
   if not PAtomAgree(v, p) then
      VC_Guess_NP := AltUnique(c, ObjcSet, Objc, Unkn + 1)
   else
      if PAtomDetermined(p) then
	 VC_Guess_NP :=
	    AltUnique(c, SubjSet, Subj,
	    AltUnique(c, ObjcSet, Objc, Unkn + 1))
      else
	 VC_Guess_NP :=
	    AltUnique(c, ObjcSet, Objc,
	    AltUnique(c, SubjSet, Subj, Unkn + 1))
end;


function NC_Guess_NP(c: integer; p: integer): integer;
var
   r: integer;		(* result *)
begin
   if CAtomPAtomFirst(c) = CAtomPAtomLast(c) then
      r := AltDeterm(p, PreC, Voct)
   else
      r := AltUnique(c, SubjSet, Subj,
	   AltUnique(c, PreCSet, PreC, Spec));
   if r = Spec then
      Distance(p) := PaR_Dis2Cod(-1, 'P');
   NC_Guess_NP := r
end;


function Guess_NP_Function(c: integer; p: integer): integer;
var
   v: integer;
   w: integer;
begin
   v := CAtomPAtomByType(c, VP);
   if v = 0 then
      Guess_NP_Function := NC_Guess_NP(c, p)
   else begin
      w := PAtomWordLast(v);
      if Copula(w) then
	 Guess_NP_Function := NC_Guess_NP(c, p)
      else
	 if not Participle(w) then
	    Guess_NP_Function := VC_Guess_NP(c, p)
	 else
	    if p < v then
	       Guess_NP_Function :=
		  AltUnique(c, SubjSet, Subj,
		  AltUnique(c, ObjcSet, Objc, Unkn + 1))
	    else
	       Guess_NP_Function :=
		  AltUnique(c, ObjcSet, Objc,
		  AltUnique(c, SubjSet, Subj, Unkn + 1))
   end
end;


function Guess_PP_Function(c: integer; p: integer): integer;
begin
   assert(p > 0);
   if CAtomPAtomByType(c, VP) <> 0 then
      Guess_PP_Function := AltUnique(c, CmplSet, Cmpl, Unkn + 1)
   else
      Guess_PP_Function := AltUnique(c, PreCSet, PreC, Unkn + 1)
end;


function Guess_VP_Function(c: integer; p: integer): integer;
(* Guess the parsing code for a VP with a non-finite verb *)
begin
   case AnalysisList[PAtomWordLast(p), KO_VT] of
      VT_InfC:
	 Guess_VP_Function :=
	    AltSuffix(PAtomWordLast(p),
	       AltUnique(c, PredSet, Pred, Unkn),
	       AltUnique(c, ObjcSet, PreO,
	       AltUnique(c, SubjSet, PreS, Unkn)));
      VT_InfA:
	 Guess_VP_Function := AltUnique(c, PredSet, Pred, Unkn);
      VT_PtcA:
	 Guess_VP_Function :=
	    AltSuffix(PAtomWordLast(p),
	       AltUnique(c, PreCSet, PreC, Unkn), PtcO);
      VT_PtcP:
	 Guess_VP_Function := AltUnique(c, PreCSet, PreC, Unkn);
   end
end;


function Attempt_Link(c: integer; p: Vs_PhraseType_IndexType): integer;
const
   d = -2;	(* default distance *)
var
   possible: boolean;
begin
   possible :=
      (CAtomPAtomFirst(c) <= p + d) and (p + 1 <= CAtomPAtomLast(c)) and
      (PAtomType(p + d) in [NP, PrNP, PP]) and
      (PAtomType(p + 1) in [NP, PrNP, PP]);
   if not possible then
      Attempt_Link := Conj
   else begin
      Distance(p + 1) := PaR_Dis2Cod(d - 1, 'P');
      Parsing(p + 1) := Para;
      Distance(p) := PaR_Dis2Cod(d, 'P');
      Attempt_Link := Link
   end
end;


function ParseByPhraseType(c: integer; p: Vs_PhraseType_IndexType): integer;
(* First pass of SupplementParsing. The phrase atoms are parsed
   sequentially, so only assign those of which we can be pretty sure.
   This way the second pass can be more successful. *)
begin
   case PAtomType(p) of
      AdjP:
	 ParseByPhraseType := AltUnique(c, PreCSet, PreC, Unkn);
      AdvP:
	 ParseByPhraseType := PAtomAdjunct(c, p);
      CP:
	 if Relative(PAtomWordFirst(p)) then
	    ParseByPhraseType := Rela
	 else
	    ParseByPhraseType := Attempt_Link(c, p);
      DPrP:
	 ParseByPhraseType := AltUnique(c, SubjSet, Subj, Unkn);
      IPrP:
	 ParseByPhraseType := Unkn;
      InjP:
	 ParseByPhraseType := AltSuffix(PAtomWordLast(p), Intj, IntS);
      InrP:
	 ParseByPhraseType := AltSuffix(PAtomWordLast(p), Ques, PrcS);
      NP:
	 if Copula(PAtomWordLast(p)) then
	    ParseByPhraseType := AltSuffix(PAtomWordLast(p), Exst, ExsS)
	 else
	    ParseByPhraseType := Unkn;
      NegP:
	 if Copula(PAtomWordLast(p)) then
	    ParseByPhraseType := AltSuffix(PAtomWordLast(p), NCop, NCoS)
	 else
	    ParseByPhraseType := Nega;
      PP:
	 if ObjectMarker(PAtomWordFirst(p)) then
	    ParseByPhraseType := Objc
	 else
	    ParseByPhraseType := PAtomSupplementary(c, p);
      PPrP:
	 if Enclitic(PAtomWordLast(p)) then
	    ParseByPhraseType := AltUnique(c, ObjcSet, Objc, Unkn)
	 else
	    ParseByPhraseType := AltUnique(c, SubjSet, Subj, Unkn);
      PrNP:
	 if CAtomPAtomFirst(c) = CAtomPAtomLast(c) then
	    ParseByPhraseType := Voct
	 else
	    ParseByPhraseType := AltUnique(c, SubjSet, Subj, Unkn);
      VP:
	 if FiniteVerb(PAtomWordLast(p)) then
	    ParseByPhraseType := AltSuffix(PAtomWordLast(p), Pred, PreO)
	 else
	    ParseByPhraseType := Unkn
   end
end;


function ParseByGuessWork(c: integer; p: Vs_PhraseType_IndexType): integer;
(* Second pass of SupplementParsing *)
begin
   (* The missing cases have been assigned in the first pass *)
   case PAtomType(p) of
      AdjP:
	 ParseByGuessWork := Guess_AdjP_Function(c, p);
      DPrP:
	 ParseByGuessWork := Guess_NP_Function(c, p);
      IPrP:
	 ParseByGuessWork := Guess_NP_Function(c, p);
      NP:
	 ParseByGuessWork := Guess_NP_Function(c, p);
      PP:
	 ParseByGuessWork := Guess_PP_Function(c, p);
      PPrP:
	 ParseByGuessWork := Guess_NP_Function(c, p);
      PrNP:
	 ParseByGuessWork := Guess_NP_Function(c, p);
      VP:
	 ParseByGuessWork := Guess_VP_Function(c, p)
   end
end;


procedure SupplementParsing(c: integer);
var
   p: integer;
begin
   (* Setup: determine the predicate *)
   p := CAtomPAtomByType(c, VP);
   if p <> 0 then begin
      if not PAtomParsed(p) then
	 Parsing(p) := ParseByPhraseType(c, p);
      if not PAtomParsed(p) then
	 Parsing(p) := ParseByGuessWork(c, p)
   end;
   (* First pass: constituents by phrase type *)
   for p := CAtomPAtomFirst(c) to CAtomPAtomLast(c) do
      if not PAtomParsed(p) then
	 if StartOfClauseResolver[PHRASE, p, 0] >= 0 then
	    Parsing(p) := ParseByPhraseType(c, p)
	 else begin
	    Parsing(p) := Appo;
	    Distance(p) := PaR_Dis2Cod(-1, 'P')
	 end;
   (* Second pass: we can use the constituents of the first pass *)
   for p := CAtomPAtomFirst(c) to CAtomPAtomLast(c) do
      if not PAtomParsed(p) then
	 Parsing(p) := ParseByGuessWork(c, p);
   (* Third pass: fill in possible adjuncts left from second pass *)
   for p := CAtomPAtomFirst(c) to CAtomPAtomLast(c) do
      if Parsing(p) = Unkn + 1 then
	 Parsing(p) := PAtomAdjunct(c, p)
end;


procedure SupplementVerse;
(* Parse all the Unkn in the verse *)
var
   c: integer;
begin
   for c := 1 to VerseCAtomCount do
      SupplementParsing(c)
end;


procedure ChangePhrase(wrdnr, origfirstw, origlastw: integer;
   var maxphr: integer);
var
   p,q,r	 : integer;
begin
   if wrdnr > origlastw then    { new phrase is larger }
   begin
      WordSetPhraseType(origfirstw, wrdnr);
      WordSetDetermination(origfirstw, wrdnr);

      {adapt/delete number of phrases }
      q := PAtomByWord(origlastw);
      p := q - 1;
      repeat
	 p := p + 1;
	 Parsing(p) := Unkn
      until (StartOfClauseResolver[LAST_WORD, p + 1, 0] >= wrdnr) or (p>= maxphr);
      r := p - q;
      r := r + 1;
      writeln(q,p,r, maxphr);
      StartOfClauseResolver[CLAUSE_MARKS, p + 1, 0] := StartOfClauseResolver[CLAUSE_MARKS, q, 0];
      PhraseInfoMove(p + 1, -r);
      writeln('OLD maxphr', maxphr:3);
      maxphr := maxphr - r;
      writeln('NEW maxphr', maxphr:3);
      StartOfClauseResolver[CLAUSE_MARKS, maxphr + 1, 0] := START_CLAUSE;
      writeln(q,p,r, maxphr);

   end else if wrdnr < origlastw then    { new phrase is shorter}
   begin
      WordSetPhraseType(origfirstw, wrdnr);
      WordSetDetermination(origfirstw, wrdnr);
      WordSetPhraseType(wrdnr + 1, origlastw);
      WordSetDetermination(wrdnr + 1, origlastw);

      {adapt/insert number of phrases }
      p := maxphr + 1;
      q := PAtomByWord(origlastw);
      PhraseInfoMove(q, 1);
      StartOfClauseResolver[PHRASE   , q + 1, 0] := AnalysisList[origlastw, PHRASE_TYPE];
      StartOfClauseResolver[PHRASE   , q, 0] := AnalysisList[wrdnr, PHRASE_TYPE];
      StartOfClauseResolver[LAST_WORD, q, 0] := wrdnr;
      StartOfClauseResolver[CLAUSE_MARKS,q,0] := StartOfClauseResolver[CLAUSE_MARKS,q + 1,0];
      StartOfClauseResolver[CLAUSE_MARKS,q + 1,0] := 0;
      Parsing(q) := Unkn;
      maxphr := maxphr + 1;
      StartOfClauseResolver[CLAUSE_MARKS, maxphr + 1, 0] := START_CLAUSE;
   end else
   begin
      writeln(' Your proposal is equal to the present phrase division!');
      writeln(' No changes will be made.');
   end;

end;

procedure AdaptPhrases(var startphr, stopphr, maxphr: integer);
var
   firstphrnr, phrnr		  : integer;
   verse, firstword, firstPHRword : integer;
   lastPHRword, lastword, wrdnr	  : integer;
   adaptation, exist_mark	  : boolean;

begin
   adaptation := false;
   if startphr = 1 then
      firstword := 1
   else
      firstword := StartOfClauseResolver[LAST_WORD, startphr-1, 0] + 1;
   lastword := StartOfClauseResolver[LAST_WORD, stopphr, 0];
   wrdnr := firstword - 1;
   verse := 1;
   phrnr := 0;
   repeat
      phrnr := phrnr + 1;
      if StartOfClauseResolver[CLAUSE_MARKS, phrnr, 0] = 99 then
	 verse := verse + 1
      until phrnr > startphr;
   phrnr := startphr - 1;
   repeat
      phrnr := phrnr + 1;
      firstPHRword := StartOfClauseResolver[LAST_WORD, phrnr-1, 0] + 1;
      lastPHRword := StartOfClauseResolver[LAST_WORD, phrnr, 0];
      wrdnr := lastPHRword;
      if (PAtomType(phrnr) = CP)	(* "W" between phrases *)
	 and (LexemeList[StartOfClauseResolver[LAST_WORD, phrnr-1, 0] + 1] = 'W   ')
	 and (phrnr > startphr) and (phrnr < stopphr) then
      begin
	 writeln(' trying adaptations of VerseLine:',verse:4);
	 writeln(StartOfClauseResolver[PARSE, phrnr-1,0], StartOfClauseResolver[PARSE, phrnr + 1,0]);
	 writeln(StartOfClauseResolver[PHRASE, phrnr-1,0], StartOfClauseResolver[PHRASE, phrnr + 1,0]);
	 writeln(LexemeList[StartOfClauseResolver[LAST_WORD, phrnr-2, 0] + 1]);
	 writeln(LexemeList[StartOfClauseResolver[LAST_WORD, phrnr, 0] + 1]);
	 writeln(AnalysisList[StartOfClauseResolver[LAST_WORD, phrnr-1, 0],KO_PRS],' sfx');
	 writeln(AnalysisList[StartOfClauseResolver[LAST_WORD, phrnr + 1, 0],KO_PRS],' sfx');
	 if ((StartOfClauseResolver[PARSE, phrnr-1,0] =                   { identical parsing }
	     StartOfClauseResolver[PARSE, phrnr + 1,0])
	     and (StartOfClauseResolver[PHRASE, phrnr-1,0] > 0) )  { no app }
	    and
	    ((StartOfClauseResolver[PHRASE, phrnr-1,0] =	{ identical PHR type }
	     StartOfClauseResolver[PHRASE, phrnr + 1,0])
	     and
	     (AnalysisList[StartOfClauseResolver[LAST_WORD, phrnr-1, 0],KO_PRS] =
	     AnalysisList[StartOfClauseResolver[LAST_WORD, phrnr + 1, 0],KO_PRS]) {ident sfx}
	     )
	    then
	 begin
	    if ( (StartOfClauseResolver[PHRASE, phrnr-1,0] = 5) and           {prep}
		(LexemeList[StartOfClauseResolver[LAST_WORD, phrnr-2, 0] + 1] =
		LexemeList[StartOfClauseResolver[LAST_WORD, phrnr, 0] + 1])
		)
	       or (StartOfClauseResolver[PHRASE, phrnr-1,0] <> 5)
	       then
	    begin
	       writeln(' CONJ in phrase:', phrnr:3);
	       writeln(' its first word:', firstPHRword);
	       writeln(' its last  word:',  lastPHRword);
	       firstphrnr := phrnr-1;         { phrase before W }
	       firstPHRword := StartOfClauseResolver[LAST_WORD, firstphrnr-1, 0] + 1;
	       writeln(' first word previous phr:', firstPHRword);
	       if StartOfClauseResolver[CLAUSE_MARKS, firstphrnr, 0] = 99 then
		  exist_mark := true
	       else
		  exist_mark := false;
	       writeln(' clause mark:',StartOfClauseResolver[CLAUSE_MARKS, firstphrnr, 0]);
	       lastPHRword := StartOfClauseResolver[LAST_WORD, firstphrnr, 0];
	       writeln(' last  word previous phr:',  lastPHRword);
	       wrdnr := StartOfClauseResolver[LAST_WORD, phrnr + 1, 0];  { phrase after W }
	       writeln('proposal phrase until wordnr:',wrdnr:3);

	       if wrdnr <> lastPHRword then begin
		  ChangePhrase(wrdnr, firstPHRword, lastPHRword, maxphr);
		  Changed := true
	       end;

	       writeln('phrnr:',phrnr:3);
	       phrnr := phrnr - 1;
	       writeln('phrnr:',phrnr:3);

	       stopphr := stopphr - 2;
	       lastPHRword := StartOfClauseResolver[LAST_WORD, phrnr, 0];
	       writeln(' its first word:', firstPHRword);
	       writeln(' clause mark:',StartOfClauseResolver[CLAUSE_MARKS, phrnr, 0]);
	       writeln('something wrong with clause marks; will try to repair');
	       readln;
	       if exist_mark then
		  StartOfClauseResolver[CLAUSE_MARKS, phrnr, 0] := 99;
	       writeln(' its last  word:',  lastPHRword);
	       writeln(' new stopphr:',  stopphr);
	       adaptation := true;
	    end else
	       writeln('Attempt unsuccessful: different prepositions');
	 end else
	    writeln('Attempt unsuccessful');
      end
   until phrnr >= stopphr;
   if adaptation then
   begin
      writeln('End_of_AdaptPhr');
      writeln('Adaptation made');
   end;
end;


procedure StartEditor(var startphr, stopphr, maxphr : integer);
var rep,
   phrnr, n	    : integer;
   firstword, firstPHRword  : integer;
   lastPHRword: integer;
   lastword, wrdnr	    : integer;
   answer		    : char;
   ok			    : boolean;

procedure ChangeColumns(firstw, lastw, startphr : integer);
var
   colnr, n,q, phrnr  : integer;
   max, min, lexnr: integer;
   finished	      : boolean;
begin
   phrnr := startphr;
   writeln; writeln(' changing columns State;  PPOSp;  PType;  Dterm ');
   writeln(' ---------------------------------------------- ');
   colnr := 0;
   finished := false;
   max := 13; min := -1;
   while not finished and ((colnr < 11) or (colnr > 14))  do
   begin
      writeln(' Please indicate what feature you need to change:');
      writeln(' 11 : State');
      writeln(' 12 : Phrase_dependent Part of Speech');
      writeln(' 13 : Phrase Type ');
      writeln(' 14 : Determination');
      writeln('  s : stop ');
      colnr := 0;

      SkipSpace(input);
      if input^ = 's' then begin
	 finished := true;
	 readln
      end else begin
	 while not ReadInteger(input, colnr) or not (colnr in [11 .. 14]) do begin
	    readln;
	    writeln(' Wrong Column Number. Please try again')
	 end;
	 readln;
	 writeln(' Column to correct is:', colnr);

	 writeln(' Which lexeme?'); lexnr := 0;
	 SkipSpace(input);
	 if input^ = 's' then begin
	    finished := true;
	    writeln(' SORRY');
	    readln
	 end else begin
	    while not ReadInteger(input, lexnr) or not (lexnr in [firstw .. lastw]) do begin
	       readln;
	       writeln(' try again')
	    end;
	    readln;
	    writeln(' Column to correct is:', colnr);
	    writeln(' lexeme to correct is:', lexnr);
	    phrnr := PAtomByWord(lexnr);
	    writeln(' PHRNR:',phrnr:3);
	    n := -1;
	    case colnr of
	      11 : begin
		      { state: 1 or 2 with nouns/adj only }
		      if AnalysisList[lexnr, NOMINAL_ENDING] = -1 then
		      begin
			 writeln(' This words takes no STATE label');
			 writeln(' chanching state label is not allowed');
			 writeln;
		      end else
		      begin
			 writeln(' values allowed: 1: constr  2: abs  0: skip');
			 { check AnalysisList[lexnr, 12 }
			 max := 2; min := 1;
			 writeln(' enter value');
			 n := 0;
		      end;
		   end;
	      12 : begin { check AnalysisList[lexnr, 1 }
		      write  ('this lexeme has an initial part of speech:');
		      writeln((AnalysisList[lexnr, 1]):4);
		      writeln(' values allowed: 0 -  13         -1: skip');
		      max := 13; min := 0;
		      writeln(' enter value');
		      n := 0;
		   end;
	      13 : begin
		      if AnalysisList[lexnr, colnr] = 0
			 then
		      begin  writeln(' PHRASE does not end with this lexeme!');
			 writeln(' changing phrase type is not allowed');
			 writeln(' if needed, change PHRASE divisions first');
			 writeln;
		      end
		      else
		      begin
			 if (AnalysisList[lexnr, colnr] < 0) and
			    (AnalysisList[lexnr, PHRASEdist] =0)
			    then
			    writeln('strange, app and no dist!');
			 writeln(' values allowed: 1 -  13          0: skip');
			 max := 13; min := 1;
			 writeln(' enter value');
			 n := 0;
		      end;
		   end;
	      14 : begin
		      if AnalysisList[lexnr, 13] = 0
			 then
		      begin  writeln(' PHRASE does not end with this lexeme!');
			 writeln(' changing determination is not allowed');
			 writeln(' if needed, change PHRASE divisions first');
		      end
		      else if not (AnalysisList[lexnr, 13] in [ 2, 3, 5, 13 ])
			 then
		      begin
			 writeln(' PHRASE is not a PP or a NP!');
			 writeln(' adding determination is not allowed');
		      end
		      else
		      begin
			 writeln(' values allowed: 1: idet  2: det  0: skip');
			 max := 2; min := 1;
			 writeln(' enter value');
			 n := 0;
		      end;
		   end;
	    end;
	    if n = -1 then
	       writeln(' skipped')
	    else begin
	       AskInteger(n);
	       if (min <= n) and (n <= max) then begin
		  if (n = 0) and (colnr in [11, 14]) then
		     q := -1
		  else
		     q := abs(n);
		  AnalysisList[lexnr, colnr] := q;
		  if colnr = 12 then begin
		     PAtomSetPhraseType(phrnr);
		     PAtomSetDetermination(phrnr)
		  end;
		  if colnr = 13 then begin
		     StartOfClauseResolver[PHRASE, phrnr, 0] := q;
		     PAtomSetDetermination(phrnr)
		  end
	       end
	    end
	 end
      end
   end
end;


procedure PrintColumns(firstw, lastw, startphr : integer);
var
   colnr,  phrnr, w : integer;
begin
   write('COLUMNS in PS                    ');
   for colnr := KO_VT to LAST_FUNCTION do
   begin
      if colnr < 11 then write(colnr:4)
      else if colnr = 11 then write(' State')
      else if colnr = 12 then write(' PPOSp')
      else if colnr = 13 then write(' PType')
      else if colnr = 14 then write(' Dterm')
      else if colnr > 15 then write(colnr:4)
      else write(colnr:6);
   end;
   writeln;
   write('                                 ');
   for colnr :=  KO_VT to 10 do write(' ---');
   for colnr := 11 to 15 do write(' -----');
   for colnr := 16 to 19 do write(' ---');
   writeln;

   w := firstw - 1;
   phrnr := startphr;
   repeat
      w := w + 1;
      if (w > firstw) and (AnalysisList[w, CLAUSE_MARKER] = 99)
	 then
      begin writeln; write('                                               ');
	 writeln('N e w   C l a u s e  a t o m '); writeln;
      end;
      write('PHR',phrnr:2,'   Lex',w:3,' ',LexemeList[w]);
      for colnr := KO_VT  to 10  do
	 write((AnalysisList[w, colnr]):4);
      for colnr := 11 to 15  do
      begin
	 if colnr = 11 then
	 begin
	    if AnalysisList[w, colnr] = 1 then write('  Cstr')
	    else if AnalysisList[w, colnr] = 2 then write('   Abs')
	    else write((AnalysisList[w, colnr]):6);
	 end else if colnr = 12 then
	 begin
	    if AnalysisList[w, colnr] = -1 then write('    ??')
	    else if AnalysisList[w, colnr] =  0 then write(' d.art')
	    else if AnalysisList[w, colnr] =  1 then write('  verb')
	    else if AnalysisList[w, colnr] =  2 then write('  noun')
	    else if AnalysisList[w, colnr] =  3 then write('  name')
	    else if AnalysisList[w, colnr] =  4 then write('   adv')
	    else if AnalysisList[w, colnr] =  5 then write('  prep')
	    else if AnalysisList[w, colnr] =  6 then write('  conj')
	    else if AnalysisList[w, colnr] =  7 then write(' pronP')
	    else if AnalysisList[w, colnr] =  8 then write(' pronD')
	    else if AnalysisList[w, colnr] =  9 then write(' pronI')
	    else if AnalysisList[w, colnr] = 10 then write('  intj')
	    else if AnalysisList[w, colnr] = 11 then write('   neg')
	    else if AnalysisList[w, colnr] = 12 then write(' quest')
	    else if AnalysisList[w, colnr] = 13 then write('   adj') else
	 end else if colnr = 13 then
	 begin
	    if AnalysisList[w, colnr] = -1 then write('    ??')
	    else if AnalysisList[w, colnr] <  0 then write(' appos')
	    else if AnalysisList[w, colnr] =  0 then write('     |')
	    else if AnalysisList[w, colnr] =  1 then write('    VP')
	    else if AnalysisList[w, colnr] =  2 then write('    NP')
	    else if AnalysisList[w, colnr] =  3 then write('  PrNP')
	    else if AnalysisList[w, colnr] =  4 then write('  AdvP')
	    else if AnalysisList[w, colnr] =  5 then write('    PP')
	    else if AnalysisList[w, colnr] =  6 then write('    CP')
	    else if AnalysisList[w, colnr] =  7 then write(' NPppr')
	    else if AnalysisList[w, colnr] =  8 then write(' NPdpr')
	    else if AnalysisList[w, colnr] =  9 then write(' NPipr')
	    else if AnalysisList[w, colnr] = 10 then write('  InjP')
	    else if AnalysisList[w, colnr] = 11 then write('  NegP')
	    else if AnalysisList[w, colnr] = 12 then write('  QstP')
	    else if AnalysisList[w, colnr] = 13 then write('  AdjP')
	 end else if colnr = 14 then
	 begin
	    if AnalysisList[w, colnr] = 1 then write(' Indet')
	    else if AnalysisList[w, colnr] = 2 then write('   Det')
	    else write((AnalysisList[w, colnr]):6);
	 end else
	    write((AnalysisList[w, colnr]):6);
      end;
      for colnr := 16 to LAST_FUNCTION-1 do
	 write((AnalysisList[w, colnr]):4);
      writeln;
      if AnalysisList[w, PHRASE_TYPE] <> 0 then
      begin
	 phrnr := phrnr + 1;
	 writeln;
      end
   until w>= lastw;
end;

begin
   { will print AnalysisList on the screen and ask for changes }
   { prints only from startphr to stopphr (one clause-atom }
   { changes allowed: split or join phrase-atoms;
    p := p + 1;
    split or join clause-atoms;
demands:correct "state", "det", "phrase_type", internal phrase parsing;
    redo xxx.ct4; xxx.ps4.
    xxx.ct4.p and xxx.ps4.p are produced by this programme. }
   writeln;
   writeln(' Sorry, the Editor is still under construction. Stay cool!');
   writeln; rep := 0;
   ok := false;

   while not ok do
   begin
      if startphr = 1 then
	 firstword := 1
      else
	 firstword := StartOfClauseResolver[LAST_WORD, startphr-1, 0] + 1;
      lastword := StartOfClauseResolver[LAST_WORD, stopphr, 0];
      wrdnr := firstword - 1;
      phrnr := startphr;


      { CHANGES }
      answer := 'y'; rep := 0;
      while answer = 'y' do
      begin
	 PrintColumns(firstword, lastword, startphr);
	 if rep > 0 then
	 writeln(' Do you need to change MORE PHRASE divisions?  [n(o) / y(es) ]') else
	 writeln(' Do you need to change the PHRASE divisions?  [n(o) / y(es) ]');
	 rep := rep + 1;
	 repeat
	    readln(answer)
	 until answer in ['n', 'y'];
	 if answer = 'y' then
	 begin
	    repeat
	       writeln(' What is the number of the first INcorrect Phrase-atom?');
	       AskInteger(n);
	       phrnr := n;
	       writeln(' First incorrect Phrase:', phrnr);
	       if phrnr = 1 then firstPHRword := 1 else
	       firstPHRword := StartOfClauseResolver[LAST_WORD, phrnr-1, 0] + 1;
	       lastPHRword := StartOfClauseResolver[LAST_WORD, phrnr, 0];
	       writeln(' its first word:', firstPHRword);
	       writeln(' its last  word:',  lastPHRword);
	       { check startphr - stopphr }
	       if (n > stopphr) or (n < startphr) then
		  writeln(' NOT beyond this clause_atom!');
	    until (phrnr <= stopphr) and (phrnr >= startphr);
	    repeat
	       writeln(' What should be the number of the LAST Lexeme of this Phrase-atom?');
	       AskInteger(n);
	       wrdnr := n;
	       if n < firstPHRword then
		  writeln(' NOT before first word of phrase_atom!');
	       if n > lastword then
		  writeln(' NOT beyond this clause_atom!');
	    until (n <= lastword) and (n >= firstPHRword);
	    writeln(' Last Word of Phrase:   ', wrdnr);
	    { check word nr firstword - lastword }
	    if wrdnr <> lastPHRword then begin
	       ChangePhrase(wrdnr, firstPHRword, lastPHRword, maxphr);
	       stopphr := PAtomByWord(lastword);
	       Changed := true
	    end;
	    PrintColumns(firstword, lastword, startphr);
	    { make corrections to phrases cf. corrps3 }
	    { phrase type ok?'}
	    answer := 'y';
	    while answer <> 'n' do
	    begin
	       writeln(' Do you need to change other features? [ State, Part_of_Sp, Phrase_Type, Det.?]');
	       repeat readln(answer) until answer in ['n', 'y'];
	       if answer = 'y' then
	       begin
		  ChangeColumns(firstword, lastword, startphr);
		  PrintColumns(firstword, lastword, startphr);
	       end;
	    end;
	    answer := 'y';
	 end;

      end;

      answer := 'y'; rep := 0;
      while answer <> 'n' do
      begin
	 PrintColumns(firstword, lastword, startphr);
	 if rep > 0 then
	 writeln(' Do you need to change MORE CLAUSE division?   [n(o) / s(plit) / j(oin) ]') else
	 writeln(' Do you need to change the CLAUSE division?   [n(o) / s(plit) / j(oin) ]');
	 rep := rep + 1;
	 repeat
	    readln(answer);
	    if not (answer in ['n','s','j']) then
	       writeln('Please select: n(o) / s(plit) or j(oin) ');
	 until answer in ['n', 's', 'j' ];
	 if answer = 'j' then
	 begin
	    writeln(' Join this clause_atom to the PREVIOUS one? [y / n]');
	    repeat readln(answer) until answer in ['n', 'y'];
	    if answer = 'y' then
	    begin
	       StartOfClauseResolver[CLAUSE_MARKS, startphr, 0] := 0;
	       AnalysisList[firstword, LAST_FUNCTION] := -1;
	    end
	    else if answer = 'n' then
	    begin
	       writeln(' So I will join it to the NEXT one.');
	       StartOfClauseResolver[CLAUSE_MARKS, stopphr + 1, 0] := 0;
	       AnalysisList[lastword + 1, LAST_FUNCTION] := -1;
	    end;
	    Changed := true; answer := 'y';
	 end else if answer = 's' then begin
	    repeat
	       writeln(' What is the NUMBER of the phrase_atom where you START a new clause_atom?');
	       AskInteger(phrnr);
	    until (startphr < phrnr) and (phrnr <= stopphr);
	    StartOfClauseResolver[CLAUSE_MARKS, phrnr, 0] := 99;
	    AnalysisList[StartOfClauseResolver[LAST_WORD, phrnr-1, 0] + 1,LAST_FUNCTION] := 99;
	    Changed := true; answer := 'y';
	 end else if answer = 'n' then
	    ok := true;
	 writeln;
      end;
   end;
end;	(* StartEditor *)


function AskDistanceToPhraseHead: integer;
const
   MYSTDIST = 19;
var
   n: integer;
   ok: boolean;
begin
   writeln('Enter distance to the mother counted in phrase atoms.');
   repeat
      write('Negative number between ', -MYSTDIST:1, ' and -1: ');
      ok := ReadInteger(input, n) and (-MYSTDIST <= n) and (n < 0);
      readln
   until ok;
   AskDistanceToPhraseHead := n
end;


procedure ConnectPAtom(p, d: integer);
(* Connect phrase atom with index [p] to its mother at distance d *)
const
   Q = 'Does the daughter refer to the entire phrase?';
var
   m: integer;		(* size of mother in words *)
   u: char;		(* distance unit *)
begin
   u := 'P';
   if (p + d < 1) then
      writeln('Mother outside this clause atom.')
   else begin
      m := StartOfClauseResolver[LAST_WORD, p + d, 0] -
	   StartOfClauseResolver[LAST_WORD, p + d - 1, 0];
      if (m > 1) and not YesNoQuestion(Q) then begin
	 u := 'W';
	 d := StartOfClauseResolver[LAST_WORD, p + d, 0] -
	      StartOfClauseResolver[LAST_WORD, p, 0];
	 writeln('Found mother ', -d:1, ' words back.')
      end
   end;
   Distance(p) := PaR_Dis2Cod(d, u)
end;


function AssignCopula(p, w: integer): integer;
(* Return the appropriate value from CopuSet that should be assigned to
   phrase p featuring word w *)
begin
   if not Copula(w) then
      AssignCopula := Unkn
   else begin
      if StartOfClauseResolver[PHRASE, p, 0] <> NegP then
	 AssignCopula := AltSuffix(w, Exst, ExsS)
      else
	 AssignCopula := AltSuffix(w, NCop, NCoS)
   end
end;


function AssignPredicate(p, w: integer): integer;
(* Return the appropriate value from PredSet + PreCSet that should be
   assigned to phrase p featuring word w *)
begin
   if StartOfClauseResolver[PHRASE, p, 0] <> VP then
      AssignPredicate := PreC
   else if InfinitiveConstruct(w) and PronSuffix(w) and
      not YesNoQuestion('Is the suffix referring to an Object?')
   then
      AssignPredicate := PreS
   else if Participle(w) then
      AssignPredicate := AltSuffix(w, PreC, PtcO)
   else
      AssignPredicate := AltSuffix(w, Pred, PreO)
end;


function AssignSubject(p, w: integer): integer;
(* Return the appropriate value from SubjSet that should be assigned to
   phrase p featuring word w *)
begin
   if not PronSuffix(w) then 
      AssignSubject := Subj
   else 
      case StartOfClauseResolver[PHRASE, p, 0] of
	 VP:
	    AssignSubject := PreS;
	 AdvP:
	    AssignSubject := ModS;
	 InjP:
	    AssignSubject := IntS;
	 otherwise
	    if not Copula(w) then 
	       AssignSubject := Subj
	    else begin
	       if StartOfClauseResolver[PHRASE, p, 0] <> NegP then 
		  AssignSubject := ExsS
	       else 
		  AssignSubject := NCoS
	    end
      end
end;


function Assign_Frnt(p: integer): integer;
(* For phrase p, return the parsing code for Fronted Element and
   establish the distance to the phrase atom with the resumption *)
var
   d: integer;	(* distance in phrase atoms *)
begin
   d := 0;
   while (d <= 0) or (MAX_PATMS - p < d) do begin
      write('Give the distance in phrase atoms to the resumption: ');
      AskInteger(d)
   end;
   Distance(p + d) := PaR_Dis2Cod(-d, 'P');
   Assign_Frnt := Frnt
end;


function Assign_PrAd(p: integer): integer;
(* For phrase p, return the parsing code for Predicative Adjunct and
   establish the distance to the phrase atom with its subject *)
var
   d: integer;	(* distance in phrase atoms *)
begin
   d := 0;
   while d = 0 do begin
      write('Give the distance in phrase atoms to its subject: ');
      AskInteger(d)
   end;
   Distance(p) := PaR_Dis2Cod(d, 'P');
   Assign_PrAd := PrAd
end;


procedure CorrectParsing(c: integer; var verse_line: LineType;
			 var maxphr: integer);
var
   b, e: integer;	(* begin and end of word search *)
   phrase_type_index : integer;
   dist, p	     : integer;
   parse_code	     : integer;
   partpos	     : integer;
#ifdef ARAMAIC
   HWA: integer;
#endif
   answ		     : char;
   ch		     : char;
   ok, NON	     : boolean;
   startphr: integer;
   stopphr: integer;
begin
   partpos := 0;
   startphr := CAtomPAtomFirst(c);
   stopphr := CAtomPAtomLast(c);
   ok := true; { assumes automatic parses are ok }
   writeln;
   writeln(' please check the parsings proposed');
   writeln(' for EDITING Phrase divisions or Clause divisions enter:  "e" ');

   phrase_type_index := startphr - 1;
   repeat
      phrase_type_index := phrase_type_index + 1;

      lastPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index, 0];
      if phrase_type_index = 1
	 then firstPhrLex := 1
      else
	 firstPhrLex := StartOfClauseResolver[LAST_WORD, phrase_type_index-1, 0] + 1;
      p := 0; partpos := 0;
      write(phrase_type_index:5,' " ');
      repeat
	 p := p + 1;
	 if verse_line[p] in ['-',' ','#','$']
	    then partpos := partpos + 1;
	 if (partpos>= firstPhrLex-1) and (partpos <= lastPhrLex)
	    then
	 begin
	    if verse_line[p] = '$' then write('-')
	    else if verse_line[p] = '#' then write(' ')
	    else write(verse_line[p])
	 end;
      until partpos = lastPhrLex;
      write('" ');
      if StartOfClauseResolver[PHRASE, phrase_type_index,0] < 0        {app}
	 then
      begin
	 Parsing(phrase_type_index) := Appo;
	 if Distance(phrase_type_index) = 0 { DIST unknown }
	    then
	    Distance(phrase_type_index) := -1;
	 AnalysisList[lastPhrLex,PHRASEdist] := Distance(phrase_type_index);
      end;

      if Parsing(phrase_type_index) = 0 then
	 Parsing(phrase_type_index) := Unkn;
      if Parsing(phrase_type_index) >= LEAST_PARSING_CODE then
      begin
	 (* Participles, and only participles, are PreC as a VP *)
	 if AnalysisList[lastPhrLex, PHRASE_TYPE] = VP then
	    if Participle(lastPhrLex) then begin
	       if Parsing(phrase_type_index) = Pred then
		  Parsing(phrase_type_index) := PreC
	    end else begin
	       if Parsing(phrase_type_index) = PreC then
		  Parsing(phrase_type_index) := Pred
	    end;
	 WriteLabel(Parsing(phrase_type_index), output);
	 writeln;
	 if Parsing(phrase_type_index) < Unkn then begin
	    answ := AskValidChar(' Is this parsing OK?', YNE);
	    if not (answ in YES) then
	       ok := false
	    else begin
	       ok := true;
	       if (StartOfClauseResolver[PHRASE, phrase_type_index,0] < 0) or
		  (Parsing(phrase_type_index) = Para) or
		  (Parsing(phrase_type_index) = Link) or
		  (Parsing(phrase_type_index) = Spec)
	       then begin
		  if StartOfClauseResolver[PHRASE, phrase_type_index,0] < 0
		     then
		     writeln(' <App>') else
		       begin if Parsing(phrase_type_index) = Para
			     then writeln(' <PARA>') else
		             if Parsing(phrase_type_index) = Link
			     then writeln(' <Cpar>') else
			     writeln(' <Spec>');
		       end;
		  dist := Distance(phrase_type_index);
		  if dist >= -10 then begin
		     answ := 'n';
		     writeln('   DISTance to Head of Phrase is unknown');
		  end else begin
		     write('Mother is a ');
		     if dist < -100 then
			write('word at distance ', (dist + 100):1)
		     else (* (-100 <= dist) and (dist < -10) *)
			write('phrase at distance ', (dist + 10):1);
		     write('. ');
		     if YesNoQuestion('OK?') then
			answ := 'y'
		     else
			answ := 'n'
		  end;
		  if answ = 'n' then
		  begin
		     ConnectPAtom(phrase_type_index, AskDistanceToPhraseHead);
		     AnalysisList[lastPhrLex,PHRASEdist] := Distance(phrase_type_index);
		     if AnalysisList[lastPhrLex,PHRASEdist] = 0 then
		     begin writeln('app!'); pcexit(1);
		     end;
		  end;
	       end;

	    end;
	 end else ok := false;
      end else writeln;

      if not ok then begin
	 if (Parsing(phrase_type_index) > 0) and (answ = 'e') then
	    ch := 'e'
	 else begin
	    write('  please enter parsing code of phrase number', phrase_type_index:3,' :');
	    Distance(phrase_type_index) := 0;  { no distance marker }
	    ch := AskParsingCode(NON)
	 end;

	 case ch of
	   'e' : begin
	      StartEditor(startphr, stopphr, maxphr);
	      CalcPAtomTextIndices(verse_line);
	      SupplementParsing(min(c, VerseCAtomCount));
	      phrase_type_index := startphr - 1;
	   end;

	    'P':
	       parse_code := AssignPredicate(phrase_type_index, lastPhrLex);
	   'S' :
	       parse_code := AssignSubject(phrase_type_index, lastPhrLex);
	   'V' : parse_code := Voct;
	   'F' :
	       parse_code := Assign_Frnt(phrase_type_index);
	   'j' :
	      begin
		 parse_code := Link;
		 ConnectPAtom(phrase_type_index, AskDistanceToPhraseHead);
		 AnalysisList[lastPhrLex,PHRASEdist] := Distance(phrase_type_index)
	      end;
	   'p' :
	      begin
		 parse_code := Para;
		 ConnectPAtom(phrase_type_index, AskDistanceToPhraseHead);
		 AnalysisList[lastPhrLex,PHRASEdist] := Distance(phrase_type_index)
	      end;
	   's' :
	      begin
		 parse_code := Spec;
		 ConnectPAtom(phrase_type_index, AskDistanceToPhraseHead);
		 AnalysisList[lastPhrLex,PHRASEdist] := Distance(phrase_type_index)
	      end;
	   'o' :
	      begin
		 parse_code := Sfxs;
		 b := WordPrecSuffix(StartOfClauseResolver[LAST_WORD, phrase_type_index - 1, 0]);
		 e := StartOfClauseResolver[LAST_WORD, phrase_type_index, 0];
		 if b <> 0 then
		    Distance(phrase_type_index) := PaR_Dis2Cod(b - e, 'W')
		 else begin
		    write('ERROR: No suffix found.');
		    writeln(' Setting parsing to Unkn.');
		    parse_code := Unkn
		 end
	      end;
	   'X' : parse_code := AssignCopula(phrase_type_index, lastPhrLex);
	   'O' : parse_code := Objc;
	   'C' : parse_code := Cmpl;
	   'A' : parse_code := Adju;
	   'B' : parse_code := Assign_PrAd(phrase_type_index);
	   'a' : parse_code := Appo;
	   'c' : parse_code := Supp;
	   'T' : begin
	      parse_code := Time;
	      findreason('t', NumberTimeLex, TimeRefList, firstPhrLex, lastPhrLex);
	   end;
	   'L' : begin
	      parse_code := Loca;
	      findreason('l', NumberLocLex, LocRefList, firstPhrLex, lastPhrLex);
	   end;
	   'M' :
	      if (LexemeList[lastPhrLex] <> '<WD/   ') or not PronSuffix(lastPhrLex) then
		 parse_code := Modi
	      else begin
		 parse_code := ModS;
		 writeln(' + suffix referring to a Subject ')
	      end;
	   'J' : parse_code := Conj;
	   'R' : parse_code := Rela;
	   'N' :
	      if AnalysisList[lastPhrLex, PHRASE_TYPE] = 11 then
		 parse_code := Nega
	      else
		 parse_code := Unkn;
	   'Q' : parse_code := Ques;
	   'I' : parse_code := Intj;
	   'E' : parse_code := EPPr;
	   'U' : parse_code := Unkn;
	 end;
	 if ch <> 'e' then
	    Parsing(phrase_type_index) := parse_code;
	 if parse_code = Appo then
	 begin
	    if NON then
	    begin
	       if StartOfClauseResolver[PHRASE, phrase_type_index,0] < 0 then
		  StartOfClauseResolver[PHRASE, phrase_type_index,0] :=
		  -(StartOfClauseResolver[PHRASE, phrase_type_index,0]); {undo  app}
	       parse_code := Unkn;
	       Parsing(phrase_type_index) := parse_code;
	       Distance(phrase_type_index) := 0;
	       AnalysisList[lastPhrLex,PHRASE_TYPE] := -(AnalysisList[lastPhrLex,PHRASE_TYPE]);
	       AnalysisList[lastPhrLex,PHRASEdist] := 0;
	       phrase_type_index := phrase_type_index - 1;
	    end else
	    begin
	       if StartOfClauseResolver[PHRASE, phrase_type_index,0] > 0 then
		  StartOfClauseResolver[PHRASE, phrase_type_index,0] :=
		  -(StartOfClauseResolver[PHRASE, phrase_type_index,0]);   {force app}
	       Parsing(phrase_type_index) := Appo;
	       Distance(phrase_type_index) := -1;
	       write(' <App>');
	       write('      DISTance =',Distance(phrase_type_index):3, ' ');
	       if YesNoQuestion('OK?') then
		  answ := 'y'
	       else
		  answ := 'n';
	       if answ = 'n' then
		  ConnectPAtom(phrase_type_index, AskDistanceToPhraseHead);
	       AnalysisList[lastPhrLex,PHRASEdist] := Distance(phrase_type_index);
	       if AnalysisList[lastPhrLex,PHRASEdist] = 0 then
	       begin
		  writeln('app!!!');
		  pcexit(1);
	       end;
	       AnalysisList[lastPhrLex,PHRASE_TYPE] := -(AnalysisList[lastPhrLex,PHRASE_TYPE]);
	    end;
	 end;
      end

      {end;}
   until phrase_type_index = stopphr;

   writeln (' clauses with new parsing will be inserted into the file "verbvalList" ');
end;  { CorrectParsing }


procedure ApplyInstructions(var i: InstructionsType; var old: boolean);
(* Run through the instructions and update parsing, distance and clause
   marker in StartOfClauseResolver.
   Set old to true if a known parsing code is found. *)
var
   c: integer;		(* clause atom index *)
   n: integer;		(* absolute phrase atom index *)
   p: integer;		(* relative phrase atom index *)
   w: integer;		(* last word of clause atom *)
begin
   n := 0;
   with i do
      for c := 1 to size do
	 with atm[c] do begin
	    for p := 1 to size do
	       with coco[p] do begin
		  n := n + 1;
		  old := old or (Appo <= pars) and (pars < Unkn);
		  StartOfClauseResolver[PARSE, n, 0] := pars;
		  (* AnalysisList[word_index, PHRASEdist] := dist; *)
		  Distance(n) := dist
	       end;
	    if next = EOD then
	       w := NumberOfWordsInVerse
	    else
	       w := next - 1;
	    AnalysisList[w + 1, CLAUSE_MARKER] := START_CLAUSE;
	    if size = 0 then
	       n := PAtomByWord(w);
	    StartOfClauseResolver[CLAUSE_MARKS, n + 1, 0] := START_CLAUSE
	 end
end;


procedure ReadVerse(var maxword	   : integer;
		    var maxphr	   : integer;
		    var verse_line : LineType);
var
   word_index	      : integer;
   phrase_type_index  : integer;
   i		      : integer;
   first_word	      : integer;
   start_clause_index : integer;
   function_index     : integer;
   verse_label	      : LabelType;
   ins: InstructionsType;
begin
   phrase_type_index := 0;
   rewrite(Ps3pV);
   start_clause_index := 0;
   Oldparsing := false;
   read(Text, verse_label);
   SkipSpace(Text);
   writeln;
   write(verse_label, ' ');
   i := 0;
   if not eoln(Text) then
   repeat
      i := i + 1;
      read(Text, verse_line[i]);
      if (verse_line[i] = ' ') and
	 (verse_line[i-1] = '1')
	 then verse_line[i] := '_'
      else if (verse_line[i] = ' ') and
	 (verse_line[i-1] = ' ')   { effect of Ketib WeLa Qere: Ruth 3,5,17 }
	 then
      begin
	 verse_line[i] := '_';
	 i := i + 1; verse_line[i] := ' ';
      end
   until (verse_line[i] = '*') or (eoln(Text));
   if eoln(Text) then begin i := i + 1; verse_line[i] := ' ';
			    i := i + 1; verse_line[i] := '*';
		      end;
   { writeln(' max char:', i); }

   readln(Text);
   word_index := 0;
   repeat						{ read from file Ps3p }
      word_index := word_index + 1;
      read(Ps3p, verse_label);
      SkipSpace(Ps3p);
      write(Ps3pV, verse_label, ' ');
      if word_index = 1 then
	 VerseLabel := verse_label;
      if VerseLabel = verse_label then
      begin
	 for i := 1 to LEXEME_LENGTH do
	 begin
	    read(Ps3p, LexemeList[word_index, i]);
	    write(Ps3pV, LexemeList[word_index, i]);
	 end;
	 function_index := FIRST_FUNCTION;
	 repeat
	    function_index := function_index + 1;
	    if not(eoln(Ps3p)) then
	    read(Ps3p, AnalysisList[word_index, function_index])
	    else AnalysisList[word_index, function_index] := -1;
	    write(Ps3pV, AnalysisList[word_index, function_index])
	 until function_index = LAST_FUNCTION - 1;

	 if AnalysisList[word_index, PHRASE_TYPE] <> 0 then {fill StartofClRes}
	 begin
	    phrase_type_index := phrase_type_index + 1;
	    StartOfClauseResolver[PHRASE, phrase_type_index, 0] :=
	    AnalysisList[word_index, PHRASE_TYPE];
	    StartOfClauseResolver[LAST_WORD, phrase_type_index, 0] := word_index;
	    if phrase_type_index = 1 then
	       first_word := 1
	    else
	       first_word := StartOfClauseResolver[LAST_WORD, phrase_type_index-1, 0] + 1;
	    findconditions(first_word, word_index, phrase_type_index);
	 end
	 { appositions are not skipped  }

	 { info is known in Instructions }

      end;
      writeln(Ps3pV);
      readln(Ps3p)
   until (word_index > 1) and (VerseLabel <> verse_label);
   StartOfClauseResolver[CLAUSE_MARKS, phrase_type_index + 1, 0 ] := 99;  {test}
   AnalysisList[word_index, CLAUSE_MARKER] := START_CLAUSE; (* NOTE: This is essential! *)
   word_index := word_index - 1;
   maxword := word_index;
   maxphr := phrase_type_index;

   ReadInstructions(Instructions, ins);
   i := Instructions_PSize(ins);
   if (i = 0) or (i = maxphr) then begin
      Instructions_CheckVerse(ins);
      ApplyInstructions(ins, Oldparsing)
   end else begin
      write(VerseLabel, ': ERROR: ');
      writeln('Parse labels do not match phrase atoms');
      pcexit(1)
   end;
end; { ReadVerse }


procedure WriteSimplePhrase(var f: text; n: integer;
			    var v: LineType; var s: integer);
(* Write n words from v to f, starting at character s *)
begin
   while n > 0 do begin
      assert(s <= LINE_LENGTH);
      if not (v[s] in WORD_SEPARATORS) then
	 write(f, v[s])
      else begin
	 n := n - 1;
	 if (n <> 0) or not Space(NormalSeparator(v[s])) then
	    write(f, NormalSeparator(v[s]))
      end;
      s := s + 1
   end;
end;


procedure WriteConstituent(var f: text; var p: Vs_PhraseType_IndexType;
			   var v: LineType; var s: integer);
(* Writes one constituent to f. The constituent starts at phrase atom
   number p and includes any dependent phrase atoms that follow it. The
   text of the constituent starts at v[s]. Both p and s are updated in
   the process. For recursion see ct(5) *)
var
   phlab: integer;
begin
   phlab := Parsing(p);
   WriteSimplePhrase(f, PAtomWordCount(p), v, s);
   if Space(NormalSeparator(v[s - 1])) then
      write(f, ' ');
   p := p + 1;
   if (Parsing(p) in DeptSet) and
      (StartOfClauseResolver[CLAUSE_MARKS, p, 0] <> START_CLAUSE)
   then begin
      write(f, '/ ');
      WriteConstituent(f, p, v, s)
   end;
   WriteLabel(phlab, f)
end;


procedure WriteCt4Atom(var f: text; var p: Vs_PhraseType_IndexType;
		       var v: LineType; var s: integer);
(* Writes one clause atom to f. The clause atom starts at phrase atom
   number p. The text of the clause atom starts at v[s]. Both p and s
   are updated in the process. *)
var
   i: integer;
begin
   write(f, VerseLabel);
   for i := 1 to CAtomConstCount(p) do begin
      write(f, ' [');
      WriteConstituent(f, p, v, s);
      write(f, ']')
   end;
   writeln(f)
end;


procedure WriteCt4(var f: text; var v: LineType);
(* Writes one verse to f *)
var
   c: integer;
   p: Vs_PhraseType_IndexType;
   s: integer;				(* string index in verse line *)
begin
   p := 1;
   s := 1;
   for c := 1 to VerseCAtomCount do
      WriteCt4Atom(f, p, v, s)
end;


function DeCodePhraseDistance(w: Word_IndexType; c: integer): integer;
var
   d: integer;	(* distance *)
   u: char;	(* unit *)
begin
   PaR_Cod2Dis(c, d, u);
   case u of
      'W': DeCodePhraseDistance := w + d;
      'P': DeCodePhraseDistance := WordIndex_PhrDis(w, d);
      'C': DeCodePhraseDistance := -1;
      '.': assert(u <> '.')
   end
end;


procedure FillSpace(var f: text; s: integer; w: integer);
var
   i: integer;
begin
   for i := s + 1 to w do
      write(f, ' ')
end;


procedure DisplayCAtomText(c: integer; var v: LineType);
const
   MIN_WIDTH = length('Subj');
var
   p1, p2: integer;
   s0, s: integer;
begin
   p1 := CAtomPAtomFirst(c);
   p2 := CAtomPAtomLast(c);
   s := CAtomTextStart(c);
   write('CAtom ', c:2, ': ');
   s0 := s;
   WriteSimplePhrase(output, PAtomWordCount(p1), v, s);
   while p1 < p2 do begin
      if Space(NormalSeparator(v[s - 1])) then
	 FillSpace(output, s - s0 - 1, MIN_WIDTH)
      else
	 FillSpace(output, s - s0, MIN_WIDTH);
      p1 := p1 + 1;
      write(PATOM_SEPARATOR);
      s0 := s;
      WriteSimplePhrase(output, PAtomWordCount(p1), v, s);
   end;
   writeln
end;


procedure DisplayCAtomNums(c: integer; var v: LineType);
var
   p1, p2: integer;
begin
   p1 := CAtomPAtomFirst(c);
   p2 := CAtomPAtomLast(c);
   write('PAtom:    ', p1:PAtomTextWidth(p1, v));
   while p1 < p2 do begin
      p1 := p1 + 1;
      write(PATOM_SEPARATOR, p1:PAtomTextWidth(p1, v))
   end;
   writeln
end;


procedure DisplayCAtomTyps(c: integer; var v: LineType);
var
   p1, p2: integer;
begin
   p1 := CAtomPAtomFirst(c);
   p2 := CAtomPAtomLast(c);
   write('PType:    ', PAtomTypeLabel(p1):PAtomTextWidth(p1, v));
   while p1 < p2 do begin
      p1 := p1 + 1;
      write(PATOM_SEPARATOR, PAtomTypeLabel(p1):PAtomTextWidth(p1, v))
   end;
   writeln
end;


procedure DisplayCAtomPars(c: integer; var v: LineType);
var
   p1, p2: integer;
begin
   p1 := CAtomPAtomFirst(c);
   p2 := CAtomPAtomLast(c);
   if not CAtomParsed(c) then
      write('Parse ##: ')
   else
      write('Parsings: ');
   write(PAtomParseLabel(p1):PAtomTextWidth(p1, v));
   while p1 < p2 do begin
      p1 := p1 + 1;
      write(PATOM_SEPARATOR, PAtomParseLabel(p1):PAtomTextWidth(p1, v))
   end;
   writeln
end;


procedure DisplayCAtom(c: integer; var v: LineType);
begin
   DisplayCAtomText(c, v);
   DisplayCAtomNums(c, v);
   DisplayCAtomTyps(c, v);
   DisplayCAtomPars(c, v)
end;


procedure DisplayVerse(c: integer; var v: LineType);
(* Display the verse with clause atom number c in focus *)
const
   EXTRA = 3;	(* Lines used for header and footer *)
   LINES = 5;	(* Lines used to display one clause atom *)
   OFFSET = 1;  (* Offset of the clause atom in focus, counted in
      clause atoms from the bottom of the screen *)
   TTY_STDCOLS = 80;
   TTY_STDROWS = 25;
var
   i: integer;
   n: integer;	(* number of clause atoms that fit on the screen *)
   c0: integer;	(* first clause atom to display *)
   c1: integer;	(* last clause atom to display *)
   cols, rows: integer;
begin
   if not GetWindowSize(cols, rows) then begin
      cols := TTY_STDCOLS;
      rows := TTY_STDROWS
   end;
   n := ((rows - EXTRA) div LINES);
   if c < n - OFFSET then begin
      c0 := 1;
      c1 := min(n, VerseCAtomCount)
   end else if c > VerseCAtomCount - OFFSET then begin
      c0 := max(1, VerseCAtomCount - n + 1);
      c1 := VerseCAtomCount
   end else begin
      c0 := c + OFFSET - n + 1;
      c1 := c + OFFSET
   end;
   for i := c0 to c1 do begin
      DisplayCAtom(i, v);
      writeln
   end
end;


procedure maakclauses;
var
   char_index		 : integer;
   last_char		 : integer;
   answer		 : char;
   phrase_count		 : integer;
   clause_count		 : integer;
   apo			 : integer;
   atomnr		 : integer;
   clause_atom_nr	 : integer;
   word_count		 : integer;
   i,cnr		 : integer;
   maxphr		 : integer;
   number_of_phrases	 : integer;
   verse_line		 : LineType;
   x, y		 : integer;
   UNKpres		 : boolean;
   found		 : boolean;
   LastWordOfClauseAtom	 : integer;
   FirstWordOfClauseAtom : integer;
   FirstToWrite		 : integer;
   LookForAppSpec	 : boolean;
   StopThis		 : boolean;
   temp			 : integer;
   LastToPrint		 : integer;


procedure do_identify;
(* local to maakclausees *)
var
   a: integer;		(* clause atom index *)
   s: integer;		(* starting phrase *)
   e: integer;		(* ending phrase *)
begin
   s := 1;
   for a := 1 to VerseCAtomCount do begin
      e := s + CAtomPAtomCount(a) - 1;
      if Interactive and not Oldparsing then begin
	 AdaptPhrases(s, e, maxphr);
	 FindParsing(s, e, true, verse_line);
	 SupplementParsing(a)
      end;
      s := e + 1
   end
end; (* maakclauses/do_identify *)


procedure do_no;
(* local to maakclauses:
   the user has disapproved the parsing of the verse *)
var
   atomnr: integer;
   cnr: integer;
   end_phr: integer;
   start_phr: integer;
begin
   if VerseCAtomCount = 1 then
      clause_atom_nr := 1
   else
      repeat
	 write('Which clause atom do you want to edit? ');
	 AskInteger(clause_atom_nr)
      until (0 < clause_atom_nr) and (clause_atom_nr <= VerseCAtomCount);
   atomnr := 1;
   start_phr := 0;
   end_phr := 0;
   cnr := 1;
   while atomnr < clause_atom_nr do
   begin
      cnr := cnr + 1;
      if (StartOfClauseResolver[CLAUSE_MARKS, cnr,  0] = START_CLAUSE)
	 then atomnr := atomnr + 1;
   end;
   start_phr := cnr;
   if StartOfClauseResolver[CLAUSE_MARKS, cnr + 1,  0] = START_CLAUSE
      then end_phr := cnr
   else
   begin
      repeat
	 cnr := cnr + 1
      until (cnr > maxphr) or (StartOfClauseResolver[CLAUSE_MARKS, cnr + 1,  0] = START_CLAUSE);
      end_phr := cnr;
   end;

   write('clause-atom ', atomnr: 2,' runs from phr.', start_phr:3 ,' to phr.', end_phr:3 );
   writeln;
   FindParsing(start_phr, end_phr, true, verse_line);
   SupplementParsing(atomnr);
   CorrectParsing(atomnr, verse_line, maxphr);
end; (* maakclauses/do_no *)


procedure do_yes;
(* local to maakclausees *)
var
   atomnr: integer;
   cnr: integer;
   end_phr: integer;
   start_phr: integer;
begin
   atomnr := 0;
   cnr := 0;
   start_phr := 0;
   end_phr := 0;
   repeat
      atomnr := atomnr + 1;
      start_phr := end_phr + 1;
      repeat
	 cnr := cnr + 1;
      until (StartOfClauseResolver[CLAUSE_MARKS, cnr,  0] = START_CLAUSE) or (cnr > maxphr);
      end_phr := cnr - 1;
      writeln('clause-atom ', atomnr: 2,'runs from phr.', start_phr:3 ,' to phr.', end_phr:3 );
      FindParsing(start_phr, end_phr, false, verse_line);    {insert clauses}
   until (cnr > maxphr) or (Stop);
   writeln('clause-atom ', atomnr: 2,'runs from phr.', start_phr:3 ,' to phr.', end_phr:3 );

   number_of_phrases := maxphr
end; (* maakclauses/do_yes *)


begin (* maakclauses *)
   clear_arrays;
   ReadVerse(NumberOfWordsInVerse, maxphr, verse_line);
   CheckVerse(NumberOfWordsInVerse);
   clause_atom_nr := VerseCAtomFirstUnparsed;
   number_of_phrases := 1;
   do_identify;
   CalcPAtomTextIndices(verse_line);

   if Oldparsing then
      if VersePAtomCount = VerseParseCount then
	 writeln(' existing parsing is used.')
      else begin
	 write(VerseLabel, ': ERROR: ');
	 writeln('Parse labels do not match phrase atoms');
	 pcexit(1)
      end;

   { Start the screen   presentation}
   if Interactive then
   begin
      number_of_phrases := 0;
      repeat
	 word_count := 0;
	 char_index := 0;
	 phrase_count := 0;
	 clause_count := 0;
	 apo := 0;
	 i := 0;
	 x := 0;
	 last_char := 0;
	 if number_of_phrases > 0 then
	 begin
	    { is gelijk aan teller in array StartOfClauseResolver }
	    word_count := StartOfClauseResolver[LAST_WORD, number_of_phrases,0];

	    repeat
	       char_index := char_index + 1;
	       if verse_line[char_index] in [' ', '-', '#', '$'] then
		  apo := apo + 1
	       until apo = word_count;	{ plaats van char in StartOfClauseResolver }
	    last_char := char_index;
	    atomnr := 1;
	    phrase_count := 0;
	    repeat
	       phrase_count := phrase_count + 1;
	       if StartOfClauseResolver[CLAUSE_MARKS, phrase_count,0] = START_CLAUSE then
		  atomnr := atomnr + 1
	       until phrase_count = number_of_phrases;
	    i := number_of_phrases;
	    x := i
	 end else
	    atomnr := 0;
	 lines_on_screen := 0;
	 { controle: }
	 for cnr := PARSPOS downto 1 do
	 begin
	    for apo := 1 to maxphr do
	       write(StartOfClauseResolver[PHRASE, apo,cnr]: 4);  {conditions}
	    writeln( ' conditions');
	 end;
	 writeln;
	 for apo := 1 to maxphr do
	    if Distance(apo) < 0
	       then
	       write(Distance(apo): 4)
	    else
	       write('    ');
	 writeln( ' <App> ; <Spec>; counts PHRASES or LEXEMES');
	 for apo := 1 to maxphr do
	    write(StartOfClauseResolver[PHRASE, apo,0]: 4);
	 writeln( ' phrases');
	 for apo := 1 to maxphr do
	    write(StartOfClauseResolver[LAST_WORD, apo,0]: 4);
	 writeln( ' position last word of phrase');
	 for apo := 1 to maxphr + 1 do
	 begin
	    if StartOfClauseResolver[CLAUSE_MARKS, apo,0] = 99
	       then clause_count := clause_count + 1;
	    write(StartOfClauseResolver[CLAUSE_MARKS, apo,0]: 4);
	 end;
	 writeln( ' start of Clause');
	 for apo := 1 to maxphr do
	    write(Parsing(apo): 4);
	 writeln( ' parse of Phrase');
	 { text in clauses on screen }
	 writeln(VerseLabel, TAB, '(', clause_count:1, ' clause atoms)');
	 writeln;

	 UNKpres := VerseCAtomFirstUnparsed <> 0;
	 if not UNKpres then
	    if GOON then
	       answer := 'y'
	    else begin
	       DisplayVerse(clause_atom_nr, verse_line);
	       write('Do you agree with all parsings [y/n/f/s/G]? ');
	       repeat
		  readln(answer)
	       until answer in ['j','n','y', 'f', 's', 'G']
	    end
	 else begin
	    answer := 'n';
	    SupplementVerse;
	    DisplayVerse(clause_atom_nr, verse_line);
	    GOON := false
	 end;

	 case answer of
	    'G':
	       GOON := not UNKpres;
	    'f':
	       clause_atom_nr := clause_atom_nr + 4;
	    'j', 'y':
	       do_yes;
	    'n':
	       do_no;
	    's':
	       Stop := true
	 end

      until (number_of_phrases >= maxphr) or (Stop)
   end;

   { tekst maken }
   if not Stop then begin
      WriteCt4(NewText, verse_line);
      last_char := 0;
      for i := 1 to maxphr do
      begin
	 AnalysisList[StartOfClauseResolver[LAST_WORD, i,0], CLAUSE_PARSING]
	 := Parsing(i);
	 AnalysisList[StartOfClauseResolver[LAST_WORD, i,0], PHRASEdist]
	 := Distance(i);
	 write(Parselabel(Parsing(i)))
      end;
      writeln;

      LookForAppSpec := false;
      for i := 1 to NumberOfWordsInVerse do
      begin
	 WriteLexeme(LexemeList, i);	{ nog aanvullen: noteer uit verse_line }
	 WriteValues(Ps3pED, i, KO_SPR3);
	 WriteValues(Ps4, i, LAST_FUNCTION);
	 repeat
	    last_char := last_char + 1;
	    if verse_line[last_char] = '#' then
	       verse_line[last_char] := ' '
	    else if verse_line[last_char] = '$' then
	       verse_line[last_char] := '-';
	 until verse_line[last_char] in [' ', '-'];

	 if AnalysisList[i, CLAUSE_PARSING] > -1 then
	 begin
	    (* Find last word of clause atom *)
	    x := i - 1;
	    found := false;
	    repeat
	       x := x + 1;
	       if AnalysisList[x + 1, CLAUSE_MARKER] = START_CLAUSE then
		  found := true;
	    until found;
	    LastWordOfClauseAtom := x;

	    if not LookForAppSpec then
	    begin
	       (* Find next clause parsing *)
	       x := i;
	       found := false;
	       if AnalysisList[i, CLAUSE_PARSING] in DeptSet then
		  found := true
	       else
	       begin
		  StopThis := false;
		  if x < LastWordOfClauseAtom then
		  begin
		     repeat
			x := x + 1;
			if (AnalysisList[x, CLAUSE_PARSING] in DeptSet)
			   then
			   found := true
			else if AnalysisList[x, CLAUSE_PARSING] <> -1 then
			   StopThis := true;
			if x >= LastWordOfClauseAtom then
			   StopThis := true;
		     until found or StopThis;
		  end;
	       end;
	       if found then
	       begin
		  LookForAppSpec := true;
		  StopThis := false;
		  x := x - 1;
		  repeat
		     x := x + 1;
		     if AnalysisList[x, CLAUSE_PARSING] in DeptSet
			then
			LastToPrint := x
		     else if AnalysisList[x, CLAUSE_PARSING] <> -1 then
			StopThis := true;
		     if x >= LastWordOfClauseAtom then
			StopThis := true
		  until StopThis;
	       end;
	    end;
	    if LookForAppSpec then
	    begin
	       if i = LastToPrint then
	       begin
		  LookForAppSpec := false;
		  (* Find beginning of clause atom *);
		  x := i + 1;
		  found := false;
		  repeat
		     x := x - 1;
		     if x = 1 then
			found := true
		     else if (AnalysisList[x-1, CLAUSE_MARKER] = START_CLAUSE)
			then
			found := true;
		  until found;
		  FirstWordOfClauseAtom := x;

		  (* Find, if possible, the head of the phrase. *)
		  found := false;
		  x := i + 1;
		  temp := -1;
		  repeat
		     x := x - 1;
		     if (AnalysisList[x, CLAUSE_PARSING] in DeptSet)
			and (AnalysisList[x, CLAUSE_PARSING] <> -1)
			then
		     begin
			y := DeCodePhraseDistance(x, AnalysisList[x, PHRASEdist]);
			if y > 0 then
			   if not (AnalysisList[y, CLAUSE_PARSING] in DeptSet)
			      then
			      found := true
		     end;
		     until found or (x = FirstWordOfClauseAtom);
		  if found then
		     temp := y;

		  (* Find first app or spec to write *)
		  x := i + 1;
		  StopThis := false;
		  repeat
		     x := x - 1;
		     if AnalysisList[x, CLAUSE_PARSING] in DeptSet then
			FirstToWrite := x
		     else if AnalysisList[x, CLAUSE_PARSING] <> -1 then
			StopThis := true;
		     if x = 1 then
			StopThis := true;
		  until StopThis;

		  x := LastToPrint;
	       end;
	    end;
	 end;

	 if (AnalysisList[i + 1, CLAUSE_MARKER] = START_CLAUSE)
	    and (i < NumberOfWordsInVerse) then
	 begin
	    writeln(Ps4, '           *');
	 end;
      end;
      WriteToDivP(ClauseDivisParse, maxphr);
      writeln(Ps4, '           *');
      writeln(Ps3pED, '           *');
      Stop := (VerseCount = NumberOfVerses) or
	 not Interactive and (VerseCount = NumberOfNDivisions)
   end
end;


procedure ReadClstruc;
var
   ch		     : char;
   condition	     : integer;
   clause_type_index : integer;
   phrase_type_index : integer;
   phrase_type	     : integer;
   condition_index   : integer;
begin
   clause_type_index := 0;
   phrase_type_index := 0;
   phrase_type := 0;

   while not eof(Clstruc) and (clause_type_index < MAX_OF_STRUCS) do
   begin
      clause_type_index := clause_type_index + 1;
      phrase_type_index := 0;
      condition_index := 0;
      if clause_type_index >= MAX_OF_STRUCS
	 then
      begin
	 writeln(' your file clause.struc is too long; it will cause trouble');
	    pcexit(1);
	 end else
	 begin
	    while not eoln(Clstruc) do
	    begin
	       phrase_type_index := phrase_type_index + 1;
	       read(Clstruc, phrase_type);                {  write(phrase_type:4);  }
	       Strucs[clause_type_index, phrase_type_index, 0] := phrase_type;
	       Strucs[clause_type_index, phrase_type_index, 1] := 0; { plaats voor condities }
	       repeat
		  if not eoln(Clstruc) then
		     read(Clstruc, ch)
		  until (ch in ['(', '-']) or eoln(Clstruc);
	       condition_index := 0;
	       if ch = '(' then                           { read conditions from clause set}
	       begin                                      {     write(' (');  }
		  repeat
		     read(Clstruc, condition);            {   write(condition:4); }
		     repeat
			read(Clstruc, ch)
		     until ch in [')', ','];              {      write(' ',ch);   }

		     if condition >= LEAST_PARSING_CODE            {        phrase parsing            }
			then Strucs[clause_type_index, phrase_type_index, PARSPOS] := condition
		     else
		     begin
			condition_index := condition_index + 1;
			Strucs[clause_type_index, phrase_type_index, condition_index] := condition
		     end
		  until ch = ')';
		  condition_index := condition_index + 1;
		  Strucs[clause_type_index, phrase_type_index, condition_index] := 0
	       end
	    end;
	 end;
      Strucs[clause_type_index, phrase_type_index + 1, 0] := START_CLAUSE;
      {  writeln(START_CLAUSE);  }
      readln(Clstruc)
   end;
   NumberOfClauseStruc := clause_type_index;

   writeln(' total number of Clause Struc:', NumberOfClauseStruc: 4);
   writeln;
end;


procedure WriteLexCondList(var f: text; var l: LexCondListType;
			   n: integer);
var
   p: integer;
begin
   for p := 1 to n do
      writeln(f, l[p])
end;


procedure WriteNClstruc;
var p , phr, cn : integer;

begin
   writeln(' "Nclause.struc" a new version of file clause.struc');
   { from Strucs }
   p := 0;
   while p < NumberOfClauseStruc do
   begin p := p + 1;
      phr := 0;
      repeat
	 phr := phr + 1;
	 cn := 0;
	 write(NClstruc, (Strucs[ p, phr, cn]):3);

	 if (Strucs[ p , phr, 1 ] > 0) or (Strucs[ p, phr, PARSPOS] >= LEAST_PARSING_CODE)
	    then
	 begin
	    write(NClstruc, ' ( ');
	    repeat
	       cn := cn + 1;
	       if Strucs[ p , phr, cn ] >= LEAST_PARSING_CODE
		  then
	       begin
		  if Strucs[p, phr, 1] > 0 then
		     write(NClstruc, ' ,',(Strucs[ p, phr, cn]):4)
		  else write(NClstruc, (Strucs[ p, phr, cn]):4)
	       end
	       else if Strucs[ p , phr, cn ] > 0
		  then
	       begin
		  if cn > 1 then write(NClstruc, ' , ');
		  write(NClstruc,(Strucs[ p, phr, cn]):3);
	       end
	    until cn = PARSPOS;
	    write(NClstruc, ' )');
	 end
	 else
	    write(NClstruc,' - ');
      until Strucs[ p, phr + 1, 0 ] = 99;

      write(NClstruc,' 99');

      if Strucs[ p, phr + 2, 0 ] = 999 then write(NClstruc, ' NEW');
      writeln(NClstruc);
   end;
end;


procedure ReadClauses;
var
   ch		     : char;
   clause_set	     : text;
   condition	     : integer;
   clause_type_index : integer;
   phrase_type_index : integer;
   phrase_type	     : integer;
   condition_index   : integer;
begin
   OpenReset(clause_set, 'NClset', 'old');
   clause_type_index := 0;
   phrase_type_index := 0;
   phrase_type := 0;
   writeln;
   writeln(' ... reading "NClSet". Be patient, it may take a while ... ');

   while not eof(clause_set) do
   begin
      clause_type_index := clause_type_index + 1;
      if clause_type_index mod 100 = 0 then writeln (clause_type_index);

      phrase_type_index := 0;
      condition_index := 0;
      while not eoln(clause_set) do
      begin
	 phrase_type_index := phrase_type_index + 1;
	 read(clause_set, phrase_type);      {            write(phrase_type:4); }
	 Resolver[clause_type_index, phrase_type_index, 0] := phrase_type;
	 Resolver[clause_type_index, phrase_type_index, 1] := 0; { plaats voor condities }
	 repeat
	    if not eoln(clause_set) then
	       read(clause_set, ch);
	 until (ch in ['(', '-']) or eoln(clause_set);
	 condition_index := 0;
	 if ch = '(' then            { read conditions from clause set}
	 begin
	    repeat
	       read(clause_set, condition);
	       repeat
		  read(clause_set, ch)
	       until ch in [')', ','];

	       if condition >= LEAST_PARSING_CODE
		  then Resolver[clause_type_index, phrase_type_index, PARSPOS] := condition
	       else
	       begin
		  condition_index := condition_index + 1;
		  Resolver[clause_type_index, phrase_type_index, condition_index] := condition
	       end
	    until ch = ')';
	    condition_index := condition_index + 1;
	    Resolver[clause_type_index, phrase_type_index, condition_index] := 0
	 end
      end;
      Resolver[clause_type_index, phrase_type_index + 1, 0] := START_CLAUSE;
      {               writeln(START_CLAUSE);      }
      readln(clause_set)
   end;
   close(clause_set);
   NumberOfClauseTypes := clause_type_index;

   writeln(' total number of Clause Types:', NumberOfClauseTypes: 4);
   writeln;
   if NumberOfClauseTypes > NUMBER_CLAUSE_TYPES -2 then noroom := true
   else noroom := false;
end; { Read_clauses  }



procedure ReadMorfCondList(var f: text; var list: MorfCondListType;
			   var count: ConditionIndexType);
var
   ch		   : char;
   condition_index : ConditionIndexType;
   function_index  : Function_IndexType;
   gram_value	   : integer;
   value_index	   : ValueIndexType;
begin
   while not eof(f) do
   begin
      read(f, condition_index);
      read(f, function_index);
      list[condition_index].FunctionIndex := function_index;
      repeat
	 read(f, ch)
      until ch in ['=', ':'];
      value_index := 1;
      repeat
	 read(f, gram_value);
	 list[condition_index].ValueList[value_index] := gram_value;
	 value_index := value_index + 1
      until gram_value = EOI; { test on value_index missing }
      readln(f)
   end;
   count := condition_index;
   writeln('Last condition read was number ', condition_index:1, '.')
end;


procedure ReadLexCondList
(var f: text; var list: LexCondListType; var count: integer);
var
   i: integer;
begin
   i := 0;
   while not eof(f) and (i < MAX_LEXCOND) do begin
      i := i + 1;
      readln(f, list[i])
   end;
   if eof(f) and (i <= MAX_LEXCOND) then
      writeln('Read ', i:1, ' lexemes. Last is ', trim(list[i]), '.')
   else begin
      writeln('Lexeme list too long. Maximum is ', MAX_LEXCOND: 1, '.');
      pcexit(1)
   end;
   count := i
end;


procedure ReadVerbLess(var f: text; var count, maxcol: integer);
var
   lab		  : LabType;
   ch		  : char;
   numkol, numlab : integer;
   line, kol	  : integer;
   NOCHAR,
   SKIPlast       : boolean;

begin
   maxcol := 0;
   reset(f);
   count := 0; SKIPlast := false;
   line := 0;
   repeat
      read(f, ch, lab);
      maxcol := maxcol + 1;
      ConstVBLpresent[0,maxcol] := ch;
      VerbLess[0,maxcol,1] := lab
   until (lab = 'Parse') or (eoln(f)); (* writeln; *)
   readln(f);
   if lab = 'Parse' then
   begin
      maxcol := maxcol - 1;
      writeln('File has ', maxcol:1, ' columns.')
   end
   else
   begin
      writeln(' headline in file "verbvalList" is missing or damaged');
      pcexit(1);
   end;

   NumberOfVerbLessPat := 0;
   line := 0;
   while (line <= MAXVBLCL ) and not eof(f) and not SKIPlast do
   begin
      line := line + 1; NOCHAR := false;
      numkol := 0; numlab := 0;
      kol := 0; lab := '     ';
      repeat
	 kol := kol + 1;
	 VerbLess[line,kol,1] := lab;   { make empty }
	 VerbLess[line,kol,2] := lab;
      until kol = maxcol;
      kol := 1;

	 read(f,ch); { : "+" or "." or '#' }
	 {write( '"',ch,'"'); }
	 if not (ch in ['+','.','#']) then
			     begin writeln(' line:',line:3,' WRONG BEGIN:','{',ch,'}');
                             end;
	 if ord(ch) < 1 then begin NOCHAR := true; writeln('EMPTY LINE');
			     end;
        if NOCHAR then
        begin
	   writeln(' wrong line found in VerbLessList:',line:5);
	   writeln(' Line has been skipped    <Enter> ');
	   {SKIPlast := true; }
	   line := line - 1;
	   readln;
        end else                   {start new lex}
	 if (ch = '#') and (line > 1) then
	begin
	    line := line - 1;
	end else

	 if not(eoln(f)) then
	begin read(f,lab);{ write('"',lab,'"'); }
	  if ch = '+' then numkol := numkol + 1;
	  VerbLess[line,kol,1] := lab;
	  ConstVBLpresent[line,kol] := ch;
          repeat
	   read(f,ch, lab);{ write('  "',ch,'"',' "',lab,'"'); }
	   kol := kol + 1;
	   VerbLess[line,kol,1] := lab;
	   ConstVBLpresent[line,kol] := ch;
	   if (ch <> '.') or (lab <> '     ') { and (kol > 1)   skipf first label }
	    then numkol := numkol + 1          { number of categories present }
          until (kol = maxcol) or (eoln(f)) or (eof(f));
         kol := 0;
	    repeat
	       if not eoln(f) then
	       begin
		  read(f,lab); { write('"',lab,'"'); }
		  numlab := numlab + 1;
		  repeat
		     kol := kol + 1;
		     if (ConstVBLpresent[line,kol] in ['-','+','0'] )
			then VerbLess[line,kol,2] := lab
		     else VerbLess[line,kol,2] := '     ';
		  until (ConstVBLpresent[line,kol] in ['-','+','0']) or (kol = maxcol)
	       end
	    until (eoln(f)); {  writeln('eoln'); }
	    if numkol <> numlab then
	    begin writeln(' number of labels and number of categories do not match for');
	       writeln(' line:', line:3, VerbLess[line, 1, 1]);
	       writeln('categories:',numkol:3,' parselabels:',numlab:3);
	       pcexit(1);
	    end;
	 end;
      readln(f);
   end;
   write('Read ', line:1, ' patterns. ');
   NumberOfVerbLessPat := line
end;


procedure ReadVerbVal(var f : text; var count, maxcol: integer);
var
   lab		  : LabType;
   ch		  : char;
   line, kol	  : integer;
   n_hash	  : integer;	(* number of hash signs seen *)

procedure read_verbvalline(var f: text);
(* Local to ReadVerbVal *)
var
   lab		  : LabType;
   ch		  : char;
   numkol, numlab : integer;
begin
   numkol := 0;
   numlab := 0;
   kol := 0;
   repeat
      kol := kol + 1;
      VerbVal[line,kol,1] := '     ';
      VerbVal[line,kol,2] := '     '
   until kol = maxcol;
   kol := 0;
   repeat
      kol := kol + 1;
      read(f, ch, lab);
      if (2 < kol) or (ch = '.') then
	 Constpresent[line,kol] := ch
      else begin
	 write('verbvalList, line ', line + n_hash:1, ': ');
	 writeln('Column ', kol:1, ' not formatted properly.');
	 pcexit(1)
      end;
      VerbVal[line,kol,1] := lab;
      if ((ch <> '.') or (lab <> '     ')) and not (kol in [VVL_Root,VVL_P123, VVL_sfx])
	 then numkol := numkol + 1;         { number of categories present }
   until (kol = maxcol) or eoln(f);
   if not eoln(f) then begin
      VerbVal[line, VVL_Root,2] := '     ';
      VerbVal[line, VVL_P123,2] := '     ';
      kol := 3;            {skip root and person}
      numlab := 0;         { = label of VP}
      repeat
	 read(f,lab);

	 if lab = ' <Pr>' then
#ifdef ARAMAIC
	    if numlab = 1 then begin		(* already PC *)
	       VerbVal[line, VVL_HWA, 2] := lab;
	       numlab := numlab + 1
	    end else
#endif
	    begin
	       VerbVal[line, VVL_lex, 2] := lab;
	       numlab := 1
	    end
	 else if (lab = ' <PC>') and (numlab = 0)      { first pos only }
	    then
	 begin
	    VerbVal[line, VVL_lex, 2] := lab;
	    numlab := 1
	 end
	 else if lab = ' <PO>' then
	 begin
	    VerbVal[line, VVL_lex, 2] := lab;
	    VerbVal[line, VVL_sfx, 2] := ' <Ob>';
	    (* write(VerbVal[line, VVL_sfx, 2]); *)
	    numlab := 1;
	 end
	 else if lab = ' <po>' then
	 begin
	    VerbVal[line, VVL_lex, 2] := lab;
	    VerbVal[line, VVL_sfx, 2] := ' <Ob>';
	    (* write(VerbVal[line, VVL_sfx, 2]); *)
	    numlab := 1;
	 end
	 else if lab = ' <Ps>' then
	 begin
	    VerbVal[line, VVL_lex, 2] := lab;
	    VerbVal[line, VVL_sfx, 2] := ' <Su>';
	    (* write(VerbVal[line, VVL_sfx, 2]); *)
	    numlab := 1;
	 end
	 else
	    repeat
	       kol := kol + 1;
	       if kol = VVL_sfx then
		  kol := kol + 1;
	       if (Constpresent[line,kol] in ['-','+','0'] ) then
	       begin
		  if lab = ' <PC>' then
		  begin
		     if kol <> VVL_PrCm then
		     begin
			writeln(' verb:', VerbVal[line, VVL_lex, 1], ' line ', line:1);
			writeln(' wrong <PC>'); pcexit(1);
		     end;
		  end;
		  VerbVal[line,kol,2] := lab;
		  (* write('col:',kol:2,'= [',VerbVal[line,kol,2],']');
		   *)
		  numlab := numlab + 1;
	       end
	       else VerbVal[line,kol,2] := '     ';
	    until (Constpresent[line,kol] in ['-','+','0']) or (kol = maxcol);
      until (eoln(f)) or (lab[2] = '|');  { instruction }
      if numkol <> numlab then begin
	 write('verbvalList, line ', line + n_hash:1, ': ');
	 write('Number of labels (', numlab:1, ') and ');
	 writeln('categories (', numkol:1, ') does not match.');
	 pcexit(1);
      end;
   end
end; (* ReadVerbVal/read_verbvalline *)

begin
   reset(f);
   count := 0;
   maxcol := 0;
   line := 1;
   repeat
      read(f, ch, lab);
      maxcol := maxcol + 1;
      Constpresent[0,maxcol] := ch;
      VerbVal[0,maxcol,1] := lab
   until (lab = 'Parse') or eoln(f);
   if lab = 'Parse' then begin
      maxcol := maxcol - 1;
      writeln('File has ', maxcol:1, ' columns.')
   end else begin
      writeln(' headline in file "verbvalList" is missing or damaged');
      pcexit(1)
   end;
   NumberOfVerbValPat := 0;
   readln(f);
   n_hash := 1;
   line := 0;
   while (line <= MAXVerbs) and not eof(f) do begin
      if f^ = '#' then
	 n_hash := n_hash + 1
      else begin
	 line := line + 1;
	 read_verbvalline(f)
      end;
      readln(f)
   end;
   NumberOfVerbValPat := line;
   write('Read ', NumberOfVerbValPat:1, ' patterns. ');
   writeln('Last lexeme was ', trim(VerbVal[line-1, VVL_lex, 1]), '.')
end;

procedure WriteVerbLess(var f: text; var maxcol: integer);
var
   FirstCat, p : integer;
   line, kol   : integer;

begin
   writeln;
   writeln;
   { rewrite(f);}  line := 0;
   for kol := 1 to maxcol + 1 do
      write(f,ConstVBLpresent[line,kol], VerbLess[line,kol,1] );
   writeln(f);
   FirstCat := 1;
   repeat
      line := line + 1;
      if line <= NumberOfVerbLessPat then
      begin
	 p := 0;
	 repeat
	    p := p + 1
	 until (ConstVBLpresent[line, p] = '+') or (p > 13);
	 if p > FirstCat then
	 begin FirstCat := p;
	    for kol := 1 to maxcol + 1 do
	       write(f,ConstVBLpresent[0,kol], VerbLess[0,kol,1] ); writeln(f);
	 end;
      end;
      kol := 0;
      repeat
	 kol := kol + 1;
	 write(f, ConstVBLpresent[line,kol], VerbLess[line,kol,1])
      until (kol = maxcol);
      for kol := 1 to maxcol do
	 if ConstVBLpresent[line,kol] in ['-','+','0']
	    then write(f, VerbLess[line, kol,2]);
      writeln(f)

   until line = NumberOfVerbLessPat;
   for kol := 1 to maxcol + 1 do
      write(f,ConstVBLpresent[0,kol], VerbLess[0,kol,1] );
   writeln(f)
end;

procedure WriteVerbVal(var f: text; var maxcol: integer);
var
   line, kol : integer;
begin
   writeln;
   writeln;
   rewrite(f); line := 0;
   for kol := 1 to maxcol + 1 do
      write(f,Constpresent[line,kol], VerbVal[line,kol,1] ); writeln(f);
   repeat
      line := line + 1;
      kol := 0;
      repeat
	 kol := kol + 1;
	 write(f, Constpresent[line,kol], VerbVal[line,kol,1])
      until (kol = maxcol);

      write(f, VerbVal[line, VVL_lex,2]);  { <Pr>, <PC> }
      for kol := 3 to maxcol do
      begin if kol <> VVL_sfx           { sfx: O or S in Pred label  }
	 then
	 if Constpresent[line,kol] in ['-','+','0'] then
	    write(f, VerbVal[line, kol,2]);
      end;
      writeln(f);
      if Constpresent[line,1] = '+' then
      begin writeln(' "+" in line', line:3);
	 { pcexit(1); }
      end;
      if line < NumberOfVerbValPat then
      begin
	 if (VerbVal[line, VVL_lex,1] <> VerbVal[line + 1, VVL_lex,1]) or
	    (VerbVal[line, VVL_Root,1] <> VerbVal[line + 1, VVL_Root,1])
	    then
	 begin                      { new category }
	       for kol := 1 to maxcol + 1 do
		  write(f,Constpresent[0,kol], VerbVal[0,kol,1] ); writeln(f);
	    end
      end
   until line = NumberOfVerbValPat
end;


procedure initialize;
(* Initialises global variables *)
begin
   assert(MAX_WORDS < EOD);
   (* For backward compatibility, add the obsolete parsing labels to
      the sets, so that they are recognised. *)
   AdvbSet := AdvbSet + [FrnA];
   CmplSet := CmplSet + [IrpC] + [FrnC];
   ObjcSet := ObjcSet + [IrpO] + [FrnO];
   PreCSet := PreCSet + [IrpP] + [PtSp];
   QuesSet := QuesSet + [IrpS];
   SubSSet := SubSSet + [IrpS] + [FrnS];
   SubjSet := SubjSet + SubSSet;
   DistSet := DeptSet + RefrSet;
   Alfabet := ALPHABET;
   Changed := false;
   GOON := false;
   Interactive := false;
   MAXcolN := 0;
   MAXcolV := 0;
   NumberLocLex := 0;
   NumberOfClauseTypes := 0;
   NumberOfVerbLessPat := 0;
   NumberOfVerbValPat := 0;
   NumberTimeLex := 0;
   Oldparsing := false;
   VerseCount := 0;
   ambipars := 0;
   newVBLlines := 0;
   newlines := 0;
   nopars := 0;
   parsed := 0
end;


function Filled(var f: text): boolean;
begin
   reset(f);
   while not eof(f) and (f^ = ' ') do
      get(f);
   Filled := not eof(f)
end; { Filled }


procedure ReadConditions;
begin
   writeln('Reading morphological conditions from morfcondcl.');
   ReadMorfCondList(MorfCondFile, MorfCondList, NumberMorfCond);
   writeln('Reading lexical conditions from lexcondcl.');
   ReadLexCondList(LexCondFile, LexCondList, NumberLexCond);
   writeln('Reading lexical conditions from time.ref.');
   ReadLexCondList(Tref, TimeRefList, NumberTimeLex);
   writeln('Reading lexical conditions from loc.ref.');
   ReadLexCondList(Lref, LocRefList, NumberLocLex);
end;


procedure UpdatePs3p;
var ch   : char;
begin
   {  print actual verse }
   reset(Ps3pV);
   while not eof(Ps3pV) do
   begin
      while not eoln(Ps3pV) do
      begin
	 read(Ps3pV,ch); write(Ps3pED,ch);
      end; readln(Ps3pV);
      writeln(Ps3pED);
   end;

   while not eof(Ps3p) do
   begin
      while not eoln(Ps3p) do
      begin
	 read(Ps3p,ch); write(Ps3pED,ch);
      end; readln(Ps3p);
      writeln(Ps3pED);
   end;
end;

procedure prepareNCLsort;
begin
   writeln(nclsort ,'#!/bin/sh');
   writeln(nclsort ,'name=$1');
   writeln(nclsort ,'sort -o $name.Nclauses.sort $name.Nclauses');
end;


#ifdef DEBUG
procedure dumpAnalysisList(s, e: Word_IndexType);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpAnalysisList(30, 50) *)
var
   w: Word_IndexType;
   f: Function_IndexType;
begin
   for w := s to e do begin
      write(w:3, ':');
      for f := FIRST_FUNCTION to LAST_FUNCTION do
         write(' ', AnalysisList[w, f]:3);
      writeln
   end
end;


procedure dumpOneLineVal(var o: OneLineVal);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpOneLineVal(&LineVal) *)
var
   i, j: integer;
begin
   for j := 1 to 2 do begin
      write(j:1, ': ');
      for i := 1 to MAXcat - 1 do
	 write(o[i, j], '|');
      writeln(o[MAXcat, j])
   end
end;


procedure dumpPredVal(var p: PredValType; s, e, c: integer);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpPredVal(&VerbLess, 10, 20, 2) *)
var
   l, k: integer;
begin
   for l := s to e do begin
      write(l, ':');
      for k := 1 to MAXcolN do
         write(' ', p[l, k, c]);
      writeln
   end
end;


procedure dumpStartOfClauseResolver(p, s, e: integer);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpStartOfClauseResolver(4, 30, 50) *)
var
   w: Word_IndexType;
   c: Condition_IndexType;
begin
   for w := s to e do begin
      write('[', p:1, ',', w:2, ',0-', PARSPOS:1, ']');
      for c := 0 to PARSPOS do
         write(' ', StartOfClauseResolver[p, w, c]:4);
      writeln
   end
end;


procedure dumpSOCR2(s, e, c: integer);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpSOCR2(0, maxphr + 1, 0) *)
var
   p: PhraseInfo_IndexType;
   v: Vs_PhraseType_IndexType;
begin
   for v := s to e do begin
      write('[0-', NUMBER_OF_PHRASE_INFO:1, ',', v:2, ',', c:1, ']');
      for p := 0 to NUMBER_OF_PHRASE_INFO do
         write(' ', StartOfClauseResolver[p, v, c]:4);
      writeln
   end
end;
#endif	/* DEBUG */


begin { of programme}
   initialize;
   PrepareFiles;
   Interactive := YesNoQuestion('Work interactively?');
   NumberOfDivisions := CountLines(ClauseDivisions);
   NumberOfNDivisions := CountLines(ClauseDivisParse);
   NumberOfVerses := CountLines(Text);
   CheckDivisions;

   ReadConditions;
   {ReadClauses;
    ReadClstruc;
    }
   writeln('Reading valence patterns from verbvalList.');
   ReadVerbVal(VVL, NumberOfVerbValPat, MAXcolV);
   writeln('Reading valence patterns from verblessList.');
   ReadVerbLess(VBL, NumberOfVerbLessPat, MAXcolN);
   writeln(' Files Read');

   writeln(' Files Prepared');

   Stop := (NumberOfVerses = 0) or
      not Interactive and (NumberOfNDivisions = 0);
   while not eof(Ps3p) and not Stop do begin
      VerseCount := VerseCount + 1;
      maakclauses
   end;

   {WriteNClstruc;
    }
   rewrite(Tref);
   WriteLexCondList(Tref, TimeRefList, NumberTimeLex);
   rewrite(Lref);
   WriteLexCondList(Lref, LocRefList, NumberLocLex);
   rewrite(VVL);
   WriteVerbVal(VVL, MAXcolV);
   rewrite(VBL);
   WriteVerbLess(VBL, MAXcolN);

   writeln(' Number of verses in text ', PericopeName, ' :', VerseCount);
   { writeln(' number of unparsed clauses:', nopars:5);
    writeln(' number of   parsed clauses:', parsed:5);
    writeln(' of them not fully parsed  :', ambipars:5);
    }
   writeln(' number of NEWly parsed clauses inserted into "verbvalList":',newlines:4);
   writeln(' number of NEWly parsed clauses inserted into "verblessList":',newVBLlines:4);
   writeln;
   writeln(' File with parsing labels:', PericopeName + '.ct4.p');
   writeln;
   UpdatePs3p;
   if Changed then begin
      writeln('WARNING: This session required modification of the');
      writeln('   input data.  Please run postparsecl in order to');
      writeln('   ensure that these  modifications are propagated');
      writeln('   to the input files at level 3, 3p, and 4.')
   end;
   writeln;
   writeln(' sh NCLsort ', PericopeName);
   writeln(' more ', PericopeName + '.Nclauses.sort');
   if Changed then
      writeln(' postparsecl ', PericopeName);
   writeln;
   prepareNCLsort;
   CloseFiles
end.
