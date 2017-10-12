#ifndef	GRAMMAR_H
#define	GRAMMAR_H

(* ident "@(#)dapro/syn03/Grammar.h	1.3 15/04/29" *)

#include <CondSet.h>
#include <File.h>
#include <LCTable.h>
#include <Locus.h>
#include <MCTable.h>
#include <Pattern.h>
#include <PhraseSet.h>
#include <Word.h>

type
   GrammarInstance =
      record
	 ltab: LCTableType;
	 mtab: MCTableType;
	 pset: PhraseSetType
      end;
   GrammarType =
      ^ GrammarInstance;

procedure Grammar_Add(g: GrammarType; p: PatternType);
extern;

procedure Grammar_Create(var g: GrammarType);
extern;

procedure Grammar_Delete(var g: GrammarType);
extern;

procedure Grammar_Label(g: GrammarType; p: PatternType; l: LocusType);
extern;

procedure Grammar_Match(g: GrammarType; p1, p2: PatternType);
(* Copies to [p2] the longest match in [g] for [p1] *)
extern;

procedure Grammar_Read(g: GrammarType; var ps, mc, lc: FileType);
extern;

function  Grammar_Rematch(g: GrammarType; p1, p2: PatternType):boolean;
extern;

procedure Grammar_Remove(g: GrammarType; p: PatternType);
extern;

procedure Grammar_Report(g: GrammarType; var f: FileType);
extern;

procedure Grammar_WC(g: GrammarType; w0, w1: WordType; c: CondSetType);
(* Fills [c] with all conditions from [g] that [w1] meets. The previous
   word [w0] is needed to test [w1] for the condition that is has a
   lexeme equal to its predecessor. *)
extern;

procedure Grammar_Write(g: GrammarType; var ps: FileType);
extern;

#endif	(* not GRAMMAR_H *)
