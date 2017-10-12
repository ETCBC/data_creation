h54570
s 00288/00000/00000
d D 1.1 00/09/19 12:20:28 const 1 0
c Version of Apr 7 1997
e
u
U
f e 0
f m q2pro/at2ps/get_at.c
t
T
I 1
/* Output from p2c, the Pascal-to-C translator */
/* From input file "syn00.p" */


#include "p2c.h"


/* this program reads a part of a book and glues parts of verses together
*/


#define SYNFILE         "synnr"
#define VERSLEN         512	/* Length of verse identification
				   string */
#define FILENAMELEN     255	/* length of filenames */

#define SYNDIR          "/projects/grammar/bin/"
 /* dir where progs reside */
#define LIBDIR          "/projects/grammar/lib/"
 /* dir where languages are */
#define BOOKDIR         "/projects/grammar/newtenach/"	/* dir where
						books reside */


typedef Char    FileName[FILENAMELEN + 1];

typedef Char    LetterName[11];


extern Char    *itos(Char * Result, long i);

/* This function returns a string containing the value of i) */

extern Char    *StageFile(Char * Result, long Stage);

/* This function checks whether a program is run at the proper stage,
   and returns the filename of the text currently in proces. If the
   program is not at the proper stage, it is halted with an
   appropriate text. The stage is kept in a file and updated by means
   of procedure SafeStage. It is called with the number of the current
   stage as an argument, e.g
     filename := Stagefile (1);  [ check for stage 1 ]
*/


extern void     SafeStage(long Stage, Char * Name);


/* This procedure safes the current stage and the current textfilename
   in a file called SYNFILE. Stage may range from 0..99, FileName is a
   string with as much as FILENAMELEN chars. To be called as e.g.:
   SafeStage (0, 'exodus1-1');
*/

typedef Char    VerseCode[VERSLEN];	/* versaanduiding */


Static _TEXT    Book;		/* original text file */
Static _TEXT    Cap;		/* part with adjusted format: one verse
				   per line */
Static Char     Ch;
Static long     CapNr, OldCapNr;
Static long     VersNr;
Static VerseCode VVers;		/* vorig vers */
Static VerseCode VN;
Static long     ECap, LCap;
Static FileName FName, FPart;
Static boolean  Present, Kompleet, Changed;

void
SafeStage(long Stage, Char * Name)
{
   /*
      This procedure safes the current stage and the current
      textfilename in a file called SYNFILE. To be called as e.g.:
      SafeStage (0, 'exodus1-1');
   */
   _TEXT           SynNrFile;

   SynNrFile.f = NULL;
   *SynNrFile.name = '\0';
   strcpy(SynNrFile.name, P_trimname(SYNFILE, 256));
   if ((SynNrFile.f = fopen(SynNrFile.name, "w")) == NULL)
      _EscIO(FileNotFound);
   else {
      SETUPBUF(SynNrFile.f, Char);
      fprintf(SynNrFile.f, "%ld %s\n", Stage, Name);
   }
   if (SynNrFile.f != NULL)
      fclose(SynNrFile.f);
}				/* SafeStage */


Char           *
itos(Char * Result, long i)
{
   (void) sprintf(Result, "%02ld", i);
   return Result;
}				/* itos */


Static void
leesfilenaam(void)
{
   long            error;
   Char            STR1[256];

   do {
      error = 0;
      printf(" What is the name of the book to be read from %s? ", BOOKDIR);
      gets(FName);
      sprintf(STR1, "%s%s", BOOKDIR, FName);
      strcpy(Book.name, P_trimname(STR1, 256));
      if ((Book.f = fopen(Book.name, "r")) == NULL)
	 error = 1;
      else
	 SETUPBUF(Book.f, Char);
      if (error != 0)
	 printf(" Check the spelling of %s.\n", FName);
   } while (error != 0);
}				/* leesfilenaam */


Static void
leespartnaam(void)
{
   LetterName        STR1, STR2;

   if (ECap == LCap)
      sprintf(FPart, "%s%s", FName, itos(STR1, ECap));
   else
      sprintf(FPart, "%s%s-%s", FName, itos(STR1, ECap), itos(STR2, LCap));
   strcpy(Cap.name, P_trimname(FPart, FILENAMELEN + 1));
   if ((Cap.f = fopen(Cap.name, "w")) == NULL)
      _EscIO(FileNotFound);
   else
      SETUPBUF(Cap.f, Char);
   printf(" ... reading: /projects/tenach/%s\n", FName);
   printf(" ... writing: %s\n", FPart);
}				/* leespartnaam */

Static void
GetLine (void)
{
   fgets (VN, VERSLEN, Book.f);	/* lees regel */
   while (VN[0] == '#')
   {
      strcpy (VVers, VN);
      Changed = true;
      fgets (VN, VERSLEN, Book.f);
   }
}

Static void
GetCap (void)
{
   int p = 0;
   CapNr = 0;
   while (VN[p] != ',') p++;
   while (isdigit(VN[p-1])) p--;
   while (isdigit(VN[p]))
   {
      CapNr *= 10;
      CapNr += VN[p] - '0';
      p++;
   }
}


Static void
leesVers(void)
{
   GetLine ();
   GetCap ();
   if (CapNr != OldCapNr)
   {
      OldCapNr = CapNr;
      if (!Present && CapNr == ECap)
	 printf("\n ... writing :");
      if (CapNr <= LCap)
	 printf("%4ld", CapNr);
   }
   if (CapNr < ECap || CapNr > LCap)
      return;
   Present = true;
   if (Changed)
   {
      fputs (VVers, Cap.f);
      Changed = false;
   }
   fputs (VN, Cap.f);
}				/* leesVers */


Static void
aantalCaps(void)
{
   do {
      printf(" What is the FIRST chapter of %s that you want? ", FName);
      scanf("%ld%*[^\n]", &ECap);
      getchar();
      if (ECap < 1 || ECap > 150)
	 printf(" Trying to be funny, huh?\n");
   } while (ECap <= 0 || ECap >= 151);
   do {
      printf(" ... and the FINAL chapter? ");
      scanf("%ld%*[^\n]", &LCap);
      getchar();
      if (LCap < ECap)
	 printf(" Hey, reading backwards?\n");
      if (LCap > 150)
	 printf(" David stopped at 150, honey, that should be enough for you too ...\n");
   } while (LCap < ECap || LCap >= 151);
}				/* aantalCaps */


Static void
Init(void)
{
   OldCapNr = 0;
   ECap = 0;
   LCap = 0;
   Present = false;
   leesfilenaam();		/* Which book? */
   aantalCaps();		/* Which chapters? */
   leespartnaam();		/* Name of output file */
   if (*Book.name != '\0') {
      if (Book.f != NULL)
	 Book.f = freopen(Book.name, "r", Book.f);
      else
	 Book.f = fopen(Book.name, "r");
   } else
      rewind(Book.f);
   if (Book.f == NULL)
      _EscIO(FileNotFound);
   RESETBUF(Book.f, Char);
   if (*Cap.name != '\0') {
      if (Cap.f != NULL)
	 Cap.f = freopen(Cap.name, "w", Cap.f);
      else
	 Cap.f = fopen(Cap.name, "w");
   } else {
      if (Cap.f != NULL)
	 rewind(Cap.f);
      else
	 Cap.f = tmpfile();
   }
   if (Cap.f == NULL)
      _EscIO(FileNotFound);
   SETUPBUF(Cap.f, Char);
   Kompleet = false;		/* Writing not ready, to begin with */
}				/* Init */


main(int argc, Char * argv[])
{				/* main */
   PASCAL_MAIN(argc, argv);
   Cap.f = NULL;
   *Cap.name = '\0';
   Book.f = NULL;
   *Book.name = '\0';
   Init();
   printf(" ... skipping :");
   do {				/* Checking the chapters */
      leesVers();
   } while (!(Kompleet | BUFEOF(Book.f)));	/* Ready! */

   if (CapNr < LCap)
      printf(" You do not seem to have realized that %s only has %ld chapters.\n",
	     FName, CapNr);
   if (Cap.f != NULL)
      fclose(Cap.f);
   Cap.f = NULL;
   if (!Present)
      printf(" Chapter(s) not found.\n");
   printf("\n Now you may run program at2ps.\n");
   printf(" ... (this program will read %s.)\n\n", FPart);
   SafeStage(0, FPart);
   if (Book.f != NULL)
      fclose(Book.f);
   if (Cap.f != NULL)
      fclose(Cap.f);
   exit(EXIT_SUCCESS);
}



/* End. */
E 1
