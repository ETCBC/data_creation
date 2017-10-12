h40355
s 00005/00003/00057
d D 1.3 15/04/29 15:38:39 const 3 2
c Needed to generate condition 205 (same lexeme) for parsephrases(1)
e
s 00003/00002/00057
d D 1.2 99/03/25 10:38:38 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00059/00000/00000
d D 1.1 99/02/16 14:13:31 const 1 0
c date and time created 99/02/16 14:13:31 by const
e
u
U
f e 0
f m dapro/syn03/Grammar.h
t
T
I 1
#ifndef	GRAMMAR_H
#define	GRAMMAR_H

D 3
(* ident "%Z%%M% %I% %G%" *)
E 3
I 3
(* ident "%W% %E%" *)
E 3

D 2
#include <File.h>
E 2
#include <CondSet.h>
I 2
#include <File.h>
E 2
#include <LCTable.h>
I 2
#include <Locus.h>
E 2
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

D 2
procedure Grammar_Label(g: GrammarType; p: PatternType; l: VerseLabelType);
E 2
I 2
procedure Grammar_Label(g: GrammarType; p: PatternType; l: LocusType);
E 2
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

D 3
procedure Grammar_WC(g: GrammarType; w: WordType; c: CondSetType);
(* Fills [c] with all conditions from [g] that [w] meets *)
E 3
I 3
procedure Grammar_WC(g: GrammarType; w0, w1: WordType; c: CondSetType);
(* Fills [c] with all conditions from [g] that [w1] meets. The previous
   word [w0] is needed to test [w1] for the condition that is has a
   lexeme equal to its predecessor. *)
E 3
extern;

procedure Grammar_Write(g: GrammarType; var ps: FileType);
extern;

#endif	(* not GRAMMAR_H *)
E 1
