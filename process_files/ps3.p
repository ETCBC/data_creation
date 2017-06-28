


BIBLICAL LANGUAGES                                       PS3.P(5)



NAME
     ps3.p - morpho-syntactic analysis with subphrases

SYNTAX
     The syntax of this file is an extension  to  the  syntax  of
     ps3(5), with the following supplementary rules.

     line =              label   <space>   lexical_data   <space>
                         morph_data   <space>  func_data  <space>
                         phrase_data <space> subphrase_data <new-
                         line>.

     subphrase_data =    subphrase_code  <space>   subphrase_code
                         <space> subphrase_code.

     subphrase_code =    <integer>.

DESCRIPTION
     ps3.p is the format of the morpho-syntactic data base output
     by  parsephrases(1).   This type of file contains the result
     of adding subphrases to the analysis.

     The subphrases are indicated with a code at the last word of
     the  subphrase.  The code contains the distance to the first
     word of the  subphrase  (beginning),  the  distance  to  the
     mother of the subphrase (distance), and the type of relation
     (relation).  They can be extracted from the code  using  the
     following functions.

          beginning   =    -1 * (abs(code) mod 10000 div 100)
          distance    =    code div 10000
          relation    =    abs(code) mod 100

     Note that the dividend of  the  modulo  operation  is  never
     negative  here, so there is no uncertainty about the sign of
     the remainder.  The distances are measured  in  words.   The
     distance of a mother subphrase is zero.

     The value of the type of relation is  taken  from  the  next
     table.

           2   Regens/rectum   REG
           4   Modifier        MOD
           5   Adjunct         ADJ
           6   Parallel        PAR
           8   Demonstrative   DEM
          13   Attribute       ATR

BUGS
     The format allows a maximum of three  subphrases  ending  at
     the  same  word.   There are, however, phrases with a deeper
     level of nesting.  In  those  cases  only  the  three  outer



Werkgroep Informatica Last change: 10/04/20                     1






BIBLICAL LANGUAGES                                       PS3.P(5)



     subphrases are to be recorded.

SEE ALSO
     parsephrases(1), ps3(5).



















































Werkgroep Informatica Last change: 10/04/20                     2



