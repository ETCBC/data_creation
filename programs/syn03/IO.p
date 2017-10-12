module IO;

(* ident "@(#)dapro/syn03/IO.p	1.8 15/09/14" *)

#include <Error.h>
#include <IO.h>


const
   EOAL = 999; (* End of atom list in PHD file *)


private
function eowchr(var f: text):boolean;
begin
   eowchr := eof(f) or eoln(f) or Space(f^) or (f^ = '-')
end;


private
procedure pattern_assign(p: PatternType; pos_l: IntListType; cl: CondSetListType; sta_l, pdp_l, typ_l, det_l: IntListType);
var
   c: CondSetType;
   i: ItemType;
   w_pos, p_sta, p_pos, p_typ, p_det: integer;
begin
   Pattern_Clear(p);
   Item_Create(i);
   CondSet_Create(c);
   IntList_First(pos_l);
   CondSetList_First(cl);
   IntList_First(sta_l);
   IntList_First(pdp_l);
   IntList_First(typ_l);
   IntList_First(det_l);
   while not IntList_End(pos_l) do begin
      IntList_Retrieve(pos_l, w_pos);
      IntList_Next(pos_l);
      CondSetList_Retrieve(cl, c);
      CondSetList_Next(cl);
      IntList_Retrieve(sta_l, p_sta);
      IntList_Next(sta_l);
      IntList_Retrieve(pdp_l, p_pos);
      IntList_Next(pdp_l);
      Item_Add(i, 0, w_pos, 0, c, p_sta, p_pos);
      IntList_Retrieve(typ_l, p_typ);
      IntList_Next(typ_l);
      IntList_Retrieve(det_l, p_det);
      IntList_Next(det_l);
      if p_typ <> 0 then begin
	 Item_SetTyp(i, p_typ);
	 Item_SetDet(i, p_det);
	 Pattern_Add(p, i);
	 Item_Clear(i)
      end
   end;
   CondSet_Delete(c);
   Item_Delete(i)
end;


private
procedure read_label(var f: FileType; var l: VerseLabelType);
begin
   with f do
      if not VerseLabel_Read(fp, l) then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('verse label expected');
	 Quit
      end
end;


private
procedure read_surfstr(var f: FileType; var s: StringType);
begin
   with f do begin
      s := '';
      while not eowchr(fp) do begin
	 s := s + fp^;
	 get(fp)
      end;
      if fp^ = '-' then begin
	 s := s + fp^;
	 get(fp)
      end
   end
end;


function read_atom(var f: FileType; var a: AtomType):boolean;
var
   done: boolean;
   look_ahead: integer;
   speech, state: integer;
begin
   Atom_Clear(a);
   with f do begin
      if not Scan_Integer(fp, look_ahead) then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('integer expected (state or end-of-verse)');
	 Quit
      end;
      if look_ahead = EOAL then
	 read_atom := false
      else begin
	 done := false;
	 repeat
	    if not Feature_IsVal(sta, look_ahead) then begin
	       write('syn03: ', fname, ': line ', line:1, ': ');
	       writeln('improper value for state: ', look_ahead:1)
	    end;
	    state := look_ahead;
	    if not Scan_Integer(fp, look_ahead) then begin
	       write('syn03: ', fname, ': line ', line:1, ': ');
	       writeln('integer expected (phrase dependent part of speech)');
	       Quit
	    end;
	    if not Feature_IsVal(pdp, look_ahead) then begin
	       write('syn03: ', fname, ': line ', line:1, ': ');
	       writeln('improper value for phrase dependent part of speech: ', look_ahead:1)
	    end;
	    speech := look_ahead;
	    Atom_Add(a, state, speech);
	    SkipSpace(fp);
	    if fp^ <> ',' then
	       done := true
	    else begin
	       get(fp);
	       if not Scan_Integer(fp, look_ahead) then begin
		  write('syn03: ', fname, ': line ', line:1, ': ');
		  writeln('integer expected (state or end-of-verse)');
		  Quit
	       end
	    end
	 until done;
	 if fp^ = ':' then
	    get(fp)
	 else begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('colon expected');
	    Quit
	 end;
	 if not Scan_Integer(fp, look_ahead) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('integer expected (phrase type)');
	    Quit
	 end;
	 if not Feature_IsVal(typ, look_ahead) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('improper value for phrase type: ', look_ahead:1)
	 end;
	 Atom_SetTyp(a, look_ahead);
	 if not Scan_Integer(fp, look_ahead) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('integer expected (determination)');
	    Quit
	 end;
	 if not Feature_IsVal(det, look_ahead) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('improper value for determination: ', look_ahead:1)
	 end;
	 Atom_SetDet(a, look_ahead);
	 read_atom := true
      end
   end
end;


private
procedure print_condset(var f: text; s: CondSetType);
var
   c, i: integer;
begin
   if CondSet_Size(s) = 0 then
      write(f, '-')
   else begin
      write(f, '(');
      CondSet_First(s);
      for i := 1 to CondSet_Size(s) - 1 do begin
	 CondSet_Retrieve(s, c);
	 write(f, c:1, ', ');
	 CondSet_Next(s)
      end;
      CondSet_Retrieve(s, c);
      write(f, c:1, ')')
   end
end;


procedure Print_Pattern(var f: text; p: PatternType);
var
   i: ItemType;
   n: integer;
   t: TagType;
   cs: CondSetType;
   pdp, pos, sta: integer;
begin
   CondSet_Create(cs);
   Item_Create(i);
   Pattern_First(p);
   while Pattern_Get(p, i) do begin
      Item_First(i);
      while Item_Get(i, pos, cs, sta, pdp) do begin
	 write(f, pos:1, ' ');
	 print_condset(f, cs);
	 write(f, ' ')
      end
   end;
   write(f, '100 - ');
   Pattern_First(p);
   while Pattern_Get(p, i) do begin
      Item_First(i);
      while Item_Get(i, pos, cs, sta, pdp) do
	 write(f, sta:1, ' - ')
   end;
   write(f, '100 - ');
   Pattern_First(p);
   while Pattern_Get(p, i) do begin
      Item_First(i);
      while Item_Get(i, pos, cs, sta, pdp) do
	 write(f, pdp:1, ' - ')
   end;
   write(f, '100 - ');
   Pattern_First(p);
   while Pattern_Get(p, i) do begin
      for n := 1 to Item_Size(i) - 1 do
	 write(f, '0 - ');
      if Item_Apposition(i) then
	 write(f, -Item_Type(i):1, ' - ')
      else
	 write(f, Item_Type(i):1, ' - ')
   end;
   write(f, '100 - ');
   Pattern_First(p);
   while Pattern_Get(p, i) do begin
      for n := 1 to Item_Size(i) - 1 do
	 write(f, '-1 - ');
      write(f, Item_Determination(i):1, ' - ')
   end;
   write(f, '99	# ');
   Pattern_GetTag(p, t, n);
   Print_Tag(f, t, n, 0);
   writeln(f);
   Item_Delete(i);
   CondSet_Delete(cs)
end;


procedure Read_AtomList(var f: FileType; l: AtomListType);
var
   a: AtomType;
   v: VerseLabelType;
begin
   Atom_Create(a);
   AtomList_Clear(l);
   read_label(f, v);
   AtomList_SetLabel(l, v);
   while read_atom(f, a) do
      AtomList_Add(l, a);
   File_ReadLine(f);
   Atom_Delete(a)
end;


private
procedure read_condset(var f: FileType; cs: CondSetType; l: LCTableType; m: MCTableType);
var
   i: integer;
begin
   CondSet_Clear(cs);
   with f do begin
      if fp^ = '-' then
	 get(fp)
      else begin
	 if fp^ <> '(' then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('expected opening bracket of condition set');
	    Quit
	 end;
	 repeat
	    get(fp);
	    if not Scan_Integer(fp, i) then begin
	       write('syn03: ', fname, ': line ', line:1, ': ');
	       writeln('integer expected (condition)');
	       Quit
	    end;
	    if MCTable_InRange(i) then
	       if MCTable_Exist(m, i) then
		  CondSet_Add(cs, i)
	       else begin
		  write('syn03: ', fname, ': line ', line:1, ': ');
		  writeln('morphological condition ', i:1, ' not defined');
		  Quit
	       end
	    else if LCTable_InRange(i - LC_OFFSET) then
	       if LCTable_Exist(l, i - LC_OFFSET) then
		  CondSet_Add(cs, i)
	       else begin
		  write('syn03: ', fname, ': line ', line:1, ': ');
		  writeln('lexical condition ', i:1, ' not defined');
		  Quit
	       end
	    else
	       CondSet_Add(cs, i);
	    SkipSpace(fp)
	 until fp^ <> ',';
	 if fp^ = ')' then
	    get(fp)
	 else begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('expected closing bracket of condition set');
	    Quit
	 end
      end
   end
end;


function Read_Feature(var f: FileType; ft: FeatureType; var i: integer):boolean;
const
   SEP0 = 99;
   SEP1 = 100;
begin
   with f do begin
      if not Scan_Integer(fp, i) then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('integer expected (', Feature_String(ft), ')');
	 Quit
      end;
      if (i = SEP0) or (i = SEP1) then
	 Read_Feature := false
      else begin
	 if Feature_IsVal(ft, i) then
	    Read_Feature := true
	 else begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('illegal value for ', Feature_String(ft),': ', i:1);
	    Quit
	 end
      end
   end
end;


function Scan_Integer(var f: text; var i: integer):boolean;
const
   BASE = 10;
var
   int:		integer;
   sign:	integer;
begin
   if eof(f) then
      Scan_Integer := false
   else if eoln(f) then
      Scan_Integer := false
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
	 until not Digit(f^);
	 i := sign * int;
	 Scan_Integer := true
      end else
	 Scan_Integer := false
   end
end;


procedure SkipSpace(var f: text);
var
   stop: boolean;
begin
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
end;


private
procedure read_mcond(var f: FileType; var c: MCondType);
const
   EOC = 99;
var
   i: integer;
begin
   MCond_Clear(c);
   with f do begin
      if not Scan_Integer(fp, i) then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('integer expected (feature)');
	 Quit
      end;
      if (i < ord(Feature_First)) or (ord(Feature_Last) < i) then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('feature index ', i:1, ' is out of range');
	 Quit
      end;
      MCond_SetFeature(c, Feature(i));
      SkipSpace(fp);
      if fp^ <> '=' then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('expected ''='' after feature index');
	 Quit
      end;
      get(fp);
      repeat
	 if not Scan_Integer(fp, i) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('integer expected (value list)');
	    Quit
	 end;
	 if i <> EOC then
	    MCond_Add(c, i)
      until i = EOC;
      if MCond_Size(c) = 0 then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('empty value list: condition will never be met');
	 Quit
      end
   end
end;


procedure Read_MCTable(var f: FileType; t: MCTableType);
var
   c: MCondType;
   i: integer;
begin
   MCond_Create(c);
   while not File_EOF(f) do begin
      with f do begin
	 if not Scan_Integer(fp, i) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('integer expected (condition index)');
	    Quit
	 end;
	 if not MCTable_InRange(i) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('index ', i:1, ' is out of range');
	    Quit
	 end
      end;
      read_mcond(f, c);
      MCTable_Store(t, c, i);
      File_ReadLine(f)
   end;
   MCond_Delete(c)
end;


private
procedure read_word(var f: FileType; w: WordType);
var
   t: FeatureType;
   l: LexemeType;
   v: integer;
begin
   with f do begin
      if not Lexeme_Read(fp, l) then begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('short read in lexeme');
	 Quit
      end;
      Word_SetLexeme(w, l);
      if Space(fp^) then
	 get(fp)
      else begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('space required after lexeme');
	 Quit
      end;
      for t := Feature_First to Feature_Last do begin
	 if t > sta then
	    v := -1
	 else begin
	    if not Scan_Integer(fp, v) then begin
	       write('syn03: ', fname, ': line ', line:1, ': ');
	       writeln('integer expected in column ', ord(t):1);
	       Quit
	    end;
	    if not Feature_IsVal(t, v) then begin
	       write('syn03: ', fname, ': line ', line:1, ': ');
	       writeln('illegal feature value in column ', ord(t):1);
	       Quit
	    end
	 end;
	 Word_SetFeature(w, t, v)
      end
   end
end;


procedure Print_Word(var f: text; w: WordType);
var
   l: LexemeType;
   t: FeatureType;
   v: integer;
begin
   Word_GetLexeme(w, l);
   Lexeme_Write(f, l);
   for t := Feature_First to Feature_Last do begin
      Word_GetFeature(w, t, v);
      write(f, ' ');
      write(f, v:Feature_Width(t))
   end
end;


procedure Read_Verse(var f: FileType; v: VerseType);
var
   l: VerseLabelType;
   w: WordType;
begin
   Word_Create(w);
   read_label(f, l);
   Verse_Clear(v);
   Verse_SetLabel(v, l);
   repeat
      with f do begin
	 if not Space(fp^) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('space required after verse label');
	    Quit
	 end;
	 get(fp);
      end;
      read_word(f, w);
      Verse_Add(v, w);
      File_ReadLine(f);
      read_label(f, l)
   until VerseLabel_Empty(l);
   File_ReadLine(f);
   Word_Delete(w)
end;


procedure Read_LCTable(var f: FileType; t: LCTableType);
var
   i: integer;
   s: StringType;
begin
   i := 0;
   while not File_EOF(f) do begin
      with f do begin
	 if eoln(fp) then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('inept condition: empty lexeme');
	    Quit
	 end;
	 read(fp, s);
	 i := i + 1;
	 if i > LCTABLE_SIZE then begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    writeln('too many conditions');
	    Quit
	 end
      end;
#ifdef P2C
      String_Pad(s);
#endif
      LCTable_Store(t, s, i);
      File_ReadLine(f)
   end
end;


procedure Read_Pattern(var f: FileType; p: PatternType; l: LCTableType; m: MCTableType);
var
   cl: CondSetListType;
   cs: CondSetType;
   fl: array [sta .. det] of IntListType;
   ft: FeatureType;
   n: integer;
   pl: IntListType;
   stop: boolean;
begin
   IntList_Create(pl);
   CondSetList_Create(cl);
   CondSet_Create(cs);
   while Read_Feature(f, pos, n) do begin
      IntList_Add(pl, n);
      SkipSpace(f.fp);
      read_condset(f, cs, l, m);
      CondSetList_Add(cl, cs)
   end;
   CondSet_Delete(cs);
   for ft := sta to det do begin
      IntList_Create(fl[ft]);
      stop := false;
      repeat
	 with f do begin
	    SkipSpace(fp);
	    if fp^ = '-' then
	       get(fp)
	    else begin
	       write('syn03: ', fname, ': line ', line:1, ': ');
	       writeln('separator missing (''-'')');
	       Quit
	    end
	 end;
	 if Read_Feature(f, ft, n) then
	    IntList_Add(fl[ft], n)
	 else
	    stop := true
      until stop;
      if IntList_Length(fl[ft]) <> IntList_Length(pl) then begin
	 with f do begin
	    write('syn03: ', fname, ': line ', line:1, ': ');
	    write('number of values for ', Feature_String(ft), ' ');
	    writeln('does not match parts of speech')
	 end;
	 Quit
      end
   end;
   if IntList_Length(pl) = 0 then begin
      with f do begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('zero length pattern')
      end;
      Quit
   end;
   IntList_Retrieve(fl[typ], n);
   if n = 0 then begin
      with f do begin
	 write('syn03: ', fname, ': line ', line:1, ': ');
	 writeln('pattern lacks phrase type')
      end;
      Quit
   end;
   pattern_assign(p, pl, cl, fl[sta], fl[pdp], fl[typ], fl[det]);
   Pattern_First(p);
   for ft := sta to det do
      IntList_Delete(fl[ft]);
   CondSetList_Delete(cl);
   IntList_Delete(pl);
end;


procedure Read_Surface(var f: FileType; s: SurfaceType);
var
   l: VerseLabelType;
   w: StringType;
begin
   Surface_Clear(s);
   read_label(f, l);
   Surface_SetLabel(s, l);
   with f do begin
      SkipSpace(fp);
      while not eoln(fp) and (fp^ <> '*') do begin
	 repeat
	    read_surfstr(f, w);
	    Surface_Add(s, w)
	 until (length(w) = 0) or (String_End(w) <> '-');
	 SkipSpace(fp)
      end
   end;
   File_ReadLine(f)
end;


function Width(n: integer):integer;
const
   BASE = 10;
begin
   if n >= BASE then
      Width := Width(n div BASE) + 1
   else if n >= 0 then
      Width := 1
   else if n > -BASE then
      Width := 2
   else
      Width := Width(n div BASE) + 1
end;


private
procedure write_atom(var f: FileType; a: AtomType);
var
   sta, pdp: integer;
begin
   Atom_First(a);
   with f do begin
      while not Atom_End(a) do begin
	 Atom_Retrieve(a, sta, pdp);
	 write(fp, ' ', sta:2);
	 write(fp, ' ', pdp:2);
	 Atom_Next(a);
	 if not Atom_End(a) then
	    write(fp, ' ,')
	 else
	    write(fp, ' :')
      end;
      if Atom_Apposition(a) then
	 write(fp, ' ', -Atom_Type(a):2)
      else
	 write(fp, ' ', Atom_Type(a):2);
      write(fp, ' ', Atom_Determination(a):2)
   end
end;


procedure Write_AtomList(var f: FileType; l: AtomListType);
var
   a: AtomType;
   v: VerseLabelType;
begin
   Atom_Create(a);
   AtomList_GetLabel(l, v);
   VerseLabel_Write(f.fp, v);
   AtomList_First(l);
   while not AtomList_End(l) do begin
      AtomList_Retrieve(l, a);
      write_atom(f, a);
      AtomList_Next(l)
   end;
   writeln(f.fp, ' ', EOAL:1);
   Atom_Delete(a)
end;


procedure Write_Loci(var f: FileType; l: LociType);
const
   INDENT = '   ';
   SEPARATOR = ', ';
   WIDTH = 80;
var
   s: StringType;
   offset: integer;
   new_line: boolean;
begin
   offset := 0;
   new_line := true;
   with f do begin
      Loci_First(l);
      while not Loci_End(l) do begin
	 Locus_String(Loci_Current(l), s);
	 if offset + length(SEPARATOR) + length(s) > WIDTH then
	    if not new_line then begin
	       writeln(fp);
	       new_line := true
	    end;
	 if new_line then begin
	    write(fp, INDENT);
	    offset := length(INDENT);
	    new_line := false
	 end else begin
	    write(fp, SEPARATOR);
	    offset := offset + length(SEPARATOR)
	 end;
	 write(fp, s);
	 offset := offset + length(s);
	 Loci_Next(l)
      end;
      if not new_line then
	 writeln(fp);
      writeln(fp)
   end
end;


procedure Write_Pattern(var f: FileType; p: PatternType);
begin
   Print_Pattern(f.fp, p)
end;


procedure Write_ReportPattern(var f: FileType; p: PatternType; l, n: integer);
var
   i: ItemType;
   s: integer;
   t: TagType;
   cs: CondSetType;
   pdp, pos, sta: integer;
begin
   CondSet_Create(cs);
   Item_Create(i);
   Pattern_GetTag(p, t, s);
   with f do begin
      write(fp, 'Pattern ');
      Print_Tag(fp, t, s, 0);
      writeln(fp, ', line ', l:1, ': ', n:1);
      Pattern_First(p);
      while Pattern_Get(p, i) do begin
	 Item_First(i);
	 while Item_Get(i, pos, cs, sta, pdp) do
	    write(fp, ' ', pos:1, ':', pdp:1);
	 write(fp, ' = ', Item_Type(i):1);
	 write(fp, '/', Item_Determination(i):1);
	 if Item_Apposition(i) then
	    write(fp, '(a)');
	 if Pattern_End(p) then
	    writeln(fp, '.')
	 else
	    write(fp, ',')
      end;
   end;
   Item_Delete(i);
   CondSet_Delete(cs)
end;


procedure Print_Tag(var f: text; t: TagType; n, w: integer);
var
   i: integer;
begin
   for i := 1 to w - Width(n) do
      write(f, ' ');
   write(f, n:1);
   case t of
      t_div:
	 write(f, 'd');
      t_join:
	 write(f, 'j');
      t_set:
	 write(f, 's');
      t_user:
	 write(f, 'u')
   end
end;


procedure Write_Verse(var f: FileType; v: VerseType);
var
   l: VerseLabelType;
   w: WordType;
begin
   Word_Create(w);
   Verse_GetLabel(v, l);
   Verse_First(v);
   with f do begin
      while not Verse_End(v) do begin
	 VerseLabel_Write(fp, l);
	 write(fp, ' ');
	 Verse_Retrieve(v, w);
	 Print_Word(fp, w);
	 writeln(fp);
	 Verse_Next(v)
      end;
      VerseLabel_Clear(l);
      VerseLabel_Write(fp, l);
      writeln(fp, ' *')
   end;
   Word_Delete(w)
end;
