#ifndef	IO_H
#define	IO_H

(* ident "@(#)dapro/syn03/IO.h 1.3 04/14/99" *)

#include <AtomList.h>
#include <File.h>
#include <LCTable.h>
#include <Loci.h>
#include <MCTable.h>
#include <Pattern.h>
#include <Surface.h>
#include <Verse.h>

const
   TAG_WIDTH = 6;

procedure Print_Pattern(var f: text; p: PatternType);
extern;

procedure Print_Tag(var f: text; t: TagType; n, w: integer);
extern;

procedure Print_Word(var f: text; w: WordType);
extern;

procedure Read_AtomList(var f: FileType; l: AtomListType);
extern;

procedure Read_LCTable(var f: FileType; t: LCTableType);
extern;

procedure Read_MCTable(var f: FileType; t: MCTableType);
extern;

procedure Read_Pattern(var f: FileType; p: PatternType; l: LCTableType; m: MCTableType);
extern;

procedure Read_Surface(var f: FileType; s: SurfaceType);
extern;

procedure Read_Verse(var f: FileType; v: VerseType);
extern;

function  Scan_Integer(var f: text; var i: integer):boolean;
extern;

procedure SkipSpace(var f: text);
extern;

function  Width(n: integer):integer;
extern;

procedure Write_AtomList(var f: FileType; l: AtomListType);
extern;

procedure Write_Loci(var f: FileType; l: LociType);
extern;

procedure Write_Pattern(var f: FileType; p: PatternType);
extern;

procedure Write_ReportPattern(var f: FileType; p: PatternType; l, n: integer);
extern;

procedure Write_Verse(var f: FileType; v: VerseType);
extern;

#endif	(* not IO_H *)
