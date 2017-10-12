h60462
s 00020/00008/00618
d D 1.3 15/09/14 16:30:51 const 3 2
c Enclitic phrases need to be sticky, when enclitics have word status.
e
s 00001/00001/00625
d D 1.2 99/04/14 11:05:24 const 2 1
c Bug in Grammar_Label and Pattern_StickyTail. Cleaned up code.
e
s 00626/00000/00000
d D 1.1 99/02/16 14:13:43 const 1 0
c date and time created 99/02/16 14:13:43 by const
e
u
U
f e 0
f m dapro/syn03/Pattern.p
t
T
I 1
module Pattern;

D 3
(* ident "%Z%%M% %I% %G%" *)
E 3
I 3
(* ident "%W% %E%" *)
E 3

#include <Error.h>
#include <Pattern.h>


procedure Pattern_Add(p: PatternType; i: ItemType);
var
   aux: ItemNodePointer;
begin
   new(aux);
   with aux^ do begin
      Item_Create(item);
      Item_Copy(item, i);
      next := nil;
      prior := nil
   end;
   with p^ do begin
      if head = nil then
	 begin
	    head := aux;
	    tail := aux
	 end
      else
	 begin
	    tail^.next := aux;
	    aux^.prior := tail;
	    tail := aux
	 end;
      current := aux;
      size := size + Item_Size(i);
      length := length + 1
   end
end;


function Pattern_StickyTail(p: PatternType):boolean;
begin
   with p^ do begin
      if tail = nil then
	 Pattern_StickyTail := false
      else begin
	 Pattern_StickyTail :=
D 2
	    (Item_Size(tail^.item) = 1) and Item_Transitive(tail^.item)
E 2
I 2
	    (size = 1) and Item_Transitive(tail^.item)
E 2
      end
   end
end;


private
function atmcmp(p1, p2: PatternType):CompareType;
var
   cmp: CompareType;
   aux1, aux2: ItemNodePointer;
begin
   aux1 := p1^.head;
   aux2 := p2^.head;
   repeat
      if aux1 = nil then
	 if aux2 = nil then
	    cmp := equal
	 else
	    cmp := less
      else
	 if aux2 = nil then
	    cmp := greater
	 else begin
	    cmp := Item_AtmCmp(aux1^.item, aux2^.item);
	    aux1 := aux1^.next;
	    aux2 := aux2^.next
	 end
   until (cmp <> equal) or (aux1 = aux2);
   atmcmp := cmp
end;


procedure Pattern_Atomise(p: PatternType; l: AtomListType);
var
   i: ItemNodePointer;
begin
   AtomList_Clear(l);
   with p^ do begin
      i := head;
      while i <> nil do begin
	 AtomList_Add(l, i^.item^.atm);
	 i := i^.next
      end
   end
end;


procedure Pattern_Clear(p: PatternType);
var
   aux: ItemNodePointer;
begin
   with p^ do begin
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Item_Delete(aux^.item);
	 dispose(aux)
      end;
      tag_n := 0;
      current := nil;
      tail := nil;
      size := 0;
      length := 0
   end
end;


private
function cndsiz(p: PatternType):integer;
var
   aux: ItemNodePointer;
   siz: integer;
begin
   aux := p^.head;
   siz := 0;
   while aux <> nil do begin
      siz := siz + Item_CndSiz(aux^.item);
      aux := aux^.next
   end;
   cndsiz := siz
end;


function cs_first(i: ItemNodePointer):CondSetType;
begin
   with i^ do begin
      Item_First(item);
      cs_first := Item_CndRef(item)
   end
end;


function cs_next(var i: ItemNodePointer):CondSetType;
begin
   Item_Next(i^.item);
   if not Item_End(i^.item) then
      cs_next := Item_CndRef(i^.item)
   else begin
      i := i^.next;
      if i = nil then
	 cs_next := nil
      else begin
	 Item_First(i^.item);
	 cs_next := Item_CndRef(i^.item)
      end
   end
end;


function cs_last(i: ItemNodePointer):boolean;
begin
   if i = nil then
      cs_last := true
   else
      cs_last := Item_End(i^.item) and (i^.next = nil)
end;


private
function cndcmp(p1, p2: PatternType):CompareType;
var
   cmp: CompareType;
   cs1, cs2: CondSetType;
   aux1, aux2: ItemNodePointer;
begin
   cmp := Compare(cndsiz(p1), cndsiz(p2));
   if cmp = equal then begin
      aux1 := p1^.head;
      aux2 := p2^.head;
      cs1 := cs_first(aux1);
      cs2 := cs_first(aux2);
      repeat
	 if cs_last(aux1) then
	    if cs_last(aux2) then
	       cmp := equal
	    else
	       cmp := less
	 else
	    if cs_last(aux2) then
	       cmp := greater
	    else begin
	       cmp := Compare(CondSet_Size(cs1), CondSet_Size(cs2));
	       if cmp = equal then begin
		  cmp := CondSet_Compare(cs1, cs2);
		  cs1 := cs_next(aux1);
		  cs2 := cs_next(aux2)
	       end
	    end
      until (cmp <> equal) or (aux1 = aux2)
   end;
   cndcmp := cmp
end;


function Pattern_Compare(p1, p2: PatternType):CompareType;
var
   cmp: CompareType;
begin
   cmp := Pattern_PosCmp(p1, p2);
   if cmp = equal then begin
      cmp := cndcmp(p1, p2);
      if cmp = equal then begin
	 cmp := atmcmp(p1, p2)
      end
   end;
   Pattern_Compare := cmp
end;


procedure Pattern_Copy(p1, p2: PatternType);
var
   aux1, aux2: ItemNodePointer;
begin
   aux1 := p1^.head;
   aux2 := p2^.head;
   while aux2 <> nil do begin
      if aux1 = nil then begin
	 new(aux1);
	 Item_Create(aux1^.item);
	 with p1^ do begin
	    if head = nil then
	       begin
		  head := aux1;
		  aux1^.prior := nil;
	       end
	    else
	       begin
		  tail^.next := aux1;
		  aux1^.prior := tail;
	       end;
	    aux1^.next := nil;
	    tail := aux1
	 end
      end;
      Item_Copy(aux1^.item, aux2^.item);
      aux1 := aux1^.next;
      aux2 := aux2^.next
   end;
   with p1^ do begin
      if aux1 <> nil then begin
	 tail := aux1^.prior;
	 tail^.next := nil
      end;
      while aux1 <> nil do begin
	 current := aux1^.next;
	 Item_Delete(aux1^.item);
	 dispose(aux1);
	 aux1 := current
      end;
      current := head
   end;
   p1^.tag_n := p2^.tag_n;
   p1^.tag_t := p2^.tag_t;
   p1^.size := p2^.size;
   p1^.length := p2^.length
end;


procedure Pattern_Create(var p: PatternType);
begin
   new(p);
   with p^ do begin
      tag_n := 0;
      head := nil;
      current := nil;
      tail := nil;
      size := 0;
      length := 0
   end
end;


procedure Pattern_Chip(p: PatternType);
var
   i: ItemNodePointer;
begin
   with p^ do begin
      i := tail;
      if i <> nil then begin
	 Item_Last(i^.item);
	 size := size - Item_Size(i^.item);
	 Item_Cut(i^.item);
	 size := size + Item_Size(i^.item);
	 if Item_Size(i^.item) = 0 then begin
	    tail := i^.prior;
	    if tail = nil then
	       head := nil
	    else
	       tail^.next := nil;
	    Item_Delete(i^.item);
	    dispose(i);
	    length := length - 1
	 end
      end;
      current := head
   end
end;


procedure Pattern_Delete(var p: PatternType);
var
   aux: ItemNodePointer;
begin
   with p^ do
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Item_Delete(aux^.item);
	 dispose(aux)
      end;
   dispose(p);
   p := nil
end;


procedure Pattern_First(p: PatternType);
I 3
var
   aux: ItemNodePointer;
E 3
begin
D 3
   p^.current := p^.head
E 3
I 3
   with p^ do begin
      aux := head;
      while aux <> nil do begin
	 Item_First(aux^.item);
	 aux := aux^.next
      end;
      current := head
   end
E 3
end;


function Pattern_End(p: PatternType):boolean;
begin
   Pattern_End := p^.current = nil
end;


function Pattern_Get(p: PatternType; var i: ItemType):boolean;
begin
   with p^ do
      if current = nil then
	 Pattern_Get := false
      else begin
	 Item_Copy(i, current^.item);
	 current := current^.next;
	 Pattern_Get := true
      end
end;


procedure Pattern_GetTag(p: PatternType; var t: TagType; var n: integer);
begin
   t := p^.tag_t;
   n := p^.tag_n
end;


function Pattern_Head(p: PatternType):PosType;
begin
   with p^ do
      if size > 0 then
	 Pattern_Head := Item_Head(head^.item)
      else
	 Panic('Pattern_Head')
end;


procedure Pattern_Join(p1, p2: PatternType);
begin
   if p2^.head <> nil then begin
      p1^.tail^.next := p2^.head;
      p2^.head^.prior := p1^.tail;
      p1^.tail := p2^.tail;
      p1^.length := p1^.length + p2^.length;
      p1^.size := p1^.size + p2^.size;
      p1^.tag_t := t_join
   end;
   with p2^ do begin
      head := nil;
      current := nil;
      tail := nil;
      size := 0;
      length := 0
   end
end;


procedure Pattern_Last(p: PatternType);
begin
   with p^ do
      current := tail
end;


function Pattern_Match(p1, p2: PatternType):boolean;
var
   q1, q2: PatternType;
begin
   Pattern_Create(q1);
   Pattern_Create(q2);
   Pattern_Copy(q1, p1);
   Pattern_Copy(q2, p2);
   Pattern_Stretch(q1);
   Pattern_Stretch(q2);
   Pattern_Match := Item_Match(q1^.head^.item, q2^.head^.item);
   Pattern_Delete(q1);
   Pattern_Delete(q2)
end;


function pos_first(i: ItemNodePointer):integer;
begin
   with i^ do begin
      Item_First(item);
      pos_first := Item_Pos(item)
   end
end;


function pos_next(var i: ItemNodePointer):integer;
begin
   Item_Next(i^.item);
   if not Item_End(i^.item) then
      pos_next := Item_Pos(i^.item)
   else begin
      i := i^.next;
      if i = nil then
	 pos_next := 0
      else begin
	 Item_First(i^.item);
	 pos_next := Item_Pos(i^.item)
      end
   end
end;


function pos_last(i: ItemNodePointer):boolean;
begin
   if i = nil then
      pos_last := true
   else
      pos_last := Item_End(i^.item) and (i^.next = nil)
end;


function Pattern_PosCmp(p1, p2: PatternType):CompareType;
var
   cmp: CompareType;
   sp1, sp2: integer;
   aux1, aux2: ItemNodePointer;
begin
   aux1 := p1^.head;
   aux2 := p2^.head;
   sp1 := pos_first(aux1);
   sp2 := pos_first(aux2);
   repeat
      if pos_last(aux1) then
	 if pos_last(aux2) then
	    cmp := equal
	 else
	    cmp := less
      else
	 if pos_last(aux2) then
	    cmp := greater
	 else begin
	    cmp := Compare(sp1, sp2);
	    sp1 := pos_next(aux1);
	    sp2 := pos_next(aux2)
	 end
   until (cmp <> equal) or (aux1 = aux2);
   Pattern_PosCmp := cmp
end;


function Pattern_StickyHead(p: PatternType):boolean;
begin
   with p^ do begin
      if head = nil then
	 Pattern_StickyHead := false
      else begin
D 3
	 Pattern_StickyHead := Item_Apposition(head^.item)
E 3
I 3
	 Pattern_StickyHead :=
	    Item_Apposition(head^.item) or Item_Enclitic(head^.item)
E 3
      end
   end
end;


procedure Pattern_Retrieve(p: PatternType; var i: ItemType);
begin
   Item_Copy(i, p^.current^.item)
end;


procedure Pattern_SetTag(p: PatternType; t: TagType; n: integer);
begin
   p^.tag_t := t;
   p^.tag_n := n
end;


function Pattern_Single(p: PatternType):boolean;
begin
   with p^ do
      if size <> 1 then
	 Pattern_Single := false
      else
	 Pattern_Single := Item_Single(head^.item)
end;


function Pattern_Size(p: PatternType):integer;
begin
   Pattern_Size := p^.size
end;


procedure Pattern_Split(p1, p2: PatternType; n: integer);
(* precondition: 0 < n < size(p1) *)
var
   aux: ItemNodePointer;
begin
   with p1^ do begin
      aux := tail;
      while aux^.prior <> nil do begin
	 aux := aux^.prior;
	 Item_Join(aux^.item, aux^.next^.item);
	 Item_Delete(aux^.next^.item);
	 dispose(aux^.next)
      end
   end;
   with p2^ do begin
      while head <> nil do begin
	 aux := head;
	 head := head^.next;
	 Item_Delete(aux^.item);
	 dispose(aux)
      end
   end;
   new(aux);
   with aux^ do begin
      Item_Create(item);
      next := nil;
      prior := nil
   end;
   with p1^ do begin
      Item_Split(head^.item, aux^.item, n);
      current := head;
      tail := head;
      size := n;
      length := 1
   end;
   with p2^do begin
      head := aux;
      current := head;
      tail := head;
      size := Item_Size(aux^.item);
      length := 1
   end
end;


procedure Pattern_Stretch(p: PatternType);
var
   aux: ItemNodePointer;
begin
   with p^ do begin
      aux := current^.next;
      while aux <> nil do begin
	 Item_Join(current^.item, aux^.item);
	 Item_Delete(aux^.item);
	 length := length - 1;
	 aux := aux^.next
      end;
      aux := tail;
      while aux <> current do begin
	 tail := aux^.prior;
	 dispose(aux);
	 aux := tail
      end;
      Item_First(current^.item);
      tail^.next := nil
   end
end;


function Pattern_Subset(p1, p2: PatternType):boolean;
var
   pass: boolean;
   aux1, aux2: ItemNodePointer;
begin
   pass := true;
   aux1 := p1^.head;
   aux2 := p2^.head;
   while pass and (aux1 <> nil) and (aux2 <> nil) do begin
      if not Item_Subset(aux1^.item, aux2^.item) then
	 pass := false;
      aux1 := aux1^.next;
      aux2 := aux2^.next
   end;
   Pattern_Subset := (aux1 = aux2) and pass
end;


procedure Pattern_Update(p: PatternType; i: ItemType);
begin
   with p^ do begin
      size := size + Item_Size(i) - Item_Size(current^.item);
      Item_Copy(current^.item, i)
   end
end;


function Pattern_Valid(p: PatternType):boolean;
I 3
(* Pre and post: the first element is current, and so in all items *)
E 3
var
   inv: boolean;
   aux: ItemNodePointer;
begin
D 3
   inv := false;
E 3
I 3
   if not Pattern_StickyHead(p) then
      inv := false
   else begin
      inv := true;
      Error_Set(EHEAPP)
   end;
E 3
   with p^ do begin
D 3
      if Item_Apposition(head^.item) then begin
	 inv := true;
	 Error_Set(EHEAPP)
      end;
E 3
      aux := head;
      while (aux <> nil) and not inv do begin
	 inv := not Item_Valid(aux^.item);
	 aux := aux^.next
      end
   end;
   Pattern_Valid := not inv
end;
E 1
