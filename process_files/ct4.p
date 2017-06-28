


BIBLICAL LANGUAGES                                          CT(5)



NAME
     ct - Coded Text (surface)

SYNTAX
     ct =                clause_atom { clause_atom }.

     clause_atom =       VSLAB phrase eocm.

     phrase =            simple_phrase | full_phrase.

     eocm =              <empty> | '*'.

     full_phrase =       '[' simple_phrase sub_phrase PHLAB ']'.

     sub_phrase =        <empty> | '/'  simple_phrase  sub_phrase
                         PHLAB.

     simple_phrase =     WORD { '-' } { WORD { '-' } }.

DESCRIPTION
     The CT file lists the clause atoms of a text line  by  line.
     Every  line  starts with a verse label, followed by the sur-
     face text of the words that constitute the clause atom.  The
     line  is  traditionally  ended  with  an  asterisk, which is
     optional.  Words are separated by white space  or  connected
     with  hyphens.   CT  files  written  by syn01(1) are in this
     form.

     Apart from this plain format, the CT file provides for anno-
     tated  clause  atom,  in  which  the constituent phrases are
     demarcated by square brackets and labelled. Within  phrases,
     subsidiary phrase atoms are separated by slashes and receive
     a label of their own.  Annotated CT files  are  produced  by
     parseclauses(1).

TOKENS
     The tokens used in the grammar above, PHLAB, VSLAB and WORD,
     are further defined in this section.

     PHLAB
          Annotated phrase atoms have one of the following phrase
          labels  indicating  either  the phrase atom relation or
          the function within the clause.  The  angular  brackets
          are  part  of  the  label.  The second column lists the
          four-letter abbreviation used by pxdump(1).

          Phrase Atom Relations

          l l l.  <ap> Appo Apposition (500) <cj> Link Link (567)
          <pa> Para Parallel (566) <ss> Sfxs Suffix specification
          (535) <sp> Spec Specification (582)




Werkgroep Informatica Last change: 14/03/07                     1






BIBLICAL LANGUAGES                                          CT(5)



          Phrase Function within Clause

          l l l.  <..> Unkn Unknown (599) <Aj> Adju Adjunct (505)
          <Co> Cmpl Complement  (504) <Cj> Conj Conjunction (509)
          <Ep> EPPr Enclitic     personal      pronoun      (541)
          <Xs> ExsS Existence    with    subject   suffix   (552)
          <eX> Exst Existence  (550)  <Fr> Frnt Fronted   element
          (572)            <Ij> Intj Interjection           (512)
          <Is> IntS Interjection  with   subject   suffix   (522)
          <Lo> Loca Locative   (507)   <Mo> Modi Modifier   (508)
          <Ms> ModS Modifier   with    subject    suffix    (528)
          <NC> NCop Negative   copula   (540)  <Ns> NCoS Negative
          copula with  subject  suffix  (542)  <Ng> Nega Negation
          (510)   <Ob> Objc Object   (503)  <Pj> PrAd Predicative
          adjunct (525) <PS> PrcS Predicate complement with  sub-
          ject  suffix (523) <PC> PreC Predicate complement (521)
          <Pr> Pred Predicate  (501)   <PO> PreO Predicate   with
          object  suffix  (531)  <Ps> PreS Predicate with subject
          suffix (532) <po> PtcO Participle  with  object  suffix
          (534) <Qu> Ques Question (511) <Re> Rela Relative (519)
          <Su> Subj Subject (502) <sc> Supp Supplementary consti-
          tuent     (515)    <Ti> Time Time    reference    (506)
          <Vo> Voct Vocative (562)

          Note that the  labels  for  `Fronted  element  as'  and
          `Interrogative  pronoun  as' have been removed, as they
          have been superseded by the  phrase  relation  `resump-
          tion'  or are equivalent to phrase type = IPrP, respec-
          tively.

     VSLAB
          The first ten characters of each line make up the verse
          label, which must be followed by a space.

     WORD Words consist of character strings  from  the  alphabet
          &.0-9:;<>@A-Z_  (the  underscore  indicates an embedded
          space).

SEE ALSO
     at(5), parseclauses(1), pxdump(1), syn01(1).















Werkgroep Informatica Last change: 14/03/07                     2



