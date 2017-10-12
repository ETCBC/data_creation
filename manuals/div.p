


BIBLICAL LANGUAGES                                       DIV.P(5)



NAME
     div.p - clause divisions and constituent codes

SYNTAX
     div_p =             verse { verse }.

     verse =             label clause_atom { clause_atom } '\n'.

     clause_atom =       phrase_atom { phrase_atom } next.

     phrase_atom =       constituent_code distance_code.

     distance_code =     <empty> | <integer>.

     A verse label is a string of exactly ten characters.

     The token `next' is a positive integer less than 100.

     A constituent code is an integer in the range [500..599].

     A distance code is a signed integer unequal to 0.

DESCRIPTION
     The div.p file contains the clause divisions and constituent
     codes that were made during a session with parseclauses(1).

     The token `next' is equal to the  word  number  (within  the
     verse)  of  the beginning of the next clause atom, or to the
     special value 99 if it was  the  last  clause  atom  in  the
     verse.   A  positive  distance can be distinguished from the
     token `next', because in that case the preceding constituent
     code  requires a distance.  A distance must not point out of
     the verse.

     The distance code can be decoded into a distance and a  unit
     using the following function, with 100 as the divisor.


          typedef struct { clause, phrase, word } unit_t;

          void
          rela_decode(rela_t *r, int code, int divisor)
          {
             unit_t         u = word;

             while (divisor) {
                if (code / divisor) {
                   r->dist = code - SIGN(code) * divisor;
                   r->unit = u;
                   return;
                }
                divisor /= 10;



Talstra Centre        Last change: 14/03/10                     1






BIBLICAL LANGUAGES                                       DIV.P(5)



                u--;
             }
          }

SEE ALSO
     div(5), divp2div(1), parseclauses(1).

















































Talstra Centre        Last change: 14/03/10                     2



