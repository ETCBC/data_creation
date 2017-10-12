#include	<stdio.h>
#include	"grammar.h"

#define	PREFIX	1
#define INFIX	2
#define	SUFFIX	3
#define	MARKER	4
#define	ENCLITIC	5
main ()
{
   int count;
   char ch;
   setbuf (stdout, NULL);
   for (count = 1; count < 1000; count++)
   {
      grammar_create ();

      grammar_add_morpheme (PREFIX,'!',"preformative",1);
      grammar_add_morpheme (PREFIX,']',"verbal stem",2);
      grammar_add_morpheme (SUFFIX,'[',"verbal ending",3);
      grammar_add_morpheme (SUFFIX,'/',"nominal ending",4);
      grammar_add_morpheme (SUFFIX,'~',"locative",5);
      grammar_add_morpheme (MARKER,':',"vowel pattern mark",6);
      grammar_add_morpheme (ENCLITIC,'+',"pronominal suffix",7);

      grammar_add_morph_element (1,"",1);
      grammar_add_morph_element (1,">",2);
      grammar_add_morph_element (1,"H",3);
      grammar_add_morph_element (1,"J",4);
      grammar_add_morph_element (1,"M",5);
      grammar_add_morph_element (1,"N",6);
      grammar_add_morph_element (1,"T",7);
      grammar_add_morph_element (1,"T=",8);

      grammar_add_morph_element (2,">T",1);
      grammar_add_morph_element (2,"H",2);
      grammar_add_morph_element (2,"HCT",3);
      grammar_add_morph_element (2,"HT", 4);
      grammar_add_morph_element (2,"N",5);
      grammar_add_morph_element (2,"NT",6);
      grammar_add_morph_element (2,"T",7);

      grammar_add_morph_element (3,"",1);
      grammar_add_morph_element (3,"H",2);
      grammar_add_morph_element (3,"H=",3);
      grammar_add_morph_element (3,"W",4);
      grammar_add_morph_element (3,"WN",5);
      grammar_add_morph_element (3,"J",6);
      grammar_add_morph_element (3,"JN",7);
      grammar_add_morph_element (3,"NH",8);
      grammar_add_morph_element (3,"NW",9);
      grammar_add_morph_element (3,"T",10);
      grammar_add_morph_element (3,"T=",11);
      grammar_add_morph_element (3,"TH",12);
      grammar_add_morph_element (3,"TJ",13);
      grammar_add_morph_element (3,"TM",14);
      grammar_add_morph_element (3,"TN",15);

      grammar_add_morph_element (4,"",1);
      grammar_add_morph_element (4,"H",2);
      grammar_add_morph_element (4,"WT",3);
      grammar_add_morph_element (4,"WTJ",4);
      grammar_add_morph_element (4,"J",5);
      grammar_add_morph_element (4,"J=",6);
      grammar_add_morph_element (4,"JM",7);
      grammar_add_morph_element (4,"JM=",8);
      grammar_add_morph_element (4,"JN",9);
      grammar_add_morph_element (4,"T",10);
      grammar_add_morph_element (4,"TJ",11);
      grammar_add_morph_element (4,"TJM",12);

      grammar_add_morph_element (5,"H",1);

      grammar_add_morph_element (6,"a",1);
      grammar_add_morph_element (6,"c",2);
      grammar_add_morph_element (6,"d",3);
      grammar_add_morph_element (6,"n",4);
      grammar_add_morph_element (6,"p",5);

      grammar_add_morph_element (7,"H",1);
      grammar_add_morph_element (7,"HW",2);
      grammar_add_morph_element (7,"HM",3);
      grammar_add_morph_element (7,"HMH",4);
      grammar_add_morph_element (7,"HN",5);
      grammar_add_morph_element (7,"HNH",6);
      grammar_add_morph_element (7,"W",7);
      grammar_add_morph_element (7,"J",8);
      grammar_add_morph_element (7,"K",9);
      grammar_add_morph_element (7,"K=",10);
      grammar_add_morph_element (7,"KM",11);
      grammar_add_morph_element (7,"KN",12);
      grammar_add_morph_element (7,"M",13);
      grammar_add_morph_element (7,"MW",14);
      grammar_add_morph_element (7,"N",15);
      grammar_add_morph_element (7,"NW",16);
      grammar_add_morph_element (7,"NJ",17);

      grammar_add_function ("gender", 1);
       grammar_assign (7,1);
	grammar_add_func_element (1, "feminine", 1);
	grammar_add_func_element (1, "masculine", 2);
      grammar_add_function ("number", 2);
       grammar_assign (7,2);
	grammar_add_func_element (2, "singular", 1);
	grammar_add_func_element (2, "dual", 2);
	grammar_add_func_element (2, "plural", 3);
      grammar_add_function ("person", 3);
       grammar_assign (7,3);
	grammar_add_func_element (3, "first", 1);
	grammar_add_func_element (3, "second", 2);
	grammar_add_func_element (3, "third", 3);
      grammar_add_function ("lexical set", 4);
	grammar_add_func_element (4, "cardinal", 1);
	grammar_add_func_element (4, "gentilic", 2);
	grammar_add_func_element (4, "noun of multitude", 3);
	grammar_add_func_element (4, "noun of distribution", 4);
	grammar_add_func_element (4, "noun of existence", 5);
	grammar_add_func_element (4, "ordinal", 6);
	grammar_add_func_element (4, "possible adverb", 7);
	grammar_add_func_element (4, "possible conjunction", 8);
	grammar_add_func_element (4, "possible interrogative", 9);
	grammar_add_func_element (4, "possible demonstrative pronoun", 10);
	grammar_add_func_element (4, "possible preposition", 11);
	grammar_add_func_element (4, "verb of direct speech", 12);
	grammar_add_func_element (4, "verb of existence", 13);
      grammar_add_function ("part of speech", 5);
	grammar_add_func_element (5, "adjective", 1);
	grammar_add_func_element (5, "adverb", 2);
	grammar_add_func_element (5, "article", 3);
	grammar_add_func_element (5, "conjunction", 4);
	grammar_add_func_element (5, "interrogative", 5);
	grammar_add_func_element (5, "interjection", 6);
	grammar_add_func_element (5, "negative", 7);
	grammar_add_func_element (5, "proper noun", 8);
	grammar_add_func_element (5, "demonstrative pronoun", 9);
	grammar_add_func_element (5, "preposition", 10);
	grammar_add_func_element (5, "interrogative pronoun", 11);
	grammar_add_func_element (5, "personal pronoun", 12);
	grammar_add_func_element (5, "substantive", 13);
	grammar_add_func_element (5, "verb", 14);
      grammar_add_function ("state", 6);
	grammar_add_func_element (6, "constructus", 1);
	grammar_add_func_element (6, "absolutus", 2);
      grammar_add_function ("verbal stem", 7);
	grammar_add_func_element (7, "qal", 1);
	grammar_add_func_element (7, "passive qal", 2);
	grammar_add_func_element (7, "niphal", 3);
	grammar_add_func_element (7, "piel", 4);
	grammar_add_func_element (7, "pual", 5);
	grammar_add_func_element (7, "hiphil", 6);
	grammar_add_func_element (7, "hophal", 7);
	grammar_add_func_element (7, "hitpael", 8);
	grammar_add_func_element (7, "hotpaal", 9);
	grammar_add_func_element (7, "hishtaphal", 10);
      grammar_add_function ("verbal tense", 8);
	grammar_add_func_element (8, "perfect", 1);
	grammar_add_func_element (8, "imperfectum", 2);
	grammar_add_func_element (8, "imperativum", 3);
	grammar_add_func_element (8, "infinitivus", 4);
	grammar_add_func_element (8, "participium", 5);

      if (count % 100 == 0)
	 printf ("\r%d    ", count);
      grammar_delete ();
   }
}
