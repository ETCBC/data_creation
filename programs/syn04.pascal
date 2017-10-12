program syn04;

(* ident @(#)dapro/simple/syn04.p	1.25 17/02/13 *)

{
   Reads a PS file, i.e. the product of a morphological analysis by
   program syn01, program syn02 and program syn03; produces a new PS
   file with addition of clause atom divisions.
   XXX.ps4 + XXX.div   ( XXX + divisions )
   IN:	x.ps3 x.ct clset lexcondcl morfcondcl
   OUT:	x.ps4 x.div x.ct4
}

#include <hebrew/hebrew.h>
#include <hebrew/syntax.h>

const
   NO				= ['n', 'N'];
   YES				= ['Y', 'y', 'j', 'J'];
   YES_NO			= ['j', 'J', 'y', 'Y', 'n', 'N', 's'];
   START_CLAUSE			= 99;
   COMPLEX_PHRASE		= 100;
   (* Phrase is first entry in s-o-c resolver *)
   PHRASE			= 1;
   LAST_WORD			= 2;
   CLAUSE_MARKS			= 3;
   LEXICAL_SET			= 0;
   PART_OF_SPEECH		= 1;
   PREFORMATIVE			= 2;
   ROOT_MORPHEME		= 3;
   VERBAL_ENDING		= 4;
   NOMINAL_ENDING		= 5;
   SUFFIX			= 6;
   VERBAL_TENSE			= 7;
   PERSON			= 8;
   NUMBER			= 9;
   GENDER			= 10;
   STATE			= 11;
   PHRDEP_PSP			= 12;
   PHRASE_TYPE			= 13;
   DETERMINATION		= 14;
   CLAUSE_MARKER		= 15;

   LEAST_PARSING_CODE		= 500;
   (* End of divisions in division files *)
   EOD				= LEAST_PARSING_CODE - 1;
   (* End of information in conditions *)
   EOI				= 99;

   SMALLEST_CL_PHRASE_INDEX	= -1;

   SMALLEST_VS_PHRASE_INDEX	= 0;

   CONDITION_LENGTH		= 5;
   MAX_COND_VALUES              = 10;
   FIRST_CONDITION		= -2;
   LAST_CONDITION		= 65;
   NUMBER_OF_PHRASE_INFO	= 3;
   NUMBER_OF_CONDITIONS		= 5;
   SMALLEST_CLAUSE_TYPE		= -2;
   NUMBER_CLAUSE_TYPES		= 9500;
   SMALLEST_APPOSITION		= -30;
   HIGHEST_CONDITION		= 200;
   FIRST_FUNCTION		= -1;		(* -1 - 0 : Lexical information		*)
   LAST_FUNCTION		= 15;		(*  1 - 6 : Morphological information	*)
					(*  7 - 11: Word level function values	*)
					(* 12 - 12: Phrase level function values	*)
					(* 13: Clause marker *)

type
   PhraseInfo_IndexType =
	 0 .. NUMBER_OF_PHRASE_INFO;
   Function_IndexType =
	 FIRST_FUNCTION .. LAST_FUNCTION;
   ValueIndexType =
	 0 .. MAX_COND_VALUES;
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
   ConditionListType =
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
	 0 .. NUMBER_OF_CONDITIONS;
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

var
   AnalysisList:		Gram_Anal_ListType;
   NumberConditions:		ConditionIndexType;

   ClauseDivisions:		text;		(* Input/Output file: x.div *)
   PartialDivFile:		text;
   ConditionsFile,
   LexConditionsFile:           text;
   ConditionList:		ConditionListType;
   Lexeme:			LexemeType;
   LexemeList:			LexemeListType;
   LexCondList:			LexemeListType;
   NewText:			text;		(* Output file: x.ct4 *)
   NumberOfClauseTypes:		integer;
   NumberOfVerses:              integer;
   NumberOfDivisions:           integer;
   NumberOfNew_Clauses:		integer;
   lines_on_screen:             integer;
   DivisionCount:		integer;
   NumberLexCond:		integer;

   PericopeName:		StringType;
   Ps3:				text;		(* Input file:  x.ps3 *)
   Ps4:				text;		(* Output file: x.ps4 *)
   addcl:			text;		(* list of new clauses *)
   Resolver:			ResolverType;
   StartOfClauseResolver:	StartOfClauseResolverType;
   StoreDivisions:		boolean;
   Stop:                        boolean;
   InComplete:			boolean;
   noroom:                      boolean;
   Text:			text;		(* Input file:  x.ct  *)
   VerseCount:			integer;
   VerseLabel:			LabelType;
   synnr:			text;
   Interactive:			boolean;
   CldName:                     StringType;


procedure vraagbestand;				{ name of Ps file }
var
   filenr: integer;
   ch: char;
   error: integer;
begin
   error := 0;
   { Dummy statement to fool the compiler, so it doesn't complain about
     variable error being used before set. }
   open(synnr, 'synnr', 'old', error);
   if error <> 0 then begin
      writeln(' Too eager, huh? Run capnr and subsequent programs first');
      halt
   end;
   reset(synnr);
   read(synnr, filenr, ch, PericopeName);
   writeln('"',PericopeName,'"');
   case filenr of
      0:
	 begin
	    writeln(' Input ready for syn01 only. Please run syn01 first.');
	    halt
	 end;
      1:
	 begin
	    writeln(' Input ready for syn02 only. Please run syn02 first.');
	    halt
	 end;
      2:
	 begin
	    writeln(' Input ready for syn03 only. Please run syn03 first.');
	    halt
	 end;
      otherwise
	 null
   end;
   writeln;
   writeln(' ... reading: ', PericopeName, '.ps3 .');
   open(Ps3, PericopeName + '.ps3', 'old', error);
   if error <> 0 then begin
      writeln(' ', PericopeName, '.ps3 file missing. Please run syn03 first.');
      halt
   end;
   open(Ps4, PericopeName + '.ps4', 'new');
   writeln(' ... writing: ', PericopeName, '.ps4');
   open(Text, PericopeName + '.ct', 'old');
   writeln(' ... also reading: ', PericopeName, '.ct .');
   open(ClauseDivisions, PericopeName + '.div', 'unknown');
   CldName := PericopeName + '.div';
   writeln(' ... also writing: ', PericopeName, '.div .');
   open(NewText, PericopeName + '.ct4', 'new');
   writeln(' ... and ', PericopeName, '.ct4 .');
   open(addcl, 'addClSet', 'new');
   rewrite(addcl);
   open(PartialDivFile, 'partcldivis', 'unknown');

   writeln(' user-accepted clauses will be written to file "addClSet" ');

end; { vraagbestand }


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


function CountLines(var f: text):integer;
var
   n: integer;
begin
   n := 0;
   reset(f);
   while not eof(f) do begin
      readln(f);
      n := n +1
   end;
   CountLines := n;
   reset(f)
end; { Countlines }

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
      writeln(dst);
   end;
   reset(src);
   reset(dst)
end; { CopyFile }

procedure CheckDivisions(var div_file: text);
begin
  InComplete := false;
  writeln('Number of lines in ',CldName, ': ', NumberOfDivisions:1);
  if NumberOfDivisions < NumberOfVerses then begin
     writeln(CldName, ' (= file with clause-divisions) is INcomplete.');
     writeln(
	' Please make new clauses (interactively) starting from line ',
	(NumberOfDivisions +1):2, '.'
     );
     CopyFile(div_file, PartialDivFile);
     writeln;
     writeln(' < hit  Return >'); readln;
     InComplete := true;
     reset(PartialDivFile);
     rewrite(div_file);
     if not Interactive then
     begin writeln(' non-Interactive mode is changed into INteractive mode');
	   Interactive := true;
     end;
   end;
end;   { CheckDivisions }

procedure WriteLexeme(var LexemeList: LexemeListType; WordIndex: integer);
begin
   write(Ps4, VerseLabel, ' ', LexemeList[WordIndex])
end; { WriteLexeme }


procedure WriteValues(WordIndex: integer);
var
   p: integer;
begin				{ schrijft kolommen 0 .. 15 }
   write(Ps4, AnalysisList[WordIndex, LEXICAL_SET]: 3);
   write(Ps4, AnalysisList[WordIndex, PART_OF_SPEECH]: 4);
   for p := 2 to SUFFIX do { morph info }
      write(Ps4, AnalysisList[WordIndex, p]: 3);
   write(Ps4, AnalysisList[WordIndex, 7]: 5);
   for p := 8 to 10 do { func info }
      write(Ps4, AnalysisList[WordIndex, p]: 3);
   write(Ps4, AnalysisList[WordIndex, STATE] : 6);
   write(Ps4, AnalysisList[WordIndex, PHRDEP_PSP]: 4 );
   if (WordIndex > 1) and (PART_OF_SPEECH = 6)
   then AnalysisList[WordIndex, PHRASE_TYPE] := -6;
   write(Ps4, AnalysisList[WordIndex, PHRASE_TYPE]: 4);
   write(Ps4, AnalysisList[WordIndex, DETERMINATION] :4);
   writeln(Ps4, AnalysisList[WordIndex, CLAUSE_MARKER]: 6)
end; { WriteValues }


procedure clear_arrays;
var
   word_index:	Word_IndexType;
   func_index:	Function_IndexType;
   info_index:	PhraseInfo_IndexType;
   type_index:	Vs_PhraseType_IndexType;
   cond_index:  Condition_IndexType;
begin
   for word_index := 1 to MAX_WORDS do
      for func_index := FIRST_FUNCTION to LAST_FUNCTION do
	 AnalysisList[word_index, func_index] := -1;
   for info_index := 1 to NUMBER_OF_PHRASE_INFO do
      for type_index := 1 to MAX_PATMS do
	  for cond_index := 0 to NUMBER_OF_CONDITIONS do
	 StartOfClauseResolver[info_index, type_index, cond_index] := 0
end; { clear_arrays }


procedure zoekclauses(var positie, phrase: integer);
var
   identical_phrase_types:	boolean;
   clause_type_index:		integer;
   condition:			integer;
   condition_index:		integer;
   l,cnr, pos :			integer;
   m, phrasepos :		integer;
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
      repeat
	 clause_type_index := clause_type_index + 1;
	 phrase_position := -1;
	 phrase_type_index := 0;			{ zoek phrase in array       }
	 condition := 0;
	 condition_index := 0;
	 repeat
	    phrase_position := phrase_position + 1;
	    phrase_type_index := phrase_type_index + 1;
	    identical_phrase_types :=
	       StartOfClauseResolver[PHRASE, positie + phrase_position,0] =
	       Resolver[clause_type_index, phrase_type_index, 0]
	 until not identical_phrase_types or
	    (Resolver[clause_type_index, phrase_type_index, 0] = COMPLEX_PHRASE) or
	    (Resolver[clause_type_index, phrase_type_index, 0] = START_CLAUSE);
	 identical_phrase_types :=
	    (Resolver[clause_type_index, phrase_type_index, 0] = START_CLAUSE) or
	    (Resolver[clause_type_index, phrase_type_index, 0] = COMPLEX_PHRASE);

	    {  conditions  }
	    phrasepos := 0;
	    for pos := positie to positie + phrase_position -1 do
		begin phrasepos := phrasepos + 1;
		      for cnr := 1 to 5 do
		      if StartOfClauseResolver[PHRASE, pos, cnr] <>
					      Resolver[clause_type_index, phrasepos, cnr]
		      then identical_phrase_types := false;
		      if StartOfClauseResolver[PHRASE, pos, 0] <>
					      Resolver[clause_type_index, phrasepos, 0]
                      then writeln(' something wrong in comparison of conditions');
                end;


	 if identical_phrase_types and
	    (Resolver[clause_type_index, phrase_type_index, 0] = START_CLAUSE)
	 then
	 begin
	    if positie > 1 then begin
	       AnalysisList[StartOfClauseResolver[LAST_WORD, positie,0], CLAUSE_MARKER] :=
		  START_CLAUSE;
	       StartOfClauseResolver[CLAUSE_MARKS, positie,0] := START_CLAUSE;
	       if AnalysisList[StartOfClauseResolver[LAST_WORD, positie,0] - 1, PHRASE_TYPE] = 0
	       then begin
		  l := StartOfClauseResolver[LAST_WORD, positie,0];
		  m := l;
		  repeat
		     l := l - 1;
		     if AnalysisList[l, PHRASE_TYPE] = 0 then begin	{  deel phr }
			AnalysisList[m, CLAUSE_MARKER] := -1;
			m := l;
			AnalysisList[l, CLAUSE_MARKER] := START_CLAUSE
		     end
		  until l = StartOfClauseResolver[LAST_WORD, positie - 1,0] + 1
	       end
	    end;
	    phrase_position := phrase_position - 1;
	    positie := positie + phrase_position
	 end
      until (identical_phrase_types) or
	 (clause_type_index = NumberOfClauseTypes) or
	 (Resolver[clause_type_index+1, 1, 0] <> phrase)
   end;
   if not (identical_phrase_types)
   then positie := positie + 1;
end; { zoekclauses }


procedure WriteScreen(c: char);
begin
   if c in ['#', '$'] then
      case c of
	 '#': write(' ');
	 '$': write('-')
      end
   else
      write(c)
end; { WriteScreen }


procedure naaraddcl(var nrphrases: integer; new : boolean);

type	newphrasetype	= array [Cl_PhraseType_IndexType, 0 ..5 ] of  Phrases_And_Conditions_Type;

var	phrteller	: integer;
	smaller,id	: boolean;
	newphrase	: newphrasetype;
						{general type ( -1 .. 30)  }
	n,clnr,phrnr	: integer;
	cnr, pnr        : integer;

   procedure insertclause (var clnr : integer);

   var p,q,r : integer;

   begin writeln(' clausetype inserted',' [ ',(NumberOfClauseTypes+1):5,' ]');
	NumberOfNew_Clauses := NumberOfNew_Clauses +1;
	for p := NumberOfClauseTypes downto clnr do
	begin for q := SMALLEST_CL_PHRASE_INDEX to MAX_PATMS_CATM
		do for r := 0 to 5
			do Resolver[p+1,q,r] := Resolver[p,q,r];
        end;
	NumberOfClauseTypes := NumberOfClauseTypes + 1;

	if NumberOfClauseTypes > NUMBER_CLAUSE_TYPES -10 then
	begin writeln;
	      write(' Warning ! Only room for');
	      writeln((NUMBER_CLAUSE_TYPES - NumberOfClauseTypes):4,' new clauses left');
	      if NumberOfClauseTypes > NUMBER_CLAUSE_TYPES -2 then
	      begin writeln(' Warning ! No room for new clause types ');
		    writeln(' you may proceed with the text ');
		    noroom := true;
              end;
        end;
	for q := SMALLEST_CL_PHRASE_INDEX to MAX_PATMS_CATM
		do begin Resolver[clnr,q,0] := newphrase[q,0];        { phrases }
			 {  write(Resolver[clnr,q,0]);  }
		         for r := 1 to 5 do
			 begin Resolver[clnr,q,r] := newphrase[q,r];{ conditions }
			   {    write((Resolver[clnr,q,r]):4);
			        write(' (',(newphrase[q,r]):3,' ) '); }
                         end;
			 {  writeln; }
		   end;
   end;

begin { of naaraddcl }
n := 0; smaller := false;
for phrteller := SMALLEST_CL_PHRASE_INDEX to MAX_PATMS_CATM do
for n := 0 to 5 do newphrase [phrteller,n]:= 0;
n:= 0;
phrteller := nrphrases; { writeln(' start "naaraddcl"', nrphrases:5);}
	if (nrphrases > 1) and (StartOfClauseResolver[CLAUSE_MARKS,phrteller,0] <> START_CLAUSE)
	then
	repeat phrteller := phrteller -1
	until (StartOfClauseResolver[CLAUSE_MARKS,phrteller,0] = START_CLAUSE)
		or
	      (phrteller = 1);
	      writeln;
        repeat write(addcl,StartOfClauseResolver[PHRASE,phrteller,0]:4);
      if n < MAX_PATMS_CATM then
	 n := n + 1
      else begin
	 message('syn04: ', VerseLabel,
	    ': Clause atom with more than ', n:1, ' phrase atoms');
	 pcexit(1)
      end;
		newphrase[n,0] := StartOfClauseResolver[PHRASE, phrteller,0];
		write((newphrase[n,0]):4);
		for cnr := 1 to 5 do
		begin
		newphrase[n,cnr] := StartOfClauseResolver[PHRASE, phrteller,cnr];
		write('  (', (newphrase[n,cnr]):3,')');
		end; writeln;
		phrteller := phrteller + 1
        until phrteller > nrphrases;
	writeln(addcl); newphrase[n+1,0] := START_CLAUSE;
	writeln;
					{ add newphrase to Clset; insert in Resolver }
	n := 1;
	phrnr := 1;
	clnr := 0;
   id := false;
   while not id and (clnr <= NumberOfClauseTypes) do
      if Resolver[clnr, 1, 0] = newphrase[phrnr, 0] then
	 id := true
      else
	 clnr := clnr + 1;
   if not id then begin
      message('syn04: Phrase type ', newphrase[phrnr, 0]:1,
	 ' missing in file clset');
      pcexit(1)
   end;
	clnr := clnr -1; smaller := false;
{	write(' clause_types starting with newphrase[phrnr,0] begin');
	write(' after clausetype nr:', clnr:4);
	writeln;
	}
	repeat smaller := true; clnr := clnr +1; id := true;
				n := 0; cnr := 0;
				{comparing as long as patterns in clset have larger figures }
				repeat n:= n+1;
					if Resolver[clnr,n,0] > newphrase[n,0]
					then smaller := false;           { phrases }
					if Resolver[clnr,n,0] <> newphrase[n,0]
					then id := false;

				        if (Resolver[clnr,n,0] = START_CLAUSE)
						or
					   (Resolver[clnr,n,0] = COMPLEX_PHRASE)
				        then smaller := true
			{		write( (Resolver[clnr,n,0]):3)  }
				until (newphrase[n+1,0] = START_CLAUSE)
				       or
				      (newphrase[n+1,0] = COMPLEX_PHRASE)
				       or
				      (Resolver[clnr,n,0] <> newphrase[n,0]);
		                      if (Resolver[clnr,n+1,0] <> START_CLAUSE)
					 and (newphrase[n+1,0] = START_CLAUSE)
				      then begin if id then
						       begin smaller := false;
							     id := false;
                                                       end;
						 { smaller := true; }
				           end;
                                     if id {identical phrase pattern}
				     then begin
					   for pnr := 1 to n do
					     for cnr := 1 to 5 do
					       if (Resolver[clnr,pnr,cnr] = 0) and
						  (newphrase[pnr,cnr] > 0)
					       then  begin smaller := true;
							   id :=false;
					             end   else
					       if (Resolver[clnr,pnr,cnr]<> newphrase[pnr,cnr])
					       then  smaller := false;
					    end
			{	writeln;    }
   until (smaller = true) or
	 (Resolver[clnr, 1, 0] < newphrase[phrnr, 0]);
	if id then begin  writeln(' newclause_type is known');
	           if (new) and (Interactive)
		          then begin writeln(' < Return > '); readln;
			       end;
                   end
        else
	if noroom = false then
	begin
	  insertclause(clnr);
	  writeln(' newclause_type inserted before clausetype nr:', clnr:4);
	  writeln; {
	  writeln(' < Return > '); readln;
		   }
        end
	else begin writeln(' no room for new clause types. You may proceed with your text');
		   writeln(' < Return > '); readln;
	     end;
end;


procedure printclauseset;
var p,q,r , phrase : integer;

begin
	{ naar addcl }
	 rewrite(addcl);
	for p := 1 to NumberOfClauseTypes do
		begin q := 0;
			repeat q := q+1;
				phrase := Resolver[p,q,0];
				write(addcl,phrase:3);
				if Resolver[p,q,1] <> 0 then
				begin write(addcl,' ( '); r:= 1;
					repeat if (r> 1)
					       then write(addcl,' ,');
					       write(addcl,(Resolver[p,q,r]):4);
					       r:=r+1;
					       if Resolver[p,q,r] < 0
					       then begin writeln(' in clause type',p:3, 'neg.cond.');
							  r := 5;
						    end
					until (Resolver[p,q,r] = 0) or (r >= 5);
					write(addcl,' ) ');
				end
				else begin
				    if (Resolver[p,q+1,0] = COMPLEX_PHRASE) and
				       (Resolver[p,q+2,0] > 0)
				    then begin write(addcl,' = ');
						q:= q+1;
					  end
				    else
				   if (Resolver[p,q+1,0] <> START_CLAUSE) and
				       (Resolver[p,q+1,0] <> COMPLEX_PHRASE)
				   then write(addcl,' - ')
				   end
			until (Resolver[p,q+1,0] = START_CLAUSE)
			      or
			      ( (Resolver[p,q+1,0] = COMPLEX_PHRASE)
				 and
				(Resolver[p,q+2,0] = 0 )  );
			if Resolver[p, q, 1] <> 0 then
			   write(addcl, '   ')
			else
			   write(addcl, ' - ');
			writeln(addcl, Resolver[p, q+1, 0]:1)
		  end;

end;


function ValueList_In(var v: ValueListType; x: integer): boolean;
var
   i: integer;
   found: boolean;
begin
   i := 0;
   found := false;
   while not found and (v[i] <> EOI) do begin
      found := v[i] = x;
      i := i + 1;
      assert(i <= MAX_COND_VALUES)
   end;
   ValueList_In := found
end;


function ConditionList_In(var l: ConditionListType;
   f: Function_IndexType; v: integer;
   var c: ConditionIndexType): boolean;
var
   i: integer;
   found: boolean;
begin
   i := FIRST_CONDITION;
   found := false;
   while not found and (i <= NumberConditions) do
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


function PhraseHead(w: Word_IndexType): Word_IndexType;
(* Returns the word index of the head (the first word) of the phrase
   that ends at w *)
var
   i: Word_IndexType;
begin
   if w = 1 then
      i := 1
   else begin
      i := w - 1;
      while (i <> 1) and (AnalysisList[i, PHRASE_TYPE] = 0) do
	 i := i - 1;
      if AnalysisList[i, PHRASE_TYPE] <> 0 then
	 i := i + 1
   end;
   PhraseHead := i
end;


procedure findconditions(word_index, phrase_type_index: integer);
var
   col, TypeOfCondition: ConditionIndexType;
   gram_value: integer;
   pr: Word_IndexType;

procedure compare(col, gram_value: integer);
(* local to findconditions *)
var
   cond_index: integer;
begin
   if ConditionList_In(ConditionList, col, gram_value, TypeOfCondition)
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

    procedure findlexeme(word_index: Word_IndexType);
    var
    TypeOfCondition,
    cond_index,
    pos     : integer;
    hit     : boolean;

    begin
      pos := 0; hit := false;
	       repeat pos := pos + 1;
	         if LexemeList[word_index] = LexCondList[pos]
	         then begin { writeln(' lex.condition:',(pos+100));  }
		      TypeOfCondition := pos + 100;
		      hit := true; cond_index := 0;
			   repeat cond_index := cond_index+1
			   until StartOfClauseResolver[PHRASE, phrase_type_index,cond_index] = 0;
		           StartOfClauseResolver[PHRASE, phrase_type_index,cond_index] :=
										 TypeOfCondition;
                      end
	       until (pos = NumberLexCond) or (hit = true);

    end;

begin                                          {searches in AnalysisList(Ps3) and compares with }
      TypeOfCondition := 0;                    {morfcond.cl and lexcond.cl }
   if AnalysisList[word_index,PHRASE_TYPE] = 1      { VERB }
   then begin { writeln ( LexemeList[word_index]);
	      writeln (' rootf.morph. =', AnalysisList[word_index,3]);
	      } col := 3;
	      gram_value := AnalysisList[word_index, col];
	      compare(col, gram_value);
	      if AnalysisList[word_index,6] > 0 then
	      begin
	      { writeln (' pronom.sfx.  =', AnalysisList[word_index,6]);
	      } col := 6;
	      gram_value := AnalysisList[word_index, col];
	      compare(col, gram_value);
	      end;
	      if AnalysisList[word_index,7] in [6,62] then
	      begin
	      { writeln(' vbform      =', AnalysisList[word_index,7]);
	      } col := 7;
	      gram_value := AnalysisList[word_index, col];
	      compare(col, gram_value);
	      end;
	      col := 9; gram_value := AnalysisList[word_index,col];
	      compare(col, gram_value);               { number }

	end else
   if (AnalysisList[word_index,PHRASE_TYPE] = 2) or      { NP }
      (AnalysisList[word_index,PHRASE_TYPE] = -2)       { NPapp}
   then begin { writeln ( AnalysisList[word_index,14],' determination');
	      } col := 14;
	      gram_value := AnalysisList[word_index, col];
	      compare(col, gram_value);
	      if AnalysisList[word_index,6] > 0 then
	      begin
	      { writeln (' pronom.sfx.  =', AnalysisList[word_index,6]);
	      } col := 6;
	      gram_value := AnalysisList[word_index, col];
	      compare(col, gram_value);
	      end
	end else
   if AnalysisList[word_index,PHRASE_TYPE] = 5           { PP }
   then begin pr := PhraseHead(word_index);
              { writeln ( LexemeList[pr],' prep of PP');
	      } if AnalysisList[pr,1] = 5 then findlexeme(pr)
		else begin col := 5; gram_value := AnalysisList[word_index,col];
			   compare(col, gram_value);
		     end;
	      if AnalysisList[pr,6] > 0 then
	      begin
	      { writeln (' pronom.sfx.  =', AnalysisList[pr,6]);
	      } col := 6;
	      gram_value := AnalysisList[pr, col];
	      compare(col, gram_value);
	      end

	end else
   if AnalysisList[word_index,PHRASE_TYPE] = 6          { CjP }
   then begin { writeln ( LexemeList[word_index]);
	      } findlexeme(word_index);
	end else
   if AnalysisList[word_index,PHRASE_TYPE] = 7
   then begin { writeln ( LexemeList[word_index]);
	      } findlexeme(word_index);
	      col := 8;      { person }
              gram_value :=  AnalysisList[word_index,col];
	      compare(col, gram_value);
	end else
   if AnalysisList[word_index,PHRASE_TYPE] = 13         { AdjP }
   then begin { writeln ( LexemeList[word_index]);
	      } col := 9; gram_value := AnalysisList[word_index,col];
	      compare(col, gram_value);          { number }
	end;
end;

procedure maakclauses( var div_count: integer);
var
   char_index:		integer;
   last_char:			integer;
   answer:		char;
   phrase_count:			integer;
   apo:			integer;
   atomnr:		integer;
   clause_mark:		integer;
   last_word_index:	integer;
   phrase_type:		integer;
   clause_atom_nr:	integer;
   word_count:		integer;
   function_index:	integer;
   i,cnr:	        integer;
   lexteller:		integer;
   maxphr:		integer;
   number_of_phrases:	integer;
   phrase:		integer;
   phrase_type_index:	integer;
   start_clause_index:	integer;
   verse_line:		LineType;
   verse_label:		LabelType;
   word_index:		integer;
   x:			integer;
begin						{ begin procedure maakclauses }
   clear_arrays;
   phrase_type_index := 0;
   if div_count = NumberOfDivisions then
   begin
      StoreDivisions := true;
      InComplete := false;
      writeln('No (further) information found in file ', CldName, '.');
      writeln('Awaiting now info from you ... ');
      writeln('< hit  Return >'); readln;
   end;

   read(Text, verse_label);
   SkipSpace(Text);
   write(NewText, verse_label, ' ');
   start_clause_index := 0;				{ tekstnr uit CT }
   if InComplete then
      begin read(PartialDivFile, verse_label); repeat read(PartialDivFile, start_clause_index)
	    until start_clause_index < LEAST_PARSING_CODE;
	    writeln(' partcldivis', verse_label, ' ');
      end   else
   if not StoreDivisions then
      begin if InComplete then
	    begin
	    read(PartialDivFile, verse_label); repeat read(PartialDivFile, start_clause_index)
	    until start_clause_index < LEAST_PARSING_CODE
	    end
	    else
	    begin
            read(ClauseDivisions, verse_label); repeat read(ClauseDivisions, start_clause_index)
	    until start_clause_index < LEAST_PARSING_CODE;
	    end;
      end;

   i := 0;
   repeat
      i := i + 1;
      read(Text, verse_line[i]);
      if (verse_line[i] = ' ') and
	 (verse_line[i-1] = '1')
      then verse_line[i] := '_'
   until (verse_line[i] = '*') or eoln(Text) or (i = LINE_LENGTH);
   if verse_line[i] <> '*' then begin
      writeln('Input incorrect: Line does not end in "*".');
      halt
   end;
   writeln(' max char:', i);
   readln(Text);
   word_index := 0;
   repeat						{ read from file PS3 }
      word_index := word_index + 1;
      read(Ps3, verse_label);
      SkipSpace(Ps3);
      if word_index = 1 then
	 VerseLabel := verse_label;
      if VerseLabel = verse_label then begin
	 for i := 1 to LEXEME_LENGTH do
	    read(Ps3, LexemeList[word_index, i]);
	 function_index := FIRST_FUNCTION;
	 repeat
	    function_index := function_index + 1;
	    read(Ps3, AnalysisList[word_index, function_index])
	 until function_index = LAST_FUNCTION - 1;

	 if StoreDivisions = false then begin			{ info in ClauseDivisions }

	    if word_index = start_clause_index then begin
	       AnalysisList[word_index, CLAUSE_MARKER] := START_CLAUSE;
	       StartOfClauseResolver[CLAUSE_MARKS, phrase_type_index+1,0] := START_CLAUSE;    {test}
	       if InComplete then begin
				  if not eoln(PartialDivFile) then
				   repeat read(PartialDivFile, start_clause_index)
	                           until start_clause_index < LEAST_PARSING_CODE;
				  end
	              else
				  begin if not eoln(ClauseDivisions) then
		                   repeat read(ClauseDivisions, start_clause_index)
	                           until start_clause_index < LEAST_PARSING_CODE;
				  end;

		    naaraddcl(phrase_type_index,false);                  { bouwt onbekenden bij in addClSet } {test}
		    { printclauseset; }

	    end
	    else if word_index = -start_clause_index then begin  { app. niet meer actueel (?)}
	       AnalysisList[word_index, CLAUSE_MARKER] := COMPLEX_PHRASE;
	       if InComplete then begin
				  if not eoln(PartialDivFile) then
				   repeat read(PartialDivFile, start_clause_index)
	                           until start_clause_index < LEAST_PARSING_CODE;
				  end
		else
				  begin
				  if not eoln(ClauseDivisions) then
				   repeat read(ClauseDivisions, start_clause_index)
	                           until start_clause_index < LEAST_PARSING_CODE;
				  end;
	    end;
	 end;

	 if AnalysisList[word_index, PHRASE_TYPE] <> 0 then		{fill StartofClRes}
	 begin
	    phrase_type_index := phrase_type_index + 1;
	    StartOfClauseResolver[PHRASE, phrase_type_index, 0] :=
	       AnalysisList[word_index, PHRASE_TYPE];
	    StartOfClauseResolver[LAST_WORD, phrase_type_index, 0] := word_index;
	    findconditions(word_index, phrase_type_index);
	 end
	 { appositions are not skipped  }
      end;
      readln(Ps3)
   until (word_index > 1) and (VerseLabel <> verse_label);
   StartOfClauseResolver[CLAUSE_MARKS, phrase_type_index+1, 0 ] := START_CLAUSE;  {test}
   if StoreDivisions = false then
   begin
   naaraddcl(phrase_type_index,false);                                    {test}
   {  printclauseset; }
   end;
   word_index := word_index - 1;

   div_count := div_count + 1;
   if InComplete then
   begin readln(PartialDivFile);
	 if div_count = NumberOfDivisions then
	 writeln(' div_count = NumbersOfDivisions');
   end else
   if StoreDivisions = false then
      readln(ClauseDivisions);
   maxphr := phrase_type_index;
   {  page;  }
   writeln(VerseLabel);
   writeln(' maxw:', word_index, ' maxphr:', maxphr);
   VerseCount := VerseCount + 1;
   number_of_phrases := 0;
   if StoreDivisions then
      repeat
	 { loopt tot StartOfClauseResolver ca 568 }
	 i := number_of_phrases;
	 repeat
	    i := i + 1;
	    phrase := StartOfClauseResolver[PHRASE, i,0];
	    Lexeme := LexemeList[StartOfClauseResolver[LAST_WORD, i,0]];

	    zoekclauses(i, phrase)
	 until i >= maxphr;

{ Start the interactive procedure }
	 word_count := 0;
	 char_index := 0;
	 phrase_count := 0;
	 apo := 0;
	 i := 0;
	 x := 0;
	 last_char := 0;
	 if number_of_phrases > 0 then begin
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
		for cnr := 5 downto 1 do
		    begin for apo := 1 to maxphr do
		          write(StartOfClauseResolver[PHRASE, apo,cnr]: 4);  {conditions}
			  writeln( ' conditions');
                    end;
		 writeln;  writeln;
		for apo := 1 to maxphr do
		    write(StartOfClauseResolver[PHRASE, apo,0]: 4);
		 writeln( ' phrases');
		 for apo := 1 to maxphr do
		    write(StartOfClauseResolver[LAST_WORD, apo,0]: 4);
		 writeln( ' position last_word of phrase');
		 for apo := 1 to maxphr do
		    write(StartOfClauseResolver[CLAUSE_MARKS, apo,0]: 4);
		 writeln( ' start of Clause');

							{ text in clauses on screen }
	repeat writeln;

	    atomnr := atomnr + 1;
	    lines_on_screen := lines_on_screen + 4;
	    write('cl atom :', atomnr: 3, '  ');
	    repeat
	       char_index := char_index + 1;		{ aantal characters }
	       WriteScreen(verse_line[char_index]);
	       if verse_line[char_index] in [' ', '-', '#', '$'] then begin
		  word_count := word_count + 1;
		  if StartOfClauseResolver[LAST_WORD, phrase_count + 1,0] = word_count
		  then begin
		     write('|| ');              { divide phrases on screen }
						{ phrase dividers in array }
		     phrase_count := phrase_count + 1;
		     if verse_line[char_index] = ' ' then
			verse_line[char_index] := '#'
		     else if verse_line[char_index] = '-' then
			verse_line[char_index] := '$';
		  end
	       end
	    until (AnalysisList[word_count + 1, CLAUSE_MARKER] = START_CLAUSE) and
	       (verse_line[char_index] in [' ', '-', '#', '$']) or
	       (word_count >= word_index);
	    writeln;
	    apo := last_char;
	    if Interactive then begin

	       write('phr atom nr: ');
	       repeat
		  i := i + 1;
		  repeat
		     apo := apo + 1;
		     if not (verse_line[apo + 1] in ['#', '$']) then
			write(' ')
		  until verse_line[apo + 1] in [ '#', '$'];
		  apo := apo + 1;
		  write(i: 2, ' ||')
	       until (StartOfClauseResolver[CLAUSE_MARKS, i + 1,0] = START_CLAUSE) or
		     (i >= maxphr);
	       writeln;
	       apo := last_char
	    end;
	    write('phr type :');
	    i := x;
	    repeat
	       i := i + 1;
	       phrase_type := StartOfClauseResolver[PHRASE, i,0];
	       repeat
		  apo := apo + 1;
		  if not (verse_line[apo + 1] in ['#', '$']) then
		     write(' ')
	       until verse_line[apo + 1] in [ '#', '$'];
	       apo := apo + 1; write(' ');
	       if phrase_type < 0 then
		  write('(ap)')
	       else
		  write(PhraseLabel(phrase_type):4)
	    until (StartOfClauseResolver[CLAUSE_MARKS, i + 1,0] = START_CLAUSE) or
		  (i >= maxphr);
	    writeln;
	    if not Interactive then begin
	       write(' end position phr:');
	       i := x;
	       apo := last_char;
	       repeat
		  i := i + 1;
		  last_word_index := StartOfClauseResolver[LAST_WORD, i,0];
		  repeat
		     apo := apo + 1;
		     if not (verse_line[apo + 1] in ['#', '$']) then
			write(' ')
		  until verse_line[apo + 1] in ['#', '$'];
		  apo := apo + 1;
		  write(last_word_index: 3, ' ')
	       until (StartOfClauseResolver[CLAUSE_MARKS, i + 1,0] = START_CLAUSE) or
		     (i >= maxphr);
	       writeln;
	       write('            ');
	       i := x;
	       apo := last_char;
	       repeat
		  i := i + 1;
		  clause_mark := StartOfClauseResolver[CLAUSE_MARKS, i,0];
		  repeat
		     apo := apo + 1;
		     if not (verse_line[apo + 1] in ['#', '$']) then
			write(' ')
		  until verse_line[apo + 1] in ['#', '$'];
		  apo := apo + 1;
		  if clause_mark = 0 then
		     write('    ')
		  else if clause_mark = COMPLEX_PHRASE then
		     write('  = ')
		  else if clause_mark = START_CLAUSE then
		     write('  ^ ')
	       until (StartOfClauseResolver[CLAUSE_MARKS, i + 1,0] = START_CLAUSE) or
		     (i >= maxphr);
	       writeln
	    end;
	    x := i;
	    last_char := char_index
	 until (i >= maxphr) or (lines_on_screen > 30);
	 if Interactive then begin
	    repeat writeln;
	       write(
	       'Do you agree with the division into clause(atom)s? [y/n]  (or: [s]top) ');
	       readln(answer)
	    until (answer in YES_NO) or (answer = 's');
	    if answer in NO then begin
	       clause_atom_nr := 0;
	       repeat
		  write(' What is the number of the first INcorrect clause-atom?   ');
		  AskInteger(clause_atom_nr)
	       until clause_atom_nr > 0;
	       atomnr := clause_atom_nr;
	       write('What is really the final phrase atom of clause-atom ', atomnr: 2, '?      ');
	       AskInteger(number_of_phrases);
	       writeln;
	       clause_atom_nr := 0;			{ uitschakelen vorige indeling }
	       i := 0;
	       repeat
		  i := i + 1;
		  if StartOfClauseResolver[CLAUSE_MARKS, i,0] = START_CLAUSE then begin
		     clause_atom_nr := clause_atom_nr + 1;
		     if clause_atom_nr >= atomnr then begin
			StartOfClauseResolver[CLAUSE_MARKS, i,0] := 0;
			AnalysisList[
			   StartOfClauseResolver[LAST_WORD, i - 1,0] + 1, CLAUSE_MARKER
			] := -1
		     end
		  end
	       until i >= maxphr;
	       naaraddcl(number_of_phrases, true);		{ new clauses to file }
	       if number_of_phrases < maxphr then begin
		  StartOfClauseResolver[CLAUSE_MARKS, number_of_phrases + 1,0] := START_CLAUSE;
		  lexteller := StartOfClauseResolver[LAST_WORD, number_of_phrases +1,0];
		   { goto end of next clause_atom }
		  repeat lexteller := lexteller -1
		  until AnalysisList[lexteller,PHRASE_TYPE] <> 0;
		  lexteller := lexteller + 1;
		  AnalysisList[lexteller, CLAUSE_MARKER] := START_CLAUSE;
	       end
	    end else if answer in YES then
	       number_of_phrases := maxphr
		else if answer = 's' then Stop := true
	 end else
	    number_of_phrases := maxphr

      until (number_of_phrases >= maxphr) or (Stop);

   { tekst maken }
   { writeln('Stop:',Stop, ' StoreDivisions:',StoreDivisions,' InComplete',InComplete); }
   last_char := 0;
   if not Stop then
   begin if (StoreDivisions) or (InComplete) then
      write(ClauseDivisions, VerseLabel, ' ');
   for i := 1 to word_index do begin
      WriteLexeme(LexemeList, i);	{ nog aanvullen: noteer uit verse_line }
      WriteValues(i);
      repeat
	 last_char := last_char + 1;
	 if verse_line[last_char] = '#' then
	    verse_line[last_char] := ' '
	 else if verse_line[last_char] = '$' then
	    verse_line[last_char] := '-';
	 write(NewText, verse_line[last_char])
      until verse_line[last_char] in [' ', '-'];
      { if (StoreDivisions) or (InComplete) or (not(Interactive))
      then} begin
           if AnalysisList[i + 1, CLAUSE_MARKER] = START_CLAUSE then begin
	      writeln(Ps4, '           *');
	      writeln(NewText, '*');
	      if not Stop then
	      write(NewText, VerseLabel, ' ');
	      if (StoreDivisions) or (InComplete) then
	         write(ClauseDivisions, ' ', i + 1:1)
              end else if
	   (AnalysisList[i + 1, CLAUSE_MARKER] = COMPLEX_PHRASE) and StoreDivisions
           then
	        write(ClauseDivisions, ' ', -(i + 1):1)
	   end;
   end;
   end;
   if not Stop then begin
      if StoreDivisions or InComplete then
	 writeln(ClauseDivisions, ' ', EOD:1);
      writeln(Ps4, '           *');
      writeln(NewText, '*')
   end
end; { maakclauses }


procedure read_clauses;
var
   ch:			char;
   clause_set:		text;
   condition:		integer;
   clause_type_index:	integer;
   phrase_type_index:	integer;
   phrase_type:		integer;
   condition_index:	integer;
begin
   open(clause_set, 'clset', 'old');
   reset(clause_set);
   clause_type_index := 0;
   phrase_type_index := 0;
   phrase_type := 0;
   while not eof(clause_set) do
   begin
      clause_type_index := clause_type_index + 1;
      phrase_type_index := 0;
      condition_index := 0;
      while not eoln(clause_set) do begin
	 phrase_type_index := phrase_type_index + 1;
	 read(clause_set, phrase_type);      {            write(phrase_type:4); }
	 Resolver[clause_type_index, phrase_type_index, 0] := phrase_type;
	 Resolver[clause_type_index, phrase_type_index, 1] := 0; { plaats voor condities }
	 repeat
	    if not eoln(clause_set) then
	       read(clause_set, ch)
	 until (ch in ['(', '-']) or eoln(clause_set);
	 condition_index := 0;
	 if ch = '(' then                           { read conditions from clause set}
	 begin                               {             write(' (');         }
	    repeat
	       read(clause_set, condition);  {              write(condition:3); }
	       repeat
		  read(clause_set, ch)
	       until ch in [')', ','];       {              write(' ',ch);      }
	       condition_index := condition_index + 1;
	       Resolver[clause_type_index, phrase_type_index, condition_index] := condition
	    until ch = ')';
	    condition_index := condition_index + 1;
	    Resolver[clause_type_index, phrase_type_index, condition_index] := 0
	 end
      end;
      Resolver[clause_type_index, phrase_type_index + 1, 0] := START_CLAUSE;
					     {               writeln(START_CLAUSE);      }
      {
      if compoundphraseIndicator then
	 Resolver[clause_type_index, phrase_type_index + 1, 0] := COMPLEX_PHRASE;
	 }
      readln(clause_set)
   end;
   close(clause_set);
   NumberOfClauseTypes := clause_type_index;

   writeln(' total number of Clause Types:', NumberOfClauseTypes: 4);
   writeln;
   if NumberOfClauseTypes > NUMBER_CLAUSE_TYPES -2 then noroom := true
   else noroom := false;
end; { Read_clauses  }



procedure ReadConditionList
(var f: text; var list: ConditionListType; var count: ConditionIndexType);
var
ch:                  char;
condition_index:     ConditionIndexType;
function_index:      Function_IndexType;
gram_value:          integer;
value_index:         ValueIndexType;
begin
while not eof(f) do begin
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
	writeln(' number of morphological conditions known in file "morfcondcl":' , condition_index);
end; { ReadConditionList }


procedure ReadLexConditionList
(var f: text; var list: LexemeListType; var count: integer);
var
lex_index:          integer;
begin
	lex_index := 0;
	while not eof(f) do begin
		lex_index := lex_index + 1;
		read(f, list[lex_index]);
		readln(f);
		writeln(' list[lex_index] :',list[lex_index],'.');
	end;
	count := lex_index;
	writeln(' number of lexical conditions known in file "lexcondcl":', lex_index);
end;  { ReadLexConditionList }


procedure initialize;
{ Make sure some values are set }
begin
   assert(MAX_WORDS < EOD);
   VerseCount := 0;
   Interactive := false;
   NumberOfClauseTypes := 0;
   vraagbestand
end; { initialize } { end of procedure initialize }


function Filled(var f: text): boolean;
begin
   reset(f);
   while not eof(f) and (f^ = ' ') do
      get(f);
   Filled := not eof(f)
end; { Filled }


procedure read_conditions;
begin
   open(ConditionsFile, 'morfcondcl', 'old');
   reset(ConditionsFile);
   ReadConditionList(ConditionsFile, ConditionList, NumberConditions);
   open(LexConditionsFile, 'lexcondcl', 'old');
   reset(LexConditionsFile);
   ReadLexConditionList(LexConditionsFile, LexCondList, NumberLexCond);
end; {read_conditions }


procedure AskMode(var mode: boolean);
var
   answer:	char;
begin
   repeat
      writeln('Work interactively? [y/n]: ');
      readln(answer)
   until answer in YES_NO;
   mode :=  answer in YES
end; { AskMode }


begin
   initialize;
   AskMode(Interactive);
   if not Filled(ClauseDivisions) then begin
      StoreDivisions := true;
      rewrite(ClauseDivisions)
   end else begin
      NumberOfDivisions := CountLines(ClauseDivisions);
      NumberOfVerses := CountLines(Text);
      CheckDivisions(ClauseDivisions);
      StoreDivisions := false
   end;
   writeln(' Store Divisions: ', StoreDivisions);
   NumberOfNew_Clauses := 0;
   read_conditions;
   read_clauses;
   reset(Ps3);
   rewrite(Ps4);
   reset(Text);
   rewrite(NewText);
   DivisionCount := 0;
   Stop := false;

   while not eof(Ps3) and not Stop do
      maakclauses(DivisionCount);
   printclauseset;
   close(Ps4);
   close(NewText);
   close(ClauseDivisions);
   close(addcl);
   writeln(' Number of verses in text ', PericopeName, ' :', VerseCount);
   rewrite(synnr);
   writeln(synnr, '4 ', PericopeName);
   writeln(' Number of New Clausetypes:', NumberOfNew_Clauses:5);
   close(synnr)
end.
