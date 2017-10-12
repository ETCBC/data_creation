module User;

#include	<Error.h>
#include	<IO.h>
#include	<Surface.h>
#include	<User.h>

(* ident "@(#)dapro/syn03/User.p	1.5 15/09/14" *)

const
   YES =			['y', 'Y'];
   YES_NO =			['y', 'Y', 'n', 'N'];

type
   CharSet = set of char;

var
   Interactive, ModeKnown: boolean;

function GetWindowSize(var Columns, Rows: integer):boolean;
extern;

private
function get_char:char;
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
   get_char := c
end;


private
function get_valchr(var question: StringType; valid: CharSet):char;
var
   answer: char;
begin
   answer := chr(0);
   repeat
      write(question);
      answer := get_char
   until answer in valid;
   get_valchr := answer
end;


private
function get_answer(var q: StringType):boolean;
begin
   get_answer := get_valchr(q, YES_NO) in YES
end;


private
function get_integer(var i: integer):boolean;
var
   ok: boolean;
begin
   ok := false;
   if eof then
      begin
	 writeln;
	 reset(input)
      end
   else begin
      if not eoln then
	 ok := Scan_Integer(input, i);
      readln
   end;
   get_integer := ok
end;


private
function get_valint(var question: StringType; lower, upper: integer):integer;
var
   i: integer;
   ok: boolean;
begin
   ok := false;
   repeat
      write(question);
      if (lower < upper) then
	 write(' [', lower:1, '..', upper:1, ']: ');
      ok := get_integer(i)
   until ok and (lower <= i) and (i <= upper);
   get_valint := i
end;


function User_Action:char;
var
   q: StringType;
begin
   writeln;
   q := 'Construct, delete or retry phrase pattern? [c/d/r] ';
   User_Action := get_valchr(q, ['c', 'd', 'r'])
end;


procedure User_BadPhrase(d0, d1: DivisionType; p: PatternType);
var
   i: integer;
   n: integer;
   q: StringType;
begin
   writeln;
   q := 'What is the number of the first incorrect phrase atom?';
   n := get_valint(q, 1, Division_Length(d1));
   Division_First(d0);
   Division_First(d1);
   for i := 1 to n - 1 do begin
      Division_Next(d0);
      Division_Next(d1)
   end;
   Division_Retrieve(d1, p);
   Division_Cut(d1);
   Division_Stretch(d0)
end;


private
procedure print_pattern(s: SurfaceType; p: PatternType; n:integer);
var
   i: integer;
   itm: ItemType;
   num: integer;
   sur: StringType;
   tag: TagType;
begin
   Pattern_First(p);
   Pattern_GetTag(p, tag, num);
   Item_Create(itm);
   while Pattern_Get(p, itm) do begin
      Print_Tag(output, tag, num, TAG_WIDTH);
      write(' ', Feature_StrVal(typ, Item_Type(itm)):4);
      write(' ', Feature_StrVal(det, Item_Determination(itm)):3);
      write('  ', n:2);
      if Item_Unconditional(itm) then
	 write('* ')
      else
	 write('  ');
      for i := 1 to Item_Size(itm) do begin
	 Surface_Retrieve(s, sur);
	 write(sur);
	 if String_End(sur) <> '-' then
	    write(' ');
	 Surface_Next(s)
      end;
      if Item_Apposition(itm) then
	 write('(apposition)');
      writeln
   end;
   Item_Delete(itm)
end;


function User_Confirmation(s: SurfaceType; d0, d1: DivisionType):boolean;
var
   i: integer;
   l: VerseLabelType;
   p: PatternType;
   q: StringType;
begin
   writeln;
   Division_GetLabel(d0, l);
   VerseLabel_Write(output, l);
   writeln;
   writeln;
   i := 0;
   Surface_First(s);
   Division_First(d1);
   Pattern_Create(p);
   while Division_Get(d1, p) do begin
      i := i + 1;
      print_pattern(s, p, i)
   end;
   Pattern_Delete(p);
   Division_Last(d1);
   writeln;
   q := 'Are all phrase atoms and phrase types correct? [y/n] ';
   User_Confirmation := get_answer(q)
end;


function User_Continue:boolean;
var
   q: StringType;
begin
   if not Interactive then
      User_Continue := true
   else begin
      writeln;
      q := 'Continue with next verse? [y/n]: ';
      User_Continue := get_answer(q)
   end
end;


procedure User_Init;
begin
   Interactive := false;
   ModeKnown := false
end;


function User_Interactive:boolean;
var
   question: StringType;
begin
   if not ModeKnown then begin
      writeln;
      question := 'Do you want to work interactively? [y/n]: ';
      Interactive := get_answer(question);
      ModeKnown := true
   end;
   User_Interactive := Interactive
end;


private
function max(i1, i2: integer):integer;
begin
   if i1 < i2 then
      max := i2
   else
      max := i1
end;


private
procedure printw_sur_c(s: SurfaceType; n: integer; dx_max:integer);
var
   i: integer;
   x, dx: integer;
   done: boolean;
begin
   Surface_Mark(s);
   i := 0;
   x := 0;
   done := false;
   while (i < n) and not done do begin
      dx := length('  ') + max(Width(i), length(Surface_String(s)));
      if (x + dx >= dx_max) then
	 done := true
      else begin
	 i := i + 1;
	 write('|':dx);
	 x := x + dx;
	 Surface_Next(s)
      end
   end;
   writeln;
   Surface_Jump(s)
end;


private
procedure printw_sur_n(s: SurfaceType; n: integer; dx_max:integer);
var
   i: integer;
   x, dx: integer;
   done: boolean;
begin
   Surface_Mark(s);
   i := 0;
   x := 0;
   done := false;
   while (i < n) and not done do begin
      dx := length('  ') + max(Width(i), length(Surface_String(s)));
      if (x + dx >= dx_max) then
	 done := true
      else begin
	 i := i + 1;
	 write(i:dx);
	 x := x + dx;
	 Surface_Next(s)
      end
   end;
   writeln;
   Surface_Jump(s)
end;


private
procedure printw_sur_s(s: SurfaceType; n: integer; dx_max:integer);
var
   i: integer;
   x, dx: integer;
   done: boolean;
begin
   Surface_Mark(s);
   i := 0;
   x := 0;
   done := false;
   while (i < n) and not done do begin
      dx := length('  ') + max(Width(i), length(Surface_String(s)));
      if (x + dx >= dx_max) then
	 done := true
      else begin
	 i := i + 1;
	 write(Surface_String(s):dx);
	 x := x + dx;
	 Surface_Next(s)
      end
   end;
   writeln;
   Surface_Jump(s)
end;


private
procedure do_phrase(s: SurfaceType; i: ItemType);
var
   e: integer;
   n: integer;
   q: StringType;
   columns, rows: integer;
begin
   if Item_Size(i) = 1 then
      e := 1
   else begin
      if not GetWindowSize(columns, rows) then begin
	 rows := 25;
	 columns := 80
      end;
      writeln;
      printw_sur_s(s, Item_Size(i), columns);
      printw_sur_c(s, Item_Size(i), columns);
      printw_sur_n(s, Item_Size(i), columns);
      writeln;
      q := 'What is the last word of this phrase?';
      e := get_valint(q, 1, Item_Size(i))
   end;
   Item_First(i);
   for n := 1 to e do
      Item_Next(i);
   Item_Cut(i);
   Item_SetTyp(i, Item_DefTyp(i));
   Item_SetDet(i, Item_DefDet(i))
end;


private
function get_state(s: integer):integer;
var
   c: char;
begin
   if s <> 0 then begin
      writeln(Feature_StrVal(sta, s));
      get_state := s
   end else begin
      c := get_char;
      while not (c in ['a', 'c', 'e', 'u']) do begin
	 write('Choose from: ');
	 write('a [absolute], c [construct], e [emphatic], u [unknown]: ');
	 c := get_char
      end;
      case c of
	 'a': get_state :=  Sta_Abs;
	 'c': get_state :=  Sta_Con;
	 'e': get_state :=  Sta_Emph;
	 'u': get_state :=  Sta_Unk
      end
   end
end;


private
procedure do_state(s: SurfaceType; i0, i1: ItemType);
var
   pdp, pos: integer;
   st0, st1: integer;
   cds: CondSetType;
begin
   writeln;
   writeln('Supply the correct values for state:');
   writeln;
   Surface_Mark(s);
   CondSet_Create(cds);
   Item_First(i0);
   Item_First(i1);
   while not Item_End(i1) do begin
      Item_Retrieve(i0, pos, cds, st0, pdp);
      write(Surface_String(s):12, ' : ');
      Item_Retrieve(i1, pos, cds, st1, pdp);
      st1 := get_state(st0);
      Item_Update(i1, pos, cds, st1, pdp);
      Item_Next(i1);
      Item_Next(i0);
      Surface_Next(s)
   end;
   CondSet_Delete(cds);
   Surface_Jump(s)
end;


private
function get_speech(p0: integer):integer;
var
   n: integer;
   p1: integer;
   done: boolean;
begin
   n := 0;
   for p1 := ord(Pos_First) to ord(Pos_Last) do
      if Pos_Trans(p0, p1) then
	 n := n + 1;
   if n = 1 then begin
      writeln(Feature_StrVal(pdp, p0));
      get_speech := p0
   end else begin
      done := false;
      repeat
	 if not get_integer(p1) then
	    writeln('NOTE: A number is required.')
	 else
	 if not Feature_IsVal(pdp, p1) then
	    writeln('NOTE: The number is out of range.')
	 else
	 if not Pos_Trans(p0, p1) then
	    writeln('NOTE: This transition is not allowed.')
	 else
	    done := true;
	 if not done then begin
	    write('Choose from');
	    for p1 := ord(Pos_First) to ord(Pos_Last) do
	       if Pos_Trans(p0, p1) then
		  write(' ', p1:1, ' [', Feature_StrVal(pdp, p1), ']');
	    write(': ')
	 end
      until done;
      get_speech := p1
   end
end;


private
procedure do_speech(s: SurfaceType; i: ItemType);
var
   pdp, pos, sta: integer;
   cds: CondSetType;
begin
   writeln;
   writeln('Supply the correct values for part of speech:');
   writeln;
   Surface_Mark(s);
   CondSet_Create(cds);
   Item_First(i);
   while not Item_End(i) do begin
      write(Surface_String(s):12, ' : ');
      Item_Retrieve(i, pos, cds, sta, pdp);
      pdp := get_speech(pos);
      Item_Update(i, pos, cds, sta, pdp);
      Item_Next(i);
      Surface_Next(s)
   end;
   Item_SetTyp(i, Item_DefTyp(i));
   if not Item_Objective(i) then
      Item_SetDet(i, Det_NA);
   CondSet_Delete(cds);
   Surface_Jump(s)
end;


private
function get_phrase_type(i: ItemType):integer;
var
   n, t, u: integer;
   done: boolean;
begin
   n := 0;
   for u := Typ_First to Typ_Last do
      if Item_ValTyp(i, u) then begin
	 t := u;
	 n := n + 1
      end;
   if n = 1 then
      writeln(Feature_StrVal(typ, t))
   else begin
      done := false;
      repeat
	 if not get_integer(t) then
	    writeln('NOTE: A number is required.')
	 else
	 if not Feature_IsVal(typ, t) then
	    writeln('NOTE: The number is out of range.')
	 else
	 if not Item_ValTyp(i, t) then
	    writeln('NOTE: Incompatible phrase type.')
	 else
	    done := true;
	 if not done then begin
	    write('Choose from:');
	    for t := Typ_First to Typ_Last do
	       if Item_ValTyp(i, t) then
		  write(' ', t:1, ' [', Feature_StrVal(typ, t), ']');
	    write(': ')
	 end
      until done
   end;
   get_phrase_type := t
end;


private
procedure do_phrase_type(s: SurfaceType; i: ItemType);
begin
   writeln;
   Surface_Mark(s);
   Surface_Jump(s);
   write('Supply the value for phrase type: ');
   Item_SetTyp(i, get_phrase_type(i));
   if not Item_Objective(i) then
      Item_SetDet(i, Det_NA)
end;


private
function get_determination:integer;
var
   c: char;
begin
   write('Supply the value for phrase atom determination: ');
   c := get_char;
   while not (c in ['d', 'n', 'u']) do begin
      write('Choose from: ');
      write('d [determined], n [not applicable], u [undetermined]: ');
      c := get_char
   end;
   case c of
      'd': get_determination := Det_Det;
      'n': get_determination := Det_NA;
      'u': get_determination := Det_Und
   end
end;


private
procedure do_determination(i: ItemType);
begin
   writeln;
   if not Item_Objective(i) then
      writeln('NOTE: Determination does not apply to this phrase atom.')
   else begin
      Item_SetDet(i, get_determination)
   end
end;


private
procedure print_apposition(s: SurfaceType; i1, i2: ItemType);
begin
   Surface_Mark(s);
   Item_First(i1);
   while not Item_End(i1) do begin
      Surface_Prior(s);
      Item_Next(i1)
   end;
   writeln;
   write('---> ');
   Item_First(i1);
   while not Item_End(i1) do begin
      write(' ', Surface_String(s));
      Surface_Next(s);
      Item_Next(i1)
   end;
   write(', ');
   Item_First(i2);
   while not Item_End(i2) do begin
      write(' ', Surface_String(s));
      Surface_Next(s);
      Item_Next(i2)
   end;
   writeln;
   Surface_Jump(s)
end;


private
procedure do_apposition(s: SurfaceType; d: DivisionType; i1: ItemType);
var
   i0: ItemType;
   p: PatternType;
   q: StringType;
begin
   if (Division_Length(d) > 0) and Item_Objective(i1) then begin
      Pattern_Create(p);
      Item_Create(i0);
      Division_Retrieve(d, p);
      Pattern_Last(p);
      Pattern_Retrieve(p, i0);
      if Item_Appositive(i0, i1) then begin
	 print_apposition(s, i0, i1);
	 q := 'Does this happen to be an apposition? [y/n] ';
	 writeln;
	 Item_SetApp(i1, get_answer(q))
      end;
      Item_Delete(i0);
      Pattern_Delete(p)
   end
end;


private
procedure print_item(s: SurfaceType; i: ItemType);
var
   pd, ps, st: integer;
   cs: CondSetType;
begin
   CondSet_Create(cs);
   writeln;
   Item_First(i);	(* surface *)
   Surface_Mark(s);
   write('---> ');
   while not Item_End(i) do begin
      write('  ', Surface_String(s));
      Surface_Next(s);
      Item_Next(i)
   end;
   writeln;
   writeln;
   Item_First(i);	(* status *)
   Surface_Jump(s);
   write('sta: ');
   while not Item_End(i) do begin
      Item_Retrieve(i, ps, cs, st, pd);
      write('  ', Feature_StrVal(sta, st):length(Surface_String(s)));
      Item_Next(i);
      Surface_Next(s)
   end;
   writeln;
   Item_First(i);	(* phrase dependent part of speech *)
   Surface_Jump(s);
   write('pdp: ');
   while not Item_End(i) do begin
      Item_Retrieve(i, ps, cs, st, pd);
      write('  ', Feature_StrVal(pdp, pd):length(Surface_String(s)));
      Item_Next(i);
      Surface_Next(s)
   end;
   writeln;
   writeln;
   write('Type: ', Feature_StrVal(typ, Item_Type(i)), ',  ');
   writeln('Determination: ', Feature_StrVal(det, Item_Determination(i)));
   Surface_Jump(s);
   CondSet_Delete(cs)
end;


procedure User_MakePhrase(s: SurfaceType; d0, d1: DivisionType; p: PatternType);
(* Note: a pattern made by User_MakePhrase always contains one item. *)
var
   done: boolean;
   i0, i1: ItemType;
   n: integer;
   q: StringType;
begin
   Item_Create(i0);
   Item_Create(i1);
   Surface_First(s);
   Division_Last(d1);
   for n := 1 to Division_Size(d1) do
      Surface_Next(s);
   Division_Retrieve(d0, p);
   Pattern_Retrieve(p, i0);
   Item_Copy(i1, i0);
   do_phrase(s, i1);
   done := false;
   q := 'Have all features been correctly assigned? [y/d/p/s/t] ';
   repeat
      print_item(s, i1);
      writeln;
      Item_First(i1);
      case get_valchr(q, ['d','p','s','t','y']) of
	 'd':
	    do_determination(i1);
	 'p':
	    do_speech(s, i1);
	 's':
	    do_state(s, i0, i1);
	 't':
	    do_phrase_type(s, i1);
	 'y':
	    if Item_Valid(i1) then
	       done := true
	    else
	       writeln('NOTE: ', Error_String)
      end;
   until done;
   do_apposition(s, d1, i1);
   Pattern_Update(p, i1);
   Item_Delete(i1);
   Item_Delete(i0)
end;
