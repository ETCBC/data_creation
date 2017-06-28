


BIBLICAL LANGUAGES                                       PS4.P(5)



NAME
     ps4.p - morpho-syntactic analysis with clause constituents

SYNTAX
     The syntax of this file is an extension of the specification
     in ps3.p(5), with the following supplementary rules.

     line =              label   <space>   lexical_data   <space>
                         morph_data   <space>  func_data  <space>
                         phrase_data    <space>    subphrase_data
                         <space>     constituent_data     <space>
                         catm_flag <newline>.

     constituent_data =  distance_code <space> constituent_code.

     distance_code =     <integer>.

     constituent_code =  <integer>.

     catm_flag =         <integer>.

DESCRIPTION
     ps4.p is the format of the morpho-syntactic data base output
     by  parseclauses(1).   This type of file contains the result
     of the clause parsing, which adds the clause constituents to
     the analysis.

     The constituent data are written at the  last  word  of  the
     phrase  atom  and  indicate either a clause constituent or a
     phrase atom relation, depending on  the  distance  code.   A
     distance  of  zero  implies a clause constituent, and a non-
     zero distance implies a phrase atom relation.   The  consti-
     tuent data of words not at the last word of a phrase atom is
     to be ignored.  The convention is to write -1 for  both  the
     distance code and the constituent code.

     The distance code reflects both the distance and the unit in
     which  the  distance  is measured.  The unit is either word,
     phrase atom, or clause atom.  The following piece of  Pascal
     code illustrates how distance and unit can be extracted from
     the code.  (The function Sign returns 1 for positive and  -1
     for negative numbers.)


          if code div 100 <> 0 then begin
             dist := code - Sign(code) * 100;
             unit := 'W'
          end else if code div 10 <> 0 then begin
             dist := code - Sign(code) * 10;
             unit := 'P'
          end else if code div 1 <> 0 then begin
             dist := code - Sign(code) * 1;



Werkgroep Informatica Last change: 13/02/22                     1






BIBLICAL LANGUAGES                                       PS4.P(5)



             unit := 'C'
          end else begin
             dist := 0;
             unit := '.'
          end

     For the catm_flag, see ps4(5).

     The constituent code is an integer that specifies either the
     constituent  (subject,  object,  predicate, for example), or
     the type of the phrase atom relation (apposition, specifica-
     tion, for instance).  The constituent code values in use and
     their meaning are defined in ct(5).

SEE ALSO
     ct(5), parseclauses(1), ps3.p(5), ps4(5).







































Werkgroep Informatica Last change: 13/02/22                     2



