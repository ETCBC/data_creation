h52864
s 00025/00011/02594
d D 1.13 98/09/04 12:30:07 const 13 12
c Last single file version.
e
s 00210/00195/02395
d D 1.12 98/01/16 17:53:07 const 12 11
c (Jan 15 19:11) None.
e
s 00020/00016/02570
d D 1.11 98/01/16 17:53:02 const 11 10
c (Dec 8 12:32) Fixed a bug in ReadPhraseList.
e
s 01350/00468/01236
d D 1.10 98/01/16 17:52:56 const 10 9
c None.
e
s 00035/00022/01669
d D 1.9 98/01/16 17:52:52 const 9 8
c (Dec 8 12:24) Fixed a bug in ReadPhraseList.
e
s 00669/00428/01022
d D 1.8 98/01/16 17:52:47 const 8 7
c (Feb 4 1997) None.
e
s 00334/00215/01116
d D 1.7 98/01/16 17:52:42 const 7 6
c (Jan 9 1997) Major improvements in ReadInteger and ReadConditionList.
e
s 00002/00002/01329
d D 1.6 98/01/16 17:52:38 const 6 5
c (Dec 13 1996) Bug fix: possible use of uninitialised variables.
e
s 00067/00031/01264
d D 1.5 98/01/16 17:52:34 const 5 4
c (Oct 28 1996) Primarily cosmetic changes.
e
s 00002/00008/01293
d D 1.4 98/01/16 17:52:30 const 4 3
c (Oct 28 1996) Last modified April 3rd 1995.
e
s 00189/00064/01112
d D 1.3 98/01/16 17:52:26 const 3 2
c None.
e
s 01106/00603/00070
d D 1.2 98/01/16 17:52:22 const 2 1
c (Oct 28 1996) None.
e
s 00673/00000/00000
d D 1.1 98/01/16 17:52:19 const 1 0
c date and time created 98/01/16 17:52:19 by const
e
u
U
f e 0
f m dapro/syn03/syn03.p
t
T
I 1
D 3
program syn03;
E 3
I 3
D 4
program syn03new;  { 20 oktober 1993}
E 4
I 4
D 5
program syn03new; {20 oktober 1993}
E 5
I 5
D 10
program syn03new;
E 10
I 10
program syn03;
E 10
E 5
E 4
E 3

I 4
(* ident "%Z%%M% %I% %G%" *)
E 4
D 2
        { reads a PS file, i.e. the product of a morphological analysis
        by program syn01 and program syn02;
        produces a new PS file with addition of phrases and phrase types.
        XXX.PS3
        Data files needed:
        a XXX.PS2 file;
          XXX.CT  file;
          MORFCOND;
          PHRSET                                                   }
E 2
I 2
D 3
(* ident "%Z%%M% %I% %G%" *)
E 3

I 7
label 0; (* to exit program on fatal error *)

E 7
const
D 7
   MAX_SCR_PHRCHARS =		30;
   MAX_SCR_LINES =		50;
   END_OF_VERSE =		999;
E 7
D 3
   CLAUSE_MARK =		13;
   PHRDEP_PSP =			11;
E 3
I 3
D 8
   CLAUSE_MARK =		15;
E 8
I 8
   LINE_IN_SET =		15;
E 8
D 7
   PHRDEP_PSP =			12;
   PHRASE_TYPE =		13;
   STATE =                      11;
E 7
   DETERMINATION =              14;
I 7
   END_OF_VERSE =		999;
E 7
E 3
   EOI =			99;
   FIRST_FUNCTION =		-1;
   LABEL_LENGTH =		11;
D 3
   LAST_FUNCTION =		13;
E 3
I 3
   LAST_FUNCTION =		15;
E 3
   LEXEME_LENGTH =		18;
I 7
(* LC_OFFSET + 1 is first lexical condition *)
   LC_OFFSET =			100;
I 10
   LEX_CONDITIONS	=       100;
E 10
E 7
D 3
   MAX_CONDITIONS =		50;
E 3
I 3
   MAX_CONDITIONS =		150;
D 7
   LEX_CONDITIONS =             100; {start pointers in MORFCOND to LEXCOND }
E 7
E 3
   MAX_COND_VALUES =		10;
D 3
   MAX_PHRASE_TYPES =		2000;
   MAX_PHRASE_WORDS =		80;
   MAX_VERSE_CHARS =		240;
   MAX_VERSE_WORDS =		90;
   MAX_WORD_CONDITIONS =	3;
E 3
I 3
   MAX_PHRASE_TYPES =		5000;
   MAX_PHRASE_WORDS =		200;
I 7
   MAX_SCR_LINES =		50;
   MAX_SCR_PHRCHARS =		30;
E 7
   MAX_VERSE_CHARS =		400;
   MAX_VERSE_WORDS =		120;
   MAX_WORD_CONDITIONS =	5;
I 10
   MAX_COND_DESCR_CHARS =       4;
E 10
E 3
   NO =				['n', 'N'];
D 7
   READ =			0;
E 7
I 7
   PHRASE_TYPE =		13;
   PHRDEP_PSP =			12;
I 8
   SUFFIX     =                 6;
E 8
E 7
D 3
   PHRASE_TYPE =		12;
E 3
   PSP =			1;
I 10
   PHRASE_SEPARATOR	=       100;
E 10
I 7
   READ =			0;
I 10
   WRITE =			1;
E 10
   STAGE_FILE_NAME =            'synnr';
   STATE =                      11;
E 7
D 3
   STRING_LENGTH =		64;
E 3
I 3
   STRING_LENGTH =		75;
E 3
   UNDEFINED =			-1;
D 10
   WRITE =			1;
E 10
   YES =			['Y', 'y', 'j', 'J'];
D 10
   YES_NO =			['j', 'J', 'y', 'Y', 'n', 'N', 'S','s'];
E 10
I 10
   YES_NO =			['j', 'J', 'y', 'Y', 'n', 'N'];
   YES_NO_STOP =		['j', 'J', 'y', 'Y', 'n', 'N', 'S','s'];
E 10
D 8

E 8
I 8
   ARTICLE =                    0;
I 10
   VERB =                       1;
E 10
   NOUN =                       2;
   PROPER_NOUN  =               3;
   PREPOSITION =                5;
   CONJUNCTION =                6;
   PERSONAL_PRONOUN =           7;
   ADJECTIVE =                  13;
   NOT_APPLICABLE =             -1;
   EMPTY =                      0;
   INDETERMINED =               1;
   DETERMINED =                 2;
I 10
   USER_MADE_PHRASE =           9999;
E 10
E 8
E 2
type
D 2
    rrps       =          array [1..100,-1..13]       of integer;
    versrec    =   packed array [1..240]              of char;
    lexeme     =   packed array [1..18]               of char;
    lexemerec  =          array [1..50]               of lexeme;
    phraserec  =   packed array [1..150,-1..30,0..3]  of integer;
var
    ps2,
    ps3,
    ct,
    mrfile,
    synnr,
    synni,
    synnui,
    divis,
    cldiv,
    phrfile  :   text;
    antw,
    ch,k     :   char;
    flin,
    lfn,
    ctn      :   string[30];
    lx       :   string[18];
    phrec    :   phraserec;
    ko,
    condit   :   rrps;
    i,   psp,
    wgr, code,
    maxgr,
    maxcond,
    areg     :   integer;
    versreg  :   versrec;
    linelex  :   lexemerec;
    lex      :   lexeme;
    vvers,
    versnr   :   string[11];
    tonen,
    bewaar   :   boolean;
E 2
I 2
   CharSet =
	 set of char;
   WordIndexType =
	 0..MAX_VERSE_WORDS;
   FunctionIndexType =
	 FIRST_FUNCTION..LAST_FUNCTION;
   ConditionIndexType =
	 1..MAX_CONDITIONS;
   PhraseTypeIndexType =
	 1..MAX_PHRASE_TYPES;
   ValueIndexType =
	 1..MAX_COND_VALUES;
E 2

D 2
procedure vraagbestand;                               { name of Ps file }
var po,filenr  : integer;
    ch         : char;
E 2
I 2
   ValueListType =
	 array [ValueIndexType] of integer;
   VerseLabelType =
	 packed array [1..LABEL_LENGTH] of char;
   LexemeType =
	 packed array [1..LEXEME_LENGTH] of char;
   StringType =
	 varying [STRING_LENGTH] of char;
   VerseLineType =
	 varying [MAX_VERSE_CHARS] of char;
   ConditionType =
	 record
D 10
	    FunctionIndex:	FunctionIndexType;
	    ValueList:		ValueListType
	 end;
E 10
I 10
	    FunctionIndex : FunctionIndexType;
	    ValueList	  : ValueListType;
	    Description	  : array[1..MAX_COND_DESCR_CHARS] of char;
	 end;		  
E 10
   ConditionListType =
	 array [ConditionIndexType] of ConditionType;
   LexemeListType =
	 array [WordIndexType] of LexemeType;
   AnalysisListType =
	 array [WordIndexType, FunctionIndexType] of integer;
   ResolverType =
	 packed array
	       [PhraseTypeIndexType, -1..MAX_PHRASE_WORDS, 0..MAX_WORD_CONDITIONS]
D 7
	 of -30..100;
E 7
I 7
	 of integer;
I 10
   PhraseType =
         array [0..MAX_WORD_CONDITIONS, -1..MAX_PHRASE_WORDS] of integer;
E 10
E 7
E 2

I 10

E 10
D 2
begin
     assign(synni,'synnr');
     assign(synnui,'synnui');
     reset(synni);
     rewrite(synnui);  po := 0;
     repeat read(synni,filenr,ch,flin);
            writeln(filenr:3,' ',flin);
            writeln(synnui,filenr:3,' ',flin);
            if filenr <> 3
            then readln(synni)
     until (filenr = 3) or (eof(synni));
     close (synnui);
     if filenr <> 3
        then begin
                   writeln(' hoe heet het te lezen bestand?');
                   readln(flin);
             end;
     writeln(' invoer bestand: ',flin);
     assign(ps2,flin);
     po := pos('.',flin);  po := po + 1;
     delete(flin,po,3);
     lfn := 'PHD'; insert(flin,lfn,1);
     assign(divis,lfn);
     reset(divis); ch := ' ';
     repeat if not eof(divis) then read(divis,ch)
     until (eof(divis)) or (ch <> ' ');
     if ch = ' ' then begin rewrite(divis); bewaar := true;
                      end
           else       begin reset(divis); bewaar := false;
                      end;
     writeln(' bewaar:',bewaar);
E 2
I 2
var
D 10
   AnalysisList:	AnalysisListType;
D 7
   NumberConditions:	ConditionIndexType;
E 7
   ConditionList:	ConditionListType;
   LexemeList:		LexemeListType;
I 3
   LexCondList:		LexemeListType;
E 3
   Lexeme:		LexemeType;
   Resolver:		ResolverType;
   TextName:		StringType;
   VerseLabel:		VerseLabelType;
   VerseLine:		VerseLineType;
E 10
I 10
   AnalysisList	 : AnalysisListType;
   ConditionList : ConditionListType;
   LexemeList	 : LexemeListType;
   LexCondList	 : LexemeListType;
   Lexeme	 : LexemeType;
   Resolver	 : ResolverType;
   Phrase	 : PhraseType;
   TextName	 : StringType;
   VerseLabel	 : VerseLabelType;
   VerseLine	 : VerseLineType;
E 10
E 2

D 2
     lfn := 'DIV'; insert(flin,lfn,1);
     assign(cldiv,lfn);
     rewrite(cldiv);
     lfn := 'CT';  insert(flin,lfn,1);
     assign(ct,lfn);                         writeln(lfn);
     po := pos('.',flin);  po := po + 3;
     delete(flin,po,1);             writeln(flin);
     lfn := 'PS3'; insert(flin,lfn,1);        writeln(lfn);
E 2
I 2
D 10
   Interactive:		boolean;
   StoreDivisions:	boolean;
   Incomplete:          boolean;
   Stop:                boolean;
I 3
   DET:			boolean;
E 10
I 10
   Interactive    : boolean;
   StoreDivisions : boolean;
   Incomplete     : boolean;
   Stop           : boolean;
   DET            : boolean;
   ChangePhrset   : boolean;
   BeVerbose      : boolean;
E 10
E 3
E 2

D 2
     assign(ps3,lfn);
     assign(phrfile,'phrset');
     assign(mrfile,'morfcond');
E 2
I 2
   DivisionCount:	integer;
   NumberOfDivisions:	integer;
   NumberOfVerses:	integer;
   PhraseCount:		integer;
I 3
   NumberLexCond:       integer;
E 3
E 2

D 2
     writeln(' uitvoer bestand: ',lfn);
E 2
I 2
D 10
   StageFile:		text;
   PsIn:		text;
   PsOut:		text;
   TextFile:		text;
   DivisionsFile:	text;
   PartialDivFile:	text;
   ConditionsFile:	text;
I 3
   LexConditionsFile:   text;
E 3
   PhrasesFile:		text;
E 10
I 10
   StageFile:text;
   PsIn :		text;
   PsOut :		text;
   TextFile :		text;
   DivisionsFile :	text;
   PartialDivFile :	text;
   ConditionsFile :	text;
   LexConditionsFile :  text;
   PhrasesFile :	text;
   NewPhraseSet :       text;
E 10
E 2

D 2
     reset(synnui);
     assign(synnr,'synnr');
     filenr := 4;
     rewrite(synnr);
     while not eof(synnui) do
           begin while not eoln(synnui) do
                 begin read(synnui,ch); write(synnr,ch);
                 end;
                 readln(synnui); writeln(synnr);
           end;
           writeln(synnr,filenr:3,' ',lfn);
     close(synnr);
end;
E 2
I 2
   Ps2Name:		StringType;
   PhdName:		StringType;
   CtName:		StringType;
   Ps3Name:		StringType;
E 2

I 13
procedure StrAdd(    c : char;
		 var s : StringType);
var
   temp	: StringType;
   i	: integer;
begin
   temp := c;
   for i := 1 to length(s) do
      temp := temp + s[i];
   s := temp;
end;

E 13
I 12
procedure Str(	  n : integer;
	      var s : StringType);
var
   i : integer;
begin
   if n = 0 then
      s := '0'
   else
      s := '';
   while (n <> 0) do
   begin
      i := n mod 10;
D 13
      s := chr(ord('0') + i) + s;
E 13
I 13
      StrAdd(chr(ord('0') + i), s);
E 13
      n := (n - i) div 10;
   end;
end;
E 12

D 2
procedure schrijflex(var linrec: lexemerec; j : integer);
E 2
I 2
D 10
procedure ClearScreen; extern;
E 10
I 10
procedure testconditions(start_index, last_word: integer);
type
   soorten = array [0..6] of integer;
var
   c:			integer;
   cc:			integer;
   gram_value:		integer;
   gram_value_index:	integer;
   i1:			integer;
   i2:			integer;
   i:			integer;
   id:			boolean;				
   kolnr:		soorten;				
   psp:			integer;				
   psp_index:		integer;
   lexnum:              integer;
E 10
E 2

I 10
begin
   i1 := -1;
   i2 := 0;
   psp_index := 0;
   psp := 0;
   kolnr[0] := 7;           { verbal tense        }
   kolnr[1] := 3;           { rootformation morph } 
   kolnr[2] := 0;           { lexical set         } 
   kolnr[3] := 5;           { nominal ending      } 
   kolnr[4] := 6;           { suffix              } 
   kolnr[5] := 9;           { number              }
   kolnr[6] := 10;          { gender              }
E 10
I 7

I 10
   repeat
      psp_index := psp_index + 1;
      cc := 0;
      psp := AnalysisList[start_index + psp_index, PSP];
      if psp = VERB then
      begin
	 i1 := 0;
	 i2 := 4
      end else if psp = PROPER_NOUN then
      begin
	 i1 := 3;
	 i2 := 3
      end else if psp in [NOUN, ADJECTIVE] then
      begin
	 i1 := 2;
	 i2 := 6
      end else if psp = PREPOSITION then
      begin
	 i1 := 4;
	 i2 := 4
      end;
      if i1 > -1 then
      begin
	 { test lexical conditions }
	 for lexnum := 1 to  NumberLexCond do
	    if LexCondList[lexnum] = LexemeList[start_index + psp_index]
	       then
	    begin
	       writeln('lexcondition: ',LexCondList[lexnum]);
	       cc := cc + 1;
	       c := LEX_CONDITIONS + lexnum;            { lex condition number }
	       Phrase[cc, psp_index] := c;
	    end;

	 for i := i1 to i2 do
	 begin
	    gram_value := AnalysisList[start_index + psp_index, kolnr[i]];
	    c := 0;
	    id := false;
	    repeat
	       c := c + 1
	    until (ConditionList[c].FunctionIndex = kolnr[i])
	    or (c=LEX_CONDITIONS);
	    { conditions > 100 = lexical }
	    
	    if (i = 4) and (gram_value > 0) then
	    begin     { suffix present }	
	       cc := cc + 1;
	       Phrase[cc, psp_index] := -c
	    end else
	    begin
	       c := c - 1;
	       id := false;
	       repeat
		  c := c + 1;
		  gram_value_index := 0;
		  repeat
		     gram_value_index := gram_value_index + 1;
		     if ConditionList[c].ValueList[gram_value_index] =
			gram_value
			then 
			id := true;
		  until id
		  or (ConditionList[c].ValueList[gram_value_index] = EOI)
	       until (id = true)
	       or (ConditionList[c].FunctionIndex <> kolnr[i]);
	       
	       if ConditionList[c].FunctionIndex = kolnr[i] then
	       begin
		  cc := cc + 1;
		  Phrase[cc, psp_index] := c
	       end
	    end
	 end
      end
   until start_index + psp_index >= last_word;
end; { testconditions }


procedure PossiblyDoAddPhrase(verse_length, FirstWordOfPhrase : integer);
var
   cond_index	    : integer;
   end_previous_phr : integer;
   last_word	    : integer;
   phrase_index	    : integer;
   psp_index	    : integer;
   search_index	    : integer;
   difference	    : boolean;
   subsequent	    : boolean;
   word_index	    : integer;
   identical	    : boolean;
   ok		    : boolean;
   LastWordOfPhrase : integer;
begin
   if ChangePhrset then
   begin
      if BeVerbose then
	 writeln('Seeing if we should add phrase to phrset...');

      (* Find last word of phrase. *)
      LastWordOfPhrase := FirstWordOfPhrase - 1;
      repeat
	 LastWordOfPhrase := LastWordOfPhrase + 1;
      until AnalysisList[LastWordOfPhrase, PHRASE_TYPE] <> 0;

      (* Make sure we do not add any apositions. *)
      if AnalysisList[LastWordOfPhrase, PHRASE_TYPE] > 0 then
      begin
	 { Clear Phrase }
	 for psp_index := 0 to MAX_PHRASE_WORDS do 
	    for cond_index := 0 to MAX_WORD_CONDITIONS do 
	       Phrase[cond_index, psp_index] := 0;
	 
	 word_index := FirstWordOfPhrase - 1;
	 end_previous_phr := word_index;

	 difference := false;
	 psp_index := 0;
	 subsequent := false;
	 repeat
	    psp_index := psp_index + 1;
	    word_index := word_index + 1;
	    Phrase[0, psp_index] := AnalysisList[word_index, PSP];			
	    difference :=
	    (AnalysisList[word_index, PSP] <> AnalysisList[word_index, PHRDEP_PSP]) or
	    (AnalysisList[word_index, PHRASE_TYPE] < 0);
	    if AnalysisList[word_index, PHRASE_TYPE] <> 0 then
	    begin
	       subsequent := false;
	       if (psp_index = 1) and difference then 
		  subsequent := true   {see more context then phrase only}
	       else if word_index < verse_length then
	       begin
		  search_index := word_index;
		  repeat
		     search_index := search_index + 1
		  until
		  (AnalysisList[search_index, PHRASE_TYPE] > 0) or
		  (search_index = verse_length);		
		  subsequent := false;
		  if AnalysisList[search_index, PHRASE_TYPE] > 0 then
		  begin
		     repeat
			search_index := search_index - 1
		     until
		     (AnalysisList[search_index, PHRASE_TYPE] <> 0) or
		     (search_index = word_index);	
		     if (AnalysisList[search_index, PHRASE_TYPE] < 0) and
			(search_index > word_index)
			then 
			subsequent := true
		  end;
		  if search_index = verse_length then 
		     repeat
			word_index := word_index + 1;
			psp_index := psp_index + 1;
			Phrase[0, psp_index] := AnalysisList[word_index, PSP];
			if (AnalysisList[word_index, PSP] <> AnalysisList[word_index, PHRDEP_PSP]) or
			   (AnalysisList[word_index, PHRASE_TYPE] < 0)
			   then 
D 13
			   difference := true
			until word_index = search_index
E 13
I 13
			   difference := true;
		     until word_index = search_index
E 13
	       end
	    end
D 13
	 until (AnalysisList[word_index, PHRASE_TYPE] <> 0) and not subsequent or
	 (word_index = verse_length);
E 13
I 13
	 until ((AnalysisList[word_index, PHRASE_TYPE] <> 0) and not subsequent)
	 or (word_index = verse_length);
E 13
	 last_word := word_index;
	 if AnalysisList[word_index, PHRASE_TYPE] <> AnalysisList[end_previous_phr + 1, PHRDEP_PSP] then 
	    difference := true;			

	 { STATE }
	 word_index := end_previous_phr;
	 psp_index := psp_index + 1;
	 Phrase[0, psp_index] := PHRASE_SEPARATOR;
	 repeat
	    word_index := word_index + 1;
	    psp_index := psp_index + 1;
	    Phrase[0, psp_index] := AnalysisList[word_index, STATE]
	 until (word_index = last_word) or (word_index = verse_length);  

	 { PHRDEP_PSP }
	 word_index := end_previous_phr;
	 psp_index := psp_index + 1;
	 Phrase[0, psp_index] := PHRASE_SEPARATOR;
	 repeat
	    word_index := word_index + 1;
	    psp_index := psp_index + 1;
	    Phrase[0, psp_index] := AnalysisList[word_index, PHRDEP_PSP]
	 until (word_index = last_word) or (word_index = verse_length);

	 { PHRASE_TYPE }
	 word_index := end_previous_phr;
	 psp_index := psp_index + 1;
	 Phrase[0, psp_index] := PHRASE_SEPARATOR;
	 repeat
	    word_index := word_index + 1;
	    psp_index := psp_index + 1;
	    Phrase[0, psp_index] := AnalysisList[word_index, PHRASE_TYPE]
	 until (word_index = last_word) or (word_index = verse_length);

	 {DETERMINATION }
	 word_index := end_previous_phr;
	 psp_index := psp_index + 1;
	 Phrase[0, psp_index] := PHRASE_SEPARATOR;
	 repeat
	    word_index := word_index + 1;
	    psp_index := psp_index + 1;
	    Phrase[0, psp_index] := AnalysisList[word_index, DETERMINATION]
	 until (word_index = last_word) or (word_index = verse_length); 

	 Phrase[0, psp_index + 1] := EOI;

	 (* Length of phrase has been determined, start examining conditions *)
	 
	 if (psp_index > 1) or (psp_index = 1) and difference then 
	    testconditions(end_previous_phr, last_word);

	 { If there is room, then ... }
	 if PhraseCount < MAX_PHRASE_TYPES then
	 begin
	    PhraseCount := PhraseCount + 1;

	    { Copy the newly found Phrase into Resolver[PhraseCount,X,X]. }
	    for search_index := 1 to psp_index do
	    begin
	       Resolver[PhraseCount, search_index, 0] := Phrase[0, search_index];
	       Resolver[PhraseCount, search_index, 1] := 0;
	       if Phrase[1, search_index] <> 0 then
	       begin
		  cond_index := 0;
		  repeat
		     cond_index := cond_index + 1;
		     Resolver[PhraseCount, search_index, cond_index] :=
		     Phrase[cond_index, search_index]
		  until (cond_index = MAX_WORD_CONDITIONS)
		  or (Phrase[cond_index, search_index] = 0);
	       end;
	    end;

	    (* End the phrase with an EOI (99).. *)
	    Resolver[PhraseCount, psp_index + 1, 0] := EOI;

	    (*  Find the first phrase in phrset which starts with the same
	     *  part of speech as the found phrase. *)
	    phrase_index := 0;
	    repeat
	       phrase_index := phrase_index + 1
	    until Resolver[PhraseCount, 1, 0] = Resolver[phrase_index, 1, 0];			
	    (*  Find the place in phrset where the new phrase is to be
	     *  inserted, or that the phrase is already there. *)
	    identical := false;
	    phrase_index := 0;
	    repeat
	       phrase_index := phrase_index + 1
	    until Resolver[PhraseCount, 1, 0] = Resolver[phrase_index, 1, 0];			
	    phrase_index := phrase_index - 1;
	    repeat			
	       phrase_index := phrase_index + 1;
	       if Resolver[PhraseCount, 1, 0] = Resolver[phrase_index, 1, 0] then
	       begin
		  ok := true;
		  difference := false;
		  search_index := 0;
		  repeat
		     search_index := search_index + 1;
		     cond_index := 0;
		     repeat
			cond_index := cond_index + 1;
			if Resolver[phrase_index, search_index, cond_index]
			   <> Resolver[PhraseCount, search_index, cond_index]
			   then
			   ok := false;
		     until not ok
		     or (Resolver[phrase_index, search_index, cond_index] = 0)
		     or (cond_index = MAX_WORD_CONDITIONS);
		     
		     
		     if (Resolver[phrase_index, search_index, 0] < Resolver[PhraseCount, search_index, 0]) and (Resolver[PhraseCount, search_index, 0] < EOI) then
			difference := true;		
		     if (Resolver[phrase_index, search_index, 0] >= EOI) and (Resolver[PhraseCount, search_index, 0] < EOI) then 	
			difference := true;
		     if (Resolver[phrase_index, search_index, 0] = EOI) and (Resolver[PhraseCount, search_index, 0] = PHRASE_SEPARATOR) then 
			difference := true
		     until (Resolver[PhraseCount, search_index, 0] >= EOI) or (Resolver[phrase_index, search_index, 0] >= EOI) or (Resolver[phrase_index, search_index, 0] > Resolver[PhraseCount, search_index, 0]) or difference;
		  if ok then begin
		     identical := true;
		  end
	       end
	    until identical or difference or (Resolver[phrase_index, 1, 0] <> Resolver[PhraseCount, 1, 0]);		 
	    if identical then
	    begin
	       PhraseCount := PhraseCount - 1;
	       if BeVerbose then
		  writeln('Phrase not added');
	    end else
	    begin
	       if BeVerbose then
		  writeln('Adding phrase to phrset. Please wait...');
	       search_index := PhraseCount;
	       { Make room for new phrase by copying upwards. }
	       repeat

		  psp_index := 0;
		  repeat

		     psp_index := psp_index + 1;

		     Resolver[search_index + 1, psp_index, 0] :=
		     Resolver[search_index, psp_index, 0];
		     
		     cond_index := 0;
		     repeat
			cond_index := cond_index + 1;
			Resolver[search_index + 1, psp_index, cond_index] :=
			Resolver[search_index, psp_index, cond_index];
		     until (Resolver[search_index, psp_index, cond_index] = 0)
		     or (cond_index = MAX_WORD_CONDITIONS);

		  until Resolver[search_index, psp_index, 0] = EOI;

		  search_index := search_index - 1;
	       until search_index = phrase_index - 1;

	       { Now do the copying of the new phrase. }
	       for psp_index := 1 to MAX_PHRASE_WORDS do
		  for cond_index := 0 to MAX_WORD_CONDITIONS do
		  begin
		     Resolver[phrase_index, psp_index, cond_index] :=
		     Resolver[PhraseCount + 1, psp_index, cond_index];
		     Resolver[PhraseCount + 1, psp_index, cond_index] := 0;
		  end;
	       if BeVerbose then
		  writeln('Phrase added.');
	    end;
	 end;
      end;
      if BeVerbose then
	 writeln(VerseLabel,' total number of phrase types:', PhraseCount: 4);
   end;
end; 

E 10
procedure Die;
begin
   writeln('syn03: cannot continue');
   goto 0
end;


E 7
I 2
function Space(c: char):boolean;
E 2
begin
D 2
      write(ps3,versnr);
      write(ps3,linrec[j]);
end;
E 2
I 2
   Space := c in [' ', '	']
end; { Space }
E 2

D 2
procedure schrijfwoord(var j : integer);
var p,q : integer;
E 2

D 2
begin                                   { schrijft kolommen 0 .. 13 }
      p:= 0; q := ko[j,p]; write(ps3,q:3);
      p:= 1; q := ko[j,p]; write(ps3,q:4);
      for p := 2 to 6 do begin
                              q:= ko[j,p]; write(ps3,q:3);
                         end;
      p:= 7; q:= ko[j,p]; write(ps3,q:5);
      for p := 8 to 10 do begin
                               q := ko[j,p]; write(ps3,q:3);
                          end;
      p:= 11; q:= ko[j,p]; write(ps3,q:10);
      p:= 12; q:= ko[j,p]; write(ps3,q:3);
      p:= 13; q:= ko[j,p]; write(ps3,q:6);
E 2
I 2
function Digit(c: char):boolean;
begin
   Digit := c in ['0'..'9']
end; { Digit }
E 2

D 2
      writeln(ps3);
E 2

D 2
end;
E 2
I 2
procedure SkipSpace(var f:text);
I 7
var
   stop: boolean;
E 7
begin
D 7
   while Space(f^) do
      get(f)
E 7
I 7
   stop := false;
   while not stop do
      if not eof(f) then
	 if not eoln(f) then
	    if Space(f^) then
	       get(f)
	    else
	       stop := true
	 else
	    stop := true
      else
	 stop := true
E 7
end; { SkipSpace }
E 2

D 2
procedure leegarray;
var p,q : integer;
E 2

I 2
D 5
function ReadInteger(var i: integer):boolean;
E 5
I 5
function ReadInteger(var f: text; var i: integer):boolean;
E 5
const
   BASE = 10;
D 10
   MAXINT = 32767;
E 10
I 10
   MAXINTEGER = 32767;
E 10
var
D 7
   c:		char;
E 7
   int:		integer;
   sign:	integer;
E 2
begin
D 2
     for p := 1 to 50 do
         for q := -1 to 13 do
             ko [p,q] := -1;
end;
procedure schrijftype(var tp : integer);
var appos : boolean;
begin if tp < -1 then begin appos := true;
                            tp := -tp;
                      end
      else appos := false;
      case tp of 0: write(' ----  ');
                 1: write(' VP    ');
                 2: write(' NP    ');
                 3: write(' NPnpr ');
                 4: write(' AdvP  ');
                 5: write(' PP    ');
                 6: write(' CjP   ');
             7,8,9: write(' NPpron');
                10: write(' IntjP ');
                11: write(' NegP  ');
                12: write(' IntrgP');
                13: write(' NPadj ');
                20: write(' NPdet ');
E 2
I 2
D 7
   c := ' ';
D 5
   while not eof and Space(c) do
      read(c);
E 5
I 5
   while not eof(f) and Space(c) do
      read(f, c);
E 5
   if c in ['-', '+'] then begin
      case c of
	 '-': sign := -1;
	 '+': sign :=  1
E 2
      end;
D 2
      if appos then write('(app)');
end;
E 2
I 2
D 5
      read(c)
E 5
I 5
      read(f, c)
E 5
   end else
      sign := 1;
   if Digit(c) then begin
      int := 0;
      repeat
         int := BASE * int  +  ord(c) - ord('0');
D 5
         read(c)
E 5
I 5
         read(f, c)
E 5
      until not Digit(c) or (int > MAXINT/BASE);
      if Digit(c) then
	 (* integer overflow *)
         ReadInteger := false
      else begin
         ReadInteger := true;
         i := sign * int
      end
   end else
E 7
I 7
   if eof(f) then
E 7
      ReadInteger := false
I 7
   else if eoln(f) then
      ReadInteger := false
   else begin
      SkipSpace(f);
      if f^ in ['-', '+'] then begin
	 case f^ of
	    '-': sign := -1;
	    '+': sign :=  1
	 end;
         get(f);
      end else
	 sign := 1;
      if Digit(f^) then begin
	 int := 0;
	 repeat
	    int := BASE * int  +  ord(f^) - ord('0');
	    get(f)
D 10
	 until not Digit(f^) or (int > MAXINT/BASE);
E 10
I 10
	 until not Digit(f^) or (int > MAXINTEGER/BASE);
E 10
	 if Digit(f^) then
	    (* integer overflow *)
	    ReadInteger := false
	 else begin
	    ReadInteger := true;
	    i := sign * int
	 end
      end else
	 ReadInteger := false
   end
E 7
end; { ReadInteger }
E 2

D 2
procedure zoekphrases(var rg,psp : integer);
var id            : boolean;
    i,j,k,l,m,n,c : integer;
E 2

D 2
    function conditie(var c, nr : integer) : boolean;
    var kol,x,cc : integer;
        ok       : boolean;
E 2
I 2
function GetAnswer(var question: StringType; valid: CharSet):char;
var
   answer: char;
begin
   repeat
      write(question);
D 7
      if eof then begin
	 writeln('syn03: premature end of file');
	 halt
      end else
	 readln(answer);
E 7
I 7
      readln(answer)
E 7
   until answer in valid;
   GetAnswer := answer
end; { GetAnswer }
E 2

D 2
    begin cc  := c; if c < 0 then begin cc := -c; {write(' neg. cond.'); }
                                  end;
          kol := condit [cc, 1 ];
          ok  := false; x := 1;
          repeat x := x + 1; if ko [nr, kol] = condit [cc, x]
                             then begin ok := true; if c < 0 then ok := false;
                                  end
                             else begin ok := false; if c < 0 then ok := true;
                                  end
          until (ok) or (condit [cc, x+1] = 99) or (x = 13);
          { if c < 0 then writeln(' conditie:',ok); }
          conditie := ok;
    end;
E 2

D 2
begin  i:= 0;
       repeat i := i+1
       until (phrec [i, 1, 0] = psp)               { part of speech localiseren }
          or (i = maxgr);                          { writeln(' psp:',psp:3,' gevonden in regel:',i:3);  }
       i:= i-1; id := true;
       repeat i := i + 1;   j:= -1; k:= 0;         { zoek phrase in array       }
              id := true;
              repeat j:= j+1;  k := k+1;           { j = lengte phrase in clause}
                                                   { write(ko[rg+j,1],' =',phrec[i,k,0]); }
                  if (ko[rg+j,1] <> phrec [i,k,0]) {zoek lexeem in phrase       }
                     and (phrec[i,k,0] <> 99)
                     and (phrec[i,k,0] <> 100)
                  then id := false
                  else
E 2
I 2
procedure AskInteger(var i: integer);
I 7
var
   success: boolean;
E 7
begin
D 5
   while not eof and not ReadInteger(i) do
E 5
I 5
D 7
   while not eof and not ReadInteger(input, i) do
E 5
      write('integer expected, enter an integer: ')
E 7
I 7
   success := false;
   repeat
      if ReadInteger(input, i) then
	 success := true
      else
	 write('syn03: integer expected, enter an integer: ');
      readln
   until success
E 7
end; { AskInteger }
E 2

D 2
                  begin ko[rg+j,11] := 0;
                        if phrec[i,k,1] <> 0         { morf. condities }
                        then begin
                               n:= 0; c:= 0; m:= rg+j;
                               repeat n:= n+1; c:= phrec [i, k, n];
                                        if c <> 0 then id := conditie(c,m)
                               until (c=0) or (id = false);
                             end;
                  end;
E 2

D 2
              until (id = false) or
                    (phrec [i,k,0] = 100) or       { vervolg            }
                    (phrec [i,k,0] = 99);          { eindsymbool phrase }
                    if phrec [i,k,0] = 99
                    then id := true;
                    if phrec [i,k,0] = 100
                    then                               { for m := 1 to k+1 do begin l:=phrec [i,j,0];}
                    begin j:= -1; repeat                {                   write(l:3); end; writeln; }
                                    k:= k+1; j:= j+1;
                                    ko[rg+j,11] := phrec [i,k,0]
                                 until phrec [i,k+1,0] = 100;
                          k:= k+1;
                          j:= -1 ;repeat
                                    k := k+1; j := j+1;
                                    ko[rg+j,12] := phrec [i,k,0]
                                 until phrec [i,k+1,0] = 100;
                          rg := rg + j;
                          ko [ rg,13 ] := i;
                    end;
E 2
I 2
function EmptyFile(var f: text):boolean;
begin
   reset(f);
   while not eof(f) and (f^ = ' ') do
      get(f);
   EmptyFile := eof(f)
end; { EmptyFile }
E 2

D 2
              if ( id ) and ( phrec [i,k,0] = 99)
              then begin j:= j-1;
                         wgr := phrec[i,0,0];
                         { writeln(' wgr:',wgr:4,' gevonden in regel:',i:4); }
                         m := rg;                        { begin pos. phrase }
                         rg := rg + j;                   { eind  pos. phrase }
                         l := m-1; repeat l := l+1;
                                     n := ko[l,1];
                                     ko[l,11] := n;          { p. of speech in phrase}
                                     if l < rg then ko[l,12] := 0;
                                   until l = rg;
                         ko [rg,13] := i;                    { regel in data-file}
                         ko [rg,12] := wgr;
E 2

D 2
                   end
       until (id) or (i=maxgr);
                                    { if i= maxgr then writeln(' max groepen');    }
end;
E 2
I 2
procedure CopyFile(var src, dst: text);
begin
   reset(src);
   rewrite(dst);
   while not eof(src) do begin
      while not eoln(src) do begin
	 dst^ := src^;
	 put(dst);
	 get(src)
      end;
      readln(src);
      writeln(dst)
   end;
   reset(src);
   reset(dst)
end; { CopyFile }
E 2


D 2
procedure maakphrases;
E 2
I 2
procedure MakeFileNames(var name: StringType);
begin
   Ps2Name := name + '.ps2';
   PhdName := name + '.phd';
   CtName := name + '.ct';
   Ps3Name := name + '.ps3'
end; { MakeFileNames }
E 2

D 2
var i,j,x,r,apo,nwrd :       integer;
    ac,aw,ap,phrt    :       integer;
    atomnr,maxatom   :       integer;
    numreg,r1,r2     :       integer;
    gevonden,app     :       boolean;
    k                :       char;
E 2

I 2
D 7
procedure OpenFile(var f:text; name: StringType; mode: integer);
E 7
I 7
procedure OpenFile(var f: text; name: StringType; mode: integer);
E 7
var
   error: integer;
begin
D 7
   error := 0; { Dummy statement to fool the compiler: error is set before used }
E 7
I 7
   error := 0; (* Shuts off compiler warning *)
E 7
   case mode of
      READ:
	 begin
	    open(f, name, 'old', error);
D 10
	    if error <> 0 then begin
E 10
I 10
	    if error <> 0 then
	    begin
E 10
D 7
	       writeln('syn03: cannot open ', name, ', please run syn02.');
	       halt
E 7
I 7
	       writeln('syn03: cannot open ', name, '.');
	       Die
E 7
	    end;
	    reset(f)
	 end;
      WRITE:
	 begin
	    open(f, name, 'unknown', error);
D 10
	    if error <> 0 then begin
E 10
I 10
	    if error <> 0 then
	    begin
E 10
	       writeln('syn03: cannot create ', name, '.');
D 7
	       halt
E 7
I 7
	       Die
E 7
	    end;
	    rewrite(f)
	 end
   end
end; { OpenFile }
E 2

D 2
begin                                              { begin procedure maakphrases }
E 2

I 7
procedure CloseFile(var f: text);
begin
   close(f)
end;


E 7
D 2
      j := 0;     r := 0;  maxatom := 0; app:= false;
      leegarray;
      read(ct,vvers);  x := 0;                     { tekst uit CT            }
      if bewaar = false then read(divis,vvers)     { x : start tweede phrase }
      else write(divis,vvers);
      repeat j := j+1; read(ct,versreg[j])
      until versreg[j] = '*';
      readln(ct);
      j := 0;
      repeat j:= j+1; read(ps2,vvers);             { data uit PS2            }
                      if j=1 then begin versnr := vvers;
                                        writeln(versnr);
                                  end;
                      if versnr = vvers then
                      begin
                            for i := 1 to 18 do read(ps2,linelex[j,i]);
                            i := -1;
                            repeat i:= i+1; read(ps2,ko[j,i])
                            until i = 13;
                            if bewaar = false then
                            begin read(divis,r);
                                  ko[j,11]:=r; ko[j,12] := 0;
                                  read(divis,k,k);
                                  if k = ':'
                                  then begin read(divis,r); ko[j,12]:= r;
                                       end;
                            end;
                      end;
                      readln(ps2)
      until (j>1) and (versnr <> vvers); j:= j-1;
      if bewaar = false then readln(divis);
E 2
I 2
D 3
procedure OpenFiles;
E 3
I 3
procedure OpenFiles(var name: StringType);
I 10
var
   error : integer;
E 10
E 3
begin
I 10
   (* Dummy statement to fool the compiler so it does not complain
    * about error neither being used nor set. *)
   error := 0;
   
E 10
   OpenFile(PsIn, Ps2Name, READ);
   OpenFile(PsOut, Ps3Name, WRITE);
   OpenFile(TextFile, CtName, READ);
D 3
   OpenFile(DivisionsFile, PhdName, READ);
E 3
I 3
D 10
   open(DivisionsFile, name + '.phd', 'unknown');
E 3
   open(PartialDivFile, 'partdivis', 'unknown');
E 10
I 10
   open(DivisionsFile, name + '.phd', 'unknown', error);
   open(PartialDivFile, 'partdivis', 'unknown', error);
E 10
   OpenFile(PhrasesFile, 'phrset', READ);
D 3
   OpenFile(ConditionsFile, 'morfcond', READ)
E 3
I 3
   OpenFile(ConditionsFile, 'morfcond', READ);
   OpenFile(LexConditionsFile, 'lexcond', READ);
I 10
   OpenFile(NewPhraseSet, 'PHR', WRITE);
E 10
E 3
end; { OpenFiles }
E 2

D 2
      areg   := areg +1;
      nwrd   := 0;
      aw     := 0;
      atomnr := 0;
      numreg := 0;
E 2

D 2
if bewaar then
   repeat i := nwrd;
E 2
I 2
procedure ReadStage(var name: StringType);
var
D 7
   error:	integer;
E 7
   stage:	integer;
D 7
   ch,answer:   char;
E 7
I 7
   answer:      char;
E 7
   question:    StringType;
begin
D 7
   error := 0; { Dummy statement to fool the compiler: error is set before used }
   open(StageFile, 'synnr', 'old', error);
   if error <> 0 then begin
      writeln('syn03: cannot open synnr');
      halt
   end;
E 7
I 7
   OpenFile(StageFile, STAGE_FILE_NAME, READ);
E 7
   reset(StageFile);
D 7
   read(StageFile, stage, ch, name);
   if stage <> 2 then 
   begin if stage = 3 then
D 3
      begin question := 'you want to redo stage 3 ("syn03") ?';
E 3
I 3
      begin question := 'you want to continue  stage 3 ("syn03") ?';
E 3
         answer := GetAnswer(question,YES_NO);
         if answer in NO then halt;
      end
D 3
      else
E 3
I 3
      else if stage < 2 then
E 3
      begin
         writeln('syn03: ', stage:1, ': wrong stage');
	 writeln(' run syn02 first');
         halt
      end
   end
E 7
I 7
   read(StageFile, stage);
   SkipSpace(StageFile);
   read(StageFile, name);
D 12
   if stage < 2 then begin
E 12
I 12
   if stage < 2 then
   begin
E 12
      writeln('syn03: ', stage:1, ': wrong stage, run syn02 first');
      Die
D 12
   end else if stage = 2 then begin
E 12
I 12
   end else if stage = 2 then
   begin
E 12
      (* the common case *)
D 12
   end else if stage = 3 then begin
E 12
I 12
   end else if stage = 3 then
   begin
      writeln;
E 12
D 10
      question := 'Do you want to continue stage 3? ';
E 10
I 10
      question := 'Do you want to continue stage 3? [y/n]: ';
E 10
      answer := GetAnswer(question, YES_NO);
      if answer in NO then
	 Die;
D 12
   end else if stage > 3 then begin
      writeln('syn03: stage 3 has already been finished');
      Die
E 12
I 12
   end else if stage > 3 then
   begin
      writeln;
      writeln('WARNING: Stage file says ', stage:1, '!');
      question := 'Do you really want to do stage 3? [y/n]: ';
      answer := GetAnswer(question, YES_NO);
      if answer in NO then
	 Die;
E 12
   end;
   CloseFile(StageFile)
E 7
end; { ReadStage }
E 2

D 2
      repeat i := i + 1;
        wgr :=  ko[i,1];
        psp :=  ko[i,1];
        lex :=  linelex[i];
        zoekphrases(i,psp)
      until i >= j;
E 2

I 7
procedure WriteStage(name: StringType);
begin
   OpenFile(StageFile, STAGE_FILE_NAME, WRITE);
   rewrite(StageFile);
   writeln(StageFile, '3 ', name);
   CloseFile(StageFile)
end; { WriteStage }


E 7
D 2
                                                             { scherm uitvoer }
   ac     := 0;   r    := 0;    i := 0;
   ap     := 0;   x    := 0;  apo := 0;
E 2
I 2
D 10
procedure schrijflex(var linrec: LexemeListType; j: integer);
E 10
I 10
procedure WriteLex(var linrec: LexemeListType; j: integer);
E 10
begin
   write(PsOut, VerseLabel);
   write(PsOut, linrec[j])
D 10
end; { schrijflex }
E 10
I 10
end; { WriteLex }
E 10
E 2

D 2
   if nwrd > 0 then                               { nwrd ingelezen van scherm }
   begin  aw     := aw -1;                        { begin woord voor atomnr   }
          atomnr := atomnr -1;
          ac     := 0;
          repeat ac := ac + 1; if versreg[ac] in [' ','-']
                               then apo := apo + 1
          until apo = aw;
E 2

D 2
          i  := nwrd;
E 2
I 2
D 10
procedure schrijfwoord(j: integer);
E 10
I 10
procedure WriteColumns(j: integer);
E 10
var
   p: integer;
begin
   write(PsOut, AnalysisList[j, 0]: 3);
   write(PsOut, AnalysisList[j, PSP]: 4);
   for p := 2 to 6 do
      write(PsOut, AnalysisList[j, p]: 3);
   write(PsOut, AnalysisList[j, 7]: 5);
   for p := 8 to 10 do
      write(PsOut, AnalysisList[j, p]: 3);
D 3
   write(PsOut, AnalysisList[j, PHRDEP_PSP]: 10);
E 3
I 3
   write(PsOut, AnalysisList[j, STATE]: 8);
   write(PsOut, AnalysisList[j, PHRDEP_PSP]:  4);
E 3
   write(PsOut, AnalysisList[j, PHRASE_TYPE]: 4);
I 3
   write(PsOut, AnalysisList[j, DETERMINATION]: 4);
E 3
D 8
   writeln(PsOut, AnalysisList[j, CLAUSE_MARK]: 6)
E 8
I 8
   writeln(PsOut, AnalysisList[j, LINE_IN_SET]: 6)
E 8
D 10
end; { schrijfwoord }
E 10
I 10
end; { WriteColumns }
E 10
E 2

I 2

procedure ClearAnalysisList(var list: AnalysisListType);
var
   word_index:		WordIndexType;
   function_index:	FunctionIndexType;
begin
   for word_index := 1 to MAX_VERSE_WORDS do
      for function_index := FIRST_FUNCTION to LAST_FUNCTION do
D 10
	 list[word_index, function_index] := UNDEFINED
E 10
I 10
	 list[word_index, function_index] := UNDEFINED;
E 10
end; { ClearAnalysisList }


D 10
procedure schrijftype(phr_type: integer);
E 10
I 10
procedure WriteType(phr_type: integer);
E 10
const
   WIDTH = -8;
var
   apposition: boolean;
begin
   apposition := phr_type < -1;
   case abs(phr_type) of
      0:
	 write(' ----': WIDTH);
      1:
	 write(' VP': WIDTH);
      2:
	 if apposition then
	    write(' NP app': WIDTH)
	 else
	    write(' NP': WIDTH);
      3:
	 if apposition then
	    write(' NPnpr app': WIDTH)
	 else
	    write(' NPnpr': WIDTH);
      4:
	 write(' AdvP': WIDTH);
      5:
	 write(' PP': WIDTH);
      6:
	 write(' CjP': WIDTH);
      7, 8, 9:
	 write(' NPpron': WIDTH);
      10:
	 write(' IntjP': WIDTH);
      11:
	 write(' NegP': WIDTH);
      12:
	 write(' IntrgP': WIDTH);
      13:
	 write(' NPadj': WIDTH);
D 3
      20:
	 if apposition then
	    write(' NPdet app': WIDTH)
	 else
	    write(' NPdet': WIDTH);
E 3
E 2
   end
I 2
D 10
end; { schrijftype }
E 10
I 10
end; { WriteType }
E 10

I 7

E 7
I 3
D 10
function lexconditie(c:integer; word_index: WordIndexType): boolean;
E 10
I 10
function LexCondition(c:integer; word_index: WordIndexType): boolean;
E 10
var
   condition_met:	boolean;
D 10
   value_index:		ValueIndexType;
E 10
begin
D 10
   value_index := 1;
   { writeln(' uit LexemeList (PS2) :', LexemeList[word_index]);
   writeln(' uit Lexcond :', LexCondList[ConditionList[c].ValueList[value_index] ]);}   {test}
   if
   LexemeList[word_index]= LexCondList[ConditionList[c].ValueList[value_index] ]
   then condition_met := true
   else condition_met := false;
E 10
I 10
   if LexemeList[word_index]= LexCondList[c-100] then
      condition_met := true
   else
      condition_met := false;
E 10
   
D 10
   lexconditie := condition_met;
end;  {lexconditie }
E 10
I 10
   LexCondition := condition_met;
end;  {LexCondition }
E 10
E 3

I 7

E 7
D 10
function conditie(c:integer; word_index: WordIndexType): boolean;
E 10
I 10
function MorphCondition(c:integer; word_index: WordIndexType): boolean;
E 10
var
   function_index:	FunctionIndexType;
   value_index:		ValueIndexType;
   condition_index:	ConditionIndexType;
   condition_met:	boolean;
begin
   condition_index := abs(c);
   function_index := ConditionList[condition_index].FunctionIndex;
   value_index := 1;
   repeat
      condition_met := (
	 AnalysisList[word_index, function_index] =
	 ConditionList[condition_index].ValueList[value_index]
      );
      value_index := value_index + 1
   until condition_met or { test on value_index is missing }
	 (ConditionList[condition_index].ValueList[value_index - 1] = EOI);
   if c < 0 then
I 3
      begin { writeln(' negative condition found, "condition_met":',condition_met); }
E 3
D 10
      conditie := not condition_met
E 10
I 10
      MorphCondition := not condition_met
E 10
I 3
      end
E 3
E 2
   else
D 2
   atomnr := 0;
E 2
I 2
D 10
      conditie := condition_met
end; { conditie }
E 10
I 10
      MorphCondition := condition_met
end; { MorphCondition }
E 10
E 2

D 2
   ap := atomnr;  numreg := 1;  r := 0;
E 2

D 2
   write('phr-atom',(ap+1):3,' ');
   repeat ac := ac + 1; r := r + 1;
         write(versreg[ac]); if versreg[ac] in [' ','-']
                             then begin aw := aw + 1;        { aantal woorden }
                                     if ko[aw,12] <> 0
                                     then
                                     begin ap := ap + 1;     { aantal phrases }
                                           phrt := ko[aw,12];
                                           numreg := numreg + 1;
                                           while r < 30 do
                                              begin r := r+1;write(' ');
                                              end; write('[');
                                           schrijftype(phrt);
                                           writeln('] ');
                                           r := 0;
                                           if (versreg[ac+1] <> '*') and
                                              (numreg <= 15 )
                                           then
                                           write('phr-atom',(ap+1):3,' ');
                                     end;
                                  end
      until (versreg[ac] = '*') or (numreg > 15);    maxatom := ap;
      writeln;
      atomnr := ap;
E 2
I 2
D 10
procedure zoekphrases(var word_index: integer; psp: integer);
E 10
I 10
procedure seekphrases(var word_index: integer);
E 10
(* Returns in word_index the last word of the phrase *)
(* All kinds of side effects on AnalysisList *)
var
D 10
   condition_index:	integer;
   condition_nr:	integer;
   identical:		boolean;
   phrase_type:		integer;
   phrtype_index:	integer;
   word_offset:		integer;
I 3
D 4
   previous_value:	integer;
E 4
E 3
   wrd_nr:		integer;	(* Word number within a certain type of phrase *)
E 10
I 10
   condition_index : integer;
   condition_nr	   : integer;
   identical	   : boolean;
D 12
   phrase_type	   : integer;
E 12
   phrtype_index   : integer;
I 12
   phrase_length   : integer;
E 12
   word_offset	   : integer;
   wrd_nr	   : integer;
   limit	   : integer;
   psp		   : integer;
E 10
begin
   phrtype_index := 0;
I 10
   psp := AnalysisList[word_index, PSP];
   Lexeme := LexemeList[word_index];
   
E 10
   repeat
      phrtype_index := phrtype_index + 1
   until (Resolver[phrtype_index, 1, 0] = psp) or (phrtype_index = PhraseCount);
   phrtype_index := phrtype_index - 1;
   identical := true;
   repeat
      phrtype_index := phrtype_index + 1;
      word_offset := -1;
      wrd_nr := 0;
      identical := true;
      repeat
	 word_offset := word_offset + 1;
	 wrd_nr := wrd_nr + 1;
D 12
	 if
	    (AnalysisList[word_index + word_offset, PSP] <> Resolver[phrtype_index, wrd_nr, 0]) and
	    (Resolver[phrtype_index, wrd_nr, 0] <> EOI) and (Resolver[phrtype_index, wrd_nr, 0] <> 100)
	 then
E 12
I 12
	 if (AnalysisList[word_index + word_offset, PSP] <> Resolver[phrtype_index, wrd_nr, 0]) and
	    (Resolver[phrtype_index, wrd_nr, 0] <> 100) then
E 12
	    identical := false
D 10
	 else begin
E 10
I 10
	 else
	 begin
E 10
D 12
	    AnalysisList[word_index + word_offset, PHRDEP_PSP] := 0; (* Aargh, side effects *)
E 12
D 10
	    if Resolver[phrtype_index, wrd_nr, 1] <> 0 then begin
E 10
I 10
	    if Resolver[phrtype_index, wrd_nr, 1] <> 0 then
	    begin
E 10
	       condition_index := 0;
	       condition_nr := 0;
	       repeat
		  condition_index := condition_index + 1;
		  condition_nr := Resolver[phrtype_index, wrd_nr, condition_index];
D 3
		  if condition_nr <> 0 then
		     identical := conditie(condition_nr, word_index + word_offset)
E 3
I 3
D 7
		  if (condition_nr <> 0) and (condition_nr < LEX_CONDITIONS) then    { > 100 : lexical conditions }
E 7
I 7
		  if (condition_nr <> 0) and (condition_nr < LC_OFFSET) then    { > 100 : lexical conditions }
E 7
D 10
		     identical := conditie(condition_nr, word_index + word_offset);
E 10
I 10
		     identical := MorphCondition(condition_nr, word_index + word_offset);
E 10
D 7
                  if (condition_nr > LEX_CONDITIONS) then
E 7
I 7
                  if (condition_nr > LC_OFFSET) then
E 7
D 10
		  begin { writeln ('conditie-nr > 100 gevonden');  }                   { test }
		     identical := lexconditie(condition_nr, word_index + word_offset);
		  end
E 10
I 10
		     identical := LexCondition(condition_nr, word_index + word_offset);
E 10

I 10

E 10
E 3
	       until (condition_nr = 0) or not identical or (condition_index = MAX_WORD_CONDITIONS)
	    end
	 end
D 12
      until
	 not identical or
	 (Resolver[phrtype_index, wrd_nr, 0] = 100) or
	 (Resolver[phrtype_index, wrd_nr, 0] = EOI);
I 3
								 { phrase-dependent info }
E 3
      if Resolver[phrtype_index, wrd_nr, 0] = EOI then
	 identical := true;
D 3
      if Resolver[phrtype_index, wrd_nr, 0] = 100 then begin
E 3
I 3
D 10
      if Resolver[phrtype_index, wrd_nr, 0] = 100 then begin     { fill in col 11 : State }
E 10
I 10
      if Resolver[phrtype_index, wrd_nr, 0] = 100 then
      begin
	 { fill in col 11 : State }
E 10
E 3
	 word_offset := -1;
	 repeat
	    wrd_nr := wrd_nr + 1;
	    word_offset := word_offset + 1;
I 3
D 4
	    previous_value := AnalysisList[word_index + word_offset, STATE];
	    if (previous_value > -1) and
	    (previous_value <> Resolver[phrtype_index, wrd_nr, 0]) then begin
	       writeln (VerseLabel, " word: " word_index, " former state: "
	       previous_value, " new state: " Resolver[phrtype_index, wrd_nr, 0]);
	    end;
E 4
	    AnalysisList[word_index + word_offset, STATE] :=
	       Resolver[phrtype_index, wrd_nr, 0]
         until Resolver[phrtype_index, wrd_nr + 1,0] = 100;
E 12
I 12
      until (not identical or
	     (Resolver[phrtype_index, wrd_nr, 0] = 100));
   until identical or (phrtype_index = PhraseCount);

   if not identical then
   begin
      AnalysisList[word_index, PHRDEP_PSP] := AnalysisList[word_index, PSP];
      AnalysisList[word_index, PHRASE_TYPE] := AnalysisList[word_index, PSP];
   end else
   begin
      { fill in col 11 : State }
      word_offset := -1;
      repeat
E 12
	 wrd_nr := wrd_nr + 1;
D 10
	 word_offset := -1;                                      { fill in col 12: Phr.dep part of speech}
E 10
I 10
D 12
	 word_offset := -1;
E 12
I 12
	 word_offset := word_offset + 1;
	 AnalysisList[word_index + word_offset, STATE] :=
	 Resolver[phrtype_index, wrd_nr, 0]
      until Resolver[phrtype_index, wrd_nr + 1,0] = 100;
      wrd_nr := wrd_nr + 1;
      phrase_length := word_offset;
      word_offset := -1;
E 12

D 12
	 { fill in col 12: Phr.dep part of speech}
E 10
	 repeat
	    wrd_nr := wrd_nr + 1;
	    word_offset := word_offset + 1;
E 3
	    AnalysisList[word_index + word_offset, PHRDEP_PSP] :=
	       Resolver[phrtype_index, wrd_nr, 0]
	 until Resolver[phrtype_index, wrd_nr + 1, 0] = 100;
E 12
I 12
      { fill in col 12: Phr.dep part of speech}
      repeat
E 12
	 wrd_nr := wrd_nr + 1;
D 3
	 word_offset := -1;
E 3
I 3
D 10
	 word_offset := -1;                                      { fill in col 13: Phrase Type }
E 10
I 10
D 12
	 word_offset := -1;
E 12
I 12
	 word_offset := word_offset + 1;
	 AnalysisList[word_index + word_offset, PHRDEP_PSP] :=
	 Resolver[phrtype_index, wrd_nr, 0]
      until Resolver[phrtype_index, wrd_nr + 1, 0] = 100;
      wrd_nr := wrd_nr + 1;
      word_offset := -1;
E 12

D 12
	 { fill in col 13: Phrase Type }
E 10
E 3
	 repeat
	    wrd_nr := wrd_nr + 1;
	    word_offset := word_offset + 1;
	    AnalysisList[word_index + word_offset, PHRASE_TYPE] :=
	       Resolver[phrtype_index, wrd_nr, 0]
I 3
         until Resolver[phrtype_index, wrd_nr + 1, 0] = 100;
E 12
I 12
      { fill in col 13: Phrase Type }
      repeat
E 12
D 10
	 wrd_nr := wrd_nr + 1;                                   { fill in col 14: Determination }
E 10
I 10
	 wrd_nr := wrd_nr + 1;
I 12
	 word_offset := word_offset + 1;
	 AnalysisList[word_index + word_offset, PHRASE_TYPE] :=
	 Resolver[phrtype_index, wrd_nr, 0]
      until Resolver[phrtype_index, wrd_nr + 1, 0] = 100;
      wrd_nr := wrd_nr + 1;
E 12

D 12
	 { fill in col 14: Determination }
E 10
	 word_offset := -1;
	 repeat
	    wrd_nr := wrd_nr + 1;
	    word_offset := word_offset + 1;
	    AnalysisList[word_index + word_offset, DETERMINATION] :=
	       Resolver[phrtype_index, wrd_nr, 0]
E 3
	 until Resolver[phrtype_index, wrd_nr + 1, 0] >= EOI;
D 3
	 word_index := word_index + word_offset;
E 3
I 3
D 10
	 word_index := word_index + word_offset;                 { fill in col 15: Phrase Type Index}
E 10
I 10
	 word_index := word_index + word_offset;
	 
	 { fill in col 15: Phrase Type Index}
E 10
E 3
D 8
	 AnalysisList[word_index, CLAUSE_MARK] := phrtype_index
E 8
I 8
	 AnalysisList[word_index, LINE_IN_SET] := phrtype_index
E 8
      end;
D 10
      if identical and (Resolver[phrtype_index, wrd_nr, 0] = EOI) then begin
E 10
I 10

E 12
I 12
      { fill in col 14: Determination }
      word_offset := -1;
      repeat
	 wrd_nr := wrd_nr + 1;
	 word_offset := word_offset + 1;
	 AnalysisList[word_index + word_offset, DETERMINATION] :=
	 Resolver[phrtype_index, wrd_nr, 0]
      until Resolver[phrtype_index, wrd_nr + 1, 0] >= EOI;
D 13
      word_index := word_index + word_offset;
E 13
I 13
      word_index := word_index + phrase_length;
E 13
E 12
      
D 12
      if identical and (Resolver[phrtype_index, wrd_nr, 0] = EOI) then
      begin
E 10
(*	 word_offset := word_offset - 1;*)
	 phrase_type := Resolver[phrtype_index, 0, 0];
D 10
	 for word_index := word_index to word_index + word_offset - 1 do begin
	    AnalysisList[word_index, PHRDEP_PSP] := AnalysisList[word_index, PSP];
E 10
I 10
	 
	 limit := word_index + word_offset - 1;
	 word_index := word_index - 1;
	 repeat
	    word_index := word_index + 1;
	    AnalysisList[word_index, PHRDEP_PSP] :=
	    AnalysisList[word_index, PSP];
E 10
	    AnalysisList[word_index, PHRASE_TYPE] := 0
D 10
	 end;
E 10
I 10
	 until word_index = limit;
	 
E 10
	 AnalysisList[word_index, PHRDEP_PSP] := AnalysisList[word_index, PSP];
D 8
	 AnalysisList[word_index, CLAUSE_MARK] := phrtype_index;
E 8
I 8
	 AnalysisList[word_index, LINE_IN_SET] := phrtype_index;
E 8
	 AnalysisList[word_index, PHRASE_TYPE] := phrase_type
      end
   until identical or (phrtype_index = PhraseCount)
E 12
I 12
      { fill in col 15: Phrase Type Index}
      AnalysisList[word_index, LINE_IN_SET] := phrtype_index
   end;

E 12
D 10
end; { zoekphrases }
E 10
I 10
end; { seekphrases }
E 10
E 2


I 7
procedure WriteState(state: integer);
begin
   case state of
D 8
      -1: write('nap');
       0: write('unk');
       1: write('cst');
       2: write('abs')
E 8
I 8
      -1: write(' nap');
       0: write(' unk');
       1: write(' cst');
       2: write(' abs')
E 8
   end
end;

D 8

E 7
D 2
   if tonen then
E 2
I 2
procedure maakphrases(var f: text; var div_count: integer);
E 8
I 8
procedure ReadPhdFile(var f : text; var div_count : integer; var word_index : integer);
E 8
var
D 8
   chars_written:	integer;
   chr_index:	integer;
   answer,ch:	char;
   ap:	integer;
   apposition:	boolean;
   atomnr:	integer;
   aw:	integer;
   i:	integer;
   maxatom:	integer;
   numreg:	integer;
   nwrd:	integer;
   phr_cnt:		integer;
   ps_verse_label:	VerseLabelType;
   question:		StringType;
D 3
   r:	integer;
E 3
I 3
   r,r1,r2 :	integer;
E 3
   wgr:	integer;
   word_index:	integer;
   wrd_cnt:	integer;
   x:	integer;
I 3

E 8
I 8
D 10
   r1,r2	  : integer;
   ps_verse_label : VerseLabelType;
   i		  : integer;
   ch		  : char;
E 10
I 10
   r1,r2	     : integer;
   ps_verse_label    : VerseLabelType;
   i		     : integer;
   ch		     : char;
   wrd_index	     : integer;
   FirstWordOfPhrase : integer;
E 10
E 8
D 7
   procedure writestate( st: integer);
   begin
      case st of -1 : write('nap');
		  0 : write('unk');
		  1 : write('cst');
		  2 : write('abs');
      end;
   end;
E 7
E 3
begin
D 8
   r := 0;
   maxatom := 0;
   apposition := false;
   ClearAnalysisList(AnalysisList);
E 8
D 7
   if  div_count = NumberOfDivisions then 
E 2
   begin
E 7
I 7
D 10
   if  div_count = NumberOfDivisions then begin
E 10
I 10
   if  div_count = NumberOfDivisions then
   begin
E 10
E 7
D 2
     writeln(' division in phrase-atoms ok? ');
     repeat read(antw)
     until antw in ['j','n','y','Y','J','N'];
     readln;
     if antw in ['n','N']
     then begin apo := 0;
                repeat writeln(' give number of first incorrect phrase-atom');
                       read(apo); readln; if apo < 1 then
                                          writeln(' not < 1 !')
                                     else if apo > maxatom then
                                          writeln(' not > max atoms:',maxatom:3);
                until (apo > 0) and (apo <= maxatom);
                atomnr := apo;
                apo := 0;  aw := 0;
                if atomnr > 1 then
                repeat aw := aw + 1; if ko[aw,12] <> 0
                                   then apo := apo + 1
                until apo = atomnr-1; aw := aw + 1;       { start lexeem atomnr }
E 2
I 2
   { number of lines in DivisionsFile = number of lines in Textfile }
      StoreDivisions := true;
      Incomplete := false;
D 3
      writeln('No (further) information found file ', PhdName, '.');
E 3
I 3
      writeln('No (further) information found in file ', PhdName, '.');
E 3
D 10
      writeln('Awaiting now info from you ... ');
E 10
I 10
      writeln('Awaiting info from you now ... ');
E 10
      writeln('< hit  Return >'); readln;
   end;
I 10
   
E 10
   read(TextFile, ps_verse_label);
D 8
   x := 0;
E 8
D 7
   if Incomplete then
      begin read(PartialDivFile, ps_verse_label);
	    writeln(' partdivis',ps_verse_label);
      end	    else
   if not StoreDivisions then
E 7
I 7
D 10
   if Incomplete then begin
E 10
I 10

   if Incomplete then
   begin
E 10
      read(PartialDivFile, ps_verse_label);
      writeln(' partdivis',ps_verse_label);
   end else if not StoreDivisions then
E 7
      read(DivisionsFile, ps_verse_label);
   readln(TextFile, VerseLine);
I 10


E 10
D 7
                                                  (* read a verse from ps-file *)
E 7
I 7
   (* read a verse from ps-file *)
E 7
   word_index := 0;
   repeat
      word_index := word_index + 1;
      read(f, ps_verse_label);
D 10
      if word_index = 1 then begin
E 10
I 10
      if word_index = 1 then
      begin
E 10
	 VerseLabel := ps_verse_label;
D 10
	 { ClearScreen; }
	 writeln(VerseLabel)
E 10
I 10
	 writeln(VerseLabel);
E 10
      end;
D 7
      if ps_verse_label = VerseLabel then 
      begin
D 3
	 for i := 1 to LEXEME_LENGTH do
E 3
I 3
	 for i := 1 to LEXEME_LENGTH do { begin }
E 7
I 7
D 10
      if ps_verse_label = VerseLabel then begin
E 10
I 10
      
      if ps_verse_label = VerseLabel then
      begin
E 10
	 for i := 1 to LEXEME_LENGTH do
E 7
E 3
	    read(f, LexemeList[word_index, i]);
D 3
	 for i := 0 to 13 do
E 3
I 3
D 7
	    { write( LexemeList[word_index, i]);
	    end; writeln;                      test}

E 7
D 10
	 for i := 0 to 13 { after revision of syn02: LAST_FUNCTION } do
E 10
I 10
D 13
	 for i := 0 to 13 do
E 13
I 13
	 for i := 0 to 11 do
E 13
E 10
E 3
D 5
	    read(f, AnalysisList[word_index, i]);
         if not StoreDivisions then
	 begin
D 3
	    if Incomplete then read(PartialDivFile ,r) 
	                  else read(DivisionsFile, r);
	    AnalysisList[word_index, PHRDEP_PSP] := r;
E 3
I 3
	    if Incomplete then read(PartialDivFile ,r1,r2)       { STATE, PHRDEP_PSP } 
	                  else read(DivisionsFile, r1,r2);
E 5
I 5
	    if not ReadInteger(f, AnalysisList[word_index, i]) then
	    begin
D 7
	       writeln('integer expected (word_index is ', word_index:0, ')');
	       exit
E 7
I 7
	       writeln('syn03: integer expected (word_index is ', word_index:0, ')');
	       Die
E 7
	    end;
D 10
         if not StoreDivisions then begin
	    if Incomplete then begin
	       if not ReadInteger(PartialDivFile, r1) then begin
D 7
		  writeln('integer expected when reading state from partdivis (word_index is ', word_index:0, ')');
		  exit
E 7
I 7
D 9
		  writeln('syn03: integer expected when reading state from partdivis (word_index is ', word_index:0, ')');
E 9
I 9
		  writeln('syn03: integer expected while reading state from partdivis (word_index is ', word_index:0, ')');
E 10
I 10
         if not StoreDivisions then
	 begin
	    if Incomplete then
	    begin
	       if not ReadInteger(PartialDivFile, r1) then
	       begin
D 11
		  writeln('syn03: integer expected when reading state from partdivis (word_index is ', word_index:0, ')');
E 11
I 11
		  writeln('syn03: integer expected while reading state from partdivis (word_index is ', word_index:0, ')');
E 11
E 10
E 9
		  Die
E 7
	       end;
D 10
	       if not ReadInteger(PartialDivFile, r2) then begin
D 7
		  writeln('integer expected when reading phrase dependent part of speech from partdivis (word_index is ', word_index:0, ')');
		  exit
E 7
I 7
D 9
		  writeln('syn03: integer expected when reading phrase dependent part of speech from partdivis (word_index is ', word_index:0, ')');
E 9
I 9
		  writeln('syn03: integer expected while reading phrase dependent part of speech from partdivis (word_index is ', word_index:0, ')');
E 10
I 10
	       if not ReadInteger(PartialDivFile, r2) then
	       begin
D 11
		  writeln('syn03: integer expected when reading phrase dependent part of speech from partdivis (word_index is ', word_index:0, ')');
E 11
I 11
		  writeln('syn03: integer expected while reading phrase dependent part of speech from partdivis (word_index is ', word_index:0, ')');
E 11
E 10
E 9
		  Die
E 7
	       end
	    end
	    else begin
D 10
	       if not ReadInteger(DivisionsFile, r1) then begin
D 9
		  writeln('integer expected when reading state from phd (word_index is ', word_index:0, ')');
E 9
I 9
		  writeln('integer expected while reading state from phd (word_index is ', word_index:0, ')');
E 10
I 10
	       if not ReadInteger(DivisionsFile, r1) then
	       begin
D 11
		  writeln('integer expected when reading state from phd (word_index is ', word_index:0, ')');
E 11
I 11
		  writeln('integer expected while reading state from phd (word_index is ', word_index:0, ')');
E 11
E 10
E 9
D 7
		  exit
E 7
I 7
		  Die
E 7
	       end;
D 10
	       if not ReadInteger(DivisionsFile, r2) then begin
D 9
		  writeln('integer expected when reading phrase dependent part of speech from phd (word_index is ', word_index:0, ')');
E 9
I 9
		  writeln('integer expected while reading phrase dependent part of speech from phd (word_index is ', word_index:0, ')');
E 10
I 10
	       if not ReadInteger(DivisionsFile, r2) then
	       begin
D 11
		  writeln('integer expected when reading phrase dependent part of speech from phd (word_index is ', word_index:0, ')');
E 11
I 11
		  writeln('integer expected while reading phrase dependent part of speech from phd (word_index is ', word_index:0, ')');
E 11
E 10
E 9
D 7
		  exit
E 7
I 7
		  Die
E 7
	       end
	    end;
E 5
            AnalysisList[word_index, STATE] := r1;
	    AnalysisList[word_index, PHRDEP_PSP] := r2;
I 10

E 10
E 3
D 6
	    AnalysisList[word_index, PHRASE_TYPE] := 0;
I 3
	    AnalysisList[word_index, DETERMINATION] := -1;
E 6
I 6
	    r1 := 0;
	    r2 := UNDEFINED;
E 6
E 3
D 5
	    if Incomplete then SkipSpace(PartialDivFile)
	                  else SkipSpace(DivisionsFile);
            if Incomplete then
	    begin read(PartialDivFile, ch);
		  if ch = ':' then
D 3
		  begin read(PartialDivFile, r);
	                AnalysisList[word_index, PHRASE_TYPE] := r
E 3
I 3
		  begin read(PartialDivFile, r1,r2);             { PHRASE_TYPE, DETERMINATION }
	                AnalysisList[word_index, PHRASE_TYPE] := r1;
			AnalysisList[word_index, DETERMINATION] := r2;
E 3
                  end 
            end else
	    begin read(DivisionsFile, ch);
	          if ch = ':' then
D 3
	          begin read(DivisionsFile, r);
	                AnalysisList[word_index, PHRASE_TYPE] := r
E 3
I 3
	          begin read(DivisionsFile, r1,r2);             { PHRASE_TYPE, DETERMINATION }
	                AnalysisList[word_index, PHRASE_TYPE] := r1;
			AnalysisList[word_index, DETERMINATION] := r2;
E 3
                  end;
	    end
E 5
I 5
	    if Incomplete then
	       SkipSpace(PartialDivFile)
	    else
	       SkipSpace(DivisionsFile);
D 10
            if Incomplete then begin
E 10
I 10
            if Incomplete then
	    begin
E 10
	       read(PartialDivFile, ch);
	       if ch = ':' then begin
D 10
		  if not ReadInteger(PartialDivFile, r1) then begin
E 10
I 10
		  if not ReadInteger(PartialDivFile, r1) then
		  begin
E 10
		     writeln('integer expected when reading phrase type from partdivis (word_index is ', word_index:0, ')');
D 7
		     exit
E 7
I 7
		     Die
E 7
		  end;
D 10
		  if not ReadInteger(PartialDivFile, r2) then begin
E 10
I 10
		  if not ReadInteger(PartialDivFile, r2) then
		  begin
E 10
		     writeln('integer expected when reading determination from partdivis (word_index is ', word_index:0, ')');
D 7
		     exit
E 7
I 7
		     Die
E 7
		  end
	       end 
            end
D 10
	    else begin
E 10
I 10
	    else
	    begin
E 10
	       read(DivisionsFile, ch);
	       if ch = ':' then begin
D 10
		  if not ReadInteger(DivisionsFile, r1) then begin
E 10
I 10
		  if not ReadInteger(DivisionsFile, r1) then
		  begin
E 10
		     writeln('integer expected when reading phrase type from phd (word_index is ', word_index:0, ')');
D 7
		     exit
E 7
I 7
		     Die
E 7
		  end;
D 10
		  if not ReadInteger(DivisionsFile, r2) then begin
E 10
I 10
		  if not ReadInteger(DivisionsFile, r2) then
		  begin
E 10
		     writeln('integer expected when reading determination from phd (word_index is ', word_index:0, ')');
D 7
		     exit
E 7
I 7
		     Die
E 7
		  end
	       end;
	    end;
	    AnalysisList[word_index, PHRASE_TYPE] := r1;
	    AnalysisList[word_index, DETERMINATION] := r2;
E 5
	 end
      end;
      readln(f)
   until (word_index > 1) and (ps_verse_label <> VerseLabel);
I 10

E 10
   word_index := word_index - 1;
D 10
(**)
E 10
I 10

   (* Read line from file. *)
E 10
   div_count := div_count + 1;
   if Incomplete then 
D 10
   begin readln(PartialDivFile);
      if div_count = NumberOfDivisions then
      begin writeln(' div_count = NumberOfDivisions');
	{ CopyFile(PartialDivFile, DivisionsFile); }
      end;
   end
E 10
I 10
      readln(PartialDivFile)
E 10
   else
   if not StoreDivisions then 
      readln(DivisionsFile);
I 10

D 13
   (* See if we should add new phrases to phrset. *)
E 13
I 13
   (*  Possibly Add new phrases to phrset
    *  if we have just read something from xxx.phd. *)
E 13
   if Incomplete or not StoreDivisions then
   begin
      FirstWordOfPhrase := 1;
      wrd_index := 0;
      repeat
D 13
	 PossiblyDoAddPhrase(word_index + 1, FirstWordOfPhrase);
E 13
I 13
	 PossiblyDoAddPhrase(word_index, FirstWordOfPhrase);
E 13
	 repeat
	    wrd_index := wrd_index + 1;
	    if AnalysisList[wrd_index, PHRASE_TYPE] <> 0 then
	       FirstWordOfPhrase := wrd_index + 1;
	 until AnalysisList[wrd_index, PHRASE_TYPE] <> 0;
      until wrd_index = word_index;
   end;
E 10
D 8
   
   nwrd := 0;
   aw := 0;
   atomnr := 0;
E 8
I 8
end; { ReadPhdFile }






procedure DoSeekPhrases(LastWordOfPhrase, LastWordOfVerse : integer);
var
   i : integer;
begin   
   i := LastWordOfPhrase;
   repeat
      i := i + 1;
D 10
      Lexeme := LexemeList[i];
      zoekphrases(i, AnalysisList[i, PSP])
E 10
I 10
      seekphrases(i)
E 10
   until i >= LastWordOfVerse;
end; { DoSeekPhrases }


I 10
procedure Write_4_Char_PSP(psp : integer);
begin
   if psp < 0 then
      psp := -psp;
   
   case psp of
     0	: write(' art');
     1	: write('verb');
     2	: write('noun');
     3	: write('prop');
     4	: write('advb');
     5	: write('prep');
     6	: write('conj');
     7	: write('prsp');
     8	: write('demp');
     9	: write('intp');
     10	: write('intj');
     11	: write(' neg');
     12	: write('intr');
     13	: write(' adj');
     14	: write('....');
   end;
end;
E 10

D 10
procedure ShowPhraseAtoms(			
			      LastWordOfPhrase	: integer;
			  var maxatom		: integer;
			  var FirstWordOfPhrase	: integer;
			  var BadAtomNr		: integer);
E 10
I 10

procedure ShowPhraseAtoms(    FirstWordOfPhrase	: integer;		
			      LastWordOfVerse	: integer;
			  var maxatom		: integer);
E 10
var
D 10
   chr_index	 : integer;
   wrd_cnt	 : integer;
   chars_written : integer;
   numreg	 : integer;
   AtomPosition	 : integer;
E 10
I 10
   chr_index		 : integer;
D 12
   wrd_cnt		 : integer;
E 12
   wrd_show_cnt		 : integer;
   AtomPosition		 : integer;
   LastWordOfFirstPhrase : integer;
   LastWordOfPhrase	 : integer;
I 12
   WeHaveShownSeparator	 : boolean;
E 12
E 10
begin
D 10
   chr_index := 0;
   wrd_cnt:= 0;
E 8
   numreg := 0;
E 10
D 8
   if StoreDivisions then
      repeat { until nwrd >= word_index }
	 i := nwrd;
E 8
I 8

D 10
   if LastWordOfPhrase > 0 then
E 10
I 10
   (* Calculate the character index (- 1) of the first character of the
    * word FirstWordOfPhrase. *)
D 12
   if FirstWordOfPhrase = 1 then
      chr_index := 0
   else
E 10
   begin
D 10
      FirstWordOfPhrase := FirstWordOfPhrase - 1;
      BadAtomNr := BadAtomNr - 1;
E 10
I 10
      wrd_cnt:= 1;
E 10
      chr_index := 0;
      repeat
	 chr_index := chr_index + 1;
	 if VerseLine[chr_index] in [' ', '-'] then
	    wrd_cnt := wrd_cnt + 1;
      until wrd_cnt = FirstWordOfPhrase;
D 10
   end else
      BadAtomNr := 0;
E 10
I 10
   end;
E 12
I 12
   chr_index := 0;
E 12
E 10
   
D 10
   { section 2.3: Show lexemes }
   AtomPosition := BadAtomNr;
   numreg := 1;
   if AtomPosition > 0 then
      writeln(VerseLabel);
   write('Phrase(atom)', AtomPosition + 1: 3, ' ');
   chars_written := 0;
E 10
I 10
D 12
   (* Calculate the last word of the phrase which starts with
    * FirstWordOfPhrase. Needed for the next calculation. *)
   LastWordOfFirstPhrase := FirstWordOfPhrase - 1;
E 10
   repeat
D 10
      chr_index := chr_index + 1;
      chars_written := chars_written + 1;
      write(VerseLine[chr_index]);
      if VerseLine[chr_index] in [' ', '-'] then begin
	 FirstWordOfPhrase := FirstWordOfPhrase + 1;
	 if AnalysisList[FirstWordOfPhrase, PHRASE_TYPE] <> 0 then begin
	    AtomPosition := AtomPosition + 1;
	    numreg := numreg + 1;
	    while chars_written < MAX_SCR_PHRCHARS do begin
	       chars_written := chars_written + 1;
	       write(' ')
	    end;
	    write(AtomPosition: 2, '  [');
	    schrijftype(AnalysisList[FirstWordOfPhrase, PHRASE_TYPE]);
	    writeln(
		    ' # ', AnalysisList[FirstWordOfPhrase, PHRASE_TYPE]:1,
		    ', set # ', AnalysisList[FirstWordOfPhrase, LINE_IN_SET]:1, ']'
		    );
	    chars_written := 0;
	    if (VerseLine[chr_index + 1] <> '*') and (numreg <= MAX_SCR_LINES) then
	       write('Phrase(atom)', AtomPosition + 1: 3, ' ')
	 end
      end
   until (VerseLine[chr_index] = '*') or (numreg > MAX_SCR_LINES);
   maxatom := AtomPosition;
   BadAtomNr := AtomPosition;
E 10
I 10
      LastWordOfFirstPhrase := LastWordOfFirstPhrase + 1;
   until AnalysisList[LastWordOfFirstPhrase, PHRASE_TYPE] <> 0;
   
   (* Calculate the Atom Position of the phrase which starts with
    * FirstWordOfPhrase. *)
E 12
   AtomPosition := 0;
D 12
   wrd_cnt := 0;
   repeat
      wrd_cnt := wrd_cnt + 1;
      if AnalysisList[wrd_cnt, PHRASE_TYPE] <> 0 then
	 AtomPosition := AtomPosition + 1;
   until wrd_cnt = LastWordOfFirstPhrase;
   
E 12
   writeln;
   writeln(VerseLabel);
E 10
D 12

I 10
   (* Go through the AnalysisList and VerseLine, writing phrases and
    * words, starting from FirstWordOfPhrase and ending at LastWordOfVerse.
    *)

   LastWordOfPhrase := FirstWordOfPhrase - 1;
   wrd_show_cnt := FirstWordOfPhrase - 1;
   AtomPosition := AtomPosition - 1;
E 12
I 12
   LastWordOfPhrase := 0;
   wrd_show_cnt := 0;
   AtomPosition := 0;
   WeHaveShownSeparator := false;
E 12
   repeat
      (* Skip ahead to end of phrase *)
      repeat
	 LastWordOfPhrase := LastWordOfPhrase + 1;
      until AnalysisList[LastWordOfPhrase, PHRASE_TYPE] <> 0;
      AtomPosition := AtomPosition + 1;
I 12

      if not WeHaveShownSeparator
	 and ((wrd_show_cnt >= FirstWordOfPhrase)
	      or (FirstWordOfPhrase = 1))then
      begin
	 WeHaveShownSeparator := true;
	 writeln('--------------------------We have come this far----------');
      end;
	 
E 12
      
      write('Phrase (atom) [set # ');

      (* Write line in phrset from which this phrase was recognized. *)
      write(AnalysisList[LastWordOfPhrase, LINE_IN_SET] : 4);
      write(' | ');

      (* Write PSP *)
      Write_4_Char_PSP(AnalysisList[LastWordOfPhrase, PHRASE_TYPE]);
      write('P');

      (* If it is an apposition, say so. *)
      if AnalysisList[LastWordOfPhrase, PHRASE_TYPE] < 0 then
	 write(' app')
      else
	 write(' ...');

      write(' ] ');
      write(AtomPosition : 2);
      write(' : ');

      (* Write words (NOT lexemes!!!). *)
      repeat
	 chr_index := chr_index + 1;	
	 write(VerseLine[chr_index]);
	 if VerseLine[chr_index] in [' ', '-'] then
	    wrd_show_cnt := wrd_show_cnt + 1;
      until wrd_show_cnt = LastWordOfPhrase;
      writeln;
   until LastWordOfPhrase >= LastWordOfVerse;
   maxatom := AtomPosition;
E 10
end; { ShowPhraseAtoms }



procedure ShowBadPhraseAtom(FirstWordOfPhrase : integer; BadAtomNr : integer);
var
   x   : integer;
   wgr : integer;
   r   : integer;
begin

   (* determine the last char in the ct text line preceding the
    ** bad phrase; x is the index to that char, wgr is the number
    ** of words in the ct text preceding the bad phrase
    *)
   x := 0;
   wgr := 0;
   if BadAtomNr > 1 then
      repeat
	 x := x + 1;
	 if VerseLine[x] in [' ', '-'] then
	    wgr := wgr + 1;
      until wgr = FirstWordOfPhrase - 1;
D 10
   { section 2.4.2.4 }
E 10
I 10

E 10
   (* write the verse line with phrase divisions *)
   writeln;
   writeln(VerseLabel);
   writeln('Phrase(atom) no       :   >>', BadAtomNr: 1, '<<');
   write('Text                  :   ');
   r := x;
   repeat
      r := r + 1;
      write(VerseLine[r]);
      if VerseLine[r] in [' ', '-'] then begin
	 wgr := wgr + 1;
	 write('  ');
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('||   ')
      end
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr > FirstWordOfPhrase + 3) or (VerseLine[r] = '*'));
I 10
   
E 10
   writeln;
   wgr := FirstWordOfPhrase - 1;
   write('Word no.              : ');
   r := x;
   repeat
      r := r + 1;
      if VerseLine[r + 1] in [' ', '-'] then begin
	 wgr := wgr + 1;
	 write(wgr: 3);
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('   ||')
      end else
	 write(' ')
      until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr > FirstWordOfPhrase + 3) or (VerseLine[r + 1] = '*'));
   writeln;
end;

   
function AskPhraseType(question: StringType) : integer;
{ This function poses the question in "question", and waits for the
  user to input a character:

  Input char | Meaning         | Output number
  -----------+-----------------+--------------
           H | Article         | 0
           V | Verb            | 1
           N | Noun            | 2
D 10
           P | Proper noun     | 3
E 10
I 10
           n | Proper noun     | 3
E 10
           B | AdverB          | 4
D 10
           K | Preposition     | 5
           J | ConJunction     | 6
E 10
I 10
           P | Preposition     | 5
           C | Conjunction     | 6
E 10
           p | Pers. pronoun   | 7
           D | Demonstr. pron. | 8
           I | Interrog. pron. | 9 
           ! | Interjection    |10
           - | Negative        |11
           ? | Interrogative   |12
           A | Adjective       |13

 If the user types a non-existing char or an l, a list of possibilities
 will be shown.

}
var
   answer : char;
   code	  : integer;
begin
   repeat
      write(question);
      readln(answer);
      code := -1;
      case answer of
D 10
	'H'	: code := 0;
	'V'	: code := 1;
	'N'	: code := 2;
	'B'	: code := 3;
	'P'	: code := 4;
	'K'	: code := 5;
	'J'	: code := 6;
	'p'	: code := 7;
	'D'	: code := 8;
	'I'	: code := 9;
	'!'	: code := 10;
	'-'	: code := 11;
	'?'	: code := 12;
	'A'	: code := 13;
	'l'	: code := -1;
E 10
I 10
	'H'	  : code := 0;
	'V'	  : code := 1;
	'N'	  : code := 2;
	'n'	  : code := 3;
	'B'	  : code := 4;
	'P'	  : code := 5;
	'C'	  : code := 6;
	'p'	  : code := 7;
	'D'	  : code := 8;
	'I'	  : code := 9;
	'!'	  : code := 10;
	'-'	  : code := 11;
	'?'	  : code := 12;
	'A'	  : code := 13;
	'l'	  : code := -1;
	otherwise  code := -1;
E 10
      end; { case }
      if code < 0 then
      begin
D 10
 	 writeln('Article    : H     Preposition    : K     Interjection : !');
 	 writeln('Verb       : V     ConJunction    : J     Negative     : -');
E 10
I 10
 	 writeln('Article    : H     Preposition    : P     Interjection : !');
 	 writeln('Verb       : V     ConJunction    : C     Negative     : -');
E 10
	 writeln('Noun       : N     Pers. Pron.    : p     Interrogative: ?');
D 10
	 writeln('Proper noun: P     Demonstr. Pron.: D     Adjective    : A');
E 10
I 10
	 writeln('Proper noun: n     Demonstr. Pron.: D     Adjective    : A');
E 10
	 writeln('AdverB     : B     Interrog. Pron.: I     List         : l');
      end;
   until code in [0..13];
   AskPhraseType := code;
end;

D 10
procedure AskPhraseTypeAndApposition(LastWordOfPhrase, FirstWordOfPhrase, BadAtomNr : integer );
E 10
I 10

D 12
procedure Show_Phrase_With_PSP_And_STATE(FirstWordOfPhrase, LastWordOfPhrase : integer );
E 12
I 12
procedure Show_State(FirstWordOfPhrase, LastWordOfPhrase, x : integer );
E 12
E 10
var
I 10
D 12
   x   : integer;
E 12
   wgr : integer;
   r   : integer;
begin
I 12

   (* write state to screen *)
   write('State                 : ');
   wgr := FirstWordOfPhrase - 1;
   if x > 1 then r := x
   else  r := 0;
   repeat
      r := r + 1;
      if VerseLine[r + 1] in [' ', '-'] then
      begin
	 wgr := wgr + 1;
	 WriteState(AnalysisList[wgr, STATE]);
	 write(' ');
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('    ||')
      end else write(' ');
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
end; 


procedure Show_Phrase_with_psp(	   FirstWordOfPhrase : integer;
				   LastWordOfPhrase  : integer;
			       var x		     : integer);
var
   wgr : integer;
   r   : integer;
begin
E 12
   (* Find in x character position in VerseLine 1 char before the first word
    * of the phrase starts. *)

   (*  Get index of char one before first char of FirstWordOfPhrase in x. *)
   x := 0;
   if FirstWordOfPhrase = 1 then
      wgr := 0
   else
   begin
      wgr := 0;
      repeat
	 x := x + 1;
	 if VerseLine[x] in [' ', '-'] then
	    wgr := wgr + 1;
      until wgr = FirstWordOfPhrase - 1;
   end;
   
   (* Write the word numbers to the screen, filled out with spaces
    *  for the word length
   *)
   writeln;
   write('Word no.              :');
   if x > 1 then
      r := x
   else
      r := 0;
   repeat
      r := r + 1;
      if VerseLine[r] in [' ', '-'] then
      begin
	 wgr := wgr + 1;
	 write(wgr: 4);
I 12
	 write(' ');
E 12
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('    ||')
      end else
	 write(' ');
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
   writeln;

   
   (* Write the text of the phrase to screen *)
   wgr := FirstWordOfPhrase - 1;
   write('Text of phrase        :    ');
   if x > 1 then
      r := x
   else
      r := 0;
   repeat
      r := r + 1;
      write(VerseLine[r]);
      if VerseLine[r] in [' ', '-'] then
      begin
	 wgr := wgr + 1;
D 12
	 write('   ');
E 12
I 12
	 write('    ');
E 12
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('||   ')
      end
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
   writeln;

   
   (* Write phrase dependent parts of speech to screen *)
   write('Phrdep part of speech : ');
   wgr := FirstWordOfPhrase - 1;
   if x > 1 then
      r := x
   else
      r := 0;
   repeat
      r := r + 1;
D 12
      if VerseLine[r + 1] in [' ', '-'] then begin
E 12
I 12
      if VerseLine[r + 1] in [' ', '-'] then
      begin
E 12
	 wgr := wgr + 1;
	 Write_4_Char_PSP(AnalysisList[wgr, PHRDEP_PSP]);
I 12
	 write(' ');
E 12
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('    ||')
      end else
	 write(' ')
      until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
   writeln;
I 12
end; 
E 12

D 12

   (* write state to screen *)
   write('State                 ; ');
   wgr := FirstWordOfPhrase - 1;
   if x > 1 then r := x
   else  r := 0;
   repeat
      r := r + 1;
      if VerseLine[r + 1] in [' ', '-'] then
      begin
	 wgr := wgr + 1;
	 WriteState(AnalysisList[wgr, STATE]);
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('    ||')
      end else write(' ');
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
E 12
I 12
procedure Show_Phrase_With_PSP(FirstWordOfPhrase, LastWordOfPhrase : integer );
var
   x : integer;
begin
   Show_Phrase_with_psp(FirstWordOfPhrase, LastWordOfPhrase, x);
E 12
   writeln;
I 12
   
end; { Show_Phrase_With_PSP }
   
procedure Show_Phrase_With_PSP_And_STATE(FirstWordOfPhrase, LastWordOfPhrase : integer);
var
   x : integer;
begin
   Show_Phrase_with_psp(FirstWordOfPhrase, LastWordOfPhrase, x);
   Show_State(FirstWordOfPhrase, LastWordOfPhrase, x);
E 12
   writeln;
D 12
end; 
E 12
I 12
   writeln;
end; { Show_Phrase_With_PSP_And_STATE }
E 12

I 12
procedure WritePossibilities(word : integer);
begin
   if AnalysisList[word, PSP] <> 0 then 
   begin
      write('   ', AnalysisList[word, PSP]: 3, ' :');
      WriteType(AnalysisList[word, PSP]);
      writeln;
      if (AnalysisList[word, PHRDEP_PSP] <> AnalysisList[word, PSP])
	 and (AnalysisList[word, PHRDEP_PSP] <>0)
	 then
      begin
	 write('   ',AnalysisList[word,PHRDEP_PSP]: 3, ' :');
	 WriteType(AnalysisList[word, PHRDEP_PSP]);
	 writeln;
      end;
   end;
end;
E 12

procedure AskPhraseTypeAndApposition(FirstWordOfPhrase, LastWordOfPhrase, BadAtomNr : integer );
var
E 10
   apposition : boolean;
   answer     : char;
   r	      : integer;
   x	      : integer;
   question   : StringType;
begin
   apposition := false;
   repeat
I 10
      writeln;
D 12

      Show_Phrase_With_PSP_And_STATE(FirstWordOfPhrase, LastWordOfPhrase);
E 12
I 12
      writeln;
      writeln;
      writeln(' PHRASE TYPE   PHRASE TYPE   PHRASE TYPE   PHRASE TYPE');
      Show_Phrase_With_PSP(FirstWordOfPhrase, LastWordOfPhrase);
E 12
      
E 10
      write(
	    'I propose to re-label phrase >>', BadAtomNr: 2,
	    '<< as a          ----->   '
	    );
D 10
      schrijftype(AnalysisList[LastWordOfPhrase, PHRASE_TYPE]);
E 10
I 10
      WriteType(AnalysisList[LastWordOfPhrase, PHRASE_TYPE]);
E 10
      writeln;
D 12
      if not apposition and (AnalysisList[LastWordOfPhrase, PHRASE_TYPE] >= 2) then
E 12
I 12
      if not apposition and (AnalysisList[LastWordOfPhrase, PHRASE_TYPE] in [2,3,5]) then
E 12
      begin
D 12
	 writeln(' ... if you think it''s an apposition, enter: "a" ');
E 12
I 12
	 writeln(' ... if you think the phrase type is OK, but an apposition, enter: "a" ');
E 12
	 write('                                      ');
D 10
	 schrijftype(AnalysisList[LastWordOfPhrase, PHRASE_TYPE]);
E 10
I 10
	 WriteType(AnalysisList[LastWordOfPhrase, PHRASE_TYPE]);
E 10
D 12
	 write('      OK? (y/n/a) :  ')
E 12
I 12
	 write('      OK? [y/n/a] :  ')
E 12
      end else
      begin
	 write('                                      ');
D 10
	 schrijftype(AnalysisList[LastWordOfPhrase, PHRASE_TYPE]);
E 10
I 10
	 WriteType(AnalysisList[LastWordOfPhrase, PHRASE_TYPE]);
E 10
	 write(' OK?   [y/n] :  ')
      end;
      readln(answer);
D 12
      if answer in ['A', 'a', '-'] then 
E 12
I 12
      if answer in ['A', 'a'] then 
E 12
      begin
	 apposition := true;
	 AnalysisList[LastWordOfPhrase, PHRASE_TYPE] := -AnalysisList[LastWordOfPhrase, PHRASE_TYPE]
      end else if answer in YES then 
      begin
	 if apposition and (AnalysisList[LastWordOfPhrase, PHRASE_TYPE] > 0) then
	    AnalysisList[LastWordOfPhrase, PHRASE_TYPE] := -AnalysisList[LastWordOfPhrase, PHRASE_TYPE]
      end else if answer in NO then 
      begin
I 12
	 answer := 'y';
E 12
	 apposition := false;
	 writeln('What is the correct phrase type number?');
D 12
	 if AnalysisList[FirstWordOfPhrase, PSP] <> 0 then 
	 begin
	    write('   ', AnalysisList[FirstWordOfPhrase, PSP]: 3, ' :');
D 10
	    schrijftype(AnalysisList[FirstWordOfPhrase, PSP]);
E 10
I 10
	    WriteType(AnalysisList[FirstWordOfPhrase, PSP]);
E 10
	    writeln;
	    if (AnalysisList[FirstWordOfPhrase, PHRDEP_PSP] <> AnalysisList[FirstWordOfPhrase, PSP])
	       and (AnalysisList[FirstWordOfPhrase, PHRDEP_PSP] >0)
	       then begin write('   ',AnalysisList[FirstWordOfPhrase,PHRDEP_PSP]: 3, ' :');
D 10
		  schrijftype(AnalysisList[FirstWordOfPhrase, PHRDEP_PSP]);
E 10
I 10
		  WriteType(AnalysisList[FirstWordOfPhrase, PHRDEP_PSP]);
E 10
		  writeln;
	       end;
	 end;
E 12
I 12
	 WritePossibilities(FirstWordOfPhrase);
E 12
	 if LastWordOfPhrase > FirstWordOfPhrase then 
D 12
	 begin
	    if AnalysisList[LastWordOfPhrase, PSP] <> 0 then
	    begin
	       if AnalysisList[LastWordOfPhrase, PSP] <> AnalysisList[FirstWordOfPhrase, PSP] then
	       begin write('   ',AnalysisList[LastWordOfPhrase, PSP]: 3, ' :');
D 10
		  schrijftype(AnalysisList[LastWordOfPhrase,PSP]);
E 10
I 10
		  WriteType(AnalysisList[LastWordOfPhrase,PSP]);
E 10
		  writeln;
	       end;
	       if (AnalysisList[LastWordOfPhrase, PHRDEP_PSP] <> AnalysisList[LastWordOfPhrase, PSP])
		  and (AnalysisList[LastWordOfPhrase, PHRDEP_PSP] <> 0) then 
	       begin
		  write('   ', AnalysisList[LastWordOfPhrase, PHRDEP_PSP]: 3, ' :');
D 10
		  schrijftype(AnalysisList[LastWordOfPhrase, PHRDEP_PSP]);
E 10
I 10
		  WriteType(AnalysisList[LastWordOfPhrase, PHRDEP_PSP]);
E 10
		  writeln
	       end;
	    end;
	 end;
E 12
I 12
	    WritePossibilities(LastWordOfPhrase);
E 12
	 writeln('     0 : otherwise');
	 writeln('(To indicate apposition, enter negative type number)');
	 write(' ... your choice :  ');
	 AskInteger(r);
D 10
	 if r < 0 then begin
E 10
I 10
	 if r < 0 then
	 begin
E 10
	    apposition := true;
	    r := -r
	 end;
D 12
	 if (r > 0) and (
			 (r = AnalysisList[FirstWordOfPhrase, PHRDEP_PSP]) or
			 (r = AnalysisList[LastWordOfPhrase, PHRDEP_PSP]) 
			 )
	    then
E 12
I 12
	 if (r > 0) then
E 12
	 begin
D 12
	    answer := 'y';
E 12
	    if apposition then
	       r := -r;
	    AnalysisList[LastWordOfPhrase, PHRASE_TYPE] := r
	 end else
	 begin
	    repeat
D 12
	       question := 'Enter character for phrase dependent part of speech (l: list): ';
E 12
I 12
	       question := 'Enter character for PHRASE TYPE (l: list): ';
E 12
	       r := AskPhraseType(question);
	       question := 'Do you think it is an apposition (y/n): ';
	       if GetAnswer(question, YES_NO) in YES then
		  r := -r;

	       if r < 0 then
	       begin
		  apposition := true;
		  r := -r
	       end;
	    until r in [1..13];
	    if apposition then
	       r := -r;
	    AnalysisList[LastWordOfPhrase, PHRASE_TYPE] := r
	 end
      end;

      { If this phrase is an apposition, then if the preceding phrase is
        a conjunction (or a relative H), and if the phrase preceding that
        phrase is an apposition, then make the conjunctional phrase
        an apposition as well.
      }
      if apposition then
      begin
	 r := LastWordOfPhrase;
E 8
	 repeat
D 8
	    i := i + 1;
	    wgr := AnalysisList[i, PSP];
	    Lexeme := LexemeList[i];
	    zoekphrases(i, AnalysisList[i, PSP])
	 until i >= word_index;
	 chr_index := 0;
	 i := 0;
	 x := 0;
	 wrd_cnt := 0;
	 if nwrd > 0 then begin
	    aw := aw - 1;
	    atomnr := atomnr - 1;
	    chr_index := 0;
E 8
I 8
	    r := r - 1
	 until AnalysisList[r, PHRASE_TYPE] <> 0;
	 x := r;
	 if AnalysisList[r, PHRASE_TYPE] = CONJUNCTION then
	 begin
E 8
	    repeat
D 8
	       chr_index := chr_index + 1;
	       if VerseLine[chr_index] in [' ', '-'] then
		  wrd_cnt := wrd_cnt + 1
	    until wrd_cnt = aw;
	    i := nwrd
	 end else
	    atomnr := 0;
	 ap := atomnr;
	 numreg := 1;
	 if ap > 0 then
	    writeln(VerseLabel);
	 write('Phrase(atom)', ap + 1: 3, ' ');
	 chars_written := 0;
E 8
I 8
	       r := r - 1
	    until AnalysisList[r, PHRASE_TYPE] <> 0;
	    if AnalysisList[r, PHRASE_TYPE] < 0 then
	       AnalysisList[x, PHRASE_TYPE] := -AnalysisList[x, PHRASE_TYPE]
	 end
      end
   until answer in YES;
end;

D 10
procedure Write_4_Char_PSP(psp : integer);
begin
   case psp of
     0	: write(' art');
     1	: write('verb');
     2	: write('noun');
     3	: write('prop');
     4	: write('advb');
     5	: write('prep');
     6	: write('conj');
     7	: write('prsp');
     8	: write('demp');
     9	: write('intp');
     10	: write('intj');
     11 : write(' neg');
     12 : write('intr');
     13 : write(' adj');
   end;
end;
E 10

D 10
procedure Show_Phrase_With_PSP_And_STATE(FirstWordOfPhrase, LastWordOfPhrase : integer );
var
   x   : integer;
   wgr : integer;
   r   : integer;
begin
   (* Find in x character position in VerseLine 1 char before the first word
    * of the phrase starts. *)
   
   x := 0;
   wgr := 0;
   repeat
      x := x + 1;
      if VerseLine[x] in [' ', '-'] then
	 wgr := wgr + 1;
   until wgr = FirstWordOfPhrase - 1;
   
   (* Write the word numbers to the screen, filled out with spaces
    *  for the word length
   *)
   write('Word no.              : ');
   if x > 1 then
      r := x
   else
      r := 0;
   repeat
      r := r + 1;
      if VerseLine[r + 1] in [' ', '-'] then
      begin
	 wgr := wgr + 1;
	 write(wgr: 4);
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('    ||')
      end else
	 write(' ');
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
   writeln;

   
   (* Write the text of the phrase to screen *)
   wgr := FirstWordOfPhrase - 1;
   write('Text of phrase        :    ');
   if x > 1 then
      r := x
   else
      r := 0;
   repeat
      r := r + 1;
      write(VerseLine[r]);
      if VerseLine[r] in [' ', '-'] then
      begin
	 wgr := wgr + 1;
	 write('   ');
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('||   ')
      end
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
   writeln;

   
   (* Write phrase dependent parts of speech to screen *)
   write('Phrdep part of speech : ');
   wgr := FirstWordOfPhrase - 1;
   if x > 1 then
      r := x
   else
      r := 0;
   repeat
      r := r + 1;
      if VerseLine[r + 1] in [' ', '-'] then begin
	 wgr := wgr + 1;
	 Write_4_Char_PSP(AnalysisList[wgr, PHRDEP_PSP]);
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('    ||')
      end else
	 write(' ')
      until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
   writeln;


   (* write state to screen *)
   write('State                 ; ');
   wgr := FirstWordOfPhrase - 1;
   if x > 1 then r := x
   else  r := 0;
   repeat
      r := r + 1;
      if VerseLine[r + 1] in [' ', '-'] then
      begin
	 wgr := wgr + 1;
	 WriteState(AnalysisList[wgr, STATE]);
	 if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
	    write('    ||')
      end else write(' ');
   until
   (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
   ((wgr >= LastWordOfPhrase) or (VerseLine[r] = '*'));
end; 


E 10
D 12
procedure AskState(FirstWordOfPhrase, LastWordOfPhrase : integer);
E 12
I 12
procedure AskPhrdepPspAndState(FirstWordOfPhrase, LastWordOfPhrase : integer);
E 12
var
D 12
   answer   : char;
   wgr	    : integer;
   ch	    : char;
   r	    : integer;
   question : StringType;
E 12
I 12
   answer    : char;
   wgr	     : integer;
   ch	     : char;
   r	     : integer;
   question  : StringType;
   questword : StringType;
E 12
begin
D 10
   repeat
      answer := ' ';
E 10

I 10
   repeat
E 10
D 12
      Show_Phrase_With_PSP_And_STATE(FirstWordOfPhrase, LastWordOfPhrase);
E 12
I 12
      writeln;
      writeln;
      writeln;
      writeln(' PHRASE DEPENDENT PART OF SPEECH    PHRASE DEPENDENT PART OF SPEECH');
      Show_Phrase_With_PSP(FirstWordOfPhrase, LastWordOfPhrase);
E 12


D 10
      
      writeln;
E 10
      (* Check and/or correct the phrase dependent parts of speech *)
      wgr := FirstWordOfPhrase - 1;
D 12
      question := 'Are all phrase dependent parts of speech correct?  [y/n] : ';
E 12
I 12
      question := 'Are all PHRASE DEPENDENT PARTS OF SPEECH correct?  [y/n] : ';
E 12
      answer := GetAnswer(question, YES_NO);
      if answer in NO then
      begin
	 wgr := FirstWordOfPhrase - 1;
E 8
	 repeat
D 8
	    chr_index := chr_index + 1;
	    chars_written := chars_written + 1;
	    write(VerseLine[chr_index]);
	    if VerseLine[chr_index] in [' ', '-'] then begin
	       aw := aw + 1;
	       if AnalysisList[aw, PHRASE_TYPE] <> 0 then begin
		  ap := ap + 1;
		  numreg := numreg + 1;
		  while chars_written < MAX_SCR_PHRCHARS do begin
		     chars_written := chars_written + 1;
		     write(' ')
		  end;
		  write(ap: 2, '  [');
		  schrijftype(AnalysisList[aw, PHRASE_TYPE]);
		  writeln(
		     ' # ', AnalysisList[aw, PHRASE_TYPE]:1,
		     ', set # ', AnalysisList[aw, CLAUSE_MARK]:1, ']'
		  );
		  chars_written := 0;
		  if (VerseLine[chr_index + 1] <> '*') and (numreg <= MAX_SCR_LINES) then
		     write('Phrase(atom)', ap + 1: 3, ' ')
	       end
	    end
	 until (VerseLine[chr_index] = '*') or (numreg > MAX_SCR_LINES);
	 maxatom := ap;
E 8
I 8
	    wgr := wgr + 1;
	    writeln;
D 12
	    writeln('For word ', wgr:2, ' :');
	    question := 'Please enter phrase-dependent part of speech (l: list):  '; 
E 12
I 12
	    Str(wgr, questword);
	    question := 'Please enter phrase-dependent part of speech for word ' + questword + ' (l: list):  '; 
E 12
	    AnalysisList[wgr, PHRDEP_PSP] := AskPhraseType(question);
	 until wgr >= LastWordOfPhrase
      end;
I 10
   until answer in YES;

   repeat
I 12
      writeln;
      writeln;
      writeln;
      writeln(' STATE STATE STATE STATE STATE STATE STATE STATE STATE ');
E 12
      Show_Phrase_With_PSP_And_STATE(FirstWordOfPhrase, LastWordOfPhrase);

E 10
D 12
      question := 'Are all indications of "state" correct?  [y/n] : ';
E 12
I 12
      question := 'Are all indications of STATE correct?  [y/n] : ';
E 12
      answer := GetAnswer(question, YES_NO);
      if answer in NO then
      begin
	 wgr := FirstWordOfPhrase -1;
	 repeat
	    wgr := wgr + 1;
	    repeat
	       write('Please enter the "state" of word ');
	       write(wgr:1, ' [a:abs c:cst u:unk n:nap]: ');
	       readln(ch)
	    until ch in ['a', 'c', 'u', 'n'];
	    case ch of
	      'a' : r := 2;
	      'c' : r := 1;
	      'u' : r := 0;
	      'n' : r := -1
	    end;
	    AnalysisList[wgr, STATE] := r
	 until wgr >= LastWordOfPhrase;
I 10
      end;
   until answer in YES;

   writeln;
end;

procedure WriteDetermination(determination : integer);
begin
   case determination of
     -1	: write(' nap');
     0	: write(' unk');
     1	: write('indt');
     2	: write(' det');
   end;
end;

procedure ShowPhrsetLine(line, FirstWordOfPhrase : integer);
var
   word			 : integer;
   cond			 : integer;
   chars_written	 : integer;
   char_index		 : integer;
   i			 : integer;
   condition		 : integer;
   StopWritingConditions : boolean;
   StopWritingChars	 : boolean;
   state		 : integer;
   phrdep_psp		 : integer;
   phrase_type		 : integer;
   determination	 : integer;
   ThereAre100_Words	 : boolean;
   NoOfLexemes		 : integer;
   CondLexeme		 : LexemeType;
   phrase		 : integer;
   lexeme_index		 : integer;
begin
   writeln;
   writeln('The following is a representation of the line from phrset which');
   writeln('matched the phrase at hand.');
   
   write('EXAMPLE-LEXEME     PSP   CONDITIONS                     ');
   word := 0;
   while not (Resolver[line,word,0] in [EOI, 100]) do
      word := word + 1;
   NoOfLexemes := word - 1;
   ThereAre100_Words := Resolver[line,word,0] = 100;

   if ThereAre100_Words then
      write(' STATE   PDP_PSP   PHR_TYPE     DETERM');

   writeln;

   { Make a row of dashes. }
   for i := 1 to 95 do
      write('-');
   writeln;

   if ThereAre100_Words then
   begin
      state := (NoOfLexemes + 1) + 1;
      phrdep_psp := (NoOfLexemes + 1) * 2 + 1;
      phrase_type := (NoOfLexemes + 1) * 3 + 1;
      determination := (NoOfLexemes + 1) * 4 + 1;
   end;
   
   word := 0;
   lexeme_index := FirstWordOfPhrase - 1;
   while word < NoOfLexemes do
   begin
      word := word + 1;
      lexeme_index := lexeme_index + 1;

      { Write lexeme. }
      write(LexemeList[lexeme_index]);

      { Write PSP }
      Write_4_Char_PSP(Resolver[line,word,0]);
      write('   ');

      { Write conditions}
      chars_written := 0;
      if Resolver[line,word,1] = 0 then
      begin
	 write('none');
	 chars_written := 4;
E 10
      end
D 10
   until answer in YES
E 10
I 10
      else
      begin
	 write('(');
	 chars_written := 1;

	 StopWritingConditions := false;
	 cond := 0;
	 while not StopWritingConditions do
	 begin
	    cond := cond + 1;

	    if Resolver[line,word,cond] < 100 then
	    begin
	       condition := Resolver[line, word, cond];
	       if condition < 0 then
	       begin
		  condition := -condition;
		  write('!');
		  chars_written := chars_written + 1;
	       end;
	       write(ConditionList[condition].Description);
	       chars_written := chars_written + MAX_COND_DESCR_CHARS;
	    end
	    else
	    begin
	       CondLexeme := LexCondList[Resolver[line,word,cond]-100];
	       char_index := 0;
	       StopWritingChars := false;
	       repeat
		  char_index := char_index + 1;
		  write(CondLexeme[char_index]);
		  if char_index = LEXEME_LENGTH then
		     StopWritingChars := true
		  else if CondLexeme[char_index + 1] = ' ' then
		     StopWritingChars := true;
	       until StopWritingChars;
		     
	       chars_written := chars_written + char_index;
	    end;
	       
	    
	    if (cond >= 5) then { We don't have partial evaluation in Pascal. }
	       StopWritingConditions := true
	    else if Resolver[line,word,cond+1] = 0 then
	       StopWritingConditions := true;

	    if StopWritingConditions then
	       write(')')
	    else
	       write(',');
	    chars_written := chars_written + 1;
	 end;
      end;

      { Fill up with spaces }
      for i := chars_written to 31 do
	 write(' ');

      if ThereAre100_Words then
      begin
	 { write state. }
	 WriteState(Resolver[line,state,0]);
	 state := state + 1;
	    
	 { write phrdep_psp }
	 write('       ');
	 Write_4_Char_PSP(Resolver[line,phrdep_psp,0]);
	 phrdep_psp := phrdep_psp + 1;
	 
	 { write phrase_type }
	 write('      ');
	 phrase := Resolver[line,phrase_type,0];
	 if phrase = 0 then
	    phrase := 14;
	 Write_4_Char_PSP(phrase);

	 if phrase = 14 then
	    write(' ')
	 else
	    write('P');
	 
	 if phrase < 0 then
	    write('A')
	 else
	    write(' ');

	 phrase_type := phrase_type + 1;

	 { write determination }
	 write('      ');
	 WriteDetermination(Resolver[line,determination,0]);
	 determination := determination + 1;
      end;
      writeln;
   end;

   { Make a row of dashes. }
   for i := 1 to 95 do
      write('-');
   writeln;

E 10
end;


I 10
procedure ShouldWeDeletePhrsetLine(FirstWordOfPhrase : integer);
var
   answer	: char;
   question	: StringType;
   line		: integer;
   phrase_index	: integer;
   word_index	: integer;
   cond_index	: integer;
   word		: integer;
   current_line	: integer;
begin
   if ChangePhrset then
   begin
      (* Calculate the line. *)
      word := FirstWordOfPhrase;
      while AnalysisList[word, PHRASE_TYPE] = 0 do
	 word := word + 1;
      line := AnalysisList[word, LINE_IN_SET];

      while line = -1 do
      begin
	 repeat
	    word := word + 1;
	 until AnalysisList[word, PHRASE_TYPE] <> 0;
	 line := AnalysisList[word, LINE_IN_SET];
      end;
      writeln('line : ', line:6);

      (* Calculate the FirstWordOfPhrase. *)
      if word > 1 then
      begin
	 current_line := line;
	 repeat
	    repeat
	       word := word - 1;
	    until (word = 1) or (AnalysisList[word, PHRASE_TYPE] <> 0);
	    if AnalysisList[word, PHRASE_TYPE] <> 0 then
	       current_line := AnalysisList[word, LINE_IN_SET];
	 until (current_line <> -1) or (word = 1);

	 if word <> 1 then
	    word := word + 1;
      end;
      FirstWordOfPhrase := word;

      if (line <> USER_MADE_PHRASE)  then
      begin
	 writeln;
	 question:= 'Do you want to see and possibly delete the offending line in phrset (y/n)?';
	 answer := GetAnswer(question, YES_NO);
	 if answer in YES then
	 begin
	    ShowPhrsetLine(line, FirstWordOfPhrase);
	    writeln;
	    question := 'Do you want to delete this line from the phrset? (y/n) : ';
	    answer := GetAnswer(question, YES_NO);
	    if answer in YES then
	    begin
	       write('Deleting line. Please wait ...');
	       
	       { Delete line from phrset }
	       for phrase_index := line to (PhraseCount - 1) do
	       begin
		  word_index := -2;
		  repeat
		     word_index := word_index + 1;
		     
		     Resolver[phrase_index, word_index, 0] :=
		     Resolver[phrase_index+1, word_index, 0];
		     
		     cond_index := 0;
		     repeat
			cond_index := cond_index + 1;
			Resolver[phrase_index, word_index, cond_index] :=
			Resolver[phrase_index+1, word_index, cond_index];
		     until (Resolver[phrase_index,word_index,cond_index] = 0)
		     or (cond_index = MAX_WORD_CONDITIONS);
		  until Resolver[phrase_index, word_index, 0] = EOI;
	       end;
	       
	       PhraseCount := PhraseCount - 1;
	       
	       writeln('Line deleted. There are now ', PhraseCount:6,' phrase types');
	    end;
	 end;
	 writeln;
      end;
   end;
end;

E 10
procedure makephrases(var f: text; var div_count: integer);
var
   answer	     : char;
   BadAtomNr	     : integer;
   FirstWordOfPhrase : integer;
   i		     : integer;
   maxatom	     : integer;
   LastWordOfPhrase  : integer;
   phr_cnt	     : integer;
   question	     : StringType;
   r		     : integer;
   LastWordOfVerse   : integer;
D 10

E 10
I 10
   DoNotSeekPhrases  : boolean;
E 10
begin
D 10
   {section 1}
   r := 0;
E 10
   maxatom := 0;
   ClearAnalysisList(AnalysisList);

   ReadPhdFile(f, div_count, LastWordOfVerse);

D 10
   {section 2.0}
E 10
   LastWordOfPhrase := 0;
D 10
   FirstWordOfPhrase := 0;
   BadAtomNr := 0;
E 10
I 10
   FirstWordOfPhrase := 1;
   DoNotSeekPhrases := false;
E 10
   if StoreDivisions then
      repeat { until LastWordOfPhrase >= LastWordOfVerse }
D 10
	 {section 2.1}
	 DoSeekPhrases(LastWordOfPhrase, LastWordOfVerse);
E 10
I 10

E 10
	 
D 10
	 {section 2.2}
	 ShowPhraseAtoms(LastWordOfPhrase, maxatom, FirstWordOfPhrase, BadAtomNr);
E 10
I 10
	 if not DoNotSeekPhrases then
	 begin
	    for r := (LastWordOfPhrase + 1) to LastWordOfVerse do
	       AnalysisList[r, LINE_IN_SET] := -1;
	    DoSeekPhrases(LastWordOfPhrase, LastWordOfVerse);
	 end;
E 10
	 
D 10
	 { section 2.4 Interactive process }
E 10
I 10
	 ShowPhraseAtoms(FirstWordOfPhrase,
			 LastWordOfVerse,
			 maxatom);
	 
E 10
E 8
	 writeln;
D 8
	 atomnr := ap;
	 if Interactive then begin
E 8
I 8
D 10
	 if Interactive then
E 10
I 10
	 
	 if not Interactive then
	    LastWordOfPhrase := LastWordOfVerse
	 else
E 10
	 begin
E 8
D 3
	    question := 'Are all phrases and phrase types okay?               [y/n] : ';
E 3
I 3
D 7
	    question := 'Are all Phrases_Atoms and Phrase Types correct?       [y/n] :  (or [s]top) ';
E 7
I 7
D 10
	    question := 'Are all phrase atoms and phrase types correct?       [y/n] :  (or [s]top) ';
E 7
E 3
	    answer := GetAnswer(question, YES_NO);
I 8
	    { section 2.4.1 }
E 10
I 10
	    question := 'Are all phrase atoms and phrase types correct? [y/n] :  (or [s]top) ';
	    answer := GetAnswer(question, YES_NO_STOP);

E 10
E 8
D 7
	    if answer in ['S','s'] then Stop := true
	    else
	    if answer in NO then begin
	 (* ask number of bad phrase atom *)
E 7
I 7
	    if answer in ['S','s'] then
	       Stop := true
D 8
	    else if answer in NO then begin
E 8
I 8
D 10
	    else

	    { section 2.4.2 } 
	    if answer in NO then
E 10
I 10
	    else if answer in YES then
E 10
	    begin
E 8
D 10
(* ask number of bad phrase atom *)
I 8
	       { section 2.4.2.1: Ask incorrect phrase atom }
E 10
I 10
	       LastWordOfPhrase := LastWordOfVerse;
	       writeln
	    end
	    else if answer in NO then
	    begin
	       (* ask number of bad phrase atom *)
E 10
E 8
E 7
	       repeat
D 10
		  write('What is the first INcorrect phrase(atom)? (1..',
E 10
I 10
		  write('What is the FIRST INcorrect phrase(atom)? (1..',
E 10
		     maxatom: 2,
		     ')          :  '
		  );
D 8
		  AskInteger(atomnr);
		  if atomnr < 1 then
E 8
I 8
		  AskInteger(BadAtomNr);
		  if BadAtomNr < 1 then
E 8
		     writeln('That''s impossible! Not < 1 !')
D 8
		  else if atomnr > maxatom then
E 8
I 8
		  else if BadAtomNr > maxatom then
E 8
D 10
		     writeln('That''s impossible! Not > ', maxatom: 3, ' !')
D 7
	       until (atomnr > 0) and (atomnr <= maxatom);
	 (* determine the number of the word with which the bad phrase starts: aw *)
E 7
I 7
D 8
	       until (0 < atomnr) and (atomnr <= maxatom);
(* determine the number of the word with which the bad phrase starts: aw *)
E 7
	       aw := 0;
E 8
I 8
		  until (0 < BadAtomNr) and (BadAtomNr <= maxatom);
E 10
I 10
		     writeln('That''s impossible! Not > ', maxatom: 3, ' !');
	       until (0 < BadAtomNr) and (BadAtomNr <= maxatom);
E 10

D 10
	       { section 2.4.2.2: Determine...}
(* determine the number of the word with which the bad phrase starts: FirstWordOfPhrase *)
E 10
I 10

	       (* determine the number of the word with which
		* the bad phrase starts: FirstWordOfPhrase *)
E 10
	       FirstWordOfPhrase := 0;
E 8
	       phr_cnt := 0;
D 8
	       if atomnr > 1 then
E 8
I 8
	       if BadAtomNr > 1 then
E 8
		  repeat
D 8
		     aw := aw + 1;
		     if AnalysisList[aw, PHRASE_TYPE] <> 0 then
			phr_cnt := phr_cnt + 1
		  until phr_cnt = atomnr - 1;
	       aw := aw + 1;
D 7
	 (* determine the last char in the ct text line preceding the bad phrase;
	 ** x is the index to that char, wgr is the number of words in the ct text
	 ** preceding the bad phrase
	 *)
E 7
I 7
(* determine the last char in the ct text line preceding the
** bad phrase; x is the index to that char, wgr is the number
** of words in the ct text preceding the bad phrase
*)
E 7
	       x := 0;
	       wgr := 0;
	       if atomnr > 1 then
		  repeat
		     x := x + 1;
		     if VerseLine[x] in [' ', '-'] then
			wgr := wgr + 1
		  until wgr = aw - 1;
D 7
	 (* write the verse line with phrase divisions *)
E 7
I 7
(* write the verse line with phrase divisions *)
E 8
I 8
		     FirstWordOfPhrase := FirstWordOfPhrase + 1;
		     if AnalysisList[FirstWordOfPhrase, PHRASE_TYPE] <> 0 then
			phr_cnt := phr_cnt + 1;
		  until phr_cnt = BadAtomNr - 1;
	       
	       FirstWordOfPhrase := FirstWordOfPhrase + 1;

I 10
	       ShouldWeDeletePhrsetLine(FirstWordOfPhrase);
E 10

I 12
	       writeln;
	       writeln;
	       writeln;
	       writeln(' LAST WORD   LAST WORD   LAST WORD   LAST WORD   LAST WORD');
E 12
D 10
	       { section 2.4.2.3 }
E 10
	       ShowBadPhraseAtom(FirstWordOfPhrase, BadAtomNr);

D 10
	       


	       { section 2.4.2.5 }
E 10
E 8
E 7
	       writeln;
D 8
	       writeln(VerseLabel);
	       writeln('Phrase(atom) no       :   >>', atomnr: 1, '<<');
	       write('Text                  :   ');
	       r := x;
	       repeat
		  r := r + 1;
		  write(VerseLine[r]);
		  if VerseLine[r] in [' ', '-'] then begin
		     wgr := wgr + 1;
		     write('  ');
		     if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
			write('||   ')
		  end
	       until
		  (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
		  ((wgr > aw + 3) or (VerseLine[r] = '*'));
	       writeln;
	       wgr := aw - 1;
	       write('Word no.              : ');
	       r := x;
	       repeat
		  r := r + 1;
		  if VerseLine[r + 1] in [' ', '-'] then begin
		     wgr := wgr + 1;
		     write(wgr: 3);
		     if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
			write('   ||')
		  end else
		     write(' ')
	       until
		  (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
		  ((wgr > aw + 3) or (VerseLine[r + 1] = '*'));
	       writeln;
	       wgr := aw - 1;
	       writeln;
E 8
	       write(
D 8
		  'What is really the final word of phr.(at) >>', atomnr: 2,
E 8
I 8
		  'What is really the final word of phr.(at) >>', BadAtomNr: 2,
E 8
		  '<<?  Word no.:  '
	       );
I 10
	       
E 10
	       repeat
D 8
		  AskInteger(nwrd);
		  if nwrd < aw then
		     writeln('That''s impossible! Not < ', aw: 1, ' !')
		  else if nwrd > word_index then
		     writeln('That''s impossible! Not > ', word_index: 1, ' !')
	       until (nwrd >= aw) and (nwrd <= word_index);
D 3
	       for r := aw to nwrd do
E 3
I 3
	       for r := aw to nwrd do begin
E 8
I 8
		  AskInteger(LastWordOfPhrase);
		  if LastWordOfPhrase < FirstWordOfPhrase then
		     writeln('That''s impossible! Not < ', FirstWordOfPhrase: 1, ' !')
		  else if LastWordOfPhrase > LastWordOfVerse then
		     writeln('That''s impossible! Not > ', LastWordOfVerse: 1, ' !');
	       until (LastWordOfPhrase >= FirstWordOfPhrase) and (LastWordOfPhrase <= LastWordOfVerse);


D 10
	       { section 2.4.2.6: Metamagical Hebrew stuff }
E 10
I 10
	       { Metamagical Hebrew stuff. }
E 10
	       for r := FirstWordOfPhrase to LastWordOfPhrase do
	       begin
E 8
E 3
		  AnalysisList[r, PHRASE_TYPE] := 0;
I 3
		  AnalysisList[r, DETERMINATION] := -1;
D 8
		  AnalysisList[r, 15] :=  -1;                          { newly made phrase }
		  end;
E 8
I 8
		  AnalysisList[r, LINE_IN_SET] :=  -1;
	       end;
E 8
               DET := false;
E 3
D 8
	       AnalysisList[nwrd, PHRASE_TYPE] := AnalysisList[aw, PHRDEP_PSP];
D 3
	       if AnalysisList[nwrd, PHRASE_TYPE] = 0 then begin
		  AnalysisList[nwrd, PHRASE_TYPE] := 20;
		  if aw = nwrd then
		     AnalysisList[nwrd, PHRASE_TYPE] := 6
	       end;
E 3
I 3
	       if AnalysisList[nwrd, PHRASE_TYPE] in [2,3,5,7,13]
	       then AnalysisList[nwrd, DETERMINATION] := 0;
	       for r := aw to nwrd do
		   if (AnalysisList[r,PHRDEP_PSP] in [0,3,7]) or
		      (AnalysisList[r,6] > 0) 
                   then begin DET := true;
			      AnalysisList[nwrd,DETERMINATION] := 2;       {determination}
                        end 
                   else if not DET
			then AnalysisList[nwrd,DETERMINATION] := 1;
		   AnalysisList[nwrd, 15] := 9999;
E 8
I 8
D 10
	       AnalysisList[LastWordOfPhrase, PHRASE_TYPE] := AnalysisList[FirstWordOfPhrase, PHRDEP_PSP];
E 10
I 10
	       AnalysisList[LastWordOfPhrase, PHRASE_TYPE] :=
	       AnalysisList[FirstWordOfPhrase, PHRDEP_PSP];

	       if AnalysisList[LastWordOfPhrase, PHRASE_TYPE] = ARTICLE
		  then
		  AnalysisList[LastWordOfPhrase, PHRASE_TYPE] := NOUN;
	       
E 10
	       if AnalysisList[LastWordOfPhrase, PHRASE_TYPE] in
		  [NOUN, PROPER_NOUN, PREPOSITION, PERSONAL_PRONOUN, ADJECTIVE]
D 10
		  then AnalysisList[LastWordOfPhrase, DETERMINATION] := 0;
	       for r := FirstWordOfPhrase to LastWordOfPhrase do
		   if (AnalysisList[r,PHRDEP_PSP] in
		       [ARTICLE, PROPER_NOUN, PERSONAL_PRONOUN]) or
		      (AnalysisList[r,SUFFIX] > 0) 
                   then
		   begin
		      DET := true;
		      AnalysisList[LastWordOfPhrase,DETERMINATION] :=
		      DETERMINED;
		   end 
		   else if not DET
		      then AnalysisList[LastWordOfPhrase,DETERMINATION] :=
		      INDETERMINED;
	       AnalysisList[LastWordOfPhrase, 15] := 9999;
E 10
I 10
		  then
	       begin
		  AnalysisList[LastWordOfPhrase, DETERMINATION] := 0;
		  for r := FirstWordOfPhrase to LastWordOfPhrase do
		     if (AnalysisList[r,PHRDEP_PSP] in
			 [ARTICLE, PROPER_NOUN, PERSONAL_PRONOUN]) or
			(AnalysisList[r,SUFFIX] > 0) 
			then
		     begin
			DET := true;
			AnalysisList[LastWordOfPhrase,DETERMINATION] :=
			DETERMINED;
		     end 
		     else if not DET
			then AnalysisList[LastWordOfPhrase,DETERMINATION] :=
			INDETERMINED;
	       end;
	       AnalysisList[LastWordOfPhrase, LINE_IN_SET] := USER_MADE_PHRASE;
E 10
E 8

D 8
		  if (aw = nwrd) and (AnalysisList[aw,1] = 0) then
		     AnalysisList[nwrd, PHRASE_TYPE] := 6;
E 8
I 8
D 10
	       if (FirstWordOfPhrase = LastWordOfPhrase) and (AnalysisList[FirstWordOfPhrase,PSP] = ARTICLE) then
E 10
I 10
	       if (FirstWordOfPhrase = LastWordOfPhrase)
		  and (AnalysisList[FirstWordOfPhrase,PSP] = ARTICLE)
		  then
E 10
		  AnalysisList[LastWordOfPhrase, PHRASE_TYPE] := CONJUNCTION;
E 8

E 3
D 8
	       apposition := false;
	       repeat
		  write(
		     'I propose to re-label phrase >>', atomnr: 2,
		     '<< as a          ----->   '
		  );
		  schrijftype(AnalysisList[nwrd, PHRASE_TYPE]);
		  writeln;
		  if not apposition and (AnalysisList[nwrd, PHRASE_TYPE] >= 2) then begin
		     writeln(' ... if you think it''s an apposition, enter: "a" ');
		     write('                                      ');
		     schrijftype(AnalysisList[nwrd, PHRASE_TYPE]);
		     write('      OK? (y/n/a) :  ')
		  end else begin
		     write('                                      ');
		     schrijftype(AnalysisList[nwrd, PHRASE_TYPE]);
		     write(' OK?   [y/n] :  ')
		  end;
		  readln(answer);
		  if answer in ['A', 'a', '-'] then 
		  begin
		     apposition := true;
		     AnalysisList[nwrd, PHRASE_TYPE] := -AnalysisList[nwrd, PHRASE_TYPE]
		  end else if answer in YES then 
		  begin
		     if apposition and (AnalysisList[nwrd, PHRASE_TYPE] > 0) then
			AnalysisList[nwrd, PHRASE_TYPE] := -AnalysisList[nwrd, PHRASE_TYPE]
		  end else if answer in NO then 
		  begin
		     apposition := false;
		     writeln('What is the correct phrase type number?');
		     if AnalysisList[aw, PSP] <> 0 then 
		     begin
			write('   ', AnalysisList[aw, PSP]: 3, ' :');
			schrijftype(AnalysisList[aw, PSP]);
			writeln;
			if (AnalysisList[aw, PHRDEP_PSP] <> AnalysisList[aw, PSP])
			   and (AnalysisList[aw, PHRDEP_PSP] >0)
                        then begin write('   ',AnalysisList[aw,PHRDEP_PSP]: 3, ' :');
				   schrijftype(AnalysisList[aw, PHRDEP_PSP]);
				   writeln;
                             end;
		     end;
		     if nwrd > aw then 
			begin
			if AnalysisList[nwrd, PSP] <> 0 then
			  begin
			    if AnalysisList[nwrd, PSP] <> AnalysisList[aw, PSP] then
			    begin write('   ',AnalysisList[nwrd, PSP]: 3, ' :');
			          schrijftype(AnalysisList[nwrd,PSP]);
			          writeln;
                            end;
			  if (AnalysisList[nwrd, PHRDEP_PSP] <> AnalysisList[nwrd, PSP])
			     and (AnalysisList[nwrd, PHRDEP_PSP] <> 0) then 
			     begin
			        write('   ', AnalysisList[nwrd, PHRDEP_PSP]: 3, ' :');
			        schrijftype(AnalysisList[nwrd, PHRDEP_PSP]);
			        writeln
                             end;
D 3
                          if (AnalysisList[nwrd, PHRDEP_PSP] = 2) and
			     (AnalysisList[nwrd-1,1] = 0)
                          then begin write('    20 :'); schrijftype(20); 
				     writeln;
			       end;
E 3
			  end;
			end;
		     writeln('     0 : otherwise');
		     writeln('(To indicate apposition, enter negative type number)');
		     write(' ... your choice :  ');
D 5
		     readln(r);
E 5
I 5
		     AskInteger(r);
E 5
		     if r < 0 then begin
			apposition := true;
			r := -r
		     end;
		     if (r > 0) and (
			   (r = AnalysisList[aw, PHRDEP_PSP]) or
D 3
			   (r = AnalysisList[nwrd, PHRDEP_PSP]) or
			   ((r = 20) and (AnalysisList[nwrd,12] in [2,20])) { NPdet }
E 3
I 3
			   (r = AnalysisList[nwrd, PHRDEP_PSP]) 
E 3
			)
		     then begin
			answer := 'y';
			if apposition then
			   r := -r;
			AnalysisList[nwrd, PHRASE_TYPE] := r
		     end else begin
			repeat
			   for wgr := 1 to 8 do 
			       begin write('  (',wgr:2,')'); schrijftype(wgr); end;
			       writeln;
			   for wgr := 9 to 13 do
			       begin write('  (',wgr:2,')'); schrijftype(wgr); end;
D 3
			       write('  (20)'); schrijftype(20); writeln; 
E 3
I 3
			       writeln;
E 3
			   writeln(
D 3
			      'Please enter correct phrase type number: [ 1 .. 13, 20 ] '
E 3
I 3
			      'Please enter correct phrase type number: [ 1 .. 13 ] '
E 3
			   );
D 5
			   readln(r);
E 5
I 5
			   AskInteger(r);
E 5
			   if r < 0 then begin
			      apposition := true;
			      r := -r
			   end;
D 3
			   if not (r in [1..13, 20]) then
E 3
I 3
			   if not (r in [1..13 ]) then
E 3
			      writeln('Sorry, this type number is not in the system ...')
D 3
			until r in [1..13, 20];
E 3
I 3
			until r in [1..13 ];
E 3
			if apposition then
			   r := -r;
			AnalysisList[nwrd, PHRASE_TYPE] := r
		     end
		  end;
		  if apposition then begin
		     r := nwrd;
		     repeat
			r := r - 1
		     until AnalysisList[r, PHRASE_TYPE] <> 0;
		     x := r;
		     if AnalysisList[r, PHRASE_TYPE] = 6 then begin
			repeat
			   r := r - 1
			until AnalysisList[r, PHRASE_TYPE] <> 0;
			if AnalysisList[r, PHRASE_TYPE] < 0 then
			   AnalysisList[x, PHRASE_TYPE] := -AnalysisList[x, PHRASE_TYPE]
		     end
		  end
	       until answer in YES;
	       repeat
		  answer := ' ';
		  x := 0;
		  wgr := 0;
		  repeat
		     x := x + 1;
		     if VerseLine[x] in [' ', '-'] then
			wgr := wgr + 1
		  until wgr = aw - 1;
(* Write the word numbers to the screen, filled out with spaces for the word length *)
		  write('Word no.              : ');
		  if x > 1 then
		     r := x
		  else
		     r := 0;
		  repeat
		     r := r + 1;
		     if VerseLine[r + 1] in [' ', '-'] then begin
			wgr := wgr + 1;
			write(wgr: 3);
			if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
			   write('   ||')
		     end else
			write(' ')
		  until
		     (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
		     ((wgr >= nwrd) or (VerseLine[r] = '*'));
		  writeln;
(* Write the text of the phrase to screen *)
		  wgr := aw - 1;
		  write('Text of phrase        :   ');
		  if x > 1 then
		     r := x
		  else
		     r := 0;
		  repeat
		     r := r + 1;
		     write(VerseLine[r]);
		     if VerseLine[r] in [' ', '-'] then begin
			wgr := wgr + 1;
			write('  ');
			if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
			   write('||   ')
		     end
		  until
		     (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
		     ((wgr >= nwrd) or (VerseLine[r] = '*'));
		  writeln;
(* Write phrase dependent parts of speech to screen *)
		  write('Phrdep part of speech : ');
		  wgr := aw - 1;
		  if x > 1 then
		     r := x
		  else
		     r := 0;
		  repeat
		     r := r + 1;
		     if VerseLine[r + 1] in [' ', '-'] then begin
			wgr := wgr + 1;
			write(AnalysisList[wgr, PHRDEP_PSP]: 3);
			if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
			   write('   ||')
		     end else
			write(' ')
		  until
		     (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
		     ((wgr >= nwrd) or (VerseLine[r] = '*'));
		  writeln;
I 3
(* write state to screen *)
		  write('State                 ; ');
		  wgr := aw - 1;
		  if x > 1 then  r:= x
			   else  r:= 0;
                  repeat
		     r := r + 1;
		     if VerseLine[r + 1] in [' ', '-'] then begin
			wgr := wgr + 1;
D 7
			writestate(AnalysisList[wgr, STATE]);
E 7
I 7
			WriteState(AnalysisList[wgr, STATE]);
E 7
			if AnalysisList[wgr, PHRASE_TYPE] <> 0 then
			   write('   ||')
                     end else write(' ')
                  until
		     (AnalysisList[wgr, PHRASE_TYPE] <> 0) and
		     ((wgr >= nwrd) or (VerseLine[r] = '*'));
                  writeln;
E 3
(* Check and/or correct the phrase dependent parts of speech *)
		  wgr := aw - 1;
		  question := 'Are all phrase determined parts of speech correct?  [y/n] : ';
		  answer := GetAnswer(question, YES_NO);
		  if answer in NO then begin
		     wgr := aw - 1;
		     repeat
			wgr := wgr + 1;
			write(
			   'Please enter phrase-determined part of speech of word  ', wgr: 2,
			   ' :  '
			);
			AskInteger(r);
			AnalysisList[wgr, PHRDEP_PSP] := r
		     until wgr >= nwrd
		  end;
D 3
		  writeln;
		  writeln
E 3
I 3
		  question := 'Are all indications of "state" correct?  [y/n] : ';
		  answer := GetAnswer(question, YES_NO);
		  if answer in NO then begin
		     wgr := aw -1;
		     repeat
D 7
		       wgr := wgr + 1;
		       write(
			   'Please enter the "state" of word  ',wgr: 2,' :  ');
			   write(' [ a: abs  c: cstr u: unknown  n: not-applicable ] ');
			   repeat read(ch) until ch in ['a', 'c', 'u', 'n'];
			   case ch of 'a' : r := 2; 'c' : r := 1; 'u' : r := 0; 'n' : r := -1;
			   end;
                       AnalysisList[wgr, STATE] := r
E 7
I 7
		        wgr := wgr + 1;
		        write('Please enter the "state" of word ');
			write(wgr:1, ' [a:abs c:cst u:unk n:nap]: ');
			repeat
			   readln(ch)
			until ch in ['a', 'c', 'u', 'n'];
			case ch of
			   'a': r := 2;
			   'c': r := 1;
			   'u': r := 0;
			   'n': r := -1
			end;
                        AnalysisList[wgr, STATE] := r
E 7
                     until wgr >= nwrd;
D 7
		  {   answer := 'y'; }
                   end
E 7
I 7
		  end
E 7
E 3
	       until answer in YES
	    end else if answer in YES then begin
	       nwrd := aw;
E 8
I 8
D 10
	       { section 2.4.2.7: Sub-procedure interactive stuff }
	       AskPhraseTypeAndApposition(LastWordOfPhrase, FirstWordOfPhrase, BadAtomNr);
E 10
I 10
	       AskPhraseTypeAndApposition(FirstWordOfPhrase,
					  LastWordOfPhrase,
					  BadAtomNr);
E 10

D 10

		
	       (* section 2.4.2.8: Write phrase and state information,
		*  ask state
	       *)
E 10
D 12
	       AskState(FirstWordOfPhrase, LastWordOfPhrase);
E 12
I 12
	       AskPhrdepPspAndState(FirstWordOfPhrase, LastWordOfPhrase);
E 12

D 10
	       
	    end else if answer in YES then
	    begin
	       LastWordOfPhrase := FirstWordOfPhrase;
E 8
	       writeln
	    end
D 8
	 end else
	    nwrd := word_index
      until (nwrd >= word_index) or (Stop);
E 8
I 8
	 end
	 else
	    LastWordOfPhrase := LastWordOfVerse
E 10
I 10
	       PossiblyDoAddPhrase(LastWordOfVerse, FirstWordOfPhrase);

	       (*  Make sure that we get to display the wholev verse
		*  again if we made the last phrase include
		*  the last word of the verse. *)
	       if LastWordOfPhrase = LastWordOfVerse then
	       begin
I 12
		  writeln(' Going back to first word of verse, just to check...');
E 12
		  LastWordOfPhrase := 0;
		  FirstWordOfPhrase := 1;
	          DoNotSeekPhrases := true;
	       end
	       else
		  DoNotSeekPhrases := false;

	    end 
	 end;
	 
E 10
      until (LastWordOfPhrase >= LastWordOfVerse) or (Stop);
E 8
E 2

I 8
D 10
   { section 3: write info back. }
E 8
D 2
                                 { naar scherm schrijven }
E 2
I 2
D 7
   if not Stop then
   begin if (Incomplete) or (StoreDivisions)
E 7
I 7
   if not Stop then begin
E 10
I 10
   { Write the info back into .ps3 and .phd. }
   if not Stop then
   begin
E 10
      if (Incomplete) or (StoreDivisions)
E 7
	 then write(DivisionsFile, VerseLabel);
D 7
      for i := 1 to word_index do 
      begin
      schrijflex(LexemeList, i);
      schrijfwoord(i);
      if (StoreDivisions) or (Incomplete) then 
      begin
D 3
	 write(DivisionsFile, AnalysisList[i, PHRDEP_PSP]: 3);
E 3
I 3
	 write(DivisionsFile, AnalysisList[i, STATE]:3, AnalysisList[i, PHRDEP_PSP]: 3);
E 3
	 if AnalysisList[i, PHRASE_TYPE] <> 0 then
D 3
	    write(DivisionsFile, ' :', AnalysisList[i, PHRASE_TYPE]: 3)
E 3
I 3
	    write(DivisionsFile, ' :', AnalysisList[i, PHRASE_TYPE]:3, AnalysisList[i, DETERMINATION]:3)
E 3
	 else
	    write(DivisionsFile, ' ,')
E 7
I 7
D 8
      for i := 1 to word_index do begin
E 8
I 8
      for i := 1 to LastWordOfVerse do begin
E 8
D 10
	 schrijflex(LexemeList, i);
	 schrijfwoord(i);
	 if (StoreDivisions) or (Incomplete) then begin
E 10
I 10
	 WriteLex(LexemeList, i);
	 WriteColumns(i);
	 if (StoreDivisions) or (Incomplete) then
	 begin
E 10
	    write(DivisionsFile, AnalysisList[i, STATE]:3, AnalysisList[i, PHRDEP_PSP]: 3);
	    if AnalysisList[i, PHRASE_TYPE] <> 0 then
	       write(DivisionsFile, ' :', AnalysisList[i, PHRASE_TYPE]:3, AnalysisList[i, DETERMINATION]:3)
	    else
	       write(DivisionsFile, ' ,')
	 end;
E 7
      end;
D 7
      end;
E 7
   end;
D 7
      if not Stop then writeln(PsOut, '           *');
      if (not Stop) and ((StoreDivisions) or (Incomplete)) then
E 7
I 7
   if not Stop then
      writeln(PsOut, '           *');
   if (not Stop) and ((StoreDivisions) or (Incomplete)) then
E 7
      writeln(DivisionsFile, END_OF_VERSE:6)
D 8
end; { maakphrases }
E 8
I 8
end; { makephrases }
E 8
E 2

D 2
                x:= 0; wgr := 0;
                repeat x := x + 1; if versreg[x] in [' ','-']
                                   then wgr := wgr + 1
                until wgr = aw-1;                         { start woord atomnr }
                write(' word numbers in verse : ');
                r := x; repeat r := r + 1;
                               if versreg[r+1] in [' ','-']
                               then begin wgr := wgr + 1;
                                          write(wgr:3);
                                          if ko[wgr,12] <> 0 then write('   ||');
                                    end
                               else   write(' ')
                        until (ko[wgr,12] <> 0) and ((wgr > aw + 3)
                                                      or (versreg[r] = '*'));
                writeln; wgr := aw-1;
                write(' text of phrase        :   ');
                r := x; repeat r := r + 1; write(versreg[r]);
                               if versreg[r] in [' ','-']
                               then begin wgr := wgr + 1;
                                          write('  ');
                                          if ko[wgr,12] <> 0 then write('||   ');
                                    end;
                        until  (ko[wgr,12] <> 0) and ((wgr > aw + 3)
                                                       or (versreg[r] = '*'));
                writeln;
                write(' phrase-dep. part of sp: ');
                wgr := aw-1;
                r := x; repeat r := r + 1;
                               if versreg[r+ 1] in [' ','-']
                               then begin wgr := wgr + 1;
                                          write((ko[wgr,11]):3);
                                          if ko[wgr,12] <> 0 then write('   ||');
                                    end
                               else write(' ');
                        until (ko[wgr,12] <> 0) and ((wgr > aw+ 3)
                                                      or (versreg[r] = '*'));
                writeln; wgr := aw-1;
                writeln;
                writeln(' phrase-atom ',atomnr:2,' begins with word number',aw:3);
                writeln(' give number of last correct word of phrase-atom ',atomnr:2);
                repeat
                   read(nwrd);  readln; if nwrd< aw then
                                        writeln(' not < ',aw:2,' !')
                                   else if nwrd > j then
                                        writeln(' not > max words:',j:3)
                until (nwrd >= aw) and (nwrd <= j);
                                          {nieuwe phrase maken vanaf aw - nwrd }
                for r := aw to nwrd do ko[r,12] := 0;
                ko[nwrd,12] := ko[aw,11];          { provisorisch }
                if ko[nwrd,12] = 0
                then begin ko[nwrd,12] := 20;
                           if aw =  nwrd then ko[nwrd,12] := 6;
                     end;
                app := false;
                repeat  antw := ' ';
                  write(' new phrase type: '); schrijftype(ko[nwrd,12]);
                  writeln(' ok?       [ y / n ]');
                  if not(app) then writeln(' for  "apposition"  type: "a" ');
                                      repeat read(antw)
                                      until antw in ['j','y','n','J','N','Y','a','-'];
                                      readln;
                  if antw in ['a','-'] then
                                      begin app:= true; ko[nwrd,12] := -ko[nwrd,12];
                                      end else
                  if antw in ['j','y','Y','J'] then
                                      begin
                                          if (app) and (ko[nwrd,12]>0)
                                          then ko[nwrd,12] := -ko[nwrd,12];
                                      end else
                  if antw in ['n','N']
                  then begin app := false;
                         writeln(' give type number:');
                         r1 := ko[aw,11]; write('  ** ',r1:3,' ='); schrijftype(r1);
                         writeln('? or');
                         if nwrd > aw then
                         begin
                           r2 := ko[nwrd,11];write('  ** ',r2:3,' =');schrijftype(r2);
                           writeln('? or');
                         end;
                         writeln('  **   0 = otherwise');
                         writeln(' for "apposition" enter negative type number');
                         read(r); readln; if r < 0 then
                                          begin app := true; r := -r;
                                          end;
                        if (r > 0) and (r in [r1,r2])
                         then begin antw:= 'y'; if app then r := -r;
                                    ko[nwrd,12] := r;
                              end
                        else
                        begin
                         repeat writeln(' give type number: [ 1 .. 13, 20 ] ');
                              read(r); if r < 0 then
                                       begin app := true; r := -r;
                                       end;
                                       if not (r in [ 1..13, 20])
                                       then writeln(' number out of range')
                         until r in [ 1..13, 20];
                         if app then r := -r;
                         ko[nwrd,12] := r;
                        end;
                       end;
                       if app then              { complexe appositie }
                            begin r := nwrd;repeat r := r-1
                                            until ko[r,12] <> 0; x:= r;
                                  if ko[r,12] = 6 then
                                       begin repeat r := r -1
                                             until ko[r,12] <> 0;
                                               if ko[r,12] < 0
                                               then ko[x,12] := -ko[x,12];
                                       end;
                            end
E 2

D 2
                until antw in ['j','y','J','Y'];
                        { tekst opnieuw naar scherm }
              repeat antw := ' ';
                  x:= 0; wgr := 0;
                  repeat x := x + 1; if versreg[x] in [' ','-']
                                   then wgr := wgr + 1
                  until wgr = aw-1;                         { start woord atomnr }
                  write(' word numbers in verse : ');
                  r := x; repeat r := r + 1;
                               if versreg[r+1] in [' ','-']
                               then begin wgr := wgr + 1;
                                          write(wgr:3);
                                          if ko[wgr,12] <> 0 then write('   ||');
                                    end
                               else   write(' ')
                        until (ko[wgr,12] <> 0) and ((wgr >=nwrd )
                                                      or (versreg[r] = '*'));
                  writeln; wgr := aw-1;
                  write(' text of phrase        :   ');
                  r := x; repeat r := r + 1; write(versreg[r]);
                               if versreg[r] in [' ','-']
                               then begin wgr := wgr + 1;
                                          write('  ');
                                          if ko[wgr,12] <> 0 then write('||   ');
                                    end;
                          until  (ko[wgr,12] <> 0) and ((wgr >= nwrd)
                                                       or (versreg[r] = '*'));
                  writeln;
                  write(' phrase-dep. part of sp: ');
                  wgr := aw-1;
                  r := x; repeat r := r + 1;
                               if versreg[r+ 1] in [' ','-']
                               then begin wgr := wgr + 1;
                                          write((ko[wgr,11]):3);
                                          if ko[wgr,12] <> 0 then write('   ||');
                                    end
                               else write(' ');
                        until (ko[wgr,12] <> 0) and ((wgr >= nwrd)
                                                      or (versreg[r] = '*'));
                  writeln; wgr := aw-1;
E 2
I 2
function CountLines(var f: text):integer;
var
   n:	integer;
begin
   n := 0;
   reset(f);
D 10
   while not eof(f) do begin
E 10
I 10
   while not eof(f) do
   begin
E 10
      readln(f);
      n := n + 1
   end;
   CountLines := n;
   reset(f)
end; { CountLines }
E 2

D 2
                  writeln(' all phrase-dependent part of speech ok? ');
                  antw:= ' ';
                  repeat read(antw) until antw in ['j','n','y','n','N','Y'];
                  readln;  if antw in ['n','N'] then
                         begin wgr := aw-1;
                           repeat wgr := wgr + 1;
                           writeln(' word',wgr:3,'; enter phr.dep. part of speech ');
                           readln(r); ko[wgr,11] := r
                           until wgr >= nwrd;
                         end;
                  writeln;
                  writeln
              until antw in ['j','y','Y','J'];
          end
     else if antw in ['j','J','y','Y']
          then begin nwrd := aw;
               end;
E 2

D 2
   end
   else nwrd := j                                           { max woorden }
E 2
I 2
D 7
procedure ReadPhraseList(var f: text; var resolver: ResolverType; var phrase: integer);
E 7
I 7
procedure ReadCondition(
   var f: text;
   var res: ResolverType;
   var phr: integer;
   var wrd: integer
);
E 7
var
D 7
   word, phr_type, condition:	integer;
   aanwijzing:	boolean;
   ch, ch1:	char;
E 7
I 7
   cdn: integer;
E 7
D 9
begin
E 9
I 9
D 10
begin 
E 10
I 10
begin
E 10
E 9
I 7
   get(f); (* eat the opening parenthesis *)
   SkipSpace(f);
D 10
   if not ReadInteger(f, res[phr, wrd, 1]) then begin
E 10
I 10
   if not ReadInteger(f, res[phr, wrd, 1]) then
   begin
E 10
      writeln('syn03: phrset line ', phr:1, ': integer expected');
      Die
   end;
   SkipSpace(f);
   cdn := 1;
D 9
   while (f^ = ',') and (cdn < MAX_WORD_CONDITIONS) do begin
E 9
I 9
   while (f^ = ',') and (cdn < MAX_WORD_CONDITIONS) do
   begin
E 9
      get(f);
I 11
      if cdn = MAX_WORD_CONDITIONS then
      begin
	 writeln('syn03: maximum number of word conditions reached in reading phrset, line ', phr:1);
	 Die
      end;
E 11
I 9
D 10
      if cdn = MAX_WORD_CONDITIONS then
      begin
	 writeln('syn03: maximum number of word conditions reached in phrset line ', phr:1);
	 Die
      end;
E 10
E 9
      cdn := cdn + 1;
D 9
      if not ReadInteger(f, res[phr, wrd, cdn]) then begin
E 9
I 9
D 10
      if not ReadInteger(f, res[phr, wrd, cdn]) then
      begin
E 10
I 10
D 11
      if not ReadInteger(f, res[phr, wrd, cdn]) then begin
E 11
I 11
      if not ReadInteger(f, res[phr, wrd, cdn]) then
      begin
E 11
E 10
E 9
	 writeln('syn03: phrset line ', phr:1, ': integer expected');
	 Die
      end;
      SkipSpace(f)
   end;
I 10
D 11
   if cdn = MAX_WORD_CONDITIONS then
   begin
      writeln('syn03: maximum number of word conditions reached');
      Die
   end;
E 11
E 10
D 9
   if cdn = MAX_WORD_CONDITIONS then begin
      writeln('syn03: maximum number of word conditions reached');
      Die
   end;
E 9
   SkipSpace(f);
D 9
   if f^ <> ')' then begin
E 9
I 9
   if f^ <> ')' then
   begin
E 9
      writeln('syn03: phrset line ', phr:1, ': closing parenthesis missing');
      Die
   end;
   get(f); (* eat the closing parenthesis *)
D 9
   res[phr, wrd, cdn + 1] := 0
E 9
I 9
D 10
   if cdn < MAX_WORD_CONDITIONS then
      res[phr, wrd, cdn + 1] := 0
E 10
I 10
D 11
   res[phr, wrd, cdn + 1] := 0
E 11
I 11
   if cdn < MAX_WORD_CONDITIONS then
      res[phr, wrd, cdn + 1] := 0
E 11
E 10
E 9
end; (* ReadCondition *)


procedure ReadPhraseList(
   var f: text;
   var resolver: ResolverType;
   var phrase: integer
);
var
D 10
   word: integer;
   c: char;
E 10
I 10
   word				     : integer;
   c				     : char;
   phr_index, word_index, cond_index : integer;
E 10
begin
I 10
D 12
   writeln('Reading phrset...');
E 12
I 12
   writeln('Clearing array for phrset...');
E 12
   for phr_index := 1 to MAX_PHRASE_TYPES do
      for word_index := -1 to MAX_PHRASE_WORDS do
	 for cond_index := 0 to MAX_WORD_CONDITIONS do
	    resolver[phr_index, word_index, cond_index] := 0;

I 12
   writeln('Reading phrset...');
E 12
E 10
E 7
   phrase := 0;
D 7
   aanwijzing := false;
   while not eof(f) do begin
      phrase := phrase + 1;
      if phrase mod 25 = 0 then writeln(phrase);
E 7
I 7
D 9
   while not eof(f) and (phrase < MAX_PHRASE_TYPES) do begin
E 9
I 9
   while not eof(f) and (phrase < MAX_PHRASE_TYPES) do
   begin
E 9
E 7
      word := 0;
I 11
      if phrase = MAX_PHRASE_TYPES then
      begin
	 writeln('syn03: maximum number of phrase types reached. Increase MAX_PHRASE_TYPES.');
	 Die
      end;
E 11
D 7
      aanwijzing := false;
      while not eoln(f) do begin
E 7
I 7
      phrase := phrase + 1;
D 9
      while not eoln(f) and (word < MAX_PHRASE_WORDS) do begin
E 9
I 9
      while not eoln(f) and (word < MAX_PHRASE_WORDS) do
      begin
E 9
E 7
	 word := word + 1;
D 7
	 phr_type := 0;
	 read(f, phr_type);
	 resolver[phrase, word, 0] := phr_type;
E 7
I 7
D 9
	 if not ReadInteger(f, resolver[phrase, word, 0]) then begin
E 9
I 9
D 10
	 if not ReadInteger(f, resolver[phrase, word, 0]) then
	 begin
E 10
I 10
	 if not ReadInteger(f, resolver[phrase, word, 0]) then begin
E 10
E 9
	    writeln('syn03: phrset line ', phrase:1, ': integer expected');
	    Die
	 end;
E 7
	 resolver[phrase, word, 1] := 0;
D 7
	 while not (eoln(f) or (f^ in ['(', '-', '='])) do
	    get(f);
E 7
I 7
	 SkipSpace(f);
I 9
D 10
	 c := f^;
E 10
E 9
E 7
	 if not eoln(f) then
D 7
	    read(f, ch);
	 if ch = '(' then begin
	    condition := 0;
	    repeat
	       condition := condition + 1;
	       read(f, resolver[phrase, word, condition], ch1, ch)
	    until (ch in [')']) or (condition = MAX_WORD_CONDITIONS);
	    while ch <> ')' do
	       read(f, ch);
	    if condition < MAX_WORD_CONDITIONS then begin
	       condition := condition + 1;
	       resolver[phrase, word, condition] := 0
E 7
I 7
	    if f^ = '-' then
	       get(f)
	    else if f^ = '(' then
	       ReadCondition(f, resolver, phrase, word)
D 10
	    else begin
E 10
I 10
	    else
	    begin
E 10
	       c := f^; writeln('c is ', c);
D 10
	       writeln('syn03:: phrset line ', phrase:1, ': bad format:');
E 10
I 10
	       writeln('syn03: phrset line ', phrase:1, ': bad format:');
E 10
	       Die
E 7
	    end
D 7
	 end else if ch = '=' then begin
	    word := word + 1;
	    resolver[phrase, word, 0] := 100;
	    resolver[phrase, word, 1] := 0;
	    aanwijzing := true
	 end
E 7
      end;
I 7
D 10
      if word = MAX_PHRASE_WORDS then begin
D 9
	 writeln('syn03: too many words in phrase pattern');
E 9
I 9
	 writeln('syn03: too many words in phrase pattern in phrset line ', phrase:1);
E 10
I 10
      if word = MAX_PHRASE_WORDS then
      begin
	 writeln('syn03: too many words in phrase pattern');
E 10
E 9
	 Die
      end;
I 11
      if (phrase mod 100) = 0 then
	 writeln(phrase:4);
E 11
I 9
D 10
      if (phrase mod 100) = 0 then
	 writeln(phrase:1);
E 10
E 9
E 7
D 12
      resolver[phrase, word + 1, 0] := EOI;
E 12
I 12
      resolver[phrase, word + 1, 0] := 100;
E 12
D 7
      if aanwijzing then
	 resolver[phrase, word + 1, 0] := 100;
E 7
      resolver[phrase, 0, 0] := resolver[phrase, 1, 0];
D 9
      readln(f)
E 9
I 9
D 10
      readln(f);
      if phrase = MAX_PHRASE_TYPES then 
      begin
	 writeln('syn03: maximum number of phrase types reached');
	 Die
      end;
E 10
I 10
      readln(f)
E 10
E 9
   end;
I 10
D 11
   if phrase = MAX_PHRASE_TYPES then
   begin
      writeln('syn03: maximum number of phrase types reached');
      Die
   end;
E 11
E 10
D 7
   writeln(phrase:1, ' patterns of words are recognized as phrase(atoms) in file phrset')
E 7
I 7
D 9
   if phrase = MAX_PHRASE_TYPES then begin
      writeln('syn03: maximum number of phrase types reached');
      Die
   end;
E 9
   writeln(phrase:1, ' phrase patterns read from phrset')
E 7
end; { ReadPhraseList }
E 2

D 2
until nwrd >= j;                                            { max woorden }
                                                            { tekst maken }
      for i := 1 to j do
          begin schrijflex(linelex,i);
                schrijfwoord(i);
                if bewaar then
                begin write(divis,(ko[i,11]):3);
                      if ko[i,12] <> 0 then
                      write(divis,' :',(ko[i,12]):3)
                      else write(divis,' ,');
                end;
          end;
          writeln(ps3,'           *');
          if bewaar then writeln(divis,'   999');
E 2

I 2
procedure ClearConditionList(var list: ConditionListType);
var
   condition_index:	ConditionIndexType;
begin
   for condition_index := 1 to MAX_CONDITIONS do
D 10
      with list[condition_index] do begin
E 10
I 10
      with list[condition_index] do
      begin
E 10
	 FunctionIndex := FIRST_FUNCTION;
D 10
	 ValueList[1] := EOI
E 10
I 10
	 ValueList[1] := EOI;
	 Description := '    ';
E 10
      end
end; { ClearConditionList }
E 2

D 2
end;
E 2

D 2
procedure inleesphrases;
E 2
I 2
D 7
procedure ReadConditionList
   (var f: text; var list: ConditionListType; var count: ConditionIndexType);
E 7
I 7
procedure ReadConditionList(var f: text; var list: ConditionListType);
E 7
var
D 7
   ch:			char;
E 7
I 7
D 10
   i:			integer;
   nlines:		integer;
   nlcond, nmcond:	integer;
E 7
   condition_index:	ConditionIndexType;
   function_index:	FunctionIndexType;
   gram_value:		integer;
   value_index:		ValueIndexType;
E 10
I 10
   i		   : integer;
   nlines	   : integer;
   nmcond	   : integer;
   condition_index : ConditionIndexType;
   function_index  : FunctionIndexType;
   gram_value	   : integer;
   value_index	   : ValueIndexType;
E 10
begin
I 7
D 10
   nlcond := 0;
E 10
   nmcond := 0;
   nlines := 0;
E 7
D 10
   while not eof(f) do begin
E 10
I 10
   while not eof(f) do
   begin
E 10
D 7
      read(f, condition_index);
      read(f, function_index);
E 7
I 7
      nlines := nlines + 1;
D 10
      if not ReadInteger(f, i) then begin
E 10
I 10
      if not ReadInteger(f, i) then
      begin
E 10
	 write('syn03: morfcond, line ', nlines:1);
	 writeln(': integer expected');
	 Die
      end;
D 10
      if (i < 1) or (MAX_CONDITIONS < i) then begin
E 10
I 10
      if (i < 1) or (MAX_CONDITIONS < i) then
      begin
E 10
	 write('syn03: morfcond, line ', nlines:1);
	 writeln(': condition index out of range: ', i:1);
	 Die
      end;
      condition_index := i;
D 10
      if not ReadInteger(f, i) then begin
E 10
I 10
      if not ReadInteger(f, i) then
      begin
E 10
	 write('syn03: morfcond, line ', nlines:1);
	 writeln(': integer expected');
	 Die
      end;
D 10
      if (i < FIRST_FUNCTION) or (LAST_FUNCTION < i) then begin
E 10
I 10
      if (i < FIRST_FUNCTION) or (LAST_FUNCTION < i) then
      begin
E 10
	 write('syn03: morfcond, line ', nlines:1);
	 writeln(': function index out of range: ', i:1);
	 Die
      end;
      function_index := i;
E 7
      list[condition_index].FunctionIndex := function_index;
D 7
      repeat
	 read(f, ch)
      until ch in ['=', ':'];
E 7
I 7
      SkipSpace(f);
D 10
      if f^ <> '=' then begin
E 10
I 10
      if f^ <> '=' then
      begin
E 10
	 write('syn03: morfcond, line ', nlines:1);
	 writeln(': wrong format');
	 Die
      end;
      get(f);
E 7
      value_index := 1;
      repeat
D 7
	 read(f, gram_value);
E 7
I 7
D 10
	 if not ReadInteger(f, gram_value) then begin
E 10
I 10
	 if not ReadInteger(f, gram_value) then
	 begin
E 10
	    write('syn03: morfcond, line ', nlines:1);
	    writeln(': integer expected');
	    Die
	 end;
D 10
	 if (value_index > MAX_COND_VALUES) then begin
E 10
I 10
	 if (value_index > MAX_COND_VALUES) then
	 begin
E 10
	    write('syn03: morfcond, line ', nlines:1);
	    writeln(': too many values');
	    Die
	 end;
E 7
	 list[condition_index].ValueList[value_index] := gram_value;
	 value_index := value_index + 1
D 7
      until gram_value = EOI; { test on value_index missing }
E 7
I 7
      until gram_value = EOI;
D 10
      if condition_index > LC_OFFSET then
	 nlcond := nlcond + 1
      else
	 nmcond := nmcond + 1;
E 10
I 10
      nmcond := nmcond + 1;


      SkipSpace(f);

      if f^ <> ':' then
      begin
	 writeln('syn03: Did not find '':'' in morfcond, line ', nlines:2, '.');
	 writeln('Grab a new morfcond from /projects/grammmar/lib.');
	 Die;
      end;
      
      { Skip ':'. }
      get(f);

      { Read description }
      for i := 1 to MAX_COND_DESCR_CHARS do
      begin
	 list[condition_index].Description[i] := f^;
	 get(f);
      end;
      
E 10
E 7
      readln(f)
   end;
D 3
   count := condition_index
E 3
I 3
D 7
   count := condition_index;
   writeln(' number of morphological conditions known in file "morfcond":' , condition_index);
E 7
I 7
D 10
   write('File morfcond: ', nmcond:1, ' morphological conditions ');
   writeln('and ', nlcond:1, ' lexical conditions.')
E 10
I 10
   writeln('File morfcond: ', nmcond:1, ' morphological conditions.');
   writeln;
   
E 10
E 7
E 3
end; { ReadConditionList }
E 2

D 2
var p,q,r,s, cond      : integer;
    art,aanwijzing     : boolean;
E 2

I 3
procedure ReadLexConditionsList 
   (var f: text; var list: LexemeListType; var count: integer);
var
    lex_index:		integer;
D 7

E 7
begin 
   lex_index := 0;
D 10
   while not eof(f) do begin
E 10
I 10
   while not eof(f) do
   begin
E 10
      lex_index := lex_index + 1;
      read(f, list[lex_index]);
      readln(f);
D 7
      writeln(' list[lex_index] :',list[lex_index]);
E 7
I 7
      write('Lexeme list element #', lex_index:-2, ': ');
      writeln(list[lex_index])
E 7
   end;
   count := lex_index;
D 7
   writeln(' number of lexical conditions known in file "lexcond":', lex_index);
E 7
I 7
   write('Number of lexical conditions known in file "lexcond": ');
   writeln(count:1);
I 10
   writeln;
E 10
E 7
end;  { ReadLexConditionsList }

I 7

I 10
procedure WritePHR;
var
   p, q, r: integer;
begin
   if ChangePhrset then
   begin
      writeln('Writing the PHR file...');
      
      rewrite(NewPhraseSet);
      for p := 1 to PhraseCount do
      begin
	 r := 0;
	 repeat
	    r := r + 1;
	    q := 0;
	    write(NewPhraseSet, Resolver[p, r, q]: 2);
	    q := q + 1;
	    if Resolver[p, r, q] <> 0 then begin
	       write(NewPhraseSet, ' ( ', Resolver[p, r, q]: 2);
	       repeat
		  q := q + 1;
		  if Resolver[p, r, q] <> 0 then 
		     write(NewPhraseSet, ' , ', Resolver[p, r, q]: 2);
	       until (Resolver[p, r, q] = 0) or (q = MAX_WORD_CONDITIONS);
	       write(NewPhraseSet, ' ) ')
	    end else if Resolver[p, r + 1, 1] <> EOI then 
	       write(NewPhraseSet, ' - ');
	 until (Resolver[p, r + 1, 0] = EOI) or (r = MAX_PHRASE_WORDS);
	 writeln(NewPhraseSet, Resolver[p, r + 1, 0]: 4)
      end;
   end;
end;

E 10
E 7
E 3
D 2
begin reset(phrfile); p:= 0; q:= 0; r:= 0;
      if bewaar then
      begin
        writeln(' work interactively ?');
        repeat read(antw) until antw in ['Y','y','J','j','N','n'];
        if antw in ['Y','y','J','j'] then tonen := true;
E 2
I 2
procedure CheckDivisions(var div_file: text);
begin
   Incomplete := false;
I 10
   writeln;
E 10
   writeln('Number of lines in ', PhdName, ': ', NumberOfDivisions:1);
D 10
   if NumberOfDivisions < NumberOfVerses then begin
E 10
I 10
   if NumberOfDivisions < NumberOfVerses then
   begin
E 10
      writeln(PhdName, ' (= file with phrase-divisions) is INcomplete.');
      writeln(
	 'Please make new phrases (interactively) starting from line ',
	 (NumberOfDivisions + 1):2, '.'
      );
      CopyFile(div_file, PartialDivFile);
      writeln;
D 10
      writeln(' < hit  Return >'); readln;
E 10
I 10
      writeln('< hit  Return >'); readln;
E 10
      Incomplete := true;
      reset(PartialDivFile);
      rewrite(div_file);
      if not Interactive then
D 10
      begin writeln(' non-Interactive mode is changed into Interactive mode');
	    Interactive := true;
E 10
I 10
      begin
	 writeln(' non-Interactive mode is changed into Interactive mode');
	 Interactive := true;
E 10
E 2
      end;
D 2
      aanwijzing := false;
      while not eof(phrfile) do
      begin p:= p+1; q:= 0; s:= 0;  art := false;
            aanwijzing := false;
            while not eoln(phrfile) do
            begin q:= q+1; read (phrfile,r); phrec[p,q,0] := r;
                                             phrec[p,q,1] := 0;   { plaats voor condities }
E 2
I 2
   end
end; { CheckDivisions }
E 2

D 2
                                                                  { condities }
                  repeat if not eoln(phrfile) then read(phrfile,ch)
                  until ( ch in ['(','-','=' ] ) or (eoln(phrfile)); s := 0;
                  if ch = '(' then
                        begin
                        repeat read(phrfile,cond);
                               repeat read(phrfile,ch)
                               until ch in [')', ','];
                               s := s +1; phrec[p,q,s] := cond
                        until ch = ')';
                        s := s+1; phrec[p,q,s] := 0;             { eindsymbool reeks condities }
                        end
                 else
                 if ch = '=' then
                       begin q := q + 1; phrec[p,q,0] := 100;     { scheidingssymbool }
                             phrec[p,q,1] := 0;
                             aanwijzing := true;
                       end;
                 s :=s + 1; phrec[p,q,s] := 0;
E 2

D 2
            end;  phrec[p,q+1,0] := 99;               { eind symbool }
                  if aanwijzing then phrec[p,q+1,0] := 100;
                  s := phrec[p,1,0];                  { eerste lex van phrase }
                  phrec[p, 0, 0] := s;                { phrase type      }
E 2
I 2
procedure AskMode(var mode: boolean);
var
D 10
   answer:	char;
E 10
I 10
   answer   : char;
   question : StringType;
E 10
begin
D 10
   repeat
      write('Do you want to work interactively? [y/n]: ');
      readln(answer)
   until answer in YES_NO;
   mode := answer in YES
E 10
I 10
   question :='Do you want to work interactively? [y/n]: ';
   answer := GetAnswer(question, YES_NO);
   mode := answer in YES;

   question := 'Do you want me to be able to change the phrset? [y/n]: ';
   answer := GetAnswer(question, YES_NO);
   ChangePhrset := answer in YES;


   BeVerbose := false;
   if ChangePhrset then
   begin
      question := 'Do you want me to be verbose about changing the phrset? [y/n]: ';
      answer := GetAnswer(question, YES_NO);
      BeVerbose := answer in YES;
   end;
E 10
end; { AskMode }
E 2

D 2
            readln(phrfile);
E 2

D 2
      end; maxgr := p;
      writeln(' totaal aantal phrase-typen:', maxgr:4);
end;
E 2
I 2
D 7
procedure WriteStage(var f: text; name: StringType);
begin
   writeln(f, '3 ', name);
end; { WriteStage }
E 2

D 2
procedure inleesmorfcondities;
var p, q,r : integer;
    ch     : char;
begin p := 0; reset(mrfile);
      while not eof(mrfile) do
              begin read(mrfile,p);  write(p:4);                        { conditie nr  }
                    read(mrfile,r);  write(r:4);
                    condit[p,1] := r;                        { kolnr        }
                    repeat read(mrfile,ch); write(ch)
                    until ch in ['=',':'];                   { = of :       }
                    q := 1;
                    repeat q := q+1;
                           read(mrfile,r); write(r:4); condit[p,q] := r
                    until r=99;
                    readln(mrfile);   writeln;
              end;  maxcond := p;
       writeln(' totaal aantal morfol. condities:', maxcond:4);
 end;
E 2

E 7
D 2
{  h.p.  }
E 2
I 2
procedure CloseFiles;
begin
D 7
   close(PsIn);
   close(PsOut);
   close(DivisionsFile);
   close(PartialDivFile);
   close(StageFile);
E 7
I 7
   CloseFile(PsIn);
   CloseFile(PsOut);
I 10
   CloseFile(TextFile);
E 10
   CloseFile(DivisionsFile);
D 10
   CloseFile(PartialDivFile)
E 10
I 10
   CloseFile(PartialDivFile);
   CloseFile(PhrasesFile);
   CloseFile(ConditionsFile);
   CloseFile(LexConditionsFile);
   CloseFile(NewPhraseSet);
E 10
E 7
end; { CloseFiles }
E 2

D 2
begin areg := 0;      tonen   := false;      bewaar := true;
      maxgr:= 0;      maxcond := 0;
      vraagbestand;
E 2

D 2
      reset(ct);
      reset(mrfile);
      reset(phrfile);
      inleesphrases;
      inleesmorfcondities;
      reset(ps2); rewrite(ps3);
E 2
D 13

E 13
D 2
      while not eof(ps2) do
            maakphrases;
      close(ps3);
      if bewaar then close(divis);

      writeln(' number of lines in text ',flin,' :',areg);
end.
E 2
I 2
begin
   AskMode(Interactive);
   ReadStage(TextName);
   MakeFileNames(TextName);
D 3
   OpenFiles;
E 3
I 3
   OpenFiles(TextName);
E 3
   StoreDivisions := EmptyFile(DivisionsFile);
   NumberOfDivisions := CountLines(DivisionsFile);
   NumberOfVerses := CountLines(TextFile);
   if StoreDivisions then
      rewrite(DivisionsFile)
   else
      CheckDivisions(DivisionsFile);
   ReadPhraseList(PhrasesFile, Resolver, PhraseCount);
   ClearConditionList(ConditionList);
D 7
   ReadConditionList(ConditionsFile, ConditionList, NumberConditions);
E 7
I 7
   ReadConditionList(ConditionsFile, ConditionList);
E 7
I 3
   ReadLexConditionsList(LexConditionsFile, LexCondList, NumberLexCond);

E 3
   DivisionCount := 0;
   Stop := false;
D 7
   while (not eof(PsIn))  and (not Stop ) do
E 7
I 7
   while not eof(PsIn) and not Stop do
E 7
D 8
      maakphrases(PsIn, DivisionCount);
E 8
I 8
      makephrases(PsIn, DivisionCount);
I 9
D 10
   writeln(' UP 105. ');
E 10
E 9
E 8
   writeln('Number of verses in text ', TextName, ': ', NumberOfVerses:1);
   if StoreDivisions then
      writeln('Data on phrases stored in file ', PhdName, '.');
D 7
   rewrite(StageFile);
   WriteStage(StageFile, TextName);
E 7
I 7
D 13
   WriteStage(TextName);
E 13
I 13
   (* Only write new stage if we have processed the entire text! *)
   if (DivisionCount = NumberOfDivisions) and not Stop then
      WriteStage(TextName);
E 13
I 10
   WritePHR;
I 12
   writeln('If you want to use the new phrase set, then do '' mv PHR phrset ''');
E 12
E 10
E 7
   CloseFiles;
   if not Stop then
D 7
   writeln('Now you may run program syn04.')
   else writeln(' you need an additional run of syn03 before running syn04');
E 7
I 7
D 12
      writeln('Now you may run program syn04.')
E 12
I 12
      writeln('Now you may run program syn04 or parsephrases.')
E 12
   else
      writeln('You need an additional run of syn03 before running syn04');
0:
E 7
end. { syn03 }
E 2
E 1
