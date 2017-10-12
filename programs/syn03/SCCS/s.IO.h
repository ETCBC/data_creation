h51045
s 00011/00008/00058
d D 1.3 99/04/14 11:05:21 const 3 2
c Bug in Grammar_Label and Pattern_StickyTail. Cleaned up code.
e
s 00004/00004/00062
d D 1.2 99/03/25 10:38:40 const 2 1
c Added surface text to the phrase pattern statistics.
e
s 00066/00000/00000
d D 1.1 99/02/16 14:13:33 const 1 0
c date and time created 99/02/16 14:13:33 by const
e
u
U
f e 0
f m dapro/syn03/IO.h
t
T
I 1
#ifndef	IO_H
#define	IO_H

(* ident "%Z%%M% %I% %G%" *)

#include <AtomList.h>
#include <File.h>
#include <LCTable.h>
I 2
#include <Loci.h>
E 2
#include <MCTable.h>
#include <Pattern.h>
#include <Surface.h>
#include <Verse.h>
D 2
#include <VerseLabelList.h>
E 2

const
   TAG_WIDTH = 6;

D 3
procedure Read_AtomList(var f: FileType; l: AtomListType);
E 3
I 3
procedure Print_Pattern(var f: text; p: PatternType);
E 3
extern;

D 3
function  Read_Integer(var f: text; var i: integer):boolean;
E 3
I 3
procedure Print_Tag(var f: text; t: TagType; n, w: integer);
E 3
extern;

I 3
procedure Print_Word(var f: text; w: WordType);
extern;

procedure Read_AtomList(var f: FileType; l: AtomListType);
extern;

E 3
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

I 3
function  Scan_Integer(var f: text; var i: integer):boolean;
extern;

E 3
procedure SkipSpace(var f: text);
extern;

function  Width(n: integer):integer;
extern;

procedure Write_AtomList(var f: FileType; l: AtomListType);
extern;

I 2
procedure Write_Loci(var f: FileType; l: LociType);
extern;

E 2
procedure Write_Pattern(var f: FileType; p: PatternType);
extern;

procedure Write_ReportPattern(var f: FileType; p: PatternType; l, n: integer);
extern;

D 3
procedure Write_Tag(var f: text; t: TagType; n, w: integer);
extern;

E 3
procedure Write_Verse(var f: FileType; v: VerseType);
extern;

D 2
procedure Write_VerseLabelList(var f: FileType; l: VerseLabelListType);
extern;

E 2
D 3
procedure Write_Word(var f: text; w: WordType);
extern;

E 3
#endif	(* not IO_H *)
E 1
