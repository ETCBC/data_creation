#include	<stdio.h>
#include	<biblan.h>

#include	"Lpars.h"
#include	"lexer.h"

main(argc, argv)
   int argc;
   char *argv[];
{
   int lexval;

   if (argc != 2) {
      (void) fprintf(stderr, "usage: %s filename\n", argv[0]);
      exit(1);
   }
   if (!lex_open(argv[1])) {
      perror(argv[1]);
      exit(2);
   }
   while ((lexval = yylex()) != 0) {
      if (0 < lexval && lexval < 256) {
	 (void) printf("the character '%c'\n", (char) lexval);
	 continue;
      }
      switch (lexval) {
	 case EOFILE: printf("the token EOFILE\n"); break;
	 case CHARACTER: printf("the token CHARACTER\n"); break;
	 case IDENTIFIER: printf("the token IDENTIFIER\n"); break;
	 case LITERAL: printf("the token LITERAL\n"); break;
	 case ABSENT: printf("the token ABSENT\n"); break;
	 case ENCLITIC: printf("the token ENCLITIC\n"); break;
	 case END: printf("the token END\n"); break;
	 case EXIST: printf("the token EXIST\n"); break;
	 case FORMS: printf("the token FORMS\n"); break;
	 case FUNCTIONS: printf("the token FUNCTIONS\n"); break;
	 case IN: printf("the token IN\n"); break;
	 case INFIX: printf("the token INFIX\n"); break;
	 case MARK: printf("the token MARK\n"); break;
	 case MARKER: printf("the token MARKER\n"); break;
	 case NI: printf("the token NI\n"); break;
	 case NOT: printf("the token NOT\n"); break;
	 case PREFIX: printf("the token PREFIX\n"); break;
	 case RULES: printf("the token RULES\n"); break;
	 case SHARED: printf("the token SHARED\n"); break;
	 case SUFFIX: printf("the token SUFFIX\n"); break;
	 case UNKNOWN: printf("the token UNKNOWN\n"); break;
	 case WORD: printf("the token WORD\n"); break;
	 case ACTION_OPERATOR: printf("the token ACTION_OPERATOR\n"); break;
	 case AND: printf("the token AND\n"); break;
	 case EQUAL: printf("the token EQUAL\n"); break;
	 case NEQ: printf("the token NEQ\n"); break;
	 case OR: printf("the token OR\n"); break;
      }
   }
}
