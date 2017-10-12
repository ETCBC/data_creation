#ifndef	VERSE_H
#define	VERSE_H

(* ident "@(#)dapro/syn03/Verse.h 1.1 02/16/99" *)

#include <VerseLabel.h>
#include <Word.h>

(*
** The longest verse in Hebrew is Esther 8:9 with 76 words, in Aramaic
** Daniel 5:23 with 66 words
*)

type
   WordNodePointer =
      ^ WordNode;
   WordNode =
      record
	 wrd:  WordType;
	 next:  WordNodePointer;
	 prior: WordNodePointer
      end;
   VerseInstance =
      record
	 head:    WordNodePointer;
	 current: WordNodePointer;
	 tail:    WordNodePointer;
	 lab:     VerseLabelType;
	 length:  integer
      end;
   VerseType =
      ^ VerseInstance;
   
procedure Verse_Add(v: VerseType; w: WordType);
extern;

procedure Verse_Clear(v: VerseType);
extern;

procedure Verse_Create(var v: VerseType);
extern;

procedure Verse_Delete(var v: VerseType);
extern;

function  Verse_End(v: VerseType):boolean;
extern;

procedure Verse_First(v: VerseType);
extern;

procedure Verse_GetLabel(v: VerseType; var l: VerseLabelType);
extern;

function  Verse_Length(v: VerseType):integer;
extern;

procedure Verse_Next(v: VerseType);
extern;

procedure Verse_Retrieve(v: VerseType; w: WordType);
extern;

procedure Verse_SetLabel(v: VerseType; l: VerseLabelType);
extern;

procedure Verse_Update(v: VerseType; w: WordType);
extern;

#endif	(* not VERSE_H *)
