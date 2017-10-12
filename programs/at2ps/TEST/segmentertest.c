#include	<stdio.h>
#include	"word.h"
#include	"segment.h"

#define	VB_TENSE	1
#define	 VBT_PF		 1
#define	 VBT_IPF	 2
#define	 VBT_INF	 3
#define	 VBT_IMP	 4
#define	 VBT_PTC	 5
#define	VB_STEM		2
#define  VBS_PE		 1
#define	 VBS_PI		 2
#define  VBS_PA		 3
#define  VBS_PU		 4
#define  VBS_HA		 5
#define  VBS_HO		 6
#define  VBS_HT		 7
#define  VBS_HTP	 8
#define  VBS_IT		 9
#define  VBS_HS		 10
#define  VBS_SH		 11
#define  VBS_AP		 12
#define	PERSON		3
#define	NUMBER		4
#define	GENDER		5
#define	G_UNKOWN	 1
#define	G_MASCULINE	 2
#define	G_FEMININE	 3
#define	STATE		6
#define S_ABSOLUTE	 1
#define S_CONSTRUCT	 2
#define S_DETERMINED	 3
#define S_UNKNOWN	 4
#define	P_O_S		7
#define	POS_ADJV	 1
#define	POS_ADVB	 2
#define	POS_CONJ	 3
#define	POS_DART	 4
#define	POS_INRG	 5
#define	POS_INTJ	 6
#define	POS_NEGA	 7
#define	POS_NMPR	 8
#define	POS_PRDE	 9
#define	POS_PREP	 10
#define	POS_PRIN	 11
#define	POS_PRPS	 12
#define	POS_SUBS	 13
#define	POS_VERB	 14
#define	SEMANTIC	8
#define	SEM_CARD	 1
#define	SEM_GENS	 2
#define	SEM_GNTL	 3
#define	SEM_MENS	 4
#define	SEM_MULT	 5
#define	SEM_NMDI	 6
#define	SEM_NMEX	 7
#define	SEM_OBJM	 8
#define	SEM_ORDN	 9
#define	SEM_PADV	 10
#define	SEM_PCON	 11
#define	SEM_PERS	 12
#define	SEM_PPRE	 13
#define	SEM_QUOT	 14
#define SEM_TOPO	 15
#define SEM_VBEX	 16

void build_grammar (void)
{
   grammar_create ();

   grammar_add_morpheme (GRAMMAR_PREFIX,'!',"preformative",1);
   grammar_add_morpheme (GRAMMAR_PREFIX,']',"verbal stem",2);
   grammar_add_morpheme (GRAMMAR_SUFFIX,'[',"verbal ending",3);
   grammar_set_lexical (3);
   grammar_add_morpheme (GRAMMAR_SUFFIX,'/',"nominal ending",4);
   grammar_set_lexical (4);
   grammar_add_morpheme (GRAMMAR_SUFFIX,'~',"locative",5);
   grammar_add_morpheme (GRAMMAR_MARKER,':',"vowel pattern mark",6);
   grammar_add_morpheme (GRAMMAR_ENCLITIC,'+',"pronominal suffix",7);

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
}	/* build_grammar */

void test (char *s)
{
   word_t *w = word_create ();
   printf ("\n '%s': ", s);
   segmenter (w,s);
   word_test (w);
   word_delete (w);
}

main ()
{
   int count;
   setbuf (stdout, NULL);

   bl_init ("/projects/grammar/lib","hebrew");
   build_grammar();
   for (count = 0; count < 1000; count++)
   {
      test ("W:n");
      test ("!!]H]BD&JL[/:c");
      test ("!T=!](H&W](JY>[");
      test ("MJN+H");
      test ("XJ(H/T&W:c");
      test (">R&WR[/:pa");

      if (count % 100 == 0)
	 printf ("\r%d    ", count);
   }
   grammar_delete ();
   return 0;
}
