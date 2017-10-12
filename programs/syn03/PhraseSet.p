module PhraseSet;

(* ident "@(#)dapro/syn03/PhraseSet.p 1.2 03/25/99" *)

#include <Error.h>
#include <PhraseSet.h>


private
function bound_match(s: PhraseSetType; p: PatternType; k: PhraseSetIndexType):boolean;
(* Finds a match in the domain 1 .. k, if found sets current. *)
var
   cmp: CompareType;
   found, stop: boolean;
   i, j: PhraseSetIndexType;
begin
   with s^ do begin
      if (size = 0) or (k = 0) then
	 bound_match := false
      else begin
	 i := 1;
	 repeat
	    j := (i + 1 + k) div 2;
	    cmp := Pattern_PosCmp(patterns[j], p);
	    if cmp = greater then 
	       k := j - 1
	    else
	       i := j
	 until (i = j) and not (j < k);
	 if cmp <> equal then
	    bound_match := false
	 else begin
	    repeat
	       found := Pattern_Match(patterns[j], p);
	       if found or (j = 1) then
		  stop := true
	       else begin
		  j := j - 1;
		  stop := Pattern_PosCmp(patterns[j], p) <> equal
	       end
	    until stop;
	    if not found then
	       bound_match := false
	    else begin
	       current := j;
	       bound_match := true
	    end
	 end
      end
   end
end;


procedure PhraseSet_Add(s: PhraseSetType; p: PatternType);
(* Adds pattern and keeps phrase set sorted *)
var
   i: PhraseSetIndexType;
begin
   if not PhraseSet_FindPat(s, p) then begin
      (* The new pattern will come in the place currently occupied by
      ** current + 1.
      *)
      with s^ do begin
	 if size = PHRASESET_SIZE then begin
	    write('syn03: cannot cope with more than ');
	    write(PHRASESET_SIZE:1, ' ');
	    writeln('phrase patterns in a phrase set');
	    Quit
	 end;
	 for i := size downto current + 1 do begin
	    patterns[i + 1] := patterns[i];
	    occurrences[i + 1] := occurrences[i]
	 end;
	 current := current + 1;
	 Pattern_Create(patterns[current]);
	 Loci_Create(occurrences[current]);
	 Pattern_Copy(patterns[current], p);
	 size := size + 1
      end
   end
end;


procedure PhraseSet_Create(var s: PhraseSetType);
var
   i: PhraseSetIndexType;
begin
   new(s);
   with s^ do begin
      for i := 1 to PHRASESET_SIZE do begin
	 patterns[i] := nil;
	 occurrences[i] := nil
      end;
      current := 0;
      size := 0
   end
end;


procedure PhraseSet_Delete(var s: PhraseSetType);
var
   i: PhraseSetIndexType;
begin
   with s^ do
      for i := 1 to size do begin
	 Pattern_Delete(patterns[i]);
	 Loci_Delete(occurrences[i])
      end;
   dispose(s);
   s := nil
end;


function PhraseSet_Match(s: PhraseSetType; p: PatternType):boolean;
begin
   PhraseSet_Match := bound_match(s, p, s^.size)
end;


function PhraseSet_FindPat(s: PhraseSetType; p: PatternType):boolean;
var
   cmp: CompareType;
   i, j, k: PhraseSetIndexType;
begin
   with s^ do begin
      if size = 0 then
	 PhraseSet_FindPat := false
      else begin
	 i := 1;
	 k := size;
	 repeat
	    j := (i + 1 + k) div 2;
	    cmp := Pattern_Compare(patterns[j], p);
	    if cmp = greater then 
	       k := j - 1
	    else
	       i := j
	 until (i = j) and not (j < k);
	 current := k;
	 PhraseSet_FindPat := cmp = equal
      end
   end
end;


function PhraseSet_FindSub(s: PhraseSetType; p: PatternType):boolean;
var
   cmp: CompareType;
   found, stop: boolean;
   i, j, k: PhraseSetIndexType;
begin
   with s^ do begin
      if size = 0 then
	 PhraseSet_FindSub := false
      else begin
	 i := 1;
	 k := size;
	 repeat
	    j := (i + k) div 2;
	    cmp := Pattern_PosCmp(patterns[j], p);
	    if cmp = less then 
	       i := j + 1
	    else 
	       k := j
	 until (k = j) and not (j > i);
         if cmp <> equal then
	    PhraseSet_FindSub := false
	 else begin
	    repeat
	       found := Pattern_Subset(patterns[j], p);
	       if found or (j = size) then
		  stop := true
	       else begin
		  j := j + 1;
		  stop := Pattern_PosCmp(patterns[j], p) <> equal
	       end
	    until stop;
	    if not found then
	       PhraseSet_FindSub := false
	    else begin
	       current := j;
	       PhraseSet_FindSub := true
	    end
	 end
      end
   end
end;


function PhraseSet_FindSup(s: PhraseSetType; p: PatternType):boolean;
var
   cmp: CompareType;
   found, stop: boolean;
   i, j, k: PhraseSetIndexType;
begin
   with s^ do begin
      if size = 0 then
	 PhraseSet_FindSup := false
      else begin
	 i := 1;
	 k := size;
	 repeat
	    j := (i + 1 + k) div 2;
	    cmp := Pattern_PosCmp(patterns[j], p);
	    if cmp = greater then 
	       k := j - 1
	    else 
	       i := j
	 until (i = j) and not (j < k);
         if cmp <> equal then
	    PhraseSet_FindSup := false
	 else begin
	    repeat
	       found := Pattern_Subset(p, patterns[j]);
	       if found or (j = 1) then
		  stop := true
	       else begin
		  j := j - 1;
		  stop := Pattern_PosCmp(patterns[j], p) <> equal
	       end
	    until stop;
	    if not found then
	       PhraseSet_FindSup := false
	    else begin
	       current := j;
	       PhraseSet_FindSup := true
	    end
	 end
      end
   end
end;


procedure PhraseSet_First(s: PhraseSetType);
begin
   with s^ do
      if size <> 0 then
	 current := 1
end;


function PhraseSet_Next(s: PhraseSetType):boolean;
begin
   with s^ do begin
      if (current = 0) or (current = size) then
	 PhraseSet_Next := false
      else begin
	 current := current + 1;
	 PhraseSet_Next := true
      end
   end
end;


function PhraseSet_RefLoci(s: PhraseSetType):LociType;
begin
   with s^ do
      if current = 0 then
	 PhraseSet_RefLoci := nil
      else
	 PhraseSet_RefLoci := occurrences[current]
end;


function PhraseSet_Rematch(s: PhraseSetType; p: PatternType):boolean;
begin
   with s^ do
      if (current = 0) or (Pattern_Size(p) = 0) then
	 PhraseSet_Rematch := false
      else
	 PhraseSet_Rematch := bound_match(s, p, current - 1)
end;


procedure PhraseSet_Remove(s: PhraseSetType);
var
   i: PhraseSetIndexType;
begin
   with s^ do begin
      if (1 <= current) and (current <= size) then begin
	 Pattern_Delete(patterns[current]);
	 Loci_Delete(occurrences[current]);
	 size := size - 1;
	 for i := current to size do begin
	    patterns[i] := patterns[i + 1];
	    occurrences[i] := occurrences[i + 1]
	 end;
	 if current > size then
	    current := size
      end
   end
end;


procedure PhraseSet_Retrieve(s: PhraseSetType; p: PatternType);
begin
   with s^ do begin
      if current <> 0 then
	 Pattern_Copy(p, patterns[current])
   end
end;


procedure PhraseSet_Label(s: PhraseSetType; l: LocusType);
begin
   with s^ do
      if current <> 0 then
	 Loci_Add(occurrences[current], l)
end;


procedure PhraseSet_SetLoci(s: PhraseSetType; l: LociType);
begin
   with s^ do
      if current <> 0 then
	 Loci_Copy(occurrences[current], l)
end;
