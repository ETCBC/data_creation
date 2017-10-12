program syn04types(output);

(* Argue_Coor: de andere types *)

(* ident "@(#)dapro/simple/syn04types.p	2.25 17/02/03" *)

{
   Reads a PS file, i.e. the product of a morphological analysis by
   program syn01, program syn02, program syn03 and program syn04;
   produces a new CT file with an indication of phrases and phrase
   types.
   PS4.types
   Data files needed: A XXX.PS4 file; XXX.CT4 file.
}

#include <hebrew/hebrew.h>
#include <hebrew/syntax.h>

const
(* Capacities, as in parseclauses *)
   MAX_CTYPES		= 45;

(* Replies *)
   NO		= ['N', 'n'];
   YES		= ['J', 'Y', 'j', 'y'];

(* Field selectors in ps file *)
   KO_LS	=  0;	(* lexical set *)
   KO_SP	=  1;	(* part of speech *)
   KO_VBS	=  3;	(* verbal stem *)
   KO_VBE	=  4;	(* verbal ending *)
   KO_NME	=  5;	(* nominal ending *)
   KO_PRS	=  6;	(* pronominal suffix *)
   KO_VT	=  7;	(* verbal tense *)
   KO_PS	=  8;	(* person *)
   KO_NU	=  9;	(* number *)
   KO_GN	= 10;	(* gender *)
   KO_ST	= 11;	(* state *)
   KO_PDP	= 12;	(* phrase dependent part of speech *)
   KO_PTY	= 13;	(* phrase type *)
   KO_DET	= 14;	(* phrase determination *)
   KO_FUN	= 19;	(* phrase function *)
   KO_MIL	= 20;	(* MI line *)

(* Values for Verbal Tense in ps1(5) *)
   VT_IMPF	=  1;
   VT_PERF	=  2;
   VT_IMPV	=  3;
   VT_INFC	=  4;
   VT_INFA	=  5;
   VT_PTCA	=  6;
   VT_WAYQ	= 11;
   VT_WEYQ	= 12;
   VT_PTCP	= 62;

(* Values for Verbal Tense in codes *)
   VT_Yqt	=  1;
   VT_Qtl	=  2;
   VT_Imp	=  3;
   VT_Ptc	=  6;
   VT_Way	=  7;
   VT_Wey	=  8;

(* Values for part of speech *)
   SP_VERB	=  1;
   SP_SUBS	=  2;
   SP_NMPR	=  3;
   SP_ADVB	=  4;
   SP_PREP	=  5;
   SP_CONJ	=  6;
   SP_PRPS	=  7;
   SP_PRDE	=  8;
   SP_PRIN	=  9;
   SP_INTJ	= 10;
   SP_NEGA	= 11;
   SP_INRG	= 12;
   SP_ADJV	= 13;

(* Values for State *)
   ST_C		= 1;
   ST_A		= 2;

(* Values for Phrase (Atom) Type *)
   PTY_VP	= SP_VERB;
   PTY_NP	= SP_SUBS;
   PTY_PrNP	= SP_NMPR;
   PTY_AdvP	= SP_ADVB;
   PTY_PP	= SP_PREP;
   PTY_CP	= SP_CONJ;
   PTY_PPrP	= SP_PRPS;
   PTY_DPrP	= SP_PRDE;
   PTY_IPrP	= SP_PRIN;
   PTY_InjP	= SP_INTJ;
   PTY_NegP	= SP_NEGA;
   PTY_InrP	= SP_INRG;
   PTY_AdjP	= SP_ADJV;

(* Values for Phrase (Atom) Determination *)
   DET_TRUE	=  2;

(* Values for Text Type *)
   TTY_UNKNOWN		= '?';
   TTY_DISCURSIVE	= 'D';
   TTY_NARRATIVE	= 'N';
   TTY_QUOTATION	= 'Q';

(* General labels *)
   L_EMPTY	= '     ';
   L_QUOT	= ' [Q] ';
   L_ROOT	= ' [R] ';
   L_SUFFIX	= ' sfx.';
   L_UNKN	= '**** ';
   L_NULL	= '---- ';
   L_LSHIFT	= '<<<< ';
   L_RSHIFT	= '>>>> ';

(* Function words *)
   L_AND	= 'W    ';
   L_AS		= 'K    ';
   L_OBJC	= '>T   ';

(* Labels for Verbal Stem *)
   L_Afel	= 'afel ';
   L_Eshtafal	= 'esht ';
   L_Etpaal	= 'etpa ';
   L_Etpeel	= 'etpe ';
   L_Ettafal	= 'etta ';
   L_Hafel	= 'haf  ';
   L_Hifil	= 'hif  ';
   L_Hitpael	= 'hit  ';
   L_Hofal	= 'hof  ';
   L_Hotpaal	= 'hotp ';
   L_Hishtafal	= 'hsht ';
   L_Hitpaal	= 'htpa ';
   L_Hitpeel	= 'htpe ';
   L_Nifal	= 'nif  ';
   L_Nitpael	= 'nit  ';
   L_Pael	= 'pael ';
   L_PassiveQal	= 'pasq ';
   L_Peal	= 'peal ';
   L_Peil	= 'peil ';
   L_Piel	= 'piel ';
   L_Pual	= 'pual ';
   L_Qal	= 'qal  ';
   L_Shafel	= 'shaf ';
   L_Tifal	= 'tif  ';

(* Labels for Verbal Tense *)
   T_IMPF	= 'impf ';
   T_IMPV	= 'impv ';
   T_INFA	= 'infa ';
   T_INFC	= 'infc ';
   T_PERF	= 'perf ';
   T_PTCA	= 'ptca ';
   T_PTCP	= 'ptcp ';
   T_WAYQ	= 'wayq ';
   T_WEYQ	= 'weyq ';

(* Labels for Phrase (Atom) Type *)
   L_NP		= 'NP   ';
   L_NPDT	= 'NPdt ';
   L_PrNP	= 'NPpn ';

(* Labels for Clause Atom Type *)
   L_Defc	= 'Defc ';

(* Phrase positions in phraserec array *)
   PR_COOR	=  1;	(* coordinating conjunction *)
   PR_QUES	=  2;	(* interrogative particle *)
   PR_FOCP	=  3;	(* focus particle *)
   PR_CONJ	=  4;	(* conjunction of the clause *)
   PR_PREP	=  5;	(* conjoining preposition *)
   PR_TOPIC	=  6;	(* noun phrase moved to front *)
   PR_INRG	=  7;	(* interrogative in clause opening *)
   PR_NEGA	=  8;	(* clausal negation *)
   PR_ADVB	=  9;	(* clausal adverb *)
   PR_INTJ	= 10;	(* interjection in clause opening *)
   PR_PRDE1	= 11;	(* demonstrative pronoun in clause opening *)
   PR_PRPS1	= 12;	(* personal pronoun in clause opening *)
   PR_NP1	= 13;	(* first nominal group *)
   PR_NP1_SFX	= 14;	(* and its pronominal suffix *)
   PR_NP2	= 15;	(* second nominal group *)
   PR_NP2_SFX	= 16;	(* and its pronominal suffix *)
   PR_NP3	= 17;	(* third nominal group *)
   PR_NP3_SFX	= 18;	(* and its pronominal suffix *)
   PR_VERB	= 19;	(* verbal predicate *)
   PR_ADJV	= 20;	(* adjectival predicate *)
   PR_VT	= 21;	(* verbal tense of predicate *)
   PR_VS	= 22;	(* verbal stem of predicate *)
   PR_PNG	= 23;	(* person, number, and gender of predicate *)
   PR_PRED_SFX	= 24;	(* pronominal suffix of verbal predicate *)
   PR_MODI	= 25;	(* modifier *)
   PR_PRDE2	= 26;	(* demonstrative pronoun after predicate *)
   PR_PRPS2	= 27;	(* personal pronoun after predicate *)
   PR_NP4	= 28;	(* first nominal group after predicate *)
   PR_NP4_SFX	= 29;	(* and its pronominal suffix *)
   PR_NP5	= 30;	(* second nominal group after predicate *)
   PR_NP5_SFX	= 31;	(* and its pronominal suffix *)
   PR_NP6	= 32;	(* third nominal group after predicate *)
   PR_NP6_SFX	= 33;	(* and its pronominal suffix *)
   PR_CLAB	= 34;	(* clause label *)
   PR_LABEL	= 35;	(* typological label of clause opening *)

(* Labels in phraserec array *)
   (*  1 *) L_PR_COOR		= 'Coor ';
   (*  2 *) L_PR_QUES		= 'Ques ';
   (*  3 *) L_PR_FOCP		= 'Focp ';
   (*  4 *) L_PR_CONJ		= 'Conj ';
   (*  5 *) L_PR_PREP		= 'Prep ';
   (*  6 *) L_PR_TOPIC		= 'Topic';
   (*  7 *) L_PR_INRG		= 'Irog ';
   (*  8 *) L_PR_NEGA		= ' Neg ';
   (*  9 *) L_PR_ADVB		= ' Adv ';
   (* 10 *) L_PR_INTJ		= ' Int ';
   (* 11 *) L_PR_PRDE1		= 'PrnD ';
   (* 12 *) L_PR_PRPS1		= 'PrnP ';
   (* 13 *) L_PR_NP1		= 'NP/P ';
   (* 14 *) L_PR_NP1_SFX	= 'sfx  ';
   (* 15 *) L_PR_NP2		= 'NP/P ';
   (* 16 *) L_PR_NP2_SFX	= 'sfx  ';
   (* 17 *) L_PR_NP3		= 'NP/P ';
   (* 18 *) L_PR_NP3_SFX	= 'sfx  ';
   (* 19 *) L_PR_VERB		= 'Verb ';
   (* 20 *) L_PR_ADJV		= 'ADJ  ';
   (* 21 *) L_PR_VT		= 'Vbtn ';
   (* 22 *) L_PR_VS		= ' Rtf ';
   (* 23 *) L_PR_PNG		= ' PNG ';
   (* 24 *) L_PR_PRED_SFX	= 'Vbsf ';
   (* 25 *) L_PR_MODI		= 'Vmod ';
   (* 26 *) L_PR_PRDE2		= 'PrnD ';
   (* 27 *) L_PR_PRPS2		= 'PrnP ';
   (* 28 *) L_PR_NP4		= 'NP/P ';
   (* 29 *) L_PR_NP4_SFX	= 'sfx  ';
   (* 30 *) L_PR_NP5		= 'NP/P ';
   (* 31 *) L_PR_NP5_SFX	= 'sfx  ';
   (* 32 *) L_PR_NP6		= 'NP/P ';
   (* 33 *) L_PR_NP6_SFX	= 'sfx  ';
   (* 34 *) L_PR_CLAB		= 'CLAB ';
   (* 35 *) L_PR_LABEL		= 'Label';

(* Field selectors in Clauserec *)

   CR_PTY	= 1;	(* Phrase Type *)
   CR_FUN	= 2;	(* Phrase Function *)
   CR_REC	= 3;	(* Field in phraserec *)
   CR_PHRPNG	= 4;	(* Person-number-gender of phrase *)
   CR_SFXPNG	= 5;	(* Person-number-gender of suffix *)
   CR_PHRACT	= 6;	(* Position of phrase in Actors *)
   CR_SFXACT	= 7;	(* Position of suffix in Actors *)
   CR_PHRDIS	= 8;	(* Distance of phrase to line *)
   CR_PHRNUM	= 9;	(* Number of phrase *)
   CR_WORDNR	= 10;	(* Word number in verse of phrase end *)
   CR_LEXSET	= 11;	(* Lexical set of phrase end *)
   CR_STATE	= 12;	(* State of phrase end *)
   CR_CLAUSE	= 13;	(* Main clause constituent *)

(* Argument labels *)

   ARGLAB_12T21	= '1/2P<<2/1P';
   ARGLAB_12TO3	= '3rdP<<1/2P';
   ARGLAB_3TO12	= '1/2P<<3rdP';
   ARGLAB_ASYNQ	= 'Asyn<<QtVb';
   ARGLAB_DOWN	= 'Downward=Y';
   ARGLAB_ELLP	= 'Elliptical';
   ARGLAB_MSYN	= 'MacroSign?';
   ARGLAB_NOREF	= 'NoReferral';
   ARGLAB_PREV	= 'ParalPre00';
   ARGLAB_PRLX	= 'ParalLex00';
   ARGLAB_SHUN	= 'Downward=N';
   ARGLAB_VBT	= 'VBT << VBT';
   ARGLAB_VLEX	= 'VLex==VLex';
   ARGLAB_WHNH	= 'W-HNH+Verb';
   ARGLAB_XPOS	= 'XPos>>Main';
   (* Arglabs for CCR *)
   ARGLAB_ADJU	= 'Adju<<Main';
   ARGLAB_ATTR	= 'Rela<<Main';
   ARGLAB_COOR	= 'Coor<<Main';
   ARGLAB_OBJC	= 'Objc<<Main';
   ARGLAB_PREC	= 'PreC<<Main';
   ARGLAB_SUBJ	= 'Subj<<Main';
   ARGLAB_REOP	= 'Main<<Reop';
   ARGLAB_RESU	= 'Main<<CPen';
   ARGLAB_REVO	= 'Main<<Voct';
   ARGLAB_RGRC	= 'Rec << Reg';

(* Argument tags *)

   ARGTAG_COCJ	= 'Cocj';
   ARGTAG_NMCL	= 'VblC';
   ARGTAG_NPD1	= 'NPd1';
   ARGTAG_NPD2	= 'NPd2';
   ARGTAG_NU	= 'numV';
   ARGTAG_PNG	= 'pngV';
   ARGTAG_PREV	= 'preV';
   ARGTAG_PRPS	= 'Pron';
   ARGTAG_PS	= 'perV';
   ARGTAG_QUES	= 'Ques';
   ARGTAG_QUOT	= 'Quot';
   ARGTAG_SFX	= 'Sfx ';
   ARGTAG_SOCJ	= 'Socj';
   ARGTAG_SUBJ	= 'Subj';
   ARGTAG_ZERO	= 'Zero';

    LexLength	=	 5;
    LexemeLen	=	10;
    DaughterCode=       15;
    MotherNum   =       16;
    Linecode	=	MAX_PATMS_CATM + 1;
    TxtLength	=      500;
    LineLength  =      250;
    PARGRLENGTH =       10;
    PARSELISTSIZE =	80;
    TAG_SIZE	=        4;
    TEXTTYPE_SIZE =     10;
    N_PNG =		 3;
    N_PRPS_COLUMNS	= 2;
    N_SFX_COLUMNS	= 7;
    CL_MAX_SECTIONS	= round(sqrt(PARSELISTSIZE));

    CAR_ROOT	=	 -1;
    CAR_UNKNOWN	=	221;
    CCR_BASE	= 1000;
    PAR_BASE	= 100;

(* Fields in RelRec *)
   distCCR	= -7;
   ClConstRel	= -6;
   ClauseT	= -5;
   SentenceNr	= -4;
   PhrStop	= -3;
   PhrStart	= -2;
   ClauseNr	= -1;
   AutoMam	=  0;
   RelMode	=  1;
   RelLine	=  2;	(* original mother *)
   TabNum	=  3;	(* original tab *)
   UserMam	=  4;	(* new mother *)
   UserTab	=  5;	(* new tab *)
   MaxTabs	= 35;
   MaxCodes	= 61;	(* last entry and number of CAR *)

   ClauseT2	= MaxTabs + 1;
   ClCodes	= ClauseT2 + 1;
   TABS_MAX	= MaxTabs - UserTab;	(* maximum number of tabs *)

    Vpred	=	 1;
    Npred	=	 2;
    Subject	=	 3;
    Subj2	=	 4;
    Subjsfx	=	 5;
    Obj		=	 6;
    Obj2	=	 7;
    Objsfx	=	 8;
    Compl	=	 9;
    Cmpsfx	=	10;
    Other	=	11;
    INVENT	=	16;
    HIT		=	25;
    PARstart    =       26;
    PARNUM	=	26;
    LOWTAB      =       27;
    ARGLIST_MAX	= 2013;		(* MAX_CTYPES^2 + 3*#ARGTAG + #ARGLAB *)
    ARGON_MAX	= 20;		(* ~ sqrt(ArgumentsList)/2 *)
    CANDLIST_MAX	= 2 * (TABS_MAX - 1);
    CJVBLIST_MAX	= 16;
    LEXLIST_MAX	= 5;		(* max relevant lexemes in a phrase *)
    SHRT_MAX		= 32767;	(* max value of a "short int" *)
    SHRT_MIN		= -32768;	(* min value of a "short int" *)
    SUBPAR_MAX	= 10;

(* Sections in CodesList *)
   CL_PRED	= 1;	(* Verbal tense of the predicate *)
   CL_NMVB	= 2;	(* Preposition class of nominal verb form *)
   CL_CONJ	= 3;	(* Conjunction class of clause opening *)
   CL_PREP	= 4;	(* Preposition class of clause opening *)

(* Clause atom types *)
   CT_Defc = 0;
   CT_Unkn = 99;
   CT_Null = 100;
   CT_WayX = 167;
   CT_WXQt = 172;
   CT_NmCl = 200;
   CT_AjCl = 213;
   CT_Voct = 301;
   CT_CPen = 302;
   CT_Ellp = 303;
   CT_MSyn = 304;
   CT_Reop = 305;
   CT_XPos = 306;

(* Clause atom relation codes *)
   CARC_None =   0;
   CARC_Rela =  10;
   CARC_Prep =  50;
   CARC_Asyn = 100;
   CARC_CjAd = 300;
   CARC_Coor = 400;
   CARC_Post = 500;
   CARC_Caus = 900;
   CARC_Quot = 999;

(* Constituent Codes *)
   Adju = 505;
   Appo = 500;
   Cmpl = 504;
   Conj = 509;
   EPPr = 541;
   ExsS = 552;
   Exst = 550;
   FrnA = 576;
   FrnC = 575;
   FrnO = 574;
   FrnS = 573;
   Frnt = 572;
   Intj = 512;
   IntS = 522;
   IrpC = 594;
   IrpO = 593;
   IrpP = 591;
   IrpS = 592;
   Link = 567;
   Loca = 507;
   Modi = 508;
   ModS = 528;
   NCop = 540;
   NCoS = 542;
   Nega = 510;
   Objc = 503;
   Para = 566;
   PrAd = 525;
   PrcS = 523;
   PreC = 521;
   Pred = 501;
   PreO = 531;
   PreS = 532;
   PtcO = 534;
   PtSp = 533;
   Ques = 511;
   Rela = 519;
   Sfxs = 535;
   Spec = 582;
   Subj = 502;
   Supp = 515;
   Time = 506;
   Unkn = 599;
   Voct = 562;

(* Clause Constituent Relation Codes *)
   CCR_None = 0;
   CCR_RgRc = -SP_SUBS;
   CCR_Spec = -SP_PREP;
   CCR_Coor = -SP_CONJ;
   CCR_Attr = -SP_ADJV;
   CCR_Resu = Frnt;
   CCR_ReVo = Voct;

type
    Byte = 0..255;
    ConstituentType = Appo..Unkn;
    ShortInt = SHRT_MIN..SHRT_MAX;
    CharSet = set of char;
    ConstituentSet = set of ConstituentType;
    SmallSet = set of Byte;
    SubType = array [1..2] of char;
    rrps       =   array [0 .. MAX_WORDS, -1 .. 20 ]         of integer;
    lexeme     =   packed array [1 .. LexLength ]     of char;  {5}
    phrlex     =   packed array [1 .. LexemeLen ]     of char;  {10}
    subarr     =   array [1 .. TxtLength]	      of SubType;
    lexemerec  =   array [1 .. MAX_WORDS ]                   of lexeme;
    instrufig  =   array [1 .. SUBPAR_MAX] of integer;
    LexListType = record
       list: array [1 .. LEXLIST_MAX] of lexeme;
       size: integer
    end;
    lexrec     =   array [1 .. TxtLength, PR_NP1 .. PR_NP6] of LexListType;
    phraserec  =   array [1 .. TxtLength,  0 .. PR_LABEL]      of lexeme;
    QuotActrec =   array [1 .. 100, 1 .. 2  ] of integer;
    clausetyperec= array [1 .. PARSELISTSIZE] of lexeme;
    codesvalrec=   array [1 .. PARSELISTSIZE] of integer;
    clausecomprec= array [1 .. MAX_CTYPES + 1, 1 .. MAX_CTYPES + 1] of integer;
    Clauserec  =   array [1 .. TxtLength,  1 .. Linecode, 1..13 ]  of integer; {-5 .. 999}
    RelRec     =   array [1 .. TxtLength,  distCCR .. MaxCodes] of ShortInt; {-1 .. TxtLength}
    texttype   =   packed array [1 .. TxtLength, 1 .. TEXTTYPE_SIZE] of char;
    PredType   = (verbless, nompred, quotverb);
    Cltype     =   array [1 .. TxtLength, PredType] of boolean;
    Actorstype =   array [1 .. TxtLength, Vpred .. LOWTAB] of -1 .. 500;
    ActLextype =   array [0 .. TxtLength, Vpred .. 25] of phrlex;
    Patterntype =  array [1 .. TxtLength, INVENT .. PARstart] of -1 .. 500;
    PatLextype =   array [1 .. TxtLength, INVENT .. PARstart] of phrlex;
    PargrType = packed array [1..PARGRLENGTH] of char;
    PargrRec = array [1..TxtLength] of PargrType;
    VerseLabelListType = array [1..TxtLength] of LabelType;
    ArgType = record
      lab: phrlex;	(* argument label *)
      val: real;	(* weight of the argument *)
      dis: real;	(* mean distance *)
      par: real;	(* contribution to parallelism *)
      quo: real;	(* contribution to quotation *)
      frq: integer	(* frequency of the argument *)
    end;
    ArgListType = record
       list: array [1..ARGLIST_MAX] of ArgType;
       size: integer
    end;
    (* An Argon is an argumentation in the form of a series of
       arguments, represented as an array of their indices in
       the argument list *)
    ArgonType = record
       alix: array [1..ARGON_MAX] of integer;
       c_val, c_dis, c_par, c_quo: real;	(* cumulative values *)
       size: integer
    end;
    CandType = record
      mam: integer;	(* mother atom *)
      arg: ArgonType;	(* argumentation *)
      sub: SubType;	(* daughter's subtype *)
      typ: integer;	(* daughter's clause type *)
      score: real;	(* final score of the candidate *)
      paral, quote: boolean
    end;
    CandListType = record
       list: array [1..CANDLIST_MAX] of CandType;
       size: integer
    end;
    ColMatcher = ^function(var s1, s2: lexeme): boolean;
    CAtomTester = ^function(c: integer): boolean;
    (* A column specification is a zero-terminated array of column
       indices used to iterate over a group of columns *)
    ColSpecType = array [1..9] of integer;
    PosLabListType = array [PR_COOR..PR_LABEL] of lexeme;
    (* A conjunction verb list is an array of
       (lexeme, group number) pairs *)
    CjVbListType = record
       verb: array [1..CJVBLIST_MAX] of
	 record
	    lex: lexeme;
	    grp: integer
	 end;
       size: integer
    end;
    TagType = array [1..TAG_SIZE] of char;
   CommandType =
      record
	 num: integer;
	 cmd: char;
	 ccr: boolean;
	 sub: SubType
      end;

var
    ps4,
    ct4,
    tp4,
    act,
    constit,
    vblcl,
    cl4,
    CTT,
    CTTrev,
    ArgListFile,
    ArgReport,
    CodesLst,
    NamesLst,
    ustabs,
    hierarch,
    rep,
    clfreq,
    clfreqtot,
    clsort,
    cnsort,
    ctsort,
    cl4sort,
    px,
    Qa,
    Vll,
    ClLst,
    synnr    :   text;
    typecand :   char;
    rest     :   varying [10] of char;
    ko       :   rrps;
    ty,
    aantalw,
    PHRat, PHR,
    cols,
    linedistance,
    MAXClTypes,
    MAXArguTypes,
    MAXQuotAct,
    MAXCjLex,
    LongestLine,
    SOFAR,
    DisAgree,
    ClauseNb,
    prevClauseNb,
    SentenceNb,
    LastSentenceNb,
    DownMother,
    distPHR: integer;
    StopLine: integer;		(* number of clause atoms done *)
    NumberOfLines: integer;	(* total number of clause atoms *)
    CLN, Phr1, Phrl, Clty, CCRty, CCRdis, SnNr,  {ReadUserT}
    MAXLines	      :   integer;
    CL_LastEntry: array[1..CL_MAX_SECTIONS] of integer;

    linelex  :  lexemerec;
    CLT      :  Cltype;
    Actors   :  Actorstype;
    ActLex   :  ActLextype;
    APattern :  Patterntype;
    APatlex  :  PatLextype;
    PNGlex   :  phrlex;
    CodLST,
    clauseTR :  clausetyperec;
    clauseTV :  codesvalrec;
    clauseCM,
    clausesTOT:  clausecomprec;
    CodVal   :   codesvalrec;
    clauselex:  lexrec;                  { to list the lexemes in VP, NP and PP of all clauses}
    phrases  :  phraserec;               { to list phrase order of all clauses }
    Clauses  :  Clauserec;
    Relations:  RelRec;                  {array: line l, dep of par to line l-x  }
    candidates:  CandListType;           {array: linenumbers candidates connections }
    ArgList  :   ArgListType;
    QuotAct  :   QuotActrec;
    subtypes :  subarr;
    partxt: PargrRec;
    txt      :  texttype;
    txtTAB   :  instrufig;
    preplex,
    lex      :  lexeme;
    vvers,
    versnr   :  varying [11] of char;

    PSP,
    PS5,
    order ,
    preverbEL,
    constitorder,
    NOustabs,
    CorrectAct,
    Editor,
    ExistRefInfo,
    Interactive,
    LabelConnection: boolean;

   CjVbList: CjVbListType;
   PNG_Letters: packed array [KO_PS..KO_GN, 1..N_PNG] of char;
   PericopeName: StringType;
   PosLabList: PosLabListType;
   TextName: StringType;
   VerseLabelList: VerseLabelListType;

(* Constituent Sets. These are really constants, but the Sun Compiler
   does not handle a set constant passed as an argument correctly
   (neither as an identifier nor as a define). *)

   CmplSet: ConstituentSet := [Cmpl];
   CopuSet: ConstituentSet := [Exst, ExsS, NCop, NCoS];
   FrntSet: ConstituentSet := [Frnt];
   ObjcSet: ConstituentSet := [Objc, PreO, PtcO];
   PreCSet: ConstituentSet := [PrcS, PreC, PtcO];
   PredSet: ConstituentSet := [Pred, PreO, PreS];
   SubSSet: ConstituentSet := [ExsS, IntS, ModS, NCoS, PrcS, PreS];
   SubjSet: ConstituentSet := [Subj];

   (* The set of all parsings that do not represent an independent
      constituent and therefore require a phrase atom relation. *)
   DeptSet: ConstituentSet := [Appo, Para, Link, Sfxs, Spec];

   CCR_Set: ConstituentSet := [Adju, Cmpl, Objc, PrAd, PreC, Subj];

   Unit: packed array [1 .. 4] of char := ['W', 'P', 'C', 'S'];

   NM_Columns: ColSpecType :=
      [PR_PRDE1, PR_PRPS1,
       PR_NP1, PR_NP2, PR_NP3, PR_NP4, PR_NP5, PR_NP6, 0];

   NP_Columns: ColSpecType :=
      [PR_NP1, PR_NP2, PR_NP3, PR_NP4, PR_NP5, PR_NP6, 0];

   PNG_Columns: ColSpecType := [PR_PNG, 0];

   PRPS_Columns: ColSpecType := [PR_PRPS1, PR_PRPS2, 0];

   SFX_Columns: ColSpecType :=
      [PR_NP1_SFX, PR_NP2_SFX, PR_NP3_SFX, PR_PRED_SFX,
       PR_NP4_SFX, PR_NP5_SFX, PR_NP6_SFX, 0];

   VT_Columns: ColSpecType := [PR_VT, 0];

   (* Set of phrase positions associated with a single participant in
      the clause opening *)
   SingleSet: SmallSet := [PR_NEGA, PR_NP1, PR_NP1_SFX];

   (* Set of phrase positions associated with subordination *)
   SubordinationSet: SmallSet := [PR_CONJ, PR_PREP];

   (* Set of phrase positions that are ignored when checking for
      parallel clause atoms *)
   ParaSet: SmallSet := [PR_VERB, PR_ADJV, PR_VS];

   (* Set of phrase positions typically found in resumptive clauses
      that have a clause opening *)
   ResuSet: SmallSet :=
      [PR_QUES, PR_TOPIC, PR_NEGA, PR_PRPS1, PR_NP1, PR_NP1_SFX];

   (* Finite verb forms *)
   VT_Finite: SmallSet := [VT_Yqt, VT_Qtl, VT_Imp, VT_Way, VT_Wey];

   (* Values for Lexical Set *)
   LS_NMCP: integer;
   LS_AFAD: integer;
   LS_CJAD: integer;
   LS_FOCP: integer;
   LS_QUES: integer;
   LS_QUOT: integer;


function erf(d0 : double): double; extern;

function SentenceNumber(var r: RelRec; c, s: integer): integer;
   forward;
procedure WriteUserTabs(answer: char);
   forward;


procedure Quit;
begin
   WriteUserTabs('y');
   pcexit(1)
end;


function GetChar:char;
var
   c: char;
begin
   c := chr(0);
   if eof then
      begin
	 writeln;
	 reset(input)
      end
   else
   if eoln then
      readln
   else
      readln(c);
   GetChar := c
end;


function YesNoQuestion(q: StringType): boolean;
var
   c: char;
begin
   repeat
      write(q, ' [y/n]: ');
      c := GetChar
   until c in YES + NO;
   YesNoQuestion := c in YES
end;


function LS_Code(p, s: integer): integer;
(* Code for the combination of part of speech and lexical set *)
begin
   LS_Code := 6 * (p + 1) + s
end;


function Phi(x: real): real;
(* Cumulative Normal Distribution *)
const
   SQRT2 = sqrt(2);
begin
   Phi := (1 + erf(x / SQRT2)) / 2
end;


function Sign(i: integer): integer;
begin
   if i > 0 then
      Sign := 1
   else if i < 0 then
      Sign := -1
   else
      Sign := 0
end;


procedure SubType_Merge(var s1, s2: SubType);
(* Fill the empty instructions in s1 with those from s2 *)
var
   i: integer;
begin
   for i := 1 to 2 do
      if s1[i] = ' ' then
	 s1[i] := s2[i]
end;


function ParMark(c: integer): boolean;
begin
   ParMark := subtypes[c, 2] in ['N', '#', 'q']
end;


procedure DistDecode(c, b: integer; var d: integer; var u: char);
(* Decode c into distance and unit using b as the word unit base *)
var
   i: integer;		(* index in units *)
begin
   if c = 0 then begin
      d := 0;
      u := '.'
   end else begin
      i := 1;
      while c div b = 0 do begin
	 b := b div 10;
	 i := i + 1
      end;
      d := c - Sign(c) * b;
      u := Unit[i]
   end
end;


function DistEncode(d: integer; u: char; b: integer): integer;
(* Encode distance and unit using b as the word unit base *)
var
   i: integer;		(* index in units *)
begin
   i := 1;
   while Unit[i] <> u do begin
      b := b div 10;
      i := i + 1
   end;
   DistEncode := d + Sign(d) * b
end;


function LeftTag(var s: StringType; c: char): TagType;
(* Turn string s into a left-adjusted tag *)
var
   i, j: integer;
   r: TagType;	(* result *)
begin
   i := 1;
   j := 1;
   while i <= TAG_SIZE do begin
      if s[i] <> ' ' then begin
	 r[j] := s[i];
	 j := j + 1
      end;
      i := i + 1
   end;
   while j <= TAG_SIZE do begin
      r[j] := c;
      j := j + 1
   end;
   LeftTag := r
end;


function RightTag(var s: StringType; c: char): TagType;
(* Turn string s into a right-adjusted tag *)
var
   i, j: integer;
   r: TagType;	(* result *)
begin
   i := TAG_SIZE;
   j := TAG_SIZE;
   while i > 0 do begin
      if s[i] <> ' ' then begin
	 r[j] := s[i];
	 j := j - 1
      end;
      i := i - 1
   end;
   while j > 0 do begin
      r[j] := c;
      j := j - 1
   end;
   RightTag := r
end;


procedure Arg_Init(var A: ArgType; var lab: phrlex);
begin
   A.lab := lab;
   A.val := 0;
   A.dis := 0;
   A.par := 0;
   A.quo := 0;
   A.frq := 0
end;


function ArgTest(opt: StringType): boolean;
var
   found: boolean;
   i: integer;
   s: StringType;
begin
   found := false;
   i := 1;
   while not found and (i < argc) do begin
      argv(i, s);
      found := opt = s;
      i := i + 1
   end;
   ArgTest := found
end;


function ArgLab_Number(n: integer; t: StringType): phrlex;
(* Argument label supplemented with number *)
begin
   assert((0 <= n) and (n < 100));
   ArgLab_Number := substr(t, 1, 8) +
      chr(ord('0') + n div 10) +
      chr(ord('0') + n mod 10)
end;


function ArgLab_Pair(d: StringType; m: StringType): phrlex;
(* Argument label of dependent daughter and mother features *)
begin
   ArgLab_Pair := LeftTag(d, ' ') + '<<' + RightTag(m, ' ')
end;


function ArgLab_Para(d: StringType; m: StringType): phrlex;
(* Argument label of parallel daughter and mother features *)
begin
   ArgLab_Para := LeftTag(d, '.') + '//' + RightTag(m, '.')
end;


function CAtom_Quot(c: integer): boolean;
(* Return whether clause atom [c] has a verbal phrase with a quotation
   verb *)
begin
   CAtom_Quot := CLT[c, quotverb]
end;


function CAtom_Cocj(c: integer): boolean;
(* Return whether clause atom [c] has a coordinating conjunction *)
begin
   CAtom_Cocj := phrases[c, PR_COOR] <> L_NULL
end;


function CAtom_Socj(c: integer): boolean;
(* Return whether clause atom [c] has a subordinating conjunction *)
begin
   CAtom_Socj :=
      (phrases[c, PR_CONJ] <> L_NULL) and
      (phrases[c, PR_CONJ] <> L_LSHIFT)
end;


function CAtom_Size(c: integer): integer;
(* Return the number of phrase atoms in c *)
var
   i: integer;
begin
   i := 1;
   while (i < Linecode) and (Clauses[c, i, CR_PTY] <> Linecode) do
      i := i + 1;
   assert(Clauses[c, i, CR_PTY] = Linecode);
   CAtom_Size := i - 1
end;


function CAtom_SubDist(c1, c2: integer): integer;
(* Return the distance between c1 and c2 in units of the underlying
   object type, phrase atoms. *)
var
   r: integer;	(* result *)
begin
   if c1 > c2 then
      CAtom_SubDist := -CAtom_SubDist(c2, c1)
   else begin
      r := 0;
      while (c1 < c2) do begin
	 c1 := c1 + 1;
	 r := r - CAtom_Size(c1)
      end;
      CAtom_SubDist := r
   end
end;


function PAtom_Distance(c1, p1, c2, p2: integer): integer;
(* Return the distance in phrase atoms between c1.p1 and c2.p2 *)
begin
   PAtom_Distance :=
      (p1 - p2) -
      (CAtom_Size(c1) - CAtom_Size(c2)) +
      CAtom_SubDist(c1, c2)
end;


function PAtom_Size(c, p: integer): integer;
(* Return the size of c.p in words *)
begin
   if p = 1 then
      PAtom_Size := Clauses[c, 1, CR_WORDNR]
   else
      PAtom_Size :=
	 Clauses[c, p, CR_WORDNR] - Clauses[c, p - 1, CR_WORDNR]
end;


function PAtom_SubDist(c1, p1, c2, p2: integer): integer;
(* Return the distance between c1.p1 and c2.p2 in units of the
   underlying object type, words. *)
var
   r: integer;	(* result *)
begin
   if not ((c1 < c2) or (c1 = c2) and (p1 < p2)) then
      PAtom_SubDist := -PAtom_SubDist(c2, p2, c1, p1)
   else begin
      r := 0;
      while (c1 < c2) or (p1 < p2) do begin
	 if p1 < CAtom_Size(c1) then
	    p1 := p1 + 1
	 else begin
	    c1 := c1 + 1;
	    p1 := 1
	 end;
	 r := r - PAtom_Size(c1, p1)
      end;
      PAtom_SubDist := r
   end
end;


function Word_Distance(c1, p1, w1, c2, p2, w2: integer): integer;
(* Return the distance between c1.p1.w1 and c2.p2.w2 in words *)
begin
   Word_Distance :=
      (w1 - w2) -
      (PAtom_Size(c1, p1) - PAtom_Size(c2, p2)) +
      PAtom_SubDist(c1, p1, c2, p2)
end;


function CCR_Char2Rela(c: char): integer;
begin
   case c of
      'J': CCR_Char2Rela := Adju;
      'C': CCR_Char2Rela := Cmpl;
      'O': CCR_Char2Rela := Objc;
      'B': CCR_Char2Rela := PrAd;
      'P': CCR_Char2Rela := PreC;
      'S': CCR_Char2Rela := Subj;
      'A': CCR_Char2Rela := CCR_Attr;
      'c': CCR_Char2Rela := CCR_Coor;
      'r': CCR_Char2Rela := CCR_Resu;
      'v': CCR_Char2Rela := CCR_ReVo;
      'R': CCR_Char2Rela := CCR_RgRc;
      's': CCR_Char2Rela := CCR_Spec;
   otherwise
      CCR_Char2Rela := CCR_None
   end
end;


function CCR_Distance(d, m, p, w: integer): integer;
(* Return the CCR distance code for the distance between the boundary
   of the daughter and the mother indicated by the triple (m, p, w) *)
begin
   if w <> 0 then
      CCR_Distance := DistEncode(
	 Word_Distance(m, p, w,
	    d, CAtom_Size(d), PAtom_Size(d, CAtom_Size(d))),
	 'W', CCR_BASE)
   else if p <> 0 then
      CCR_Distance := DistEncode(
	 PAtom_Distance(m, p, d, CAtom_Size(d)),
	 'P', CCR_BASE)
   else
      CCR_Distance := DistEncode(m - d, 'C', CCR_BASE)
end;


function CL_Lookup(l: lexeme; s: integer; var v: integer): boolean;
(* Looks up lexeme l in section s of the codes list and assigns the
   corresponding value to v.
   If l is in this section, true is returned; otherwise v is not
   touched and false is returned. *)
var
   i: integer;				(* current entry *)
   found: boolean;
begin
   found := false;
   if s = 1 then
      i := 1
   else
      i := CL_LastEntry[s - 1] + 1;
   while not found and (i <= CL_LastEntry[s]) do
      if l <> CodLST[i] then
	 i := i + 1
      else begin
	 v := CodVal[i];
	 found := true
      end;
   CL_Lookup := found
end;


procedure CL_Get(l: lexeme; s: integer; var v: integer);
(* Insist on a successful CodesList lookup *)
begin
   if not CL_Lookup(l, s, v) then begin
      message('syn04types: ' , l, ': Not in CodesList');
      Quit
   end;
end;


function ConstituentOrder(d, m: integer; var K: ColSpecType): boolean;
(* Return whether the series of constituents of the daughter in columns
   K is a prefix of that of the mother when ignoring empty entries. *)
var
   i_d, i_m: integer;	(* column counter *)
   r: boolean;		(* result *)
begin
   r := true;
   i_d := 1;
   i_m := 1;
   while r and (K[i_d] <> 0) do begin
      if phrases[d, K[i_d]] <> L_NULL then begin
	 while (K[i_m] <> 0) and (phrases[m, K[i_m]] = L_NULL) do
	    i_m := i_m + 1;
	 if K[i_m] = 0 then
	    r := false
	 else begin
	    r := phrases[d, K[i_d]] = phrases[m, K[i_m]];
	    i_m := i_m + 1
	 end
      end;
      i_d := i_d + 1
   end;
   ConstituentOrder := r
end;


function Lex_Cocj(l: lexeme): boolean;
(* Return whether we have a coordinating conjunction *)
var
   class: integer;
begin
   Lex_Cocj := CL_Lookup(l, CL_CONJ, class) and (class = CARC_Coor)
end;


function ConjunctiveAdvP(c, i: integer): boolean;
(* Return whether phrase [i] in clause atom [c] is effectively a
   conjunctive adverbial phrase. The case of <L KN demonstrates that
   also a prepositional phrase headed by a 'causal' preposition and
   ended by a anaphoric adverb can play this role. Conjunctive
   adverbial phrases can typically not be preceded by a coordinating
   conjunction. The five (remarkable) exceptions with LKN do not seem
   to disprove this. *)
var
   class: integer;
begin
   ConjunctiveAdvP :=
      (Clauses[c, i, CR_REC] = PR_ADVB) and
      (Clauses[c, i, CR_LEXSET] = LS_CJAD)
      or
      (Clauses[c, i, CR_REC] = PR_NP1) and
      (Clauses[c, i, CR_LEXSET] = LS_AFAD) and
      CL_Lookup(phrases[c, PR_NP1], CL_PREP, class) and
      (class = CARC_Caus);
   null
end;


function ConstituentClause(c: integer): boolean;
(* A clause is a constituent clause if it has a CCR corresponding to a
   parsing label *)
begin
   ConstituentClause := ParseLabel2(Relations[c, ClConstRel]) <> ''
end;


function ConstituentIndex(a, k: integer; s: ConstituentSet): integer;
(* Returns the index of the first constituent from s found in
   Clauses[a,,k], or 0 if a does not contain such a constituent. *)
var
   d: integer;	(* number of dependent phrases to skip *)
   i: integer;
   found: boolean;
begin
   found := false;
   i := 1;
   d := 0;
   while not found and (i <= Linecode) do
      if Clauses[a, i, k] in s then
	 found := true
      else begin
	 d := d + ord(Clauses[a, i, k] in DeptSet);
	 i := i + 1
      end;
   if not found then
      ConstituentIndex := 0
   else
      ConstituentIndex := i - d
end;


function ExplicitSubject(c: integer): boolean;
(* Return whether clause atom c contains an explicit subject *)
begin
   ExplicitSubject := ConstituentIndex(c, CR_FUN, [Subj]) <> 0
end;


function FocusParticle(w: integer): boolean;
(* Return whether we have a focus particle *)
begin
   FocusParticle :=
      (LS_Code(ko[w, KO_SP], ko[w, KO_LS]) = LS_FOCP) or
      (ko[w, KO_PDP] = SP_ADVB) and
      (LS_Code(ko[w, KO_SP], ko[w, KO_LS]) = LS_NMCP)
      (* The latter covers the use of >PS/ as a focus particle *)
end;


function InterrogativeParticle(w: integer): boolean;
(* Return whether we have a interrogative particle, which is special
   among the interrogatives, because it focuses and does not carry a
   meaning of its own *)
begin
   InterrogativeParticle :=
      LS_Code(ko[w, KO_SP], ko[w, KO_LS]) = LS_QUES
end;


function Person(c, p: integer): boolean;
(* Return whether clause atom [c] contains a reference to person p in
   one of its phrase atoms *)
var
   i: integer;
   r: boolean;
begin
   r := false;
   i := 0;
   repeat
      i := i + 1;
      r :=
	 (Clauses[c, i, CR_PHRPNG] div 100 = p) or
	 (Clauses[c, i, CR_SFXPNG] div 100 = p)
   until r or (Clauses[c, i, CR_FUN] = 0);
   Person := r
end;


function PersonToPerson(c: integer; p1, p2: integer): boolean;
(* Return whether clause atom [c] contains both a person p1 as
   predicate and a reference to person p2 in one of its other
   phrase atoms *)
var
   i: integer;
   r1, r2: boolean;
begin
   r1 := false;
   r2 := false;
   i := 0;
   repeat
      i := i + 1;
      if Clauses[c, i, CR_FUN] in SubjSet + PredSet then 
	 r1 := r1 or (Clauses[c, i, CR_PHRPNG] div 100 = p1)
      else
	 r2 := r2 or (Clauses[c, i, CR_PHRPNG] div 100 = p2);
      if Clauses[c, i, CR_FUN] in SubSSet then 
	 r1 := r1 or (Clauses[c, i, CR_SFXPNG] div 100 = p1)
      else
	 r2 := r2 or (Clauses[c, i, CR_SFXPNG] div 100 = p2)
   until r1 and r2 or (Clauses[c, i, CR_FUN] = 0);
   PersonToPerson := r1 and r2
end;


function PosCount(c: integer; var K: ColSpecType): integer;
(* Return how many of the columns in K are occupied phrase positions *)
var
   i: integer;
   r: integer;	(* result *)
begin
   r := 0;
   i := 1;
   while K[i] <> 0 do begin
      if phrases[c, K[i]] <> L_NULL then
	 r := r + 1;
      i := i + 1
   end;
   PosCount := r
end;


function State(w: integer): integer;
(* Return the state of word w *)
begin
   if (ko[w, KO_ST] = ST_C) and (ko[w, KO_PRS] > 0) then
      State := ST_A
   else
      State := ko[w, KO_ST]
end;


function PAtom_PosIndex(c, p: integer): integer;
(* Return the index of the first phrase atom in clause atom c that has
   phrase position p *)
var
   i: integer;
begin
   i := 0;
   repeat
      i := i + 1;
   until (Clauses[c, i, CR_REC] = p) or (Clauses[c, i, CR_FUN] = 0);
   if Clauses[c, i, CR_REC] = 0 then
      PAtom_PosIndex := 0
   else
      PAtom_PosIndex := i
end;


function DaughterCount(a: integer): integer;
(* Return the the number of clause atoms that have [a] as mother *)
var
   i: integer;
   r: integer;	(* result *)
begin
   r := 0;
   for i := 1 to StopLine do
      if Relations[i, UserMam] = a then
	 r := r + 1;
   DaughterCount := r
end;


function Parsing(c, p: integer): integer;
(* Return the parsing assigned to phrase position p *)
var
   i: integer;
begin
   i := PAtom_PosIndex(c, p);
   if i = 0 then
      Parsing := Unkn
   else
      Parsing := Clauses[c, i, CR_FUN]
end;


function CAtom_Ques(c: integer): boolean;
(* Return whether clause atom c has one of the interrogative phrase
   positions occupied *)
begin
   CAtom_Ques :=
      (phrases[c, PR_QUES] <> L_NULL) or
      (phrases[c, PR_INRG] <> L_NULL)
end;


function RelaClause(c: integer): boolean;
begin
   RelaClause := Parsing(c, PR_CONJ) = Rela
end;


function Subordinated(d, m: integer): boolean;
(* A daughter clause is subordinated if it has a downward connection or
   a clause constituent relation other than CCR_Coor *)
begin
   Subordinated := (d < m) or
      (Relations[d, ClConstRel] <> CCR_None) and
      (Relations[d, ClConstRel] <> CCR_Coor);
end;


function String_Set(var s: StringType; c: char): StringType;
var
   l: integer;
begin
   l := length(s);
   if l > 0 then
      s[l] := c
   else
      s := s + c;
   String_Set := s
end;


function String_Pop(var s: StringType): StringType;
var
   l: integer;
begin
   l := length(s);
   assert(l > 0);
   if l = 1 then
      String_Pop := TTY_UNKNOWN
   else
      String_Pop := substr(s, 1, l - 1)
end;


procedure askfiles;                         { name of Ps file }

var     filenr: integer;
	ch: char;
	error: integer;

begin
error := 0;
{ Dummy statement to fool the compiler, so it doesn't complain about
variable error being used before set. }
open(synnr, 'synnr', 'old', error);
if error <> 0 then begin
writeln(' Too eager, huh? Run capnr and subsequent programs first');
pcexit(1);
end;
reset(synnr);
read(synnr, filenr, ch, PericopeName);
if filenr =  4 then filenr := 5;
case filenr of
0:
begin
writeln(' Input ready for syn01 only. Please run syn01 first.');
pcexit(1) end;
1: begin
writeln(' Input ready for syn02 only. Please run syn02/3/4 first.');
pcexit(1) end;
2: begin
writeln(' Input ready for syn03 only. Please run syn03/4 first.');
pcexit(1) end;
3: begin
writeln(' Input ready for syn04 only. Please run syn04 first.');
pcexit(1) end;
4,5: begin
           PS5 := false;
           PSP := true;
           writeln(' ... reading: ', PericopeName, '.ps4.p  .');
           open(ps4, PericopeName + '.ps4.p', 'old', error);
           if error <> 0 then
           begin
              writeln(' ', PericopeName, '.ps4.p-file is missing. I try file .ps4.');
              writeln(' ... reading: ', PericopeName, '.ps4.');
	      PSP := false;                                           { no constit. parsing }
              open(ps4, PericopeName + '.ps4', 'old', error);
              if error <> 0 then
	      begin
                 writeln(' ', PericopeName, '.ps4 file missing. Please run syn04 first.');
                 writeln(' according to "synnr" we have file ps',filenr:1);
                 pcexit(1);
              end;
           end;
      end;

   otherwise null
end;
reset(ps4);

open(tp4, PericopeName + '.typ.asc', 'new');
writeln(' ... writing: ', PericopeName, '.typ.asc ');
writeln(' ... also reading: ', PericopeName, '.lay.asc');
rewrite(tp4);
open(act, PericopeName + '.Actors', 'new');
writeln(' ... writing: ', PericopeName, '.Actors  ');
rewrite(act);
open(constit, PericopeName + '.constit', 'unknown');
rewrite(constit);
open(ct4, PericopeName + '.ct4.p', 'old', error);
  if error <> 0 then begin
  writeln(' ', PericopeName, '.ct4.p file missing. I will try file ',PericopeName,'.lay.asc');
  open(ct4, PericopeName + '.lay.asc', 'old', error);
  if error <> 0 then begin
  writeln(' ', PericopeName, '.lay.asc file missing. Please run syn04laynew first.');
  pcexit(1) end;
  end;
reset(ct4);
open(px, PericopeName + '.PX', 'unknown');
reset(px);
open(cl4, PericopeName + '.cl4', 'unknown');
rewrite(cl4);
open(vblcl, PericopeName + '.VBLESS', 'unknown');
rewrite(vblcl);
open(rep, PericopeName + '.report', 'unknown' );
rewrite(rep);
open(cl4sort, 'CL4sort', 'old');
rewrite(cl4sort);
open(ctsort, 'CTTsort', 'old');
rewrite(ctsort);
open(cnsort, 'Clauseconnsort', 'old');
rewrite(cnsort);
open(clsort, 'Clausetypesort', 'old');
rewrite(clsort);
open(CTT, PericopeName + '.CTT', 'new');
rewrite(CTT);
open(ArgReport, PericopeName + '.arg', 'new');
rewrite(ArgReport);
open(ClLst, 'ClConnList', 'unknown');
open(ArgListFile, 'ArgumentsList', 'unknown');
open(Vll, 'verbLexList', 'unknown');
open(CodesLst, 'CodesList', 'unknown');
open(NamesLst, 'NamesList', 'unknown');
rewrite(ClLst);
reset(ArgListFile);
reset(CodesLst);
rewrite(NamesLst);
open(clfreq, PericopeName + '.clfreq', 'unknown');
reset(clfreq);
end; { vraagbestand }


function CType2Label(t: integer): lexeme;
(* Return the clause type label belonging to type t *)
var
   found: boolean;
   i: integer;
begin
   if ClauseLabel4(t) <> '' then
      CType2Label := ClauseLabel4(t)
   else begin
      found := false;
      i := 1;
      while not found and (i <= MAXClTypes) do
	 if clauseTV[i] = t then
	    found := true
	 else
	    i := i + 1;
      if not found then
	 CType2Label := L_NULL
      else
	 CType2Label := clauseTR[i]
   end
end;

#define SetClauseLabel(c) \
   phrases[c, PR_CLAB] := \
   CType2Label(ClauseType(c, subtypes[c][1], CR_FUN))


function ClauseHead(c: integer): integer;
(* Returns the clause atom that is the head of the clause to which
   clause atom [c] belongs. *)
var
   m: integer;	(* mother *)
   r: integer;	(* result *)
begin
   m := c;
   repeat
      r := m;
      m := Relations[r, UserMam]
   until (m = CAR_ROOT) or
      (Relations[r, ClauseNr] <> Relations[m, ClauseNr]);
   ClauseHead := r
end;


function ClausePerson12(var r: RelRec; c: integer): boolean;
(* Return whether the clause headed by clause atom [c] contains a
   reference to a first or second person *)
var
   d: integer;		(* daughter clause atom *)
   i: integer;
   found: boolean;
begin
   found := Person(c, 1) or Person(c, 2);
   i := 1;
   while not found and (i <= r[c, MaxCodes]) do begin
      d := c + r[c, ClCodes + 2 * i - 1];
      if r[d, ClauseNr] = r[c, ClauseNr] then
	 found := Person(d, 1) or Person(d, 2);
      i := i + 1
   end;
   ClausePerson12 := found
end;


function NominalVerb(c: integer): boolean;
(* Return whether the predicate of clause atom c is a nominal form of
   the verb *)
begin
   (* This trick selects the nominal verb forms *)
   NominalVerb := phrases[c, PR_VT][2] in ['n', 't']
end;


procedure PargrAppend(var p: PargrType; c: char);
var
   i: integer;
begin
   i := 1;
   while (p[i] <> ' ') and (i < PARGRLENGTH) do
      i := i + 1;
   if p[i] = ' ' then
      p[i] := c
   else
      message('syn04types: ', p, ': Paragraph number overflow')
end;


procedure PargrCheck(var p: PargrType);
(* Force a well formed paragraph label, if necessary *)
var
   i: integer;
begin
   i := 1;
   while (i <= PARGRLENGTH) and (p[i] = ' ') do
      i := i + 1;
   if i <> 1 then begin
      p[1] := '0';
      while i <= PARGRLENGTH do begin
	 p[i] := ' ';
	 i := i + 1
      end
   end
end;


procedure PargrClear(var p: PargrType);
var
   i: integer;
begin
   for i := 1 to PARGRLENGTH do
      p[i] := ' '
end;


procedure PargrCopy(var p1, p2: PargrType);
var
   i: integer;
begin
   for i := 1 to PARGRLENGTH do
      p2[i] := p1[i]
end;


procedure PargrIncrement(var p: PargrType);
(* Increments the last character of p[] *)
var
   i: integer;
begin
   i := 1;
   while (i < PARGRLENGTH) and (p[i + 1] <> ' ') do
      i := i + 1;
   if p[i] = '9' then
      writeln('Paragraph overflow: ', trim(p))
   else
      p[i] := chr(ord(p[i]) + 1)
end;


procedure ReadPargr(var f: text; var p: PargrRec; a: integer);
(* Read the paragraph number of CAtom [a] from a usertab(5) file *)
var
   i: integer;
   o: boolean;	(* overflow detected *)
begin
   o := false;
   i := 0;
   while Digit(f^) do
      if i = PARGRLENGTH then begin
	 o := true;
	 get(f)
      end else begin
	 i := i + 1;
	 read(f, p[a, i])
      end;
   SkipSpace(f);
   if o then
      message('syn04types: clause atom ', a:1,
	 ': Paragraph number overflow')
   else
      while i < PARGRLENGTH do begin
	 i := i + 1;
	 p[a, i] := ' '
      end
end;


procedure WritePargr(var f: text; var p: PargrRec; a: integer);
var
   i: integer;
begin
   for i := 1 to PARGRLENGTH do
      write(f, p[a, i])
end;


procedure WritePargrPart(var f: text; var p: PargrType; n: integer);
(* Writes partially: only the first n characters of p. *)
var
   i: integer;
begin
   assert(n <= PARGRLENGTH);
   for i := 1 to n do
      write(f, p[i])
end;


procedure PhrLexClear(var p: phrlex);
var
   i: integer;
begin
   for i := 1 to LexemeLen do
      p[i] := ' '
end;


procedure LexList_Add(var L: LexListType; var lx: lexeme);
(* Add the lexeme to the list if there is room *)
begin
   with L do begin
      if size < LEXLIST_MAX then begin
	 size := size + 1;
	 list[size] := lx
      end
   end
end;


procedure LexList_Clear(var l: LexListType);
begin
   l.size := 0
end;


function LexList_Matches(var l1, l2: LexListType): integer;
(* Return the number of matching lexemes between l1 and l2 *)
var
   i1, i2: integer;
   r: integer;		(* result *)
begin
   r := 0;
   i1 := 1;
   while i1 <= l1.size do begin
      i2 := 1;
      while i2 <= l2.size do begin
	 if l1.list[i1] = l2.list[i2] then
	    r := r + 1;
	 i2 := i2 + 1
      end;
      i1 := i1 + 1
   end;
   LexList_Matches := r
end;


function OpeningConstituent(c: integer): integer;
(* Return the phrase index of the opening constituent of clause atom
   [c], or zero if there is not one *)
var
   i: integer;	(* phrase index *)
   p: integer;	(* phrase position *)
begin
   i := 1;
   if Clauses[c, i, CR_REC] = PR_COOR then
      i := i + 1;
   p := Clauses[c, i, CR_REC];
   if (0 < p) and (p < PR_VERB) then
      OpeningConstituent := i
   else
      OpeningConstituent := 0
end;


function SimpleOpening(c, s: integer; S: SmallSet): boolean;
(* A simple opening is either empty or contains exclusively phrase
   positions from the small set S. Return whether beyond phrase
   position s, clause atom c has a simple opening conforming to S. *)
var
   i: integer;		(* phrase atom index *)
   p: integer;		(* phrase position *)
   r: boolean;		(* result *)
begin
   r := true;
   p := Clauses[c, 1, CR_REC];
   i := 1;
   while r and (0 < p) and (p < PR_VERB) do
      if (s < p) and not (p in S) then
	 r := false
      else begin
	 i := i + 1;
	 p := Clauses[c, i, CR_REC]
      end;
   SimpleOpening := r
end;


function ResumptiveOpening(c: integer): boolean;
(* Return whether the clause atom opening of c is indicative of a
   clause resuming a casus pendens *)
var
   i: integer;		(* phrase atom index *)
   r: boolean;		(* result *)
begin
   r := true;
   if OpeningConstituent(c) <> 0 then begin
      i := 1;
      while r and (Clauses[c, i, CR_REC] < PR_VERB) do
	 if Clauses[c, i, CR_REC] in ResuSet then
	    i := i + 1
	 else
	    r := false
   end;
   ResumptiveOpening := r
end;

procedure ClearCARC(var r: RelRec; i: integer);
var
   j: integer;
begin
   for j := ClCodes to MaxCodes do
      r[i, j] := 0
end;


procedure RelationsClear(var r: RelRec);
var
   i, j: integer;
begin
   for i := 1 to TxtLength do begin
      r[i, distCCR] := 0;
      r[i, ClConstRel] := CCR_None;
      r[i, ClauseT] := CT_Unkn;
      r[i, SentenceNr] := 1;
      r[i, PhrStop] := -1;
      r[i, PhrStart] := -1;
      r[i, ClauseNr] := i;
      r[i, AutoMam] := -1;
      r[i, RelMode] := -1;
      r[i, RelLine] := CAR_ROOT;
      r[i, TabNum] := -1;
      r[i, UserMam] := CAR_ROOT;
      r[i, UserTab] := -1;
      for j := UserTab + 1 to MaxTabs do
	 r[i, j] := -1;
      r[i, ClauseT2] := -1;
      ClearCARC(r, i)
   end
end;


function Lab_Agreement(var s1, s2: lexeme): boolean;
(* Return whether the two phrase position labels are equal and not
   empty *)
begin
   Lab_Agreement := (s1 <> L_NULL) and (s1 = s2)
end;


function Ps_Agreement(var s1, s2: lexeme): boolean;
(* Return whether the two PNG labels agree in person explicitly *)
begin
   Ps_Agreement := (s1 <> L_NULL) and (s1[1] = s2[1])
end;


function Nu_Agreement(var s1, s2: lexeme): boolean;
(* Return whether the two PNG labels agree in number *)
begin
   Nu_Agreement :=
      (s1 <> L_NULL) and (s1[2] = s2[2]) and (s1[3] = s2[3])
end;


function PNG_Agreement(var s1, s2: lexeme): boolean;
(* Return whether the two PNG labels are in agreement, allowing for
   "3plM" to match "3pl-", "1sg-" to match "-sgM" et cetera. *)
begin
   PNG_Agreement := Nu_Agreement(s1, s2) and
      ((s1[1] = '-') or (s1[1] = s2[1]) or (s2[1] = '-')) and
      ((s1[4] = '-') or (s1[4] = s2[4]) or (s2[4] = '-'))
end;


function PP_Agreement(var s1, s2: lexeme): boolean;
(* Return whether the two NP labels contain the same preposition *)
begin
   PP_Agreement :=
      Lab_Agreement(s1, s2) and (substr(s1, 1, 2) <> 'NP')
end;


procedure TtyClear(var t: texttype; c: integer);
var
   i: integer;
begin
   for i := 1 to 10 do
      t[c, i] := ' '
end;


procedure TtyCopy(var t: texttype; c: integer; s: StringType);
var
   i: integer;
begin
   if length(s) <> 0 then
      for i := 1 to min(length(s), TEXTTYPE_SIZE) do
	 t[c, i] := s[i]
   else begin
      t[c, 1] := TTY_UNKNOWN;
      i := 1
   end;
   while i < TEXTTYPE_SIZE do begin
      i := i + 1;
      t[c, i] := ' '
   end
end;


function TtyDomain(var t: texttype; c: integer): char;
var
   i: integer;
   found: boolean;
   r: char;	(* result *)
begin
   r := TTY_UNKNOWN;
   found := false;
   i := 0;
   while not found and (i < TEXTTYPE_SIZE) do begin
      i := i + 1;
      if t[c, i] = ' ' then
	 found := true
      else
	 r := t[c, i]
   end;
   TtyDomain := r
end;


procedure Print23Line(w: integer);
(* Writes a horizontal line of underscores over two thirds of the
   indicated width on standard output *)
var
   i: integer;
begin
  for i := 1 to 2 * w div 3 do
     write('_');
  writeln;
  writeln
end;


function TestParamCode(mother,lineNr: integer; var code : integer): boolean;
var f, newcode, plus : integer;
    ok,paral : boolean;
begin
    plus := 0;
    newcode := 199;
    paral := true;
    ok := false;
    if mother > 0 then
  begin
    for f := PR_TOPIC  to PR_NP1 do
       begin if not ((phrases[lineNr, f] = L_NULL) and (phrases[mother, f] = L_RSHIFT))
            and not ((phrases[lineNr, f] = L_RSHIFT) and (phrases[mother, f] = L_NULL))
	    then if phrases[lineNr, f] <> phrases[mother, f] then paral := false;
       end;
    for f := PR_ADJV  to PR_VT do
	if phrases[lineNr, f] <> phrases[mother, f] then paral := false;

    if phrases[lineNr, PR_COOR] = L_AND then plus := 2                     {201}
       else
    if paral then begin if phrases[lineNr, PR_CONJ] = phrases[mother, PR_CONJ]
			then plus := 1 else                                {200}
			if (phrases[lineNr, PR_CONJ] = L_AND) and
			   (phrases[mother, PR_CONJ] = L_NULL)
                        then plus := 2 else                                {201}
			if (phrases[lineNr, PR_CONJ] = 'W >C ') and
			   (RelaClause(mother))
                        then plus := 2 else                                {201}
			if (phrases[lineNr, PR_CONJ] = 'W LM ') and
			   (phrases[mother, PR_CONJ] = 'LM<N ')
                        then plus := 2 else                                {201}
			if (phrases[lineNr, PR_CONJ] = 'W KJ ') and
			   (phrases[mother, PR_CONJ] = 'KJ   ')
                        then plus := 2 else                                {201}
			paral := false;
                  end;
    code := newcode + plus;
    if code > 199 then ok := true;
    if (subtypes[lineNr, 2] = '\') then ok := false;
  end;
  TestParamCode := ok;
end;


function CjVbList_Find(var C: CjVbListType;
   var l: lexeme; g: integer): boolean;
(* Returns whether l is a member of group g in the list of conjunction
   verbs *)
var
   i: integer;
   r: boolean;	(* result *)
begin
   r := false;
   i := 1;
   with C do
      while not r and (i <= size) do
	 if (verb[i].lex = l) and (verb[i].grp = g) then
	    r := true
	 else
	    i := i + 1;
   CjVbList_Find := r
end;


procedure CjVbList_Add(var C: CjVbListType; var l: lexeme; g: integer);
(* Add verb l to group g on the conjunction verb list *)
begin
   with C do begin
      if size < CJVBLIST_MAX then
	 size := size + 1
      else begin
	 message('Argumentation: Maximum number of arguments (',
	    CJVBLIST_MAX:1, ') exceeded');
	 Quit
      end;
      verb[size].lex := l;
      verb[size].grp := g
   end
end;


procedure ReadCjVbList(var f: text; var C: CjVbListType);
var
   l: lexeme;
   g: integer;
begin
   reset(f);
   while not eof(f) do begin
      readln(f, l, g);
      CjVbList_Add(C, l, g)
   end
end;


function FindFirstClauseNr(var r: RelRec; n: integer): integer;
var
   i: integer;
   found: boolean;
begin
   found := false;
   i := 0;
   while not found and (i < MAXLines) do begin
      i := i + 1;
      found := r[i, ClauseNr] = n
   end;
   if found then
      FindFirstClauseNr := i
   else
      FindFirstClauseNr := 0
end;


function FindMother(var r: RelRec; n, t: integer): integer;
(* Find the mother of clause atom [n] if its tab is at t *)
var
   i: integer;
   found: boolean;
   mother: integer;
begin
   mother := CAR_ROOT;
   found := false;
   if subtypes[n, 2] = '\' then begin
      i := n + 1;
      while not found and (i <= MAXLines) do
	 if r[i, UserTab] >= t then
	    i := i + 1
	 else begin
	    mother := i;
	    found := true
	 end
   end else begin
      i := n - 1;
      while not found and (i > 0) do
	 if r[i, UserTab] > t then
	    i := i - 1
	 else begin
	    mother := i;
	    found := true
	 end
   end;
   FindMother := mother
end;


procedure printcodes(var f: text; var r: RelRec; c: integer);
(* Write the clause atom relations codes of atom [c] to file f *)
var
   i: integer;		(* array index *)
   n: integer;		(* relation index *)
begin
   i := ClCodes + 1;
   for n := 1 to r[c, MaxCodes] do begin
      write(f, ' ', r[c, i]:3, ' ', r[c, i + 1]:3);
      i := i + 2
   end;
   write(f, ' ', 0:3, ' ', 0:3)
end;


procedure printpx;
var
    i, p, start,
    parsecode, group,
    line, lett	: integer;
    charnum, maxchar : integer;
    linedist, dl     : integer;
    ch		: char;
    x: integer;
begin
  reset(ct4);
  reset(ps4);
  prevClauseNb := 0;
  ClauseNb := 1;
  SentenceNb := 1;
  DownMother := 0;
  charnum := 0; repeat read(ps4,ch); charnum := charnum +1
		until eoln(ps4);
  maxchar := charnum; writeln(' MAXCHAR:',maxchar:4);
  writeln(' usertabs read SOFAR:',SOFAR:5,' lines');
  writeln(' analysis made until:',StopLine:5,' lines');
  if (SOFAR> 0) and (SOFAR < StopLine) then
  begin
    writeln(' output file "usertab" equals input file "usertab" till line',SOFAR:4);
    write  (' file "usertab" expanded from line');
    writeln( (SOFAR+1):4,' till line',StopLine:4);
  end;

  rewrite(px);
  reset(ps4);
  if StopLine > 0 then x := StopLine else x:= MAXLines;
  if SOFAR > 0 then start := SOFAR +1
  else start := 1;
  { EXPER *** for line := start to MAXLines do}
  for line := start to MAXLines do
      for i := UserTab+1 to MaxTabs do Relations[line, i] := 0;
  { EXPER *** for line := start to MAXLines do}
  if SOFAR = 0 then
      begin SentenceNb := 1;  Relations[1, SentenceNr] := 1;
	    Relations[1, ClauseNr] := 1; ClauseNb := 1;
      end else
  SentenceNb := Relations[SOFAR, SentenceNr];   {NEW}

  line := 0; group := 0;
  while (not (eof(ps4))) and (not(eof(ct4)) )  and (line < x ) do
  begin  for p:=1 to 11 do
	 begin read(ps4,ch);write(px,ch); versnr[p] := ch;
	 end; charnum := 11;
	      repeat read(ps4,ch); write(px,ch); charnum := charnum +1
	      until (ch='*') or (charnum = maxchar -9);   { eoln(ps4) - last col }
         if ch <> '*' then for p := 1 to 11 do vvers[p] := versnr[p];
         if ch ='*' then
	 begin
	  {if existdata: distPHR:= CCRdis;}
	  distPHR := 0; linedist := 0;
          line := line +1; lett := 0; group := 0;
          write(px,'  0'); for p := 1 to 10 do write(hierarch,vvers[p]);
          write(hierarch,'  0 ');
	  printcodes(px, Relations, line);
	  printcodes(hierarch, Relations, line);
          write(px, '  ', subtypes[line, 1], subtypes[line, 2]);
          write(hierarch, '  ', subtypes[line, 1], subtypes[line, 2]);
	  write(px,(Relations[line, UserTab]):3);
	  write(hierarch,(Relations[line, UserTab]):3);
          write(px,' LineNr', line:7,' ClauseNr', (Relations[line, ClauseNr]):5);
          write(hierarch,' LineNr', line:6,' ClauseNr', (Relations[line, ClauseNr]):4);
	  write(px,':',(Relations[line, PhrStart]): 4);
	  write(hierarch,':',(Relations[line, PhrStart]): 3);
	  write(px,':',(Relations[line, PhrStop]): 4);
	  write(hierarch,':',(Relations[line, PhrStop]): 3);
	  write(px,':',(Relations[line, ClauseT] ): 4);
	  write(hierarch,':',(Relations[line, ClauseT] ): 4);
            if Relations[line, ClConstRel] = Unkn then
	       begin
		 Relations[line, ClConstRel] := CCR_None;
		 Relations[line, distCCR] := 0;     { as in PX file}
		 distPHR := 0;
	       end;
	  write(px,':',(Relations[line, ClConstRel] ): 4);
	  write(hierarch,':',(Relations[line, ClConstRel] ): 3);

	  if Relations[line, ClConstRel] <> CCR_None then
	    begin distPHR := -1;
	      if (Relations[line, distCCR] < -1) or
		 (Relations[line, distCCR] > 0)  {from usertab}
	      then begin
		     distPHR := Relations[line, distCCR];
		     {
		     writeln(' line:',line:4, ' distPHR from ustabs');
	             writeln(' Relations[line, UserMam]', (Relations[line, UserMam]):4);
		     writeln(' distance =', (line-Relations[line, UserMam]):4, ' lines');
		     writeln(' distPHR =',distPHR:5);
		     }
		   end
	      else if Relations[line, distCCR] = -1 then
	      begin
	      if Relations[line, ClConstRel] = CCR_Attr
	      then
	       begin distPHR := (Relations[line, PhrStop]-Relations[line, PhrStart]+1);
		     linedist := Relations[line, UserMam] -line;
		      writeln(' ATTRIB; LINEDIST:',linedist:4,' line:',line:4, ' distPHR:',distPHR:4);

		     if linedist < 0 {-1} then
			begin
			writeln(' ATTRIB CL at dist < -1:',line:4);
			  dl := line; distPHR := 1;
			  repeat
			    dl := dl -1;
			    distPHR := distPHR +(Relations[dl, PhrStop]-Relations[dl, PhrStart]+1)
			  until (dl = (line + linedist)) or (dl < 1);
	                  distPHR := -(distPHR + PAR_BASE);
			end;
	       end else
	       begin
		     writeln(' distance =', (Relations[line, UserMam]-line):4, ' lines');
	             linedist := Relations[line, UserMam] -line;
		      if linedist < 0 then distPHR := linedist-10;
		      if linedist > 0 then distPHR := linedist+10;
	       end;
	       Relations[line, distCCR] := distPHR;
    	      end;
	      if Relations[line, distCCR] = -1 then
	      begin
		 write(' line:', line:5,':');
		 writeln(' Relations[line, distCCR] should be <> -1 !!');
		 readln;
	      end;
	    end;
	       {write(px, distPHR:5); }
	       if (distPHR < -10) and (distPHR > -PAR_BASE)
		  then write(px, distPHR:4) else
	       if (distPHR < -PAR_BASE) and (distPHR > -CCR_BASE)
		  then write(px, distPHR:5) else
	       if (distPHR < -CCR_BASE) then write(px, distPHR:6)
					     else write(px, distPHR:4);
	       write(hierarch, distPHR:5);
	       Relations[line, distCCR] := distPHR;

	  write(px,' SentenceNr', (Relations[line, SentenceNr]):6);
	  write(hierarch,' SentenceNr', (Relations[line, SentenceNr]):4);
	  write(px,' TxtType: ');
	  write(hierarch,' TxtType: ');
	  for lett := 1 to 7 do write(px, txt[line,lett]);
	  for lett := 1 to 7 do write(hierarch, txt[line,lett]);
	  write(px,' Pargr: ');
	  WritePargr(px, partxt, line);
	  write(hierarch,' Pargr: ');
	  WritePargr(hierarch, partxt, line);
	  write(px,' ClType:',phrases[line, PR_CLAB]);
	  write(hierarch,' ClType:',phrases[line, PR_CLAB]);
	  writeln(hierarch);
         end
	 else
	 begin
	   read(ps4, parsecode);
	   write(px, parsecode:3);
	   if parsecode > 499 then
	      write (px, 0:6)
	   else
	      write (px, -1:6)
	 end;
	 readln(ps4); writeln(px);
  end;
  close(px);
end; {of printpx}


function ParseCommandLine(var C: CommandType): boolean;
var
   c: char;		(* current cmd character *)
   ok: boolean;
begin
   ok := true;
   with C do begin
      num := -1;
      cmd := ' ';
      ccr := false;
      sub := '  ';
      while not eoln do
	 if Digit(input^) then begin
	    num := 0;
	    repeat
	       num := 10 * num  +  ord(input^) - ord('0');
	       get(input)
	    until not Digit(input^);
	    ok := ok and (num <= NumberOfLines)
	 end else begin
	    read(c);
	    case c of
	       '+', '-', '=', '^', '/', 'B', 'S', 'T', 'U':
		  cmd := c;
	       'c', 'd', 'l', 'L', 'm', 'r', 'v', 'x':
		  sub[1] := c;
	       '#', 'N', 'e', 'q', 'p':
		  sub[2] := c;
	       'R':
		  ccr := true;
	       '.':
		  sub := '..';
	       '\':
		  begin
		     sub[2] := c;
		     ccr := true
		  end;
	       otherwise
		  ok := false
	    end
	 end;
      readln;
      ParseCommandLine := ok
   end
end;


function TestCommand(d: integer; var C: CommandType): boolean;
(* Copy the command issued for daughter [d] to variable C and return
   whether it is correct. *)
var
   n: integer;		(* default number *)
begin
   with C do begin
      n := num;
      if not ParseCommandLine(C) then
	 TestCommand := false
      else begin
	 case cmd of
	    '+', '-', '=':
	       num := d - 1;
	    'e', 'q', 'p':
	       if num = -1 then
		  num := d - 1;
	    '\':
	       if num = -1 then
		  num := d + 1;
	    otherwise
	       if num = -1 then
	          num := n
	 end;
	 assert((0 <= num) and (num <= NumberOfLines));
	 TestCommand := (num <> d) or (cmd in ['B', 'T']);
      end
   end
end;


procedure PhrPos_Labels(var l: PosLabListType);
begin
   l[PR_COOR]     := L_PR_COOR;
   l[PR_QUES]     := L_PR_QUES;
   l[PR_FOCP]     := L_PR_FOCP;
   l[PR_CONJ]     := L_PR_CONJ;
   l[PR_PREP]     := L_PR_PREP;
   l[PR_TOPIC]    := L_PR_TOPIC;
   l[PR_INRG]     := L_PR_INRG;
   l[PR_NEGA]     := L_PR_NEGA;
   l[PR_ADVB]     := L_PR_ADVB;
   l[PR_INTJ]     := L_PR_INTJ;
   l[PR_PRDE1]    := L_PR_PRDE1;
   l[PR_PRPS1]    := L_PR_PRPS1;
   l[PR_NP1]      := L_PR_NP1;
   l[PR_NP1_SFX]  := L_PR_NP1_SFX;
   l[PR_NP2]      := L_PR_NP2;
   l[PR_NP2_SFX]  := L_PR_NP2_SFX;
   l[PR_NP3]      := L_PR_NP3;
   l[PR_NP3_SFX]  := L_PR_NP3_SFX;
   l[PR_VERB]     := L_PR_VERB;
   l[PR_ADJV]     := L_PR_ADJV;
   l[PR_VT]       := L_PR_VT;
   l[PR_VS]       := L_PR_VS;
   l[PR_PNG]      := L_PR_PNG;
   l[PR_PRED_SFX] := L_PR_PRED_SFX;
   l[PR_MODI]     := L_PR_MODI;
   l[PR_PRDE2]    := L_PR_PRDE2;
   l[PR_PRPS2]    := L_PR_PRPS2;
   l[PR_NP4]      := L_PR_NP4;
   l[PR_NP4_SFX]  := L_PR_NP4_SFX;
   l[PR_NP5]      := L_PR_NP5;
   l[PR_NP5_SFX]  := L_PR_NP5_SFX;
   l[PR_NP6]      := L_PR_NP6;
   l[PR_NP6_SFX]  := L_PR_NP6_SFX;
   l[PR_CLAB]     := L_PR_CLAB;
   l[PR_LABEL]    := L_PR_LABEL
end;


function VS_Label(w: integer): lexeme;
(* See Section 2.19 of Description of Quest II Data File Format *)
begin
   case ko[w, KO_VBS] of
      0:
	 VS_Label := L_Qal;
      1:
	 VS_Label := L_Piel;
      2:
	 VS_Label := L_Hifil;
      3:
	 VS_Label := L_Nifal;
      4:
	 VS_Label := L_Pual;
      5:
	 VS_Label := L_Hafel;
      6:
	 VS_Label := L_Hitpael;
      7:
	 VS_Label := L_Hitpeel;
      8:
	 VS_Label := L_Hofal;
      9:
	 VS_Label := L_PassiveQal;
      10:
	 VS_Label := L_Hishtafal;
      11:
	 VS_Label := L_Hotpaal;
      12:
	 VS_Label := L_Nitpael;
      13:
	 VS_Label := L_Etpaal;
      14:
	 VS_Label := L_Tifal;
      15:
	 VS_Label := L_Afel;
      16:
	 VS_Label := L_Shafel;
      17:
	 VS_Label := L_Peal;
      18:
	 VS_Label := L_Pael;
      19:
	 VS_Label := L_Peil;
      20:
	 VS_Label := L_Hitpaal;
      21:
	 VS_Label := L_Etpeel;
      22:
	 VS_Label := L_Eshtafal;
      23:
	 VS_Label := L_Ettafal;
      otherwise
	 VS_Label := L_NULL
   end
end;


function VT_Label(w: integer): lexeme;
begin
   case ko[w, KO_VT] of
      VT_IMPF:
	 VT_Label := T_IMPF;
      VT_PERF:
	 VT_Label := T_PERF;
      VT_IMPV:
	 VT_Label := T_IMPV;
      VT_INFC:
	 VT_Label := T_INFC;
      VT_INFA:
	 VT_Label := T_INFA;
      VT_PTCA:
	 VT_Label := T_PTCA;
      VT_WAYQ:
	 VT_Label := T_WAYQ;
      VT_WEYQ:
	 VT_Label := T_WEYQ;
      VT_PTCP:
	 VT_Label := T_PTCP;
      otherwise
	 VT_Label := L_NULL
   end
end;


function PNG_Char(k, v: integer): char;
begin
   if v in [1..N_PNG] then
      PNG_Char := PNG_Letters[k, v]
   else
      PNG_Char := '-'
end;


function PNG_String(k, v: integer): StringType;
begin
   if k <> KO_NU then
      PNG_String := '' + PNG_Char(k, v)
   else
      case v of
	 1: PNG_String := 'sg';
	 2: PNG_String := 'du';
	 3: PNG_String := 'pl';
      otherwise
	 PNG_String := '--'
      end
end;

function PNG_Compose(p, n, g: integer): lexeme;
begin
    PNG_Compose :=
       PNG_String(KO_PS, p) +
       PNG_String(KO_NU, n) +
       PNG_String(KO_GN, g) + ' '
end;

#define PNG_Label(w)	(PNG_Compose(ko[(w),KO_PS], ko[(w),KO_NU], ko[(w),KO_GN]))


function SFX_Label(w: integer): lexeme;
begin
   case ko[w, KO_PRS] of
      2, 3:
	 SFX_Label := PNG_Compose(1, 1, 0);
      9, 25:
	 SFX_Label := PNG_Compose(1, 3, 0);
      5, 24:
	 SFX_Label := PNG_Compose(2, 1, 1);
      4:
	 SFX_Label := PNG_Compose(2, 1, 2);
      11:
	 SFX_Label := PNG_Compose(2, 3, 1);
      10, 23:
	 SFX_Label := PNG_Compose(2, 3, 2);
      8, 20:
	 SFX_Label := PNG_Compose(3, 1, 1);
      6, 7, 19, 22:
	 SFX_Label := PNG_Compose(3, 1, 2);
      15, 16:
	 SFX_Label := PNG_Compose(3, 3, 1);
      12, 13, 14, 21:
	 SFX_Label := PNG_Compose(3, 3, 2);
      otherwise
	 SFX_Label := L_NULL
   end
end;


procedure Phrases_Shift(c, From, To: integer);
begin
   if phrases[c, To] <> L_NULL then
      message('syn04types: clause atom ' , c:1,
	 ': Phrase position ', To:1, ' is occupied.')
   else begin
      phrases[c, To] := phrases[c, From];
      Clauses[c, PAtom_PosIndex(c, From), CR_REC] := To;
      if From < To then
	 phrases[c, From] := L_RSHIFT
      else
	 phrases[c, From] := L_LSHIFT
   end
end;


function ReadAnswer(s: CharSet): char;
var
   c: char;
begin
   repeat
      read(c)
   until c in s;
   ReadAnswer := c
end;


function PhraseFirst(w: integer): integer;
(* Return the first word of the phrase ending at [w] *)
var
   i: integer;
begin
   i := w;
   while (i > 1) and (ko[i - 1, KO_PTY] = 0) do
      i := i - 1;
   PhraseFirst := i
end;


function PhraseHead(w: integer): integer;
(* Return the head of the phrase ending at [w] *)
var
   i: integer;
begin
   i := PhraseFirst(w);
   while (i <> w) and (ko[i, KO_GN] = -1) do
      i := i + 1;
   PhraseHead := i
end;


function PhraseLastPrs(w: integer): integer;
(* Return the last pronominal suffix of the phrase ending at [w] *)
var
   i: integer;
begin
   i := w;
   while (ko[i, KO_PRS] <= 0) and (i > 1) and (ko[i - 1, KO_PTY] = 0) do
      i := i - 1;
   PhraseLastPrs := i
end;


function PhraseMark(w: integer): integer;
(* Return the first word of the phrase ending at [w] that has a phrase
   dependent part of speech matching the phrase type *)
var
   i: integer;
begin
   i := PhraseFirst(w);
   while (i <> w) and (ko[i, KO_PDP] <> ko[w, KO_PTY]) do
      i := i + 1;
   PhraseMark := i
end;


function PdpLex(w, p: integer): StringType;
(* Return the lexeme of word w if its phrase dependent part of speech
   equals p, otherwise return the null lexeme *)
begin
   if ko[w, KO_PDP] = p then
      PdpLex := linelex[w]
   else
      PdpLex := L_NULL
end;


procedure Phrases_AddLex(c, p: integer; l: lexeme);
begin
   if phrases[c, p] = L_NULL then
      phrases[c, p] := l
end;


procedure Phrases_AddLexS(c, w, p: integer; s: integer);
begin
   Phrases_AddLex(c, p, linelex[w]);
   if ko[w, KO_FUN] in SubjSet then
      Phrases_AddLex(c, s, SFX_Label(w))
end;


procedure Phrases_Dept(c, w, p: integer);
begin
   if p in [PR_NP1, PR_NP2, PR_NP3, PR_NP4, PR_NP5, PR_NP6] then
      Phrases_AddLex(c, p, SFX_Label(w))
   else
      message('Dependent phrase at p = ', p:1)
end;


procedure Phrases_Prep(c, w: integer; p: integer);
(* Detect opening preposition *)
var
   h: integer;
begin
   h := PhraseFirst(w);
   if (p < PR_PREP) and (ko[h, KO_PDP] = SP_PREP) then
      phrases[c, PR_PREP] := linelex[h]
end;


procedure Phrases_Inrg(c, w: integer; var p: integer);
begin
   if p < PR_INRG then begin
      if (p < PR_QUES) and InterrogativeParticle(w) then
	 p := PR_QUES
      else
	 p := PR_INRG;
      Phrases_AddLex(c, p, linelex[PhraseMark(w)])
   end
end;


procedure Phrases_VP(c, w: integer; var p: integer);
begin
   Phrases_Prep(c, w, p);
   if (phrases[c, PR_VERB] = L_NULL) or
      (ko[w, KO_FUN] in PredSet)
   then begin
      phrases[c, PR_VERB] := linelex[w];
      phrases[c, PR_VT] := VT_Label(w);
      phrases[c, PR_VS] := VS_Label(w);
      phrases[c, PR_PNG] := PNG_Label(w);
      phrases[c, PR_PRED_SFX] := SFX_Label(w);
      CLT[c, quotverb] :=
	 LS_Code(ko[w, KO_SP], ko[w, KO_LS]) = LS_QUOT;
      p := PR_VERB
   end
end;


procedure Phrases_Nomi(c, w: integer; var p: integer; l: lexeme);
const
   N_NPP = 3;
var
   i: integer;	(* slot index *)
   n: integer;	(* number of slots left *)
begin
   if p < PR_VERB then
      i := PR_NP1
   else
      i := PR_NP4;
   n := N_NPP;
   while (n > 0) and (phrases[c, i] <> L_NULL) do begin
      n := n - 1;
      i := i + 2;
   end;
   if n = 0 then
      p := i - 2
   else begin
      phrases[c, i] := l;
      phrases[c, i + 1] := SFX_Label(w);
      p := i
   end
end;


procedure Phrases_CP(c, w: integer; var p: integer);
begin
   if p < PR_CONJ then begin
      if (p <> 0) or not Lex_Cocj(linelex[w]) then
	 p := PR_CONJ
      else begin
	 phrases[c, PR_CONJ] := L_LSHIFT;
	 p := PR_COOR
      end;
      if ko[w, KO_PDP] = SP_CONJ then
	 phrases[c, p] := linelex[w]
      else
	 phrases[c, p] := L_RSHIFT;
      Phrases_Prep(c, w, p)
   end
end;


procedure Phrases_Pron(c, w: integer; var p: integer; k1, k2: integer);
begin
   if p < PR_VERB then begin
      Phrases_AddLex(c, k1, linelex[w]);
      if p > k1 then	(* p was promoted *)
	 Phrases_Shift(c, p, PR_TOPIC);
      p := k1
   end else begin
      Phrases_AddLex(c, k2, linelex[w]);
      p := k2
   end
end;


procedure Phrases_Modi(c, w: integer; var p: integer; k: integer);
begin
   if p < PR_VERB then begin
      Phrases_AddLexS(c, w, k, PR_PRPS1);
      if p > k then	(* p was promoted *)
	 Phrases_Shift(c, p, PR_TOPIC);
      p := k
   end else begin
      Phrases_AddLexS(c, w, PR_MODI, PR_PRPS2);
      (* phrases[c, PR_LABEL][3] := 'm'; *)
      p := PR_MODI
   end
end;


procedure Phrases_AdvP(c, w: integer; var p: integer);
begin
   if not ((p < PR_FOCP) and FocusParticle(w)) then
      Phrases_Modi(c, w, p, PR_ADVB)
   else begin
      phrases[c, PR_FOCP] := linelex[w];
      p := PR_FOCP
   end
end;


procedure Phrases_AdjP(c, w: integer; var p: integer);
begin
   if not ((p < PR_VERB) and (ko[w, KO_FUN] in PreCSet)) then
      Phrases_Nomi(c, w, p, linelex[w])
   else begin
      phrases[c, PR_ADJV] := linelex[w];
      phrases[c, PR_PNG] := PNG_Label(w);
      phrases[c, PR_PRED_SFX] := SFX_Label(w);
      p := PR_ADJV
   end
end;


procedure FillPhrases(c, w: integer; var p: integer);
(* Fill phrases[c] from word [w] and update the active position p.
   Called from ReadLine in PhaseTwo. *)
begin
   assert(ko[w, KO_PTY] <> 0);
   if ko[w, KO_FUN] in DeptSet then 
      Phrases_Dept(c, w, p)
   else
      case ko[w, KO_PTY] of
	 PTY_VP:
	    Phrases_VP(c, w, p);
	 PTY_NP:
	    if ko[w, KO_DET] = DET_TRUE then
	       Phrases_Nomi(c, w, p, L_NPDT)
	    else
	       Phrases_Nomi(c, w, p, L_NP);
	 PTY_PrNP:
	    Phrases_Nomi(c, w, p, L_PrNP);
	 PTY_AdvP:
	    Phrases_AdvP(c, w, p);
	 PTY_PP:
	    Phrases_Nomi(c, w, p, linelex[PhraseFirst(w)]);
	 PTY_CP:
	    Phrases_CP(c, w, p);
	 PTY_PPrP:
	    Phrases_Pron(c, w, p, PR_PRPS1, PR_PRPS2);
	 PTY_DPrP:
	    Phrases_Pron(c, w, p, PR_PRDE1, PR_PRDE2);
	 PTY_IPrP:
	    Phrases_Inrg(c, w, p);
	 PTY_InjP:
	    Phrases_Modi(c, w, p, PR_INTJ);
	 PTY_NegP:
	    Phrases_Modi(c, w, p, PR_NEGA);
	 PTY_InrP:
	    Phrases_Inrg(c, w, p);
	 PTY_AdjP:
	    Phrases_AdjP(c, w, p);
	 otherwise begin
	    message('syn04types: ', versnr, 'clause ', c:1,
	       ', word ', w:1, ': Wrong phrase type or parsing');
	    pcexit(1)
	 end
      end
end;


function ColParCol(d, m: integer; var KD, KM: ColSpecType;
   f: ColMatcher; var p_d, p_m: integer): boolean;
(* Return whether mother and daughter have a correspondence in any of
   the listed columns. If there is a match, update p_d and p_m with the
   phrase positions where the first match occurs. *)
var
   i_d, i_m: integer;	(* column counter *)
   k_d, k_m: integer;	(* column index *)
   hit: boolean;
begin
   hit := false;
   i_d := 0;
   while not hit and (KD[i_d + 1] <> 0) do begin
      i_d := i_d + 1;
      k_d := KD[i_d];
      i_m := 0;
      while not hit and (KM[i_m + 1] <> 0) do begin
	 i_m := i_m + 1;
	 k_m := KM[i_m];
	 hit := f^(phrases[d, k_d], phrases[m, k_m])
      end
   end;
   if not hit then
      ColParCol := false
   else begin
      p_d := k_d; p_m := k_m;
      ColParCol := true
   end
end;


function LexParLex(d, m: integer; K: ColSpecType): integer;
(* Return the number of lexical correspondences between mother and
   daughter *)
var
   i_d, i_m: integer;	(* column counter *)
   k_d, k_m: integer;	(* column index *)
   r: integer;		(* result *)
begin
   r := 0;
   i_d := 1;
   while K[i_d] <> 0 do begin
      k_d := K[i_d];
      i_m := 1;
      while K[i_m] <> 0 do begin
	 k_m := K[i_m];
	 r := r + LexList_Matches(clauselex[d, k_d], clauselex[m, k_m]);
	 i_m := i_m + 1
      end;
      i_d := i_d + 1
   end;
   LexParLex := r
end;


procedure ArgList_Add(var L: ArgListType; var A: ArgType);
begin
   with L do begin
      if size < ARGLIST_MAX then
	 size := size + 1
      else begin
	 message('Argument list: Maximum number of arguments (',
	    ARGLIST_MAX:1, ') exceeded');
	 Quit
      end;
      list[size] := A
   end
end;


function ArgList_Locate(var L: ArgListType; var lab: phrlex): integer;
(* Return the location on the argument list where the argument with
   this label has been placed. Add the argument, if necessary.  *)
var
   A: ArgType;
   i: integer;
   found: boolean;
begin
   found := false;
   i := 1;
   with L do
      while (i <= size) and not found do
	 if list[i].lab = lab then
	    found := true
	 else
	    i := i + 1;
   if not found then begin
      Arg_Init(A, lab);
      ArgList_Add(L, A);
   end;
   ArgList_Locate := i
end;


procedure ArgList_Update(var L: ArgListType; var A: ArgonType);
(* Update the frequency in L of the arguments used in A *)
var
   i: integer;
begin
   with A do
      for i := 1 to size do
	 with L.list[alix[i]] do
	    frq := frq + 1
end;


procedure ReadArgList(var f: text; var L: ArgListType);
var
   arg: ArgType;
begin
   reset(f);
   while not eof(f) do begin
      with arg do
	 readln(f, lab, val, dis, par, quo, frq);
      ArgList_Add(L, arg)
   end
end;


procedure Argon_Add(var A: ArgonType; lab: phrlex);
(* Add argument `lab' to argumentation A *)
var
   i: integer;	(* index in ArgList *)
begin
   with A do begin
      if size < ARGON_MAX then
	 size := size + 1
      else begin
	 message('Argumentation: Maximum number of arguments (',
	    ARGON_MAX:1, ') exceeded');
	 Quit
      end;
      i := ArgList_Locate(ArgList, lab);
      alix[size] := i
   end
end;


procedure Argon_Clear(var A: ArgonType);
begin
   A.c_val := 0;
   A.c_dis := 0;
   A.c_par := 0;
   A.c_quo := 0;
   A.size := 0
end;

function LogProb(m: real; d: integer): real;
(* Return the logarithmic probability of distance d, when the mean
   distance is m, and m >= 1.
   Pr(d) = (r - 1)/r^d, where r = m/(m-1).  *)
begin
   if m = 1 then
      LogProb := -100 * ord(d <> 1)
   else
      LogProb := (1 - d) * ln(m / (m - 1)) - ln(m)
end;


procedure Argon_Eval(var A: ArgonType; d: integer);
(* Evaluate argumentation A for distance d *)
const
   t = 85/834;
var
   i: integer;
begin
   with A do begin
      for i := 1 to size do
	 with ArgList.list[alix[i]] do begin
	    c_val := c_val + val;
	    if dis >= 1 then
	       c_dis := c_dis + LogProb(dis, d);
	    c_par := c_par + par;
	    c_quo := c_quo + quo
	 end;
      c_val := Phi(c_val);
      c_dis := exp(t * c_dis/size)
   end
end;


function Argon_Find
   (var A: ArgonType; t: StringType; s: integer): integer;
(* Return the index in argumentation A of the first argument of which
   the label in the argument list matches tag `t' when starting at
   position `s' in the label, and 0 if there is no such argument. *)
var
   i: integer;
   l: integer;	(* tag length *)
   found: boolean;
begin
   found := false;
   l := length(t);
   i := 1;
   with A do
      while not found and (i <= size) do
	 if substr(ArgList.list[alix[i]].lab, s, l) = t then
	    found := true
	 else
	    i := i + 1;
   if found then
      Argon_Find := i
   else
      Argon_Find := 0
end;


function Argon_Match(var A1, A2: ArgonType): boolean;
(* Return whether argumentation A2 meets (is a superset of)
   argumentation A1. Hence this is not a symmetric function. *)
var
   i: integer;
   r: boolean;	(* result *)
begin
   r := true;
   i := 1;
   while r and (i <= A1.size) do
      if (i > A2.size) or (A1.alix[i] <> A2.alix[i]) then
	 r := false
      else
	 i := i + 1;
   Argon_Match := r
end;


procedure DisplayArgon(var A: ArgonType);
var
   i: integer;
begin
   with A do begin
      write('Argumentation:');
      for i := 1 to size do
	 write(' ', ArgList.list[alix[i]].lab);
      writeln;
      writeln;
      write('C: ', c_val:6:3, ' = ');
      for i := 1 to size do
	 write('   ', ArgList.list[alix[i]].val:8:3);
      writeln;
      write('D: ', c_dis:6:3, ' = ');
      for i := 1 to size do
	 write('   ', ArgList.list[alix[i]].dis:8:3);
      writeln;
      write('P: ', c_par:6:3, ' = ');
      for i := 1 to size do
	 write('   ', ArgList.list[alix[i]].par:8:3);
      writeln;
      write('Q: ', c_quo:6:3, ' = ');
      for i := 1 to size do
	 write('   ', ArgList.list[alix[i]].quo:8:3);
      writeln;
      writeln
   end
end;


procedure WriteArgon(var f: text; var A: ArgonType);
const
   TAB = chr(9);
var
   i: integer;
begin
   with A do begin
      write(f, c_val:8:5, ' ', c_dis:8:5, ' ',
	       c_par:8:5, ' ', c_quo:8:5, TAB);
      for i := 1 to size do
	 write(f, ArgList.list[alix[i]].lab, ' ')
   end;
   writeln(f)
end;


function PreVerbNPdet(d: integer): boolean;
var
   i: integer;
   k: integer;
   hit: boolean;
begin
   if phrases[d, PR_PRPS1] <> L_NULL then
      PreVerbNPdet := true
   else begin
      k := PR_NP1;
      i := 0;
      hit := false;
      while not hit and (i < 3) do begin
	 i := i + 1;
	 hit := (phrases[d, k] = L_PrNP) or (phrases[d, k] = L_NPDT);
	 k := k + 2
      end;
      PreVerbNPdet := hit or (phrases[d, PR_TOPIC] <> L_NULL)
   end
end;


function PostVerbNPdet(d: integer): boolean;
var
   i: integer;
   k: integer;
   hit: boolean;
begin
   if phrases[d, PR_PRPS2] <> L_NULL then
      PostVerbNPdet := true
   else begin
      k := PR_NP4;
      i := 0;
      hit := false;
      while not hit and (i < 3) do begin
	 i := i + 1;
	 hit := (phrases[d, k] = L_PrNP) or (phrases[d, k] = L_NPDT);
	 k := k + 2
      end;
      PostVerbNPdet := hit
   end
end;


function Conjunction(c: integer): integer;
(* Return the position of the clause opening conjunction, which might
   be the coordinating conjunction *)
begin
   if phrases[c, PR_CONJ] = L_LSHIFT then
      Conjunction := PR_COOR
   else
      Conjunction := PR_CONJ
end;


function NominalClauseType(a: integer): integer;
begin
   if phrases[a, PR_ADJV] <> L_NULL then
      NominalClauseType := CT_AjCl
   else
      NominalClauseType := CT_NmCl
end;


function SecondDigit(w, p, s: integer): integer;
(* Return the value of the second digit in the clause type number,
   given the positions of waw, predicate and subject *)
var
   r: integer;	(* Result without waw *)
begin
   if (s <> 0) and (s < p) then
      r := 2					(* XP *)
   else
      r := ord(s <> 0) + 3 * ord(w + 1 < p);	(* PX, x *)
   SecondDigit := r + 5 * w;
end;


function ClauseType_Finite(c, k, t: integer): integer;
(* Type of clause atom [c]
   having a finite verb form as predicate in Clauses[c,,k] *)
var
   w: integer;	(* waw index *)
   p: integer;	(* predicate index *)
   s: integer;	(* subject index *)
begin
   p := ConstituentIndex(c, k, PredSet);
   if p = 0 then			(* parsing error *)
      ClauseType_Finite := CT_Unkn
   else begin
      if k = CR_CLAUSE then
	 w := ord(phrases[ClauseHead(c), PR_COOR] = L_AND)
      else
	 w := ord(phrases[c, PR_COOR] = L_AND);
      s := ConstituentIndex(c, k, SubjSet);
      ClauseType_Finite := CT_Null + 10 * SecondDigit(w, p, s) + t
   end
end;


function VerbalClauseType(c, k: integer): integer;
(* Clause atom [c] having a predicate in Clauses[c,,k] *)
var
   t: integer;	(* tense *)
begin
   CL_Get(phrases[c, PR_VT], CL_PRED, t);
   if t in VT_Finite then
      VerbalClauseType := ClauseType_Finite(c, k, t)
   else
      VerbalClauseType := CT_Null + t
end;


function ClauseType(a: integer; c: char; k: integer): integer;
(* Clause type of clause atom [a] with subtype c
   according to Clauses[a,,k] *)
begin
   case c of
      'c':
	 ClauseType := CT_CPen;
      'd':
	 ClauseType := CT_Defc;
      'l':
	 ClauseType := CT_Ellp;
      'm':
	 ClauseType := CT_MSyn;
      'r':
	 ClauseType := CT_Reop;
      'v':
	 ClauseType := CT_Voct;
      'x':
	 ClauseType := CT_XPos;
   otherwise
      if phrases[a, PR_VT] <> L_NULL then
	 ClauseType := VerbalClauseType(a, k)
      else
	 ClauseType := NominalClauseType(a)
   end
end;


function AttrMam(c: integer): integer;
(* Return the index of the phrase atom that is most likely the mother
   of an attributive clause *)
var
   i: integer;
   p: integer;
begin
   p := 0;
   i := 1;
   while NM_Columns[i] <> 0 do begin
      if phrases[c, NM_Columns[i]] <> L_NULL then
	 if phrases[c, NM_Columns[i]] = L_LSHIFT then
	    p := PR_TOPIC
	 else
	    p := NM_Columns[i];
      i := i + 1
   end;
   if p = 0 then	(* nothing nominal found, guess last atom *)
      AttrMam := CAtom_Size(c)
   else
      AttrMam := PAtom_PosIndex(c, p)
end;


function EmptySlots(a, s1, s2: integer): boolean;
(* Return whether the slots phrases[a, s1..s2] are all empty *)
var
   empty: boolean;
   i: integer;
begin
   empty := true;
   i := s1;
   while (i <= s2) and empty do begin
      empty := phrases[a, i] = L_NULL;
      i := i + 1
   end;
   EmptySlots := empty
end;


function Adju_Clause(d: integer; var C: CandType): boolean;
(* TODO: Temporal en Final conjuncties toevoegen? *)
begin
   with C do
      if phrases[d, PR_PREP] = L_NULL then
	 Adju_Clause := (arg.size <> arg.size)
      else begin
	 Relations[d, ClConstRel] := Adju;
	 Relations[d, distCCR] := CCR_Distance(d, mam, 0, 0);
	 Adju_Clause := true
      end
end;


function Cmpl_Clause(d: integer; var C: CandType): boolean;
begin
   (* From lack of valency information, complement clauses cannot
      be discerned from adjunct clauses, which have a much higher
      frequency in the current database. *)
   with C do
      Cmpl_Clause := (d = mam) and (arg.size = 0)
end;


function Objc_Clause(d: integer; var C: CandType): boolean;
begin
   with C do
      if Argon_Find(arg, ARGLAB_OBJC, 1) = 0 then
	 Objc_Clause := false
      else begin
	 Relations[d, ClConstRel] := Objc;
	 Relations[d, distCCR] := CCR_Distance(d, mam, 0, 0);
	 Objc_Clause := true
      end
end;


function PreC_Clause(d: integer; var C: CandType): boolean;
begin
   with C do
      if Argon_Find(arg, ARGLAB_PREC, 1) = 0 then
	 PreC_Clause := false
      else begin
	 Relations[d, ClConstRel] := PreC;
	 Relations[d, distCCR] := CCR_Distance(d, mam, 0, 0);
	 PreC_Clause := true
      end
end;


function Subj_Clause(d: integer; var C: CandType): boolean;
begin
   with C do
      if Argon_Find(arg, ARGLAB_SUBJ, 1) = 0 then
	 Subj_Clause := false
      else begin
	 Relations[d, ClConstRel] := Subj;
	 Relations[d, distCCR] := CCR_Distance(d, mam, 0, 0);
	 Subj_Clause := true
      end
end;


function Attr_Clause(d: integer; var C: CandType): boolean;
begin
   with C do
      if Argon_Find(arg, ARGLAB_ATTR, 1) = 0 then
	 Attr_Clause := false
      else begin
	 Relations[d, ClConstRel] := CCR_Attr;
	 Relations[d, distCCR] := CCR_Distance(d, mam, AttrMam(mam), 0);
	 Attr_Clause := true
      end
end;


function Coor_Clause(d: integer; var C: CandType): boolean;
begin
   with C do
      if Argon_Find(arg, ARGLAB_COOR, 1) = 0 then
	 Coor_Clause := false
      else begin
	 Relations[d, ClConstRel] := CCR_Coor;
	 Relations[d, distCCR] := CCR_Distance(d, mam, 0, 0);
	 Coor_Clause := true
      end
end;


function Resu_Clause(d: integer; var C: CandType): boolean;
begin
   with C do
      if (Argon_Find(arg, ARGLAB_RESU, 1) = 0) and
	 (Argon_Find(arg, ARGLAB_REOP, 1) = 0)
      then
	 Resu_Clause := false
      else begin
	 Relations[d, ClConstRel] := CCR_Resu;
	 Relations[d, distCCR] := CCR_Distance(d, mam, 0, 0);
	 Resu_Clause := true
      end
end;


function ReVo_Clause(d: integer; var C: CandType): boolean;
begin
   with C do
      if Argon_Find(arg, ARGLAB_REVO, 1) = 0 then
	 ReVo_Clause := false
      else begin
	 Relations[d, ClConstRel] := CCR_ReVo;
	 Relations[d, distCCR] := CCR_Distance(d, mam, 0, 0);
	 ReVo_Clause := true
      end
end;


function RgRc_Clause(d: integer; var C: CandType): boolean;
var
   p: integer;	(* index of mother phrase atom *)
   w: integer;	(* index of mother word *)
begin
   with C do
      if Argon_Find(arg, ARGLAB_RGRC, 1) = 0 then
	 RgRc_Clause := false
      else begin
	 Relations[d, ClConstRel] := CCR_RgRc;
	 p := CAtom_Size(mam);
	 w := PAtom_Size(mam, p);
	 Relations[d, distCCR] := CCR_Distance(d, mam, p, w);
	 RgRc_Clause := true
      end
end;


function PrAd_Clause(d: integer; var C: CandType): boolean;
begin
   (* No algorithm for detection yet *)
   with C do
      PrAd_Clause := (d = mam) and (arg.size = 0)
end;


function Spec_Clause(d: integer; var C: CandType): boolean;
begin
   (* No algorithm for detection yet *)
   with C do
      Spec_Clause := (d = mam)
end;


function ClauseConstituentRelation
   (d: integer; var C: CandType): boolean;
(* The evaluation should be done in descending order of the probability
   of a correct assignment *)
begin
   ClauseConstituentRelation :=
      Adju_Clause(d, C) or
      Cmpl_Clause(d, C) or
      Objc_Clause(d, C) or
      PreC_Clause(d, C) or
      Subj_Clause(d, C) or
      Attr_Clause(d, C) or
      ReVo_Clause(d, C) or
      Coor_Clause(d, C) or
      Resu_Clause(d, C) or
      RgRc_Clause(d, C) or
      PrAd_Clause(d, C) or
      Spec_Clause(d, C) or
      false
end;


function CCR_Label(r: integer): StringType;
begin
   case r of
	  Adju: CCR_Label := '[adjunct]';
	  Cmpl: CCR_Label := '[complm.]';
	  Objc: CCR_Label := '[object ]';
	  PrAd: CCR_Label := '[pradjun]';
	  PreC: CCR_Label := '[predic.]';
	  Subj: CCR_Label := '[subject]';
      CCR_Attr: CCR_Label := '[attrib.]';
      CCR_Coor: CCR_Label := '[coordin]';
      CCR_ReVo: CCR_Label := '[ref.Voc]';
      CCR_Resu: CCR_Label := '[resumpt]';
      CCR_RgRc: CCR_Label := '[reg/rec]';
      CCR_Spec: CCR_Label := '[specif.]';
   otherwise
      CCR_Label := '[unknown]'
   end
end;


procedure CCR_Write(var f: text; rela, dist: integer);
var
   d: integer;	(* distance *)
   u: char;	(* unit *)
begin
   DistDecode(dist, CCR_BASE, d, u);
   write(f, CCR_Label(rela), ' @ ', d:1, u)
end;


procedure Print_CCR_Menu;
begin
   writeln('Adju J | Cmpl C | Objc O | PrAd B | PreC P | Subj S');
   writeln('Attr A | Coor c | Resu r | ReVo v | RgRc R | Spec s');
   writeln('None n')
end;


procedure Read_CCR_Command(var c: char; var d: integer; var u: char);
begin
   assert(not eoln);
   read(c);
   if not eoln then
      if ReadInteger(input, d) then
	 if not eoln then
	    read(u)
	 else
	    u := 'C'
      else
	 u := '.'
   else begin
      d := 0;
      u := 'C'
   end
end;


function TestCCR(var rela, dist: integer): boolean;
var
   c: char;		(* command *)
   d: integer;		(* distance *)
   u: char;		(* unit *)
begin
   if eoln then
      TestCCR := true
   else begin
      Read_CCR_Command(c, d, u);
      if (c <> 'n') and (CCR_Char2Rela(c) = CCR_None) or
	 not (u in ['W', 'P', 'C', 'S'])
      then
	 TestCCR := false
      else begin
	 rela := CCR_Char2Rela(c);
	 dist := DistEncode(d, u, CCR_BASE);
	 TestCCR := true
      end
   end;
   readln
end;


procedure EstablishCCR(var f: text; d: integer; var C: CandType);
const
   TAB = chr(9);
var
   m: integer;		(* mother *)
   p: integer;		(* number of phrase atoms *)
   rela, dist: integer;
   happy: boolean;
begin
   m := C.mam;
   write(f, d:2, ' to ', m:2, TAB, 'sys: ');
   CCR_Write(f, Relations[d, ClConstRel], Relations[d, distCCR]);
   rela := Relations[d, ClConstRel];
   if rela = CCR_None then
      dist := CCR_Distance(d, m, 0, 0)
   else
      dist := Relations[d, distCCR];
   happy := false;
   while not happy do begin
      write('Enter Clause Constituent Relation ');
      CCR_Write(output, rela, dist);
      write(': ');
      if TestCCR(rela, dist) then
	 happy := (dist = 0) or (Sign(dist) = Sign(m - d))
      else
	 Print_CCR_Menu
   end;
   if (rela <> CCR_None) and (dist <> 0) then
      Relations[d, distCCR] := dist
   else
      case rela of
	 CCR_Attr:
	    Relations[d, distCCR] := CCR_Distance(d, m, AttrMam(m), 0);
	 CCR_None:
	    Relations[d, distCCR] := 0;
	 CCR_RgRc:
	    begin
	       p := CAtom_Size(m);
	       Relations[d, distCCR] :=
		  CCR_Distance(d, m, p, PAtom_Size(m, p))
	    end;
      otherwise
	 Relations[d, distCCR] := CCR_Distance(d, m, 0, 0)
      end;
   Relations[d, ClConstRel] := rela;
   write(f, TAB, 'usr: ');
   CCR_Write(f, Relations[d, ClConstRel], Relations[d, distCCR]);
   writeln(f)
end;


procedure AddRelation(var r: RelRec; c, d, t: integer);
(* Add a relation of type t and distance d to clause atom c *)
var
   i: integer;
   n: integer;	(* resulting number of relations *)
begin
   n := r[c, MaxCodes];
   i := ClCodes + 2 * n + 1;
   if i + 1 < MaxCodes then begin
      r[c, i] := d;
      r[c, i + 1] := t;
      r[c, MaxCodes] := n + 1
   end
end;


procedure ReadUserTabs(var Relations: RelRec; var StopL:integer);
var i,j,l,m,r,
    dist, rela,
    error  : integer;
    ch     : char;
    clab : lexeme;
    ClConstRelInfo: boolean;
    stop: boolean;
begin
  i := 0; m:= 0; ty := 1;
  NOustabs := false;  LabelConnection := false;
  ExistRefInfo := false;
  error := 0;
  open(ustabs, PericopeName + '.usertab', 'old', error);
  if error <> 0 then
  begin
     writeln('file ',PericopeName,'.usertab  is empty');
     NOustabs := true;
       open (hierarch, PericopeName + '.hierarch', 'new');
       rewrite(hierarch);
  end
  else
  begin writeln('... reading file ',PericopeName,'.usertab');
    { writeln(' Do you want to the Labels of DEP.clause connections on file?');
    repeat read(ch) until ch in ['y','j','n'];
    if ch in ['y','j'] then LabelConnection := true else
			    LabelConnection := false;
    } LabelConnection := false;
      writeln(' Labels of DEP.clause connections are written to file " ClConnList " ');
    reset(ustabs);
    open (hierarch, PericopeName + '.hierarch', 'old', error);
    if error <> 0 then
    begin
       writeln('file ',PericopeName,'.hierarch  is empty');
       open (hierarch, PericopeName + '.hierarch', 'new');
       rewrite(hierarch);
    end;
    if phrases[1, PR_VT] = T_WAYQ then txt[1,ty] := 'N' else
    txt[1, ty] := '?';
    partxt[1, 1] := '1';
    while not eof(ustabs) do
	  begin i := i+1;
		read(ustabs, subtypes[i,1], subtypes[i,2]);
                repeat read(ustabs,ch) until ch = 'T';
		read(ustabs, j, ch);
		Relations[i, TabNum] := j;
		Relations[i, UserTab] := j;
                for r := 1 to 10 do txtTAB[r] := Relations[i, UserTab];
		ClConstRelInfo := false;                    { check info on Const.level.Clauses }
		  (* EXPER *)
                repeat read(ustabs,ch) until ch = 'L';
		  read(ustabs, l,ch);
		  {test: is l = i?}
                repeat read(ustabs,ch) until ch = 'C';
		  read(ustabs, CLN,ch);      Relations[i, ClauseNr] := CLN;

                repeat read(ustabs,ch) until ch = 'P';
		  read(ustabs, ch, Phr1, ch);
		  Relations[i, PhrStart] := Phr1;
                repeat read(ustabs,ch) until ch = 'P';
		  read(ustabs, ch, Phrl, ch);
		  Relations[i, PhrStop] := Phrl;
                repeat read(ustabs,ch) until ch = 'C';
		  read(ustabs, ch, ch, Clty, ch);
		  Relations[i, ClauseT] := Clty;
		                             Relations[i, ClauseT2]:= Clty;
                repeat read(ustabs,ch) until ch = 'C';
		  read(ustabs, ch, ch, CCRty, ch);
                repeat read(ustabs,ch) until ch = 'd';
		  read(ustabs, ch, ch, CCRdis,ch);
		  Relations[i, distCCR] := CCRdis;
                repeat read(ustabs,ch) until ch = 'S';
		  read(ustabs, SnNr, ch);
		  if (1 <= SnNr) and (SnNr <= TxtLength) then
		     Relations[i, SentenceNr]:= SnNr
		  else begin
		     message('syn04types: ' , PericopeName, '.usertab, line ',
			i:1, ': Sentence number overflow');
		     pcexit(1)
		  end;

                     if (CCRty < -1) or
			((CCRty > Appo) and (CCRty < Unkn)) then
			begin
			                Relations[i,ClConstRel] := CCRty;
	                    distPHR:= CCRdis;
                                        Relations[i, distCCR] := CCRdis;
			    ClConstRelInfo := true;
			end;

		{read after sentenceNb the Texttype}

                read(ustabs, ch);
		for r := 1 to 8 do
		    begin
		       read(ustabs, txt[i,r]);
		    end;
                read(ustabs, ch);
                read(ustabs, ch);
		ReadPargr(ustabs, partxt, i);
		PargrCheck(partxt[i]);
                read(ustabs,ch);
                for r := 1 to 5 do
		    begin read(ustabs, clab[r]);
                    end;
		    phrases[i, PR_CLAB] := clab;

		    LabelConnection := true;    { find out by re-calculating }
         read(ustabs,ch);
	 assert(ch = '#');
	 stop := false;
	 while not stop and not eoln(ustabs) do begin
	    read(ustabs, dist, rela);
	    if (dist = 0) or (rela = 0) then
	       stop := true
	    else
	       AddRelation(Relations, i, dist, rela)
	 end;
	 readln(ustabs);
      end;
  end;
  writeln('... number of UserTabs read:',i:3);
  writeln('... Info on participant references read from file UserTabs');
  if i = 0 then subtypes[1,1] := '.';
  StopL := i;    { = SOFAR}
  { if no part.ref. on file usertab then CalculateActors(StopL);   }
end;


function GetRelation(var rr: RelRec; c: integer): integer;
(* Return the code of the clause atom relation c has with its mother *)
var
   d: integer;	(* prevailing distance *)
   i: integer;
   r: integer;	(* result *)
   x: integer;	(* distance under examination *)
begin
   d := 0;
   r := CARC_None;
   for i := 1 to rr[c, MaxCodes] do begin
      x := rr[c, ClCodes + 2 * i - 1];
      if (x < d) and (d <= 0) or (0 <= d) and (d < x) then begin
	 d := x;
	 r := rr[c, ClCodes + 2 * i]
      end
   end;
   GetRelation := r
end;


procedure PopRelation(var r: RelRec; c: integer);
(* Remove the relation with c from its mother *)
var
   i: integer;
   m: integer;	(* mother *)
   n: integer;	(* number of relations *)
begin
   m := r[c, UserMam];
   n := r[m, MaxCodes];
   i := ClCodes + 2 * n - 1;
   if (n > 0) and (m + r[m, i] = c) then begin
      r[m, i] := 0;
      r[m, i + 1] := 0;
      r[m, MaxCodes] := n - 1
   end
end;


procedure AssignMothers(var r: RelRec; n: integer);
(* Assign a value to the column UserMam for the first n clause atoms on
   the basis of the tabs present in r *)
var
   i: integer;
   m: integer;
begin
   for i := 1 to n do begin
      m := FindMother(r, i, r[i, UserTab]);
      r[i, RelLine] := m;
      r[i, UserMam] := m
   end
end;


function SameClause(m, d: integer; e: CharSet): boolean;
(* Precondition: m <> CAR_ROOT.
   See if mother and daughter belong to the same clause.
   The meaning of 'e' is taken as:
   The next clause atom is a subsequent atom in a compound clause. *)
begin
   SameClause :=
      ((subtypes[m, 1] = 'd') or (subtypes[d, 1] = 'd')) and
      (
	 ((m < d - 1) and (subtypes[d - 1, 2] in e)) or
	 ((d < m - 1) and (subtypes[m - 1, 2] in e))
      )
end;


procedure ResolveEmbedding(var r: RelRec; n: integer; var u: integer; e: CharSet);
(* Find the clause numbers of the thus far unassigned clause atoms
   using the instructions from [e] as signal for embedding. Variable u
   is updated with the number of clause atoms left unresolved. *)
var
   d: integer;	(* daughter *)
   m: integer;	(* mother *)
   du: integer;	(* number of clause atoms resolved *)
begin
   repeat
      du := 0;
      for d := 1 to n do begin
	 m := r[d, UserMam];
	 if m <> CAR_ROOT then begin
	    if ((r[m, ClauseNr] <> 0) and (r[d, ClauseNr] = 0)) and
	       SameClause(m, d, e)
	    then begin
	       r[d, ClauseNr] := r[m, ClauseNr];
	       du := du + 1
	    end;
	    if ((r[m, ClauseNr] = 0) and (r[d, ClauseNr] <> 0)) and
	       SameClause(m, d, e)
	    then begin
	       r[m, ClauseNr] := r[d, ClauseNr];
	       du := du + 1
	    end
	 end
      end;
      u := u - du
   until (u = 0) or (du = 0)
end;


procedure ResolveUnassigned(var r: RelRec; n: integer; var u: integer);
(* Resolve the unassigned clause numbers by looking at the instruction
   'e' and if necessary at those that can eclipse it.
   Keep trying while there is progress. *)
const
   N = 3;	(* #instruction sets *)
var
   b: integer;	(* #unassigned atoms before *)
   e: array [1..N] of CharSet;
   i: integer;
begin
   e[1] := ['e'];
   e[2] := ['\'];
   e[3] := ['N', 'q', '#'];
   b := n;
   while u < b do begin
      b := u;
      i := 1;
      while (u <> 0) and (i <= N) do begin
	 ResolveEmbedding(r, n, u, e[i]);
	 i := i + 1
      end
   end
end;


procedure AssignClauseNumbers(var r: RelRec; n: integer);
(* Establish absolute clause numbers by giving every clause atom a
   clause number equal to the clause atom number of the clause atom
   that is not defective, using the mothers in combination with the
   instructions 'd' and 'e'. *)
var
   d: integer;	(* daughter *)
   u: integer;	(* #unassigned atoms *)
begin
   u := 0;
   for d := 1 to n do
      if subtypes[d, 1] <> 'd' then
	 r[d, ClauseNr] := d
      else begin
	 u := u + 1;
	 r[d, ClauseNr] := 0
      end;
   ResolveUnassigned(r, n, u);
   if u <> 0 then begin
      message('syn04types: ',
	 'Could not resolve embedding for clause atom ',
	 FindFirstClauseNr(r, 0):1);
      Quit
   end
end;


function ZeroPredicateLeaf(var r: RelRec; c: integer): boolean;
(* Return whether c has a zero predicate and is a childless daughter
   that does not start a subparagraph. *)
begin
   ZeroPredicateLeaf :=
      (r[c, ClauseT] >= CT_Voct) and
      not (subtypes[c, 1] = 'm') and
      not ParMark(c) and
      (DaughterCount(c) = 0)
end;


function SentenceNumber(var r: RelRec; c, s: integer): integer;
(* Return an absolute sentence number for the sentence to which clause
   head [c] belongs. Two clauses belong to the same sentence in the
   case of an ellipsis or a clause constituent relation. As an
   experiment we also include zero predicates which are childless
   daughters that do not start a subparagraph. *)
var
   m: integer;	(* mother *)
begin
   assert(c <> CAR_ROOT);
   if s > 0 then
      m := r[c, UserMam]
   else begin
      message('syn04types: clause atom ' , c:1, ': Cycle detected');
      Quit
   end;
   if (m <> CAR_ROOT) and (
	 (r[c, ClConstRel] <> CCR_None) or
	 ((r[c, ClauseT] = CT_Ellp) and (subtypes[c, 2] <> 'p')) or
	 ((c = m + 1) and (subtypes[m, 2] = 'p')) or
	 ZeroPredicateLeaf(r, c)
   )
   then
      SentenceNumber := SentenceNumber(r, ClauseHead(m), s - 1)
   else
      SentenceNumber := r[c, ClauseNr]
end;


procedure AssignSentenceNumbers(var r: RelRec; n: integer);
(* Establish absolute sentence numbers.
   Depends on the results of AssignTypes and AssignCodes. *)
var
   S: array [1..TxtLength] of integer;	(* sentence *)
   c: integer;				(* clause atom index *)
   s: integer;				(* new sentence number *)
begin
   s := 0;
   for c := 1 to n do
      S[c] := 0;
   for c := 1 to n do begin
      r[c, SentenceNr] := SentenceNumber(r, ClauseHead(c), n);
      if S[r[c, SentenceNr]] = 0 then begin
	 s := s + 1;
	 S[r[c, SentenceNr]] := s
      end;
      r[c, SentenceNr] := S[r[c, SentenceNr]]
   end
end;


function Clause_Tense(c: integer): lexeme;
var
   i: integer;
begin
   i := Relations[c, ClauseNr];
   if (0 < i) and (i <= TxtLength) then
      Clause_Tense := phrases[i, PR_VT]
   else
      Clause_Tense := L_UNKN
end;


function N_Trans(d: integer; t: char): boolean;
begin
   N_Trans :=
      (t <> TTY_NARRATIVE) and
      (Clause_Tense(d) = T_WAYQ) and
      not ConstituentClause(d)
end;


(* Geven afhankelijke vragen met MH van een verbum sentiendi in een N
   een discursief subdomeintje? Bijvoorbeeld Gn 2:19 en Ex 2:4. Iets om
   nog een keer uit te zoeken. *)

function D_Trans(d: integer; t: char): boolean;
begin
   D_Trans :=
      (t = TTY_NARRATIVE) and
      (Clause_Tense(d) = T_IMPF) and
      not ConstituentClause(d)
end;


function Q_Trans(d: integer; t: char): boolean;
begin
   Q_Trans :=
      (subtypes[d, 2] = 'q') or
      (t <> TTY_QUOTATION) and (
	    (Clause_Tense(d) = T_IMPV) and
	    not ConstituentClause(d) or
	    (subtypes[d, 1] = 'v')
	 )
end;


function Q_Trans12(d: integer; t: char): boolean;
begin
   Q_Trans12 := (t = TTY_UNKNOWN) and ClausePerson12(Relations, d)
end;


function TtyTrans(c: integer; t: char): char;
begin
   if Q_Trans(c, t) then
      TtyTrans := TTY_QUOTATION
   else if N_Trans(c, t) then
      TtyTrans := TTY_NARRATIVE
   else if D_Trans(c, t) then
      TtyTrans := TTY_DISCURSIVE
   else if Q_Trans12(c, t) then
      TtyTrans := TTY_QUOTATION
   else
      TtyTrans := TTY_UNKNOWN
end;


function Q_Recess(d: integer; t: char): boolean;
begin
   Q_Recess :=
      (t = TTY_QUOTATION) and (subtypes[d, 2] = '#') and
      (GetRelation(Relations, d) = CARC_Quot)
end;


procedure SetParNum(var r: RelRec; c: integer);
(* Not entirely correct; fmtpx.anode_setpars() is. *)
var
   d: integer;				(* daughter *)
   m: integer;				(* mother *)
   i: integer;
begin
   m := r[c, UserMam];
   if m = CAR_ROOT then
      partxt[c] := '1'
   else begin
      PargrCopy(partxt[m], partxt[c]);
      if ParMark(c) then
	 if r[c, UserTab] = r[m, UserTab] then
	    PargrIncrement(partxt[c])
	 else
	    PargrAppend(partxt[c], '1')
   end;
   for i := 1 to r[c, MaxCodes] do begin
      d := c + r[c, ClCodes + 2 * i - 1];
      if d <> r[c, UserMam] then
	 SetParNum(r, d)
   end
end;


procedure SetTextType(var r: RelRec; c: integer);
var
   d: integer;		(* daughter of [c] *)
   m: integer;		(* mother of [c] *)
   l: integer;		(* string length *)
   i: integer;
   parallel, recess, same_clause: boolean;
   s: StringType;
   t: char;		(* current text type *)
   x: char;		(* text type of transition *)
begin
   m := r[c, UserMam];
   if (m = CAR_ROOT) or (subtypes[c][2] = 'N') and (r[c, UserTab] = 0) then
      s := ''
   else
      s := trim(txt[m]);
   l := length(s);
   if l = 0 then
      t := TTY_UNKNOWN
   else
      t := s[l];
   x := TtyTrans(c, t);
   parallel := (l <> 0) and (r[c, UserTab] = r[m, UserTab]);
   recess := Q_Recess(c, t);
   same_clause := (l <> 0) and (r[c, ClauseNr] = r[m, ClauseNr]);
   if same_clause or (t <> TTY_UNKNOWN) and not recess and
      (parallel or (x = TTY_UNKNOWN))
   then
      TtyCopy(txt, c, s)		(* copy unaltered *)
   else if (l <> 0) and (t = TTY_UNKNOWN) and
      (parallel or not ParMark(c))
   then
      TtyCopy(txt, c, String_Set(s, x))	(* change last letter *)
   else if recess then
      TtyCopy(txt, c, String_Pop(s))	(* pop last letter *)
   else if (l = 0) and (x = TTY_UNKNOWN) then
      TtyCopy(txt, c, txt[c, 1])	(* use usertab *)
   else
      TtyCopy(txt, c, s + x);		(* add letter *)
   for i := 1 to r[c, MaxCodes] do begin
      d := c + r[c, ClCodes + 2 * i - 1];
      if d <> r[c, UserMam] then
	 SetTextType(r, d)
   end
end;


procedure AssignTextTypes(var r: RelRec; n: integer);
var
   c: integer;				(* clause atom index *)
begin
   for c := 1 to n do
      if r[c, UserMam] = CAR_ROOT then
	 SetTextType(r, c)
end;


procedure AddConstituent(var r: Clauserec; c, v: integer);
var
   i: integer;
begin
   i := r[c, Linecode, CR_CLAUSE] + 1;
   if i < Linecode then begin
      r[c, i, CR_CLAUSE] := v;
      r[c, Linecode, CR_CLAUSE] := i
   end
end;


procedure CreateClauses(var r: RelRec; n: integer);
var
   a: integer;	(* clause atom *)
   c: integer;	(* clause *)
   p: integer;	(* phrase atom *)
   d: integer;	(* distance *)
   u: char;	(* unit *)
begin
   for a := 1 to n do begin
      c := r[a, ClauseNr];
      p := 1;
      while Clauses[a, p, CR_FUN] <> 0 do begin
	 AddConstituent(Clauses, c, Clauses[a, p, CR_FUN]);
	 p := p + 1
      end;
      DistDecode(r[a, distCCR], CCR_BASE, d, u);
      if (u = 'C') and (r[a, ClConstRel] in CCR_Set) then begin
	 c := r[a + d, ClauseNr];
	 AddConstituent(Clauses, c, r[a, ClConstRel])
      end
   end
end;


function EmptyPhrase(c, p: integer): boolean;
var
   l: lexeme;
begin
   l := phrases[c, p];
   EmptyPhrase := (l = L_NULL) or (l = L_LSHIFT) or (l = L_RSHIFT)
end;


function FirstCAtom(m, d: integer): boolean;
(* Is daughter [d] the first clause atom of the clause? *)
begin
   FirstCAtom :=
      (m = -1) or
      (Relations[d, ClauseNr] <> Relations[m, ClauseNr])
end;


function PosParallel(m, d: integer;
   p1, p2: integer; E: SmallSet; var n: integer): boolean;
(* Return whether the phrase positions [p1..p2] in the daughter are
   parallel to those in the mother, when disregarding the exempt
   positions in set E. In `n' the number of jointly occupied phrase
   positions is returned. *)
var
   p: integer;	(* phrase position *)
   eq: boolean;	(* equivalence *)
begin
   eq := true;
   n := 0;
   p := p1;
   while eq and (p <= p2) do begin
      if not EmptyPhrase(m, p) or not EmptyPhrase(d, p) then begin
	 if (phrases[m, p] = phrases[d, p]) then
	    n := n + 1
	 else
	    eq := p in E
      end;
      p := p + 1
   end;
   PosParallel := eq
end;


function PosSubset(m, d: integer;
   p1, p2: integer; E: SmallSet; var n: integer): boolean;
(* Return whether the phrase positions [p1..p2] in the daughter are a
   proper subset of those in the mother, when disregarding the exempt
   positions in set E. In `n' the number of jointly occupied phrase
   positions is returned. *)
var
   o: integer;	(* occupied by mother *)
   p: integer;	(* phrase position *)
   eq: boolean;	(* equivalence *)
begin
   eq := true;
   n := 0;
   o := 0;
   p := p1;
   while eq and (p <= p2) do begin
      if EmptyPhrase(m, p) then
	 eq := EmptyPhrase(d, p)
      else begin
	 o := o + 1;
	 if (phrases[m, p] = phrases[d, p]) then
	    n := n + 1
	 else
	    eq := EmptyPhrase(d, p) or (p in E)
      end;
      p := p + 1
   end;
   PosSubset := eq and (o <> 0)
end;


function CAtom_Parallel(m, d: integer): boolean;
(* Return whether mother and daughter are parallel clause atoms. *)
var
   n: integer;		(* number of parallel phrase positions *)
   sd: boolean;		(* subject present in daughter *)
   sm: boolean;		(* subject present in mother *)
begin
   sm := ExplicitSubject(m);
   sd := ExplicitSubject(d);
   CAtom_Parallel := 
      (sm = sd) and
      (subtypes[d, 1] = subtypes[m, 1]) and
      not Subordinated(d, m) and
      PosParallel(m, d, PR_COOR + 1, PR_PRED_SFX, ParaSet, n)
end;


function VerbalTenseCode(m, d: integer): integer;
(* The verbal tense code is built from the predicates of the daughter
   and the mother clause. That is `clause', not `clause atom'. *)
var
   r: integer;	(* result *)
   v: integer;
begin
   r := 0;
   if CL_Lookup(Clause_Tense(d), CL_PRED, v) then
      r := r + 10 * v;
   if CL_Lookup(Clause_Tense(m), CL_PRED, v) then
      r := r + v;
   VerbalTenseCode := r
end;


function InQuotation(c: integer):boolean;
(* Return whether c is in a direct speech section. Note that at this
   stage, Text Type is neither guaranteed to be available nor to be
   reliable. *)
var
   m: integer;	(* mother *)
begin
   m := Relations[c, UserMam];
   while (subtypes[c, 2] = '.') and (m <> CAR_ROOT) do begin
      c := m;
      m := Relations[c, UserMam]
   end;
   InQuotation :=
      (subtypes[c, 2] = 'q') or (TtyDomain(txt, c) = TTY_QUOTATION)
end;


function IsQuoting(c: integer):boolean;
(* Return whether c has a daughter with an instruction 'q'. We have to
   do a sequential search, because at the point this function is called
   the relation codes are not available yet. *)
var
   d: integer;	(* daughter *)
   r: boolean;	(* result *)
begin
   r := false;
   d := c;
   while not r and (d < NumberOfLines) do begin
      d := d + 1;
      r := (c = Relations[d, UserMam]) and (subtypes[d, 2] = 'q')
   end;
   IsQuoting := r
end;


function Code_Quot(d: integer; var c: integer):boolean;
(* The relation CARC_Quot is issued to the daughter of an introduction
   of direct speech with a verbum dicendi or the daughter confirming
   direct speech opening a (small) paragraph with a verbum dicendi *)
var
   m: integer;	(* mother *)
begin
   m := Relations[d, UserMam];
   if (m = CAR_ROOT) or not
      (ParMark(d) and
       (Relations[m, UserTab] < Relations[d, UserTab]) and
       (CAtom_Quot(m) and (subtypes[d, 2] = 'q')
        or	(* recess *)
        CAtom_Quot(d) and InQuotation(m) and
        (ConstituentIndex(d, CR_FUN, PredSet + PreCSet) = 1) and
	not IsQuoting(d)))
   then
      Code_Quot := false
   else begin
      c := CARC_Quot;
      Code_Quot := true
   end
end;


function Code_Rela(d: integer; var c: integer): boolean;
var
   class: integer;
begin
   if not RelaClause(d) then 
      Code_Rela := false
   else begin
      if (phrases[d, PR_VT] = L_NULL) or
	 not CL_Lookup(phrases[d, PR_VT], CL_PRED, class)
      then 
	 c := CARC_Rela
      else 
	 c := CARC_Rela + class;
      Code_Rela := true
   end
end;


function Code_Defc(d: integer; var c: integer): boolean;
var
   m: integer;	(* mother *)
begin
   m := Relations[d, UserMam];
   if FirstCAtom(m, d) then
      Code_Defc := false
   else begin
      if ConstituentIndex(m, CR_FUN, PredSet + PreCSet) <> 0 then 
	 c := 223
      else if ConstituentIndex(d, CR_FUN, PredSet + PreCSet) <> 0 then 
	 c := 222
      else 
	 c := 220;
      Code_Defc := true
   end
end;


function Code_Prep(d: integer; var c: integer): boolean;
(* This function replaces Code_InfC. It is intended for daughter
   clause atoms with a nominal verb form in the VP, headed by a
   preposition with a function in the main clause atom.
   It only applies if there is no subordinating conjunction (Ex 5:13).
   A typical example is the L-InfC atom. *)
var
   class: integer;
begin
   if CAtom_Socj(d) or
      not NominalVerb(d) or
      not CL_Lookup(phrases[d, PR_PREP], CL_NMVB, class)
   then 
      Code_Prep := false
   else begin
      c := CARC_Prep + class;
      Code_Prep := true
   end
end;


function Code_Para(d: integer; var c: integer): boolean;
var
   m: integer;
begin
   m := Relations[d, UserMam];
   if not CAtom_Parallel(m, d) then
      Code_Para := false
   else begin
      c := 200 + ord(phrases[m, PR_COOR] <> phrases[d, PR_COOR]);
      Code_Para := true
   end
end;


function Code_CjAd(d: integer; var c: integer): boolean;
(* The opening constituent is a conjunctive adverb *)
var
   i: integer;	(* phrase index *)
   m: integer;	(* mother *)
begin
   m := Relations[d, UserMam];
   i := OpeningConstituent(d);
   if (i = 0) or not ConjunctiveAdvP(d, i) then
      Code_CjAd := false
   else begin
      c := CARC_CjAd + VerbalTenseCode(m, d);
      Code_CjAd := true
   end
end;


function Code_Asyn(d: integer; var c: integer): boolean;
var
   m: integer;	(* mother *)
begin
   m := Relations[d, UserMam];
   if phrases[d, PR_CONJ] <> L_NULL then
      Code_Asyn := false
   else begin
      c := CARC_Asyn + VerbalTenseCode(m, d);
      Code_Asyn := true
   end
end;


function Code_Conj(d: integer; var c: integer): boolean;
var
   class: integer;
   found: boolean;
   i: integer;	(* Index of clause opening CP *)
   p: integer;	(* Position of clause opening CP *)
begin
   p := Conjunction(d);
   i := PAtom_PosIndex(d, p);
   if i = 0 then
      found := false
   else if phrases[d, p] = L_RSHIFT then
      found := CL_Lookup(phrases[d, PR_PREP], CL_PREP, class)
   else
      found := CL_Lookup(phrases[d, p], CL_CONJ, class) or
	       CL_Lookup(phrases[d, p], CL_PREP, class);
   if found then
      c := class + VerbalTenseCode(Relations[d, UserMam], d)
   else if i <> 0 then begin
      message('syn04types: clause atom ', d:1,
	 ': Cannot handle clause opening CP');
      Quit
   end;
   Code_Conj := found
end;


function CAtomCode(i: integer): integer;
var
   c: integer;
begin
   if Code_Defc(i, c) or
      Code_Para(i, c) or
      Code_Quot(i, c) or
      Code_Rela(i, c) or
      Code_Prep(i, c) or
      Code_Conj(i, c) or
      Code_CjAd(i, c) or
      Code_Asyn(i, c)
   then
      CAtomCode := c
   else
      CAtomCode := CAR_UNKNOWN
end;


procedure AssignCodes(var r: RelRec; n: integer);
var
   i: integer;
   m: integer;	(* mother *)
   d: integer;	(* distance *)
   t: integer;	(* type *)
begin
   for i := 1 to n do
      ClearCARC(r, i);
   for i := 1 to n do begin
      m := r[i, UserMam];
      if m <> CAR_ROOT then begin
	 d := m - i;
	 t := CAtomCode(i);
	 AddRelation(r, i, d, t);
	 AddRelation(r, m, -d, t)
      end
   end
end;


procedure AssignTypes(var r: RelRec; n: integer);
(* Assign clause type and clause atom type to clause atom [1..n] *)
var
   c: integer;	(* clause *)
   i: integer;
begin
   for i := 1 to n do begin
      SetClauseLabel(i);
      c := r[i, ClauseNr];
      r[i, ClauseT] := ClauseType(c, subtypes[c][1], CR_CLAUSE)
   end
end;


procedure UpdateTabs;                              { Store Usertabs of previous decisions }
var p,q : integer;
begin
    for p := 1 to MAXLines do
	begin for q := MaxTabs downto UserTab+1 do
	      Relations[p, q] := Relations[p, q-1];
	      {
	      for q := UserTab to MaxTabs do
	      write(Relations[p,q]:3);
	  writeln(Relations[p, MaxTabs]);
	  }
        end;
end;


procedure ReadClauseTypesList;
(* The file ClTypesList hasd been phased out in favour of
   ClauseLabel4(3hebrew) and ClauseType4(3hebrew) *)
var
   i: integer;
   v: integer;
begin
   i := 1;
   clauseTR[i] := ClauseLabel4(CT_Defc) + ' ';
   i := i + 1;
   clauseTR[i] := ClauseLabel4(CT_Unkn) + ' ';
   for v := CT_Null to CT_XPos do
      if ClauseLabel4(v) <> '' then begin
	 i := i + 1;
	 clauseTR[i] := ClauseLabel4(v) + ' ';
	 clauseTV[i] := v
      end;
   assert(i < PARSELISTSIZE);
   MAXClTypes := i;
   clauseTR[i + 1] := L_EMPTY
end;


procedure ReadCodesList
(var f: text; var lab: clausetyperec; var val: codesvalrec);
const
   CL_EOS = '-----';	(* End of section in CodesList *)
var
   i: integer;
   l: lexeme;		(* lemma *)
   s: integer;		(* section *)
   v: integer;		(* value *)
   eos: boolean;	(* end of section *)
begin
   i := 0;
   s := 0;
   while not eof(f) do begin	(* read section *)
      s := s + 1;
      eos := false;
      repeat			(* read entry *)
	 read(f, l);
	 if l = CL_EOS then
	    eos := true
	 else begin
	    if i < PARSELISTSIZE then
	       i := i + 1
	    else begin
	       message('syn04types: CodesList, line ', i + s:1,
		  ': List size exceeded');
	       pcexit(1)
	    end;
	    if ReadInteger(f, v) then begin
	       lab[i] := l;
	       val[i] := v
	    end else begin
	       message('syn04types: CodesList, line ', i + s - 1:1,
		  ': Need an integer value');
	       pcexit(1)
	    end;
	 end;
	 readln(f)
      until eos or eof(f);
      CL_LastEntry[s] := i
   end;
   if i = 0 then begin
      message('syn04types: Error: CodesList is empty');
      pcexit(1)
   end
end;


procedure CandList_Add(var L: CandListType; var A: CandType);
begin
   with L do begin
      if size < CANDLIST_MAX then
	 size := size + 1
      else begin
	 message('Candidates list: Maximum number of candidates (',
	    CANDLIST_MAX:1, ') exceeded');
	 Quit
      end;
      list[size] := A
   end
end;


procedure CandList_Clear(var L: CandListType);
begin
   L.size := 0
end;


function CandList_FindMam(var L: CandListType; m: integer): integer;
(* Return the index of the candidate with clause atom number m *)
var
   i: integer;
   r: integer;	(* result *)
begin
   r := 0;
   i := 1;
   with L do
      while (r = 0) and (i <= size) do
	 if list[i].mam = m then
	    r := i
	 else
	    i := i + 1;
   CandList_FindMam := r
end;


procedure PrintOrder(var L: CandListType);
var
   i: integer;
begin
   write('{ ');
   with L do
      for i := 1 to size do
	 write(list[i].mam:1, ' ');
   writeln('}');
end;


procedure CandList_Sort(var L: CandListType);
(* Simple insertion sort, ideal for short lists *)
var
   C: CandType;
   i, j: integer;
begin
   with L do 
      if size > 0 then 
	 for i := size - 1 downto 1 do begin
	    j := i + 1;
	    C := list[i];
	    if C.score < list[j].score then begin
	       repeat
		  list[j - 1] := list[j];
		  j := j + 1
	       until (j = size + 1) or (C.score >= list[j].score);
	       list[j - 1] := C
	    end
	 end
end;


procedure ReadQuotAct;
var p, mq, dq : integer;
    error     : integer;
    ch        : char;
begin
   error := 0;
     open(Qa, 'QuotActorsList', 'old', error);
     if error <> 0 then
     begin
	writeln('file QuotActorsList  is empty');
	p := 1; QuotAct[p, 1] := 110; QuotAct[p,2] := Subj;
     end
     else
 begin writeln('... reading file QuotActorsList');
   p:= 0;
   reset(Qa);
   for p := 1 to 100 do for dq := 1 to 2 do
   QuotAct[p, dq] := 0;
   p:= 0;
   while not eof(Qa) do
   begin
     read(Qa, dq);   { daughter.PNG }
     repeat read(Qa,ch) until ch = '<'; read(Qa,ch);
     readln(Qa, mq);
     p := p+1;
     QuotAct[p, 1] := dq; QuotAct[p,2] := mq;
     { writeln(dq:5,' <<',mq:5);
     }
   end;
 end;
   MAXQuotAct := p; writeln(' maximum of lines read from QuotActersList:',MAXQuotAct:5);
end;

procedure WriteQuotACT;
var p         : integer;
begin p:= 0;
  rewrite(Qa);
  for p := 1 to MAXQuotAct do
  begin
    writeln(Qa, (QuotAct[p, 1]):5,' <<',(QuotAct[p,2]):5);
  end;
end;


procedure ReadClauseTotRelations;
var
   error,
   p, q        : integer;
   max, freq   : integer;
   ch	       : char;
begin
   TextName := '   ';
     error := 0;
     for p := 1 to 30 do
	 for q := 1 to 30 do clausesTOT[p,q] := 0;
   open(clfreqtot, 'ClFreqTot', 'old', error);
   if error <> 0 then writeln(' file ClFreqTot does not yet exist')
   else
   begin
     reset(clfreqtot);
     readln(clfreqtot); { labels }
     readln(clfreqtot); { line   }
     p := 0;
     q := 0;
     max := 30;

     repeat
        p := p+1; q := 0;
	   repeat read(clfreqtot, ch)  {; write(ch)}
	   until ch = '|';             {label}
	   while not eoln(clfreqtot) do
	   begin q := q+1;
		 read(clfreqtot, freq, ch);
		 if ch = '+' then max := q;  { max number of labels}
		 clausesTOT[p,q] := freq; { write(freq:4);
					  }
           end;
	   readln(clfreqtot);
	   readln(clfreqtot);
	   { writeln; }
     until p = max+1;

     rewrite(NamesLst);
     while not eof(clfreqtot) do
     begin
       readln(clfreqtot, TextName); writeln(NamesLst, TextName);
     end;

   end;
end;


procedure AdaptClauseTotRelations;
var
   p, q : integer;
begin
  for p := 1 to MAXClTypes+1 do
      for q := 1 to MAXClTypes+1 do

      clausesTOT[p,q] := clausesTOT[p,q] + clauseCM[p,q];

end;


function ClauseTypeIndex(var l: lexeme): integer;
var
   i: integer;
   found: boolean;
begin
   found := false;
   i := 1;
   while not found and (i <= MAXClTypes) do
      if clauseTR[i] = l then
	 found := true
      else
	 i := i + 1;
   if not found then
      ClauseTypeIndex := 0
   else
      ClauseTypeIndex := i
end;


procedure WriteCompareClauseTypes;
var
    p, q, r,  max, tot  : integer;
begin
    rewrite(clfreq);
    writeln(clfreq, PericopeName);
    if TextName = '   ' then
    open(clfreqtot, 'ClFreqTot', 'new');
    reset(NamesLst);
    rewrite(clfreqtot);
    max := 0;
    tot := 0;
    for p:= 1 to MAXClTypes do
	begin max := 0;
	      for q := 1 to MAXClTypes do
	      max := max + clauseCM[p,q];
	      clauseCM[p,q+1] := max;
        end;
    for q:= 1 to MAXClTypes do
	begin max := 0;
	      for p := 1 to MAXClTypes do
	      max := max + clauseCM[p,q];
	      clauseCM[p+1,q] := max;
        end;

    for p := 1 to MAXClTypes do
	tot := tot + clauseCM[MAXClTypes+1, p];
	clauseCM[MAXClTypes+1, MAXClTypes+1] := tot;
	{check :}
	tot := 0;
    for p := 1 to MAXClTypes do
	tot := tot + clauseCM[p, MAXClTypes+1];
	if clauseCM[MAXClTypes+1, MAXClTypes+1] <> tot
	then writeln(' maxima of rows and columns do not fit!');

    AdaptClauseTotRelations;

    write(clfreq,'     |');
                 write(clfreqtot,'     |');
    for p := 1 to MAXClTypes+1 do
	begin if p = MAXClTypes then begin write(clfreq,clauseTR[p],'+');
					   write(clfreqtot,clauseTR[p],'+');
				     end
	      else                   begin write(clfreq,clauseTR[p],'|');
					   write(clfreqtot,clauseTR[p],'|');
				     end;
        end;
        writeln(clfreq);
        writeln(clfreqtot);
    write(clfreq,'     +');
                 write(clfreqtot,'     +');
    for p := 1 to (MAXClTypes+1)*6 do
	if p mod 6 = 0 then begin write(clfreq,'+');
				  write(clfreqtot,'+');
			    end
	else                begin write(clfreq,'-');
				  write(clfreqtot,'-');
			    end;
	     writeln(clfreq);
	     writeln(clfreqtot);
    for q := 1 to MAXClTypes+1 do
	begin for r := 1 to 4 do
	      write(clfreq,clauseTR[q],'|');
              write(clfreqtot,clauseTR[q],'|');
	      for p := 1 to MAXClTypes+1 do
		       begin
			   if clauseCM[q,p] > 0 then write(clfreq,(clauseCM[q,p]):5)
			   else                      write(clfreq,L_EMPTY);
			   if clausesTOT[q,p] > 0 then write(clfreqtot,(clausesTOT[q,p]):5)
		           else                        write(clfreqtot,'    0');
			   if p = MAXClTypes then begin write(clfreq,'+');
				                        write(clfreqtot,'+');
                                                  end
			   else                   begin write(clfreq,'|');
				                        write(clfreqtot,'|');
                                                  end
		       end;
	      writeln(clfreq);
	      writeln(clfreqtot);
              write(clfreq,'     +');
	      write(clfreqtot,'     +');
	      if q = MAXClTypes
	      then begin
                   for p := 1 to (MAXClTypes+1)*6 do begin write(clfreq,'+');
							   write(clfreqtot,'+');
						     end;
		   end else
		   begin
                     for p := 1 to (MAXClTypes+1)*6 do
	                 if p mod 6 = 0 then begin write(clfreq,'+');
						   write(clfreqtot,'+')
					     end
			 else                begin write(clfreq,'-');
						   write(clfreqtot,'-')
					     end;
		   end;
	                writeln(clfreq);
	                writeln(clfreqtot);
        end;
    while not eof(NamesLst) do
    begin readln(NamesLst, TextName); writeln(clfreqtot, TextName);
    end;
    writeln(clfreqtot, PericopeName);  { add name of new matrix }

end;


function CodePNG(w: integer): integer;
var
   c: integer;	(* code *)
   k: integer;	(* column *)
begin
   c := 0;
   for k := KO_PS to KO_GN do
      c := 10 * c + max(0, ko[w, k]);
   CodePNG := c
end;


procedure WritePNG(c: integer; var f: text);
var
   k: integer;	(* column *)
   s: packed array[KO_PS..KO_GN] of char;
   x: integer;
begin
   for k := KO_GN downto KO_PS do begin
      x := c mod 10;
      if x = 0 then
	 s[k] := '-'
      else
	 s[k] := PNG_Letters[k, (x - 1) mod N_PNG + 1];
      c := c div 10
   end;
   write(f, s, '  ')
end;


procedure WriteLb (i : integer; var f : text);
begin
  case i of -1, 0, 1, 2 : write(f,'   . ');
	           3, 4 : write(f,'Subj ');
		      5 : write(f,'Sbsf ');
                   6, 7 : write(f,' Obj ');
		      8 : write(f,'Obsf ');
                      9 : write(f,'Cmpl ');
                     10 : write(f,'Cmsf ');
     11, 12, 13, 14, 15 : write(f,'Adju ');
     otherwise write(f, 'label ',i:5,' is not found in casestatement in "WriteLb" ');
  end;

end;

procedure WriteActors;
var p, q, r, parnum,
    PNG       : integer;
    id        : boolean;
    ch: char;
begin
  reset(ct4); parnum := 0;
  writeln(rep);
  write(rep, '                  VPrd Nprd Subj Sbj2 Sbsf Obj  Obj2 Obsf Cmpl Cmsf Other ');
  write(rep, '                    Actors present               ');
  write(rep, '                    #NUM LOWTAB'); writeln(rep);
  writeln(rep);
  for p := 1 to MAXLines do
      begin for q := 1 to 11 do
	    begin read(ct4,ch); write(rep, ch);
	    end;
	    readln(ct4); id := true;
            for q := 1 to 8 do begin write(rep,txt[p,q]);
				     if txt[p+1,q] <> txt[p,q] then id := false;
                               end;
	    for q := 1 to 15 do
	    if Actors[p,q] > -1 then WritePNG(Actors[p,q],rep)
				else write(rep,'   . ');
	    for q := INVENT to 24 do
	    if Actors[p,q] > -1 then WriteLb(Actors[p,q], rep)
				{ write(rep,(Actors[p,q]):2,' . ')  }
				else write(rep,'   . ');
	    for q := HIT to LOWTAB do
	    if Actors[p, q] > -1 then write(rep,(Actors[p, q]):3)
				else write(rep, '  .');;
            writeln(rep);
	    for q := 1 to 19 do write(rep,' ');
	    for q := 1 to 24 do
		begin PNGlex := ActLex[p,q];
		      for r := 1 to 5 do if PNGlex[r] in ['/', '[']
			       then write(rep, ' ') else write(rep,PNGlex[r])
		end;
            writeln(rep);
	    if (not(id)) or (subtypes[p+1,2] in ['#','N'])          { PATTERN of ACTORS }
	    then begin parnum := parnum +1;
		       for q := 1 to 75 do write(rep,' ');
		       write(rep,'Pattern of Actors: ');
		       for q := INVENT to PARstart-1 do
			   begin PNG := APattern[parnum, q];
				 if PNG > 0 then
			         WritePNG(PNG, rep) else write(rep,' --- ');
			   end;
                       writeln(rep);
		       for q := 1 to 75 do write(rep,' ');
		       write(rep,'     Main Lexemes: ');
		       for q := INVENT to PARstart-1 do
		           for r := 1 to 5 do if APatlex[parnum, q, r] in ['/', '[', '=']
					 then write(rep, ' ') else write(rep,APatlex[parnum,q,r]);
                       writeln(rep);
                       writeln(rep);
                 end;
	    if not(id) then             begin write(rep,'           =');
				              for q := 1 to 30 do write(rep,'==');
				              writeln(rep);
	                                end;
            if subtypes[p+1,2]='#' then begin write(rep,'           -');
				              for q := 1 to 30 do write(rep,'--');
				              writeln(rep);
					end else
            if subtypes[p+1,2]='N' then begin write(rep,'           =');
				              for q := 1 to 30 do write(rep,' =');
	                                      writeln(rep);
                                        end;
      end;
end;


function RecodePrs(i: integer): integer;
(* See Section 2.17 of Description of Quest II Data File Format *)
begin
   case i of
      0:
	 RecodePrs := 0;
      2, 3:
	 RecodePrs := 110;
      4:
	 RecodePrs := 212;
      5, 24:
	 RecodePrs := 211;
      6, 7, 20, 22:
	 RecodePrs := 312;
      8:
	 RecodePrs := 311;
      9, 25:
	 RecodePrs := 130;
      10, 23:
	 RecodePrs := 232;
      11:
	 RecodePrs := 231;
      12, 13, 14, 21:
	 RecodePrs := 332;
      15, 16:
	 RecodePrs := 331;
      otherwise
	 RecodePrs := -1
   end
end;


procedure ReadLine;
var i,j,
cod, afst,
vorcod, vorafst,
preTAB, TAB,
phrasepos   : integer;
preverb,
complexphrase: boolean;
ch        : char;
ll: LexListType;

   procedure FillActors(NumOfL, pars, PNG, SFX: integer; var Actorscol, ActSUFcol: integer; var PNGlex : phrlex);
   var y : integer;
   begin
     Actorscol := 0;
     { write(PNGlex); }
			      {writeln(' PNG:',PNG:5);}
			      if PNG < 0 then
			      begin writeln(' error in PNG of:');
			            writeln(' PNGlex:',PNGlex);
				    PNG := -PNG
			      end;
     case pars of Pred: begin Actors[NumOfL, Vpred] := PNG; ActLex[NumOfL, Vpred] := PNGlex;
			     Actorscol := Vpred; ActSUFcol := 0;
		       end;
		  PreC: begin Actors[NumOfL, Npred] := PNG; ActLex[NumOfL, Npred] := PNGlex;
			     if SFX > 0 then begin Actors[NumOfL, Subjsfx] := SFX;
						   ActLex[NumOfL, Subjsfx] := L_SUFFIX;
			                           Actorscol := Npred;
						   ActSUFcol := Subjsfx;
                                             end;
		       end;
		  Subj, Voct, Frnt, IrpS:
		       begin if Actors[NumOfL, Subject] > -1 then
			begin Actors[NumOfL,Subj2] := PNG; ActLex[NumOfL,Subj2] := PNGlex;
			      Actorscol := Subj2;
                        end else
		        begin Actors[NumOfL, Subject] := PNG;
			      ActLex[NumOfL,Subject] := PNGlex;
			      Actorscol := Subject;
                        end;
			     if SFX > 0 then begin Actors[NumOfL, Subjsfx] := SFX;
						   ActLex[NumOfL, Subjsfx] := L_SUFFIX;
						   ActSUFcol := Subjsfx;
                                             end;
		       end;
		  PreS, PtSp:
		       begin Actors[NumOfL, Subjsfx] := SFX;ActLex[NumOfL,Subjsfx] := L_SUFFIX;
			     Actorscol := Subjsfx; ActSUFcol := 0;
		             Actors[NumOfL, Subject] := PNG;   ActLex[NumOfL,Subject] := PNGlex;
		       end;
		  IntS, ModS, NCoS, ExsS:
		       begin Actors[NumOfL, Subjsfx] := PNG;ActLex[NumOfL,Subjsfx] := L_SUFFIX;
			     Actorscol := Subjsfx;ActSUFcol := 0;
                       end;
		  Objc, IrpO:
		       begin if (PNG = 0) and (SFX > 0)
			     then begin PNG := SFX; SFX := 0; {prep only}
				  end;
                             if PNG > 0 then
			     begin
			     if Actors[NumOfL, Obj ] > -1 then
				begin
				  Actors[NumOfL, Obj2]:= PNG; ActLex[NumOfL, Obj2] := PNGlex;
				  Actorscol := Obj2; ActSUFcol := 0;
				end
				else
				begin
				  Actors[NumOfL, Obj]:= PNG; ActLex[NumOfL, Obj] := PNGlex;
				  Actorscol := Obj; ActSUFcol := 0;
                                end;
			     end;
			     if SFX > 0 then
			     begin
				Actors[NumOfL, Objsfx] := SFX;
				ActLex[NumOfL, Objsfx] := L_SUFFIX;
			        ActSUFcol := Objsfx;
			     end;
		       end;
		  Cmpl, IrpC:
		       begin { if (PNG = 0) and (SFX > 0)
			     then begin PNG := SFX; SFX := 0; prep only
				  end; }
			     if PNG > 0 then begin Actors[NumOfL, Compl] := PNG;
						   ActLex[NumOfL, Compl] := PNGlex;
						   Actorscol := Compl; ActSUFcol := 0;
					     end;
			     if SFX > 0 then begin Actors[NumOfL, Cmpsfx] := SFX;
						   ActLex[NumOfL, Cmpsfx] := L_SUFFIX;
						   ActSUFcol := Cmpsfx;
					     end;
		       end;
	     Supp, Adju: begin if (PNG = 0) and (SFX > 0)
			     then begin PNG := SFX; SFX := 0; {prep only}
				  end;
			     y := 0; if Actors[NumOfL, Other] > -1 then
			     repeat y := y+1
			     until (Actors[NumOfL, Other+y] = -1) or (y > 5);
			     if y <= 5 then
			           begin Actors[NumOfL, Other+y] := PNG;
			                 ActLex[NumOfL, Other+y] := PNGlex;
					 Actorscol := Other+y; ActSUFcol := 0;
			              if SFX >0 then
					 begin y:= y+1; Actors[NumOfL, Other+y] := SFX;
			                                ActLex[NumOfL, Other+y] := L_SUFFIX;
							ActSUFcol := Other+y;
					 end;
                                   end;
		       end;
		  PreO: begin Actors[NumOfL, Objsfx]:= SFX; ActLex[NumOfL,Objsfx]:= L_SUFFIX;
			     Actors[NumOfL, Vpred ]:= PNG; ActLex[NumOfL, Vpred]:= PNGlex;
			     Actorscol := Vpred; ActSUFcol := Objsfx;
                       end;
		  PtcO: begin Actors[NumOfL, Objsfx]:= SFX; ActLex[NumOfL,Objsfx]:= L_SUFFIX;
			     Actors[NumOfL, Vpred ]:= PNG; ActLex[NumOfL, Vpred]:= PNGlex;
			     Actorscol := Vpred; ActSUFcol := Objsfx;
                       end;
                  otherwise
		       if (pars = 0) or (ParseLabel4(pars) <> '') then begin
			  Actorscol := 0;
			  ActSUFcol := 0
		       end else begin
			  message(versnr, ': Illegal constituent code: ', pars:1);
			  pcexit(1)
                       end
     end;
   end;

   procedure putConstit(AG, NumOfL: integer);
   type CharLine = packed array [1 .. 500] of char;
   var i,g, PH : integer;
	   maxL,
           POS, Spos, Opos, Cpos : integer;
       NextPOS, Lpos, Tpos       : integer;
       MAXpos  : integer;
       CLine,CLine2  : CharLine;
   begin   { doel: herordenen ct4 regel, naar S, O, C, etc. + PNG }
	{writeln('begin putConstit; number of phrase-atoms:', AG:5); }
        for i := 1 to 300 do begin CLine[i] := ' '; CLine2[i] := ' ';
			     end; maxL := 12;
	i := 0; repeat i := i+1; read(ct4,CLine[i])             { surface text }
		until eoln(ct4);
		maxL := i;
        readln(ct4);

       g := 0; POS := 0; MAXpos := 0; NextPOS := 0;
	       Spos := 0; Opos := 30; Cpos := 60;
	       Tpos := 100; Lpos := 125;
       repeat g := g+1; PH := 0;
	      PNGlex := ActLex[0,g];  { take from preliminary storage }
       FillActors(NumOfL, Clauses[NumOfL, g, CR_FUN], Clauses[NumOfL, g, CR_PHRPNG],
				 { parsing                PNG  }
			  Clauses[NumOfL, g, CR_SFXPNG], Clauses[NumOfL, g, CR_PHRACT],
				 { suffix                 constituent}
			  Clauses[NumOfL, g, CR_SFXACT], PNGlex);
				 { constituent in sfx: = col in Actors }

       { app. disturbs count of g }
       {write((Clauses[NumOfL, g, CR_FUN]):4,' group=',g:4, PNGlex); }
       if (Clauses[NumOfL, g, CR_FUN] <> Appo) and (Clauses[NumOfL, g, CR_FUN] <> Spec)
       and (Clauses[NumOfL, g, CR_FUN] <> Para) and (Clauses[NumOfL, g, CR_FUN] <> Link) then
       begin
          if Clauses[NumOfL, g, CR_FUN] in SubjSet
				       {Subj} then begin POS := Spos; NextPOS := 30;
					           end else
          if Clauses[NumOfL, g, CR_FUN] in ObjcSet
                                       {Obj } then begin POS := Opos; NextPOS := 60;
					           end else
          if Clauses[NumOfL, g, CR_FUN] in CmplSet
				       {Comp} then begin POS := Cpos; NextPOS :=100;
					           end else
          if Clauses[NumOfL, g, CR_FUN] = Time  {Time} then begin POS := Tpos; NextPOS :=125;
					           end else
          if Clauses[NumOfL, g, CR_FUN] = Loca  {Loc } then begin POS := Lpos; NextPOS :=150;
					           end else
						   POS := -1;
              if POS >= NextPOS then POS := -1;
         if POS > -1
         then begin

	      PH := 0;
              i := 11; repeat i := i+1; if CLine[i] = '['
					then PH := PH +1 { ; write('PH:',PH:1); }
                       until (PH = g) or (i=maxL);
		       if PH <> g then writeln(' appos; specif; cause some trouble');
                    POS := POS +1; CLine2[POS] := CLine[i];
                    repeat i := i+1; POS := POS +1; CLine2[POS] := CLine[i]
                    until (CLine[i] = ']') or (POS >= NextPOS-1);
			  if NextPOS = 30 then Spos := POS else
			  if NextPOS = 60 then Opos := POS else
			  if NextPOS =100 then Cpos := POS else
			  if NextPOS =125 then Tpos := POS else
			  if NextPOS =150 then Lpos := POS;
		    if MAXpos < POS then MAXpos := POS;
             end;
	end                           {     maakte fouten bij  Exod 33,11; IIKon23,13 }
      until g = AG;                                           { number of phrase_atoms }
      {writeln(' all groups found'); }

      for i := 1 to 11 do write(constit,CLine[i]);
      for i := 1 to MAXpos do write(constit,CLine2[i]);
      { for i := 1 to MAXpos do write(CLine2[i]);
        writeln; }
      writeln(constit);
   end;

   function  findPNG(NL, AG: integer; var linelex:lexemerec):  integer;
   var i, j     : integer;
       PNG      : integer;
       lex	: lexeme;
       stop     : boolean;
   begin
       PNG := 0; stop := false;
       j := NL;
       while not(stop) do
       begin
	j := j-1;
	if j < 1 then stop := true
	else stop := ko[j, KO_PTY] > 0;                        { <>  skip APPos ? }
       end;
        repeat j:= j+1;
	   for i := 1 to LexLength do lex[i] := linelex[j,i];
	   if (PNG = 0) and (ko[j, KO_PDP] = 3) then
	      PNG := 300
	   else
	      PNG := CodePNG(j);
	until ( (ko[j, KO_PDP] in [1,2,3,7,13]) and
		(lex <> 'KL/  ')       )   or (j = NL);
       if j < NL then
       if (ko[j, KO_PDP] = 2) and (ko[j+1, 12] = 3) then j := j+1;   {PNG = noun; lex = ProperN}
       findPNG := PNG;
       for i := 1 to 10 do PNGlex[i] := '.';
       for i := 1 to 5 do
       begin
       PNGlex[i]  := linelex[j,i];
      { if PNGlex[i] in ['/', '['] then PNGlex[i] := ' '; }
       { write(PNGlex[i]); }
       ActLex[0,AG] := PNGlex;    { store preliminarily according to order of phrases }
       end;
   end;


begin                                                            {of ReadLine}
TAB := 0; preTAB := 0; vorafst := 0;
     for i := 1 to MAX_WORDS do
         for j := -1 to 20 do ko[i,j] := -1;
  phrasepos   := 0;
  j := 0;
  NumberOfLines := NumberOfLines + 1;
  for i := PR_COOR to PR_LABEL do
  phrases[NumberOfLines, i] := L_NULL;
   LexList_Clear(ll);
       PHRat:= 0; aantalw := 0; preverb := true;
       PHR := 0;
				  complexphrase := false;
       repeat j := j+1; read(ps4,vvers);
              if j = 1 then versnr := vvers;
              if versnr = vvers then
              begin for i := 1 to LexLength do read(ps4,lex[i]);
	            for i := 1 to LexLength do linelex[j,i]:=lex[i];
                    read(ps4,rest);
                    i := -1;
                    repeat i := i + 1; if not (eoln(ps4)) then read(ps4,ko[j,i])
                    until i = 20;    { parsing in column 19 }
              if versnr = vvers then readln(ps4)
              end
        until (j >1) and (versnr <> vvers); j:= j-1;
        aantalw := j;
   VerseLabelList[NumberOfLines] := substr(versnr, 1, LABEL_LENGTH);
{ writeln(versnr); }
{if NumberOfLines mod 10 = 0 then}
{ write('cnumber of lines read:',NumberOfLines:5); }

   j := 0;
   repeat
      j := j + 1;
      if (ko[j, KO_VBE] >= 0) or (ko[j, KO_NME] >= 0) then 
	 LexList_Add(ll, linelex[j]);
      if ko[j, KO_PTY] <> 0 then begin
	 if PHRat < MAX_PATMS_CATM then
	    PHRat := PHRat + 1
	 else begin
	    message('syn04types: ', versnr, 'clause ', NumberOfLines: 1, ': Too many phrase atoms');
	    pcexit(1)
	 end;
	 Clauses[NumberOfLines, PHRat, CR_PTY] := ko[j, KO_PTY];
	 if PSP then begin
	    Clauses[NumberOfLines, PHRat, CR_FUN] := ko[j, KO_FUN];
	    if not (ko[j, KO_FUN] in DeptSet) then 
	       PHR := PHR + 1
	 end;
	 if ko[j, KO_PTY] = PTY_VP then 
	    preverb := false;
	 if (PHRat > 1) and (lex = L_AND) then begin		{ put "100" in col 20: complex phrase }
	    ko[j, KO_MIL] := 100;
	    complexphrase := true
	 end else begin
	    if not complexphrase then 
	       FillPhrases(NumberOfLines, j, phrasepos);
	    complexphrase := false;
	    Clauses[NumberOfLines, PHRat, CR_REC] := phrasepos;
	    if phrasepos in [PR_NP1..PR_NP6] then 
	       clauselex[NumberOfLines, phrasepos] := ll;
	    LexList_Clear(ll);
	    Clauses[NumberOfLines, PHRat, CR_LEXSET] := LS_Code(ko[j, KO_SP], ko[j, KO_LS]);
	    Clauses[NumberOfLines, PHRat, CR_WORDNR] := j;
	    Clauses[NumberOfLines, PHRat, CR_STATE] := State(j)
	 end;
	 { PNG head of phrase }
	 Clauses[NumberOfLines, PHRat, CR_PHRPNG] := findPNG(PhraseHead(j), PHRat, linelex);
	 { Recode value of SFX to PNG }
	 Clauses[NumberOfLines, PHRat, CR_SFXPNG] := RecodePrs(ko[PhraseLastPrs(j), KO_PRS])
      end;
      Clauses[NumberOfLines, PHRat + 1, CR_PTY] := Linecode;			{ eoln }
      Relations[NumberOfLines, PhrStart] := 1;
      if PSP then 
	 Relations[NumberOfLines, PhrStop] := PHR
      else 
	 Relations[NumberOfLines, PhrStop] := PHRat
   until j = aantalw;

   if PHRat = 0 then begin
      message('syn04types: ', versnr, 'clause ', NumberOfLines:1,
	 ': No phrase atoms');
      pcexit(1)
   end;
      SetClauseLabel(NumberOfLines);

	if PSP then putConstit(PHRat , NumberOfLines);

	if PS5 then
	begin
	   if NumberOfLines = 1 then
	   begin preTAB := 0; TAB := preTAB;
	         Relations[NumberOfLines,TabNum] := TAB;
           end;
	   repeat read(ps4,ch)  { ; write(ch)  }
	   until (ch = '0') or (eoln(ps4));
	   vorafst := 0; vorcod := 0;
	   repeat vorafst := afst; vorcod := cod;
		  read(ps4, afst, cod );
	          {  writeln(afst, cod);  }
		  if afst < 0 {daughter}
		  then begin
			 if vorafst < 0 { previous daughter conn. longest distance }
			 then begin
				Clauses[NumberOfLines+afst, DaughterCode, CR_PTY] := cod;{ downward connections}
				Clauses[NumberOfLines+afst, MotherNum, CR_PTY] := NumberOfLines;
                              end
			 else
			      begin
			        Clauses[NumberOfLines, DaughterCode, CR_PTY] := cod;
				Clauses[NumberOfLines, MotherNum, CR_PTY] := NumberOfLines+afst;
				Relations[NumberOfLines, RelLine] := Clauses[NumberOfLines, MotherNum, CR_PTY];
				Relations[NumberOfLines, TabNum] :=Relations[NumberOfLines+afst, TabNum] +1;
                              end
			        { keep linenumber of "mother" }
                       end
	   until cod = 0;

        end;
	readln(ps4);
	MAXLines := NumberOfLines;
end;               { of  ReadLine }


procedure Argue_Adju(d: integer; var C: CandType);
(* There is no Argue_Cmpl, because in the database complement clauses
   are much more infrequent (3/100) than adjunct clauses and we do not
   have information about valence. *)
begin
   with C do
      if (phrases[d, PR_PREP] <> L_NULL) and
	 (Clauses[d, 1, CR_REC] = PR_VERB) and
	 (Argon_Find(arg, ARGLAB_SHUN, 1) = 0)
      then
	 Argon_Add(arg, ARGLAB_ADJU)
end;


procedure Argue_AsSo(d: integer; var C: CandType);
(* Occurs only 25/57 times in the data base.
   Dt 28 is a good chapter to test this argument. *)
var
   i: integer;
begin
   i := OpeningConstituent(d);
   with C do
      if (phrases[mam, PR_PREP] = L_AS) and
	 (i <> 0) and (Clauses[d, i, CR_LEXSET] = LS_AFAD)
      then
	 Argon_Add(arg, 'KN << K' + substr(phrases[mam, PR_CONJ], 1, 3))
end;


procedure Argue_AsynQ(d: integer; var C: CandType);
(* Asyndetic connection to a verbum dicendi.
   Lv 23 is a good chapter to test this argument. *)
begin
   with C do
      if CAtom_Quot(mam) and (phrases[d, PR_CONJ] = L_NULL) then
	 Argon_Add(arg, ARGLAB_ASYNQ)
end;


procedure Argue_Attr(d: integer; var C: CandType);
(* 2R 23 is a good chapter to test this argument *)
(* TODO: dochterzinnen die beginnen met attributieve (en predicatieve)
   adjectiva en participia *)
begin
   with C do
      if (mam < d) and RelaClause(d) and
	 ((phrases[mam, PR_NP4] <> L_NULL)
	  or
	  (phrases[mam, PR_PNG] = L_NULL) and
	  (phrases[mam, PR_NP1] <> L_NULL))
      then
	 Argon_Add(arg, ARGLAB_ATTR)
end;


procedure Argue_Conj(d: integer; var C: CandType);
(* Both mother and daughter have a subordinating conjunction, but they
   are not the same. Lv 3 is a good chapter to test this argument. *)
begin
   with C do
      if CAtom_Socj(d) and CAtom_Socj(mam) and
	 (phrases[d, PR_CONJ] <> phrases[mam, PR_CONJ])
      then
	 Argon_Add(arg,
	    ArgLab_Pair(phrases[d, PR_CONJ], phrases[mam, PR_CONJ]))
end;


#ifdef OLD_COOR
(*
   In coordination we have syndetic and asyndetic coordination.
   The former is about twice as frequent as the latter.
   Asyndetic coordination shows the nominal form of the verb in
   an identical clause atom opening with at most a
   subordinating conjunction or an opening preposition.
   Syndetic coordination shows either an identical clause atom
   opening (when mother and daughter have the same opening
   preposition or when the mother herself is a coordinated
   clause) or an extra subordinating conjunction in the mother
   or also a continuation with wayyiqtol or weqatal in
   agreement with the predicate of the mother. The daughter is
   not likely to have an explicit subject, nor to be far from
   the mother.
*)

procedure Argue_Coor(d: integer; var C: CandType);
(* The daughter is coordinated to the mother *)
var
   n: integer;		(* number of parallel phrase positions *)
   coor: boolean;
begin
   with C do begin
      if (phrases[d, PR_COOR] = L_NULL) then
	 coor := NominalVerb(d) and
	    SimpleOpening(d, PR_COOR, SubordinationSet) and
	    PosParallel(mam, d, PR_COOR + 1, PR_PNG, ParaSet, n)
      else
	 coor :=
	    CAtom_Socj(mam) and not CAtom_Socj(d) and
	    (PosParallel(mam, d, PR_COOR + 1, PR_PNG, [PR_CONJ] + ParaSet, n) or
	       ((phrases[d, PR_VT] = T_PERF) or
		(phrases[d, PR_VT] = T_WAYQ)) and
	       (phrases[d, PR_PNG] = phrases[mam, PR_PNG])) and
	       (ConstituentIndex(d, CR_FUN, SubjSet) = 0) and
	       (d - mam < 5)
	    or
	    ((phrases[d, PR_PREP] <> L_NULL) or
	     (Relations[mam, ClConstRel] = CCR_Coor)) and
	    PosParallel(mam, d, PR_COOR + 1, PR_PNG, ParaSet, n);
      if coor then
	 Argon_Add(arg, ARGLAB_COOR)
   end
end;
#else

procedure Argue_Coor(d: integer; var C: CandType);
(* The daughter is coordinated to the mother *)
const
   FPP = PR_COOR + 1;	(* first phrase position *)
   LPP = PR_PRED_SFX;	(* last phrase position *)
var
   n: integer;		(* number of parallel phrase positions *)
begin
   with C do begin
      (* Type 1: voortzetting van een CCR *)
      if (Relations[mam, ClConstRel] <> CCR_None)
	 and
	 ((phrases[mam, PR_COOR] = L_NULL) or
	  (phrases[d, PR_COOR] <> L_NULL))
	 and
	 (CAtom_Parallel(mam, d) or
	  PosSubset(mam, d, FPP, LPP, [PR_NEGA] + ParaSet, n) and (n>1))
      then
	 Argon_Add(arg, ARGLAB_COOR)
   end
end;
#endif


procedure Argue_Down(d: integer; var C: CandType);
(* Downwards connected daughters do not have a coordinating
   conjunction and typically have an x-clause type or one of
   InfC or Ptcp. The mother cannot start with a conjunction. *)
var
   d2: integer;	(* digit 2: clause type template *)
   d3: integer;	(* digit 3: verbal tense *)
   ct: boolean;	(* daughter has suitable clause type *)
   cj: boolean;	(* forbidding conjunctions present *)
begin
   with C do begin
      assert(d < mam);
      d2 := typ div 10 mod 10;
      d3 := typ mod 10;
      ct := (d2 in [3, 4]) or (d3 in [VT_INFC, VT_Ptc]);
      cj := CAtom_Cocj(mam) or CAtom_Socj(mam) or CAtom_Cocj(d);
      if ct and not cj then
	 Argon_Add(arg, ARGLAB_DOWN)
      else
	 Argon_Add(arg, ARGLAB_SHUN)
   end
end;


procedure Argue_EachWay
   (d: integer; f: CAtomTester; var C: CandType; t: StringType);
(* Construct an argument based on tag `t' when either mother or
   daughter is true *)
var
   dok, mok: boolean;
begin
   with C do begin
      dok := f^(d);
      mok := f^(mam);
      if dok and mok then
	 Argon_Add(arg, ArgLab_Pair(t, t))
      else begin
	 if dok and not mok then
	    Argon_Add(arg, ArgLab_Pair(t, L_NULL));
	 if mok and not dok then
	    Argon_Add(arg, ArgLab_Pair(L_NULL, t))
      end
   end
end;


procedure Argue_LexPar(d: integer; var C: CandType);
(* Jos 21 is a good chapter to test this argument *)
var
   n: integer;
begin
   with C do begin
      n := LexParLex(d, mam, NP_Columns);
      if n > 0 then
	 Argon_Add(arg, ArgLab_Number(n, ARGLAB_PRLX))
   end
end;


procedure Argue_MSyn(d: integer; var C: CandType);
(* Add an argument to C if daughter d is possibly a macro-syntactic
   signal. Hag 2 is a good chapter to test this argument. *)
var
   i: integer;		(* phrase index of opening constituent *)
   p: integer;		(* phrase position of opening constituent *)
begin
   i := OpeningConstituent(d);
   with C do
      if (mam < d) and (Relations[mam, ClConstRel] = CCR_None) and
	 (CAtom_Size(d) = i)
      then begin
	 p := Clauses[d, i, CR_REC];
	 if (p in [PR_ADVB, PR_INTJ]) or
	    (i = 1) and (phrases[d, p] = L_NPDT)
	 then
	    Argon_Add(arg, ARGLAB_MSYN)
      end
end;


function PredicateSupplier(c: integer; var p: integer): boolean;
(* Return whether clause atom c, or one of its ancestors in case of
   ellipsis, could supply a predicate.
   If true, the predicate supplier is returned in p. *)
begin
   while (c <> CAR_ROOT) and (subtypes[c, 1] = 'l') do
      c := Relations[c, UserMam];
   if (c = CAR_ROOT) or (subtypes[c, 1] <> '.') then
      PredicateSupplier := false
   else begin
      p := c;
      PredicateSupplier := true
   end
end;


procedure Argue_NmCl(d: integer; var C: CandType);
(* Clause kind Nominal Clause = {AjCl, NmCL}.
   Ps 87 is a good chapter to test this argument. *)
var
   p: integer;		(* clause with predicate of the ellipsis *)
   p_d, p_m: integer;
begin
   if (phrases[d, PR_VERB] = L_NULL) then 
      with C do
	 if (phrases[mam, PR_VERB] = L_NULL) and
	    (subtypes[mam, 1] <> 'l') and
	    ConstituentOrder(d, mam, NM_Columns)
	 then
	    Argon_Add(arg, ArgLab_Para(ARGTAG_NMCL, ARGTAG_NMCL))
	 else
	    if PredicateSupplier(mam, p)
	       and		(* Possibly imports the predicate *)
	       ((ConstituentIndex(d, CR_FUN, PreCSet) = 0) or
		(ConstituentIndex(p, CR_FUN, PredSet) <> 0) and
		((ConstituentIndex(d, CR_FUN, PreCSet) = 0) =
		 (ConstituentIndex(p, CR_FUN, PreCSet) = 0)))
	       and		(* Has corresponding constituents *)
	       (ColParCol(d, mam, NP_Columns, NP_Columns,
			       addr(Lab_Agreement), p_d, p_m) or
	        ColParCol(d, mam, SFX_Columns, SFX_Columns,
			    addr(Lab_Agreement), p_d, p_m) or
	        ColParCol(d, mam, SFX_Columns, PNG_Columns,
			    addr(PNG_Agreement), p_d, p_m))
	    then
	       Argon_Add(arg, ARGLAB_ELLP)
end;


procedure Argue_Noref(d: integer; var C: CandType);
(* None of the referring elements in the daughter clause atom refers to
   the mother. Ps 81 is a good chapter to test this argument. *)
var
   p_d, p_m: integer;
begin
   with C do
      if (PosCount(d, SFX_Columns) > 0) and
	 (LexParLex(d, mam, NP_Columns) = 0) and
	 not ColParCol(d, mam, SFX_Columns, PNG_Columns,
			 addr(PNG_Agreement), p_d, p_m) and
	 not ColParCol(d, mam, SFX_Columns, PRPS_Columns,
			 addr(Lab_Agreement), p_d, p_m) and
	 not ColParCol(d, mam, SFX_Columns, SFX_Columns,
			 addr(Lab_Agreement), p_d, p_m)
      then
	    Argon_Add(arg, ARGLAB_NOREF)
end;


procedure Argue_Objc(d: integer; var C: CandType);
(* Da 5 and Ex 16 are good chapters for testing this argument *)
const
   CJVB_OBJC	= CARC_Post;
var
   i: integer;		(* phrase index of opening constituent *)
begin
   i := OpeningConstituent(d);
   with C do
      if (ConstituentIndex(mam, CR_FUN, ObjcSet) = 0) and
	 (Argon_Find(arg, ARGLAB_SHUN, 1) = 0) and (
	    (* E.g. JD< + CP(KJ) *)
	    (Parsing(d, PR_CONJ) = Conj) and
	    CjVbList_Find(CjVbList, phrases[mam, PR_VERB], CJVB_OBJC)
	    or
	    (* E.g. QVL + CP(>T >CR) *)
	    (Parsing(d, PR_CONJ) = Rela) and
	    (phrases[d, PR_PREP] = L_OBJC)
	    or
	    (* E.g. JD< + IPrP(MH) *)
	    ((i = 1) and (Clauses[d, i, CR_REC] = PR_INRG)) and
	    CjVbList_Find(CjVbList, phrases[mam, PR_VERB], CJVB_OBJC)
      ) then
	 Argon_Add(arg, ARGLAB_OBJC)
end;


procedure Argue_PNG(d: integer; var C: CandType);
(* Hi 2 and 8 are good chapters to test these arguments *)
var
   p_d, p_m: integer;
begin
   with C do begin
      if ColParCol(d, mam, PNG_Columns, PNG_Columns,
			 addr(PNG_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_PNG, ARGTAG_PNG))
      else begin
	 if ColParCol(d, mam, PNG_Columns, PNG_Columns,
			    addr(Ps_Agreement), p_d, p_m) then
	    Argon_Add(arg, ArgLab_Pair(ARGTAG_PS, ARGTAG_PS));
	 if ColParCol(d, mam, PNG_Columns, PNG_Columns,
			    addr(Nu_Agreement), p_d, p_m) then
	    Argon_Add(arg, ArgLab_Pair(ARGTAG_NU, ARGTAG_NU))
      end;
      if ColParCol(d, mam, PRPS_Columns, PNG_Columns,
			 addr(PNG_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_PRPS, ARGTAG_PNG));
      if ColParCol(d, mam, PNG_Columns, PRPS_Columns,
			 addr(PNG_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_PNG, ARGTAG_PRPS));
      if ColParCol(d, mam, SFX_Columns, PNG_Columns,
			 addr(PNG_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_SFX, ARGTAG_PNG));
      if ColParCol(d, mam, PNG_Columns, SFX_Columns,
			 addr(PNG_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_PNG, ARGTAG_SFX))
   end
end;


procedure Argue_PaPP(d: integer; var C: CandType);
(* Argument of parallel preposition phrases.
   Jos 21 is a good chapter to test this argument. *)
var
   p_d, p_m: integer;
begin
   with C do
      if ColParCol(d, mam, NP_Columns, NP_Columns,
			 addr(PP_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Para(phrases[d, p_d], phrases[mam, p_m]))
end;


procedure Argue_PreC(d: integer; var C: CandType);
(* The daughter is the predicate of the mother clause.
   Depends on the result of Argue_Subj. *)
begin
   with C do
      if (phrases[d, PR_COOR] = L_NULL) and
	 ((ConstituentIndex(mam, CR_FUN, SubjSet) <> 0) or
	    (Argon_Find(arg, ARGLAB_SUBJ, 1) <> 0)) and
	 (ConstituentIndex(mam, CR_FUN, PredSet + PreCSet) = 0) and
	 (subtypes[mam, 1] = '.') and (mam + 1 = d)
      then
	 Argon_Add(arg, ARGLAB_PREC)
end;


procedure Vorfeld(var A: ArgonType;
   m, d: integer; c: char; p1, p2: integer; E: SmallSet);
(* Add the argument for Vorfeld `c' that runs from phrase position
   p1 to p2, disregarding the exempt positions in E. *)
var
   n: integer;
begin
   if PosParallel(m, d, p1, p2, E, n) then
      Argon_Add(A, ArgLab_Number(ord(n>0), ARGTAG_PREV + c + 'par'))
   else if PosSubset(m, d, p1, p2, E, n) then
      Argon_Add(A, ArgLab_Number(ord(n>0), ARGTAG_PREV + c + 'sub'))
end;


#ifndef TOCH_MAAR_WEL_ZERO_OPENING
#define ZeroOpening(A,m,d)	null
#else
function ZLab(c: integer): StringType;
(* Return the argument label for a zero clause opening *)
var
   t: integer;	(* verbal tense *)
begin
   if (phrases[c, PR_VT] = L_NULL) or
      not CL_Lookup(phrases[c, PR_VT], CL_PRED, t)
   then
      ZLab := ''
   else if t in VT_Finite then
      ZLab := phrases[c, PR_CLAB]
   else
      ZLab := ARGTAG_ZERO
end;


procedure ZeroOpening(var A: ArgonType; m, d: integer);
var
   l_d, l_m: StringType;
begin
   l_d := ZLab(d);
   l_m := ZLab(m);
   if (length(l_d) <> 0) and (length(l_m) <> 0) and
      ((l_d = ARGTAG_ZERO) or (l_m = ARGTAG_ZERO))
   then
      Argon_Add(A, ArgLab_Pair(l_d, l_m))
end;
#endif


procedure Argue_PreV(d: integer; var C: CandType);
(* Identical pre-verbal elements *)
var
   n: integer;		(* number of parallel phrase positions *)
begin
   with C do
      if PosParallel(mam, d, PR_COOR + 1, PR_VERB - 1, [], n) then
	 if n = 0 then
	    ZeroOpening(arg, mam, d)
	 else
	    Argon_Add(arg, ArgLab_Number(ord(n>1), ARGLAB_PREV))
      else begin
	 Vorfeld(arg, mam, d, '1', PR_COOR+1, PR_PRDE1-1, [PR_NEGA]);
	 Vorfeld(arg, mam, d, '2', PR_PRDE1, PR_VERB - 1, [])
      end
end;


procedure Argue_Pron(d: integer; var C: CandType);
var
   p_d, p_m: integer;
begin
   with C do begin
      if ColParCol(d, mam, SFX_Columns, SFX_Columns,
			 addr(Lab_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_SFX, ARGTAG_SFX));
      if ColParCol(d, mam, PRPS_Columns, SFX_Columns,
			 addr(Lab_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_PRPS, ARGTAG_SFX));
      if ColParCol(d, mam, SFX_Columns, PRPS_Columns,
			 addr(Lab_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_SFX, ARGTAG_PRPS));
      if ColParCol(d, mam, PRPS_Columns, PRPS_Columns,
			 addr(Lab_Agreement), p_d, p_m) then
	 Argon_Add(arg, ArgLab_Pair(ARGTAG_PRPS, ARGTAG_PRPS))
   end
end;


procedure Argue_ReVo(d: integer; var C: CandType);
(* The mother is a vocative referred to by the daughter *)
begin
   with C do
      if ((ConstituentIndex(mam, CR_FUN, [Voct]) > 0) or
	  (subtypes[mam, 1] = 'v')) and
	 Person(d, 2)
      then
	 Argon_Add(arg, ARGLAB_REVO)
end;


procedure Argue_Reop(d: integer; var C: CandType);
(* The mother is an interrupted clause opening repeated and completed
   by the daughter *)
var
   n: integer;		(* number of parallel phrase positions *)
   p: integer;		(* last phrase position of mother *)
begin
   with C do begin
      p := Clauses[mam, CAtom_Size(mam), CR_REC];
      if (subtypes[mam, 1] = 'r') and
	 PosParallel(mam, d, PR_COOR, p, [], n)
      then
	 Argon_Add(arg, ARGLAB_REOP)
   end
end;


procedure Argue_Resu(d: integer; var C: CandType);
(* The mother is a casus pendens resumed by the daughter *)
begin
   with C do
      if ((ConstituentIndex(mam, CR_FUN, FrntSet) > 0) or
	  (subtypes[mam, 1] = 'c')) and
	 ResumptiveOpening(d)
      then
	 Argon_Add(arg, ARGLAB_RESU)
end;


procedure Argue_RgRc(d: integer; var C: CandType);
(* The last phrase atom of the mother ends in a construct state *)
var
   n: integer;	(* number of phrase atoms in mother *)
begin
   with C do begin
      n := CAtom_Size(mam);
      if (Clauses[mam, n, CR_STATE] = ST_C) and
	 (phrases[mam, PR_VT] <> T_INFC) and
	 (Relations[mam, MaxCodes] = 0) and
	 (phrases[d, PR_COOR] = L_NULL)
      then
	 Argon_Add(arg, ARGLAB_RGRC)
   end
end;


procedure Argue_Shift(d: integer; var C: CandType);
var
   d12, m12: boolean;
begin
   with C do begin
      d12 := Person(d, 1) or Person(d, 2);
      m12 := Person(mam, 1) or Person(mam, 2);
      if d12 and not m12 then
	 Argon_Add(arg, ARGLAB_3TO12);
      if m12 and not d12 then
	 Argon_Add(arg, ARGLAB_12TO3);
      d12 := PersonToPerson(d, 1, 2) and PersonToPerson(mam, 2, 1);
      m12 := PersonToPerson(mam, 1, 2) and PersonToPerson(d, 2, 1);
      if d12 or m12 then
	 Argon_Add(arg, ARGLAB_12T21)
   end
end;


(* Subjectszinnetjes hebben een lege zinsopening of alleen een
   conjunctie uit 500 op PR_CONJ en een nominale vorm van het
   werkwoord. Kenmerkend voor de moeder is dat ze geen onderwerp
   heeft en dat de zinsopening ook leeg is of maar een phrase
   bevat. Verder geen werkwoord in de eerste of tweede persoon.
   TODO: Kan dit worden uitgebreid met >CR + finiete werkwoordsvorm,
   bijvoorbeeld na passief predicaat zonder uitbreidingen? *)

procedure Argue_Subj(d: integer; var C: CandType);
(* Dt 27 is a good chapter for testing this argument *)
var
   class: integer;
begin
   with C do
      if (ConstituentIndex(mam, CR_FUN, SubjSet) = 0) and
	 (Argon_Find(arg, ARGLAB_SHUN, 1) = 0) and
	 not (phrases[mam, PR_PNG][1] in ['1', '2']) and
	 SimpleOpening(mam, PR_COOR, SingleSet)
	 and
	 NominalVerb(d) and
	 SimpleOpening(d, PR_CONJ, []) and
	 CL_Lookup(phrases[d, PR_CONJ], CL_CONJ, class) and
	 (class = CARC_Post)
      then
	 Argon_Add(arg, ARGLAB_SUBJ)
end;


procedure Argue_VLex(d: integer; var C: CandType);
begin
   with C do
      if Lab_Agreement(phrases[d, PR_VERB], phrases[mam, PR_VERB]) then
	 Argon_Add(arg, ARGLAB_VLEX)
end;


procedure Argue_VSeq(d: integer; var C: CandType);
(* Does not make sense for downward connections *)
var
   p_d, p_m: integer;
begin
   with C do
      if ColParCol(d, mam, VT_Columns, VT_Columns,
			 addr(Lab_Agreement), p_d, p_m) then
	 Argon_Add(arg, ARGLAB_VBT)
      else
	 Argon_Add(arg,
	    ArgLab_Pair(CType2Label(typ), phrases[mam, PR_CLAB]))
end;


procedure Argue_WHNH(d: integer; var C: CandType);
(* Lv 13 is a good chapter to test this argument *)
const CJVB_WHNH	= 467;
begin
   with C do
      if (phrases[d, PR_COOR] <> L_NULL) and
	 (phrases[d, PR_INTJ] <> L_NULL) and
	 CjVbList_Find(CjVbList, phrases[mam, PR_VERB], CJVB_WHNH)
      then
	 Argon_Add(arg, ARGLAB_WHNH)
end;


procedure Argue_XPos(d: integer; var C: CandType);
(* The daughter is a preceding constituent put outside the clause
   boundary of the mother *)
var
   p: integer;	(* phrase function *)
begin
   p := Clauses[d, 1, CR_FUN];
   with C do
      if (d < mam) and (CAtom_Size(d) = 1) and 
	 (Clauses[d, 1, CR_REC] = PR_NP1) and
	 (ConstituentIndex(d, CR_FUN, PredSet + PreCSet) = 0) and
	 (phrases[mam, PR_CONJ] = L_NULL) and
	 (ConstituentIndex(mam, CR_FUN, [p]) = 0) and
	 (ConstituentIndex(mam, CR_FUN, PredSet + PreCSet) <> 0)
      then
	 Argon_Add(arg, ARGLAB_XPOS)
end;


function PiecewiseContinuous(m, d: integer): boolean;
(* Return whether d could be a daughter that continues clause m *)
begin
   PiecewiseContinuous := (m < d - 1) and
      (subtypes[m, 1] in ['.', 'd']) and
      (subtypes[d, 1] in ['.', 'd']) and
      not (CAtom_Cocj(d) or CAtom_Socj(d)) and
      ((ConstituentIndex(m, CR_FUN, PredSet + PreCSet) = 0) or
       (ConstituentIndex(d, CR_FUN, PredSet + PreCSet) = 0)) and
      ((ConstituentIndex(m, CR_FUN, SubjSet) = 0) or
       (ConstituentIndex(d, CR_FUN, SubjSet) = 0))
end;


function Embedded(d: integer; var C: CandType): boolean;
(* Return whether candidate mother C is likely to embed daughter d *)
begin
   with C do
      Embedded := (d - mam = 1) and (d < MAXLines) and
	 SimpleOpening(d + 1, 0, [PR_NEGA]) and 
	 SimpleOpening(d, PR_PREP, SingleSet) and 
         SimpleOpening(mam, PR_CONJ, SingleSet) and
	 PiecewiseContinuous(mam, d + 1)
end;


function Cand_ConstituentClause(d: integer; var C: CandType): boolean;
(* Return whether candidate C supports d as a constituent clause *)
begin
   with C do
      Cand_ConstituentClause :=
	 (phrases[d, PR_PREP] <> L_NULL) or
	 (Argon_Find(arg, ARGLAB_OBJC, 1) <> 0) or
	 (Argon_Find(arg, ARGLAB_PREC, 1) <> 0) or
	 (Argon_Find(arg, ARGLAB_SUBJ, 1) <> 0)
end;


function Cand_Defc(var C: CandType; d: integer): boolean;
(* Return whether candidate mother C is likely to leave d defective *)
var
   d_initial, d_after_e: boolean;
   WP: boolean;		(* without predication *)
begin
   WP := ConstituentIndex(d, CR_FUN, PredSet + PreCSet) = 0;
   with C do begin
      d_initial :=
	 SimpleOpening(d, PR_CONJ, SingleSet) and
	 SimpleOpening(mam, PR_CONJ, SingleSet);
      d_after_e :=
	 (subtypes[d - 1, 2] = 'e') or
	 PiecewiseContinuous(mam, d)
   end;
   Cand_Defc := WP and (d_initial or d_after_e)
end;


procedure Cand_SetSub(var C: CandType; d: integer);
begin
   with C do begin
      if ConstituentIndex(d, CR_FUN, [Voct]) <> 0 then
	 sub[1] := 'v'
      else if ConstituentIndex(d, CR_FUN, FrntSet) <> 0 then
	 sub[1] := 'c'
      else if Argon_Find(arg, ARGLAB_ELLP, 1) <> 0 then
	 sub[1] := 'l'
      else if Argon_Find(arg, ARGLAB_XPOS, 1) <> 0 then
	 sub[1] := 'x'
      else if Cand_Defc(C, d) then
	 sub[1] := 'd'
      else if Argon_Find(arg, ARGLAB_MSYN, 1) <> 0 then
	 sub[1] := 'm'
      else
	 sub[1] := '.';
      if (mam = CAR_ROOT) then
	 sub[2] := 'N'
      else if (arg.c_quo > 0) and not IsQuoting(mam) then
	 sub[2] := 'q'
      else if d < mam then
	 sub[2] := '\'
      else if (typ = CT_WayX) or (typ = CT_WXQt) then
	 sub[2] := '#'
      else if Embedded(d, C) then
	 sub[2] := 'e'
      else
	 sub[2] := '.';
   end
end;


procedure ScoreCand(d: integer; var C: CandType);
(* Score candidate mother C for daughter d *)
begin
   with C do begin
      if (d < mam) and not
	 (Cand_ConstituentClause(d, C) or
	    (Argon_Find(arg, ARGLAB_DOWN, 1) <> 0))
      then
	 score := 0
      else
	 score := arg.c_dis * arg.c_val;
      paral :=
	 (arg.c_par > 0) and
	 (phrases[mam, PR_COOR] = phrases[d, PR_COOR]) and
	 (CAtom_Parallel(mam, d) or ParMark(d));
      quote := sub[2] = 'q'
   end
end;


procedure printscore(d: integer; var C: CandType);
var
   i: integer;
begin
   with C do begin
      for i := 1 to TEXTTYPE_SIZE do
	 write(txt[mam, i]);
      write(d:3, ' -->', mam:4, ' dist:', d - mam:3);
      write(' SCORE: ', score:6:3);
      write(' Tab=', Relations[mam, UserTab]:3, ' ', sub);
      if paral then
	 write(' Parallel')
      else
	 write('   INDENT');
      if quote then
	 write(' [Q]');
      writeln
   end
end;


procedure argumentation(d: integer; var C: CandType);
(* Provide candidate C with the argumentation for being a suitable
   mother for daughter d *)
begin
   Argon_Clear(C.arg);
   if d < C.mam then begin
      Argue_Down(d, C);
      Argue_XPos(d, C)
   end else begin
      Argue_VSeq(d, C);
      Argue_EachWay(d, addr(CAtom_Quot), C, ARGTAG_QUOT);
      Argue_EachWay(d, addr(CAtom_Ques), C, ARGTAG_QUES);
      Argue_EachWay(d, addr(CAtom_Cocj), C, ARGTAG_COCJ);
      Argue_VLex(d, C);
      Argue_PreV(d, C);
      Argue_LexPar(d, C);
      Argue_NmCl(d, C);
      Argue_EachWay(d, addr(CAtom_Socj), C, ARGTAG_SOCJ);
      Argue_PaPP(d, C);
      Argue_Coor(d, C);
      Argue_Shift(d, C);
      Argue_PNG(d, C);
      Argue_EachWay(d, addr(PostVerbNPdet), C, ARGTAG_NPD2);
      Argue_EachWay(d, addr(PreVerbNPdet), C, ARGTAG_NPD1);
      Argue_EachWay(d, addr(ExplicitSubject), C, ARGTAG_SUBJ);
      Argue_Pron(d, C);
      Argue_Noref(d, C);
      Argue_MSyn(d, C);
      Argue_Attr(d, C);
      Argue_AsynQ(d, C);
      Argue_Resu(d, C);
      Argue_Conj(d, C);
      Argue_RgRc(d, C);
      Argue_WHNH(d, C);
      Argue_ReVo(d, C);
      Argue_AsSo(d, C);
      Argue_Reop(d, C)
   end;
   Argue_Adju(d, C);
   Argue_Objc(d, C);
   Argue_Subj(d, C);
   Argue_PreC(d, C);
   Argon_Eval(C.arg, abs(d - C.mam))
end;


procedure WriteUserTabs(answer : char);
var i, j, j2, x, r     : integer;
begin
  if NOustabs = true then open(ustabs, PericopeName + '.usertab', 'new');
  rewrite(ustabs);

  if StopLine > 0 then x := StopLine else x:= MAXLines;
  for i := 1 to x do
    begin
      if answer = 'y' then
      begin
      Relations[i,TabNum ] := Relations[i,UserTab ];
      Relations[i,RelLine] := Relations[i,UserMam ];
      end;
      if subtypes[i,1] = ' ' then
      write  (ustabs,'.') else
      write  (ustabs, subtypes [i,1]);
      if subtypes[i,2] = ' ' then
      write  (ustabs,'.') else
      write  (ustabs, subtypes [i,2],' ');
      write  (ustabs, 'T', (Relations[i,TabNum]):3,':');
      write(ustabs,' L',i:5,':');

      { EXPER model:
      for y := 1 to Linecode do
      begin
	 if Clauses[i, y, CR_FUN] > Appo
	 then begin write(ustabs,':', y:4,(Clauses[i, y, CR_PHRDIS]):4, (Clauses[i, y, CR_PHRNUM]):4);
	      end;
      end;
      }
	    CLN   := Relations[i, ClauseNr];
	    SnNr  := Relations[i, SentenceNr];
	    Phr1  := Relations[i, PhrStart];
	    Phrl  := Relations[i, PhrStop];
	    Clty  := Relations[i, ClauseT];
		     if Relations[i, ClauseT2] > Clty then
		     Clty  := Relations[i, ClauseT2]; {original usertb cod}
	    CCRty := Relations[i, ClConstRel];
	    CCRdis:= Relations[i, distCCR];

      write(ustabs,' C', CLN:4,':');
      write(ustabs,' P1',Phr1:4,':');
      write(ustabs,' Pl',Phrl:4,':');
      write(ustabs,' Cty',Clty:5,':');
      write(ustabs,' CCR', CCRty:4,':');
      write(ustabs,' dis', CCRdis:6,':');
      write(ustabs,' S', SnNr:4,': ');

                for r := 1 to 8 do
		       write(ustabs, txt[i,r]);                   { texttype }
                write(ustabs, ': ');
		WritePargr(ustabs, partxt, i);
	  write(ustabs, ':', phrases[i, PR_CLAB]);
          write(ustabs, '#');

  { EXPER printcodes(line); }
      j := ClCodes-1;   { const 33   NEW}
      {j := UserTab-1;    const 5 }
	   repeat j := j+2; j2:= j+1;
		  write(ustabs, (Relations[i, j]):4, (Relations[i, j2]):4);
	   until (  (Relations[i,j] = 0 ) and (Relations[i,j2] = 0) )
	{	or (j2 >= MaxTabs); }
                or (j2 >= MaxCodes);

      writeln(ustabs);

    end;

end;  {of WriteUserTabs}


procedure UnlistedClauseType(a: integer);
begin
   write('Clause atom ', a:1, ': ');
   write('Unlisted clause type label: ');
   writeln(phrases[a, PR_CLAB])
end;


procedure RelFrequencies;
var
   d, m: integer;	(* daughter, mother *)
   dci, mci: integer;	(* index of clause type label *)
begin
   for d := 1 to min(StopLine, MAXLines) do begin
      m := Relations[d, UserMam];
      if m = CAR_ROOT then
	 writeln('Clause atom ', d:1, ' is a root.')
      else begin
	 mci := ClauseTypeIndex(phrases[m, PR_CLAB]);
	 if mci = 0 then
	    UnlistedClauseType(m);
	 dci := ClauseTypeIndex(phrases[d, PR_CLAB]);
	 if dci = 0 then
	    UnlistedClauseType(d);
	 if (mci <> 0) and (dci <> 0) then
	    clauseCM[dci, mci] := clauseCM[dci, mci] + 1
      end
   end
end;


procedure WriteClConnLabel(var f: text; c: integer);
begin
   write(f, phrases[c, PR_CLAB]);
   if Relations[c, ClConstRel] <> CCR_None then
      write(f, CCR_Label(Relations[c, ClConstRel]))
   else begin
      if subtypes[c, 2] = '\' then
	 write(f, ' >> ')
      else
	 write(f, ' << ');
      if Relations[c, UserMam] = CAR_ROOT then
	 write(f, L_ROOT)
      else if subtypes[c, 2] = 'q' then
	 write(f, L_QUOT)
      else if Relations[c, UserMam] > 0 then
	 write(f, phrases[Relations[c, UserMam], PR_CLAB])
      else
	 write(f, L_UNKN)
   end
end;


procedure WriteRelMode(var f: text; m: integer);
begin
   case m of
      -1:
	 write(f, '   ');
      0:
	 write(f, 'par');
      1:
	 write(f, 'dep');
      2:
	 write(f, 'dir')
   end
end;


procedure WritePhrasePositions
   (var f: text; var l: PosLabListType; var p: phraserec; n: integer);
const
   L_LINE = '====|';	(* Line under label in heading *)
var
   c: integer;		(* Clause atom index *)
   i: integer;		(* Column index *)
begin
   write(f, L_EMPTY);
   for i := PR_COOR to PR_LABEL do
      write(f, l[i]);
   writeln(f);
   write(f, L_EMPTY);
   for i := PR_COOR to PR_LABEL do
      write(f, L_LINE);
   writeln(f);
   writeln(f);
   for c := 1 to n do begin
      write(f, '[',  Clauses[c, DaughterCode, CR_PTY]:3, ']');
      for i := PR_COOR to PR_LABEL do
	 write(f, p[c, i]);
      write(f, ' ', VerseLabelList[c], ' ', c:3, ' ');
      WriteRelMode(f, Relations[c, RelMode]);
      writeln(f, ' ', Relations[c, UserMam]:3)
   end
end;


procedure WritePhrases;
type
   testTAB = array [0..TABS_MAX] of integer;
var i,j,k,kk, r,
    tabpos, tb  : integer;
    blockchar, ch: char;
    tT : testTAB;
    startdomain, stopdomain,
    VERBLESS, NOMPRED,
    id  : boolean;

begin LongestLine := 0;
      reset(ct4);
      if PSP then reset(constit);
      rewrite(act);
      for r := 1 to 10 do txtTAB[r] := 0;

for j := 1 to StopLine {MAXLines} do
begin
       { clause code }
  {alan}
{ write(cl4,'[');if j < 10 then write(cl4,'00',j:1) else
		 if j < 100 then write(cl4,'0',j:2) else write(cl4, j:3);
  r := Relations[j, UserMam];
  write(cl4, '<<'); if r < 10 then write(cl4,'00',r:1) else
		    if r < 100 then write(cl4,'0',r:2) else write(cl4, r:3);write(cl4,'] ');
} {alan}
   for r := 0 to TABS_MAX do
      tT[r] := 0;
   if j > 1 then begin
      tabpos := 0;
      if Relations[j, UserTab] > 0 then begin
	 i := j;
	 for r := Relations[j, UserTab] downto 0 do begin
	    repeat
	       i := i + 1
	    until (Relations[i, UserTab] <= r) or (j = MAXLines);
	    if (Relations[i, UserTab] = r) and (r <= TABS_MAX) then
	       tT[r] := 1			{ 1: connection line }
	    else
	       i := i - 1
	 end
      end;
	r := 0;
        id := true; stopdomain := false; startdomain := false;
	blockchar := '=';
	repeat r := r+1;
	       if txt[j-1,r] <> txt[j,r]
	       then begin id := false;
			  {if (txt[j,r] = '?') or (txt[j-1,r] = '?')
			  then id := true;
			  }
			  if ((txt[j,r] = 'N') and (txt[j-1,r] = ' '))
			  or ((txt[j,r] = ' ') and (txt[j-1,r] = 'N'))
			  then blockchar := '-' else
			  if ((txt[j,r] = 'D') and (txt[j-1,r] = ' '))
			  or ((txt[j,r] = ' ') and (txt[j-1,r] = 'D'))
			  then blockchar := '-' else
			  blockchar := '=';
                    end;
		    if id = false then
		    begin
			  tabpos := r;
			  if txt[j-1,r] = ' ' then  { only in case of further embedding }
			  begin startdomain :=true;
		                txtTAB[r] := Relations[j, UserTab];
				{ if pos connection ... }
				if subtypes[j,2] = '\'
				then begin
				       kk := j; repeat kk := kk +1
				       until (Relations[kk, UserTab] < Relations[j, UserTab])
					     or (kk > MAXLines);
                                       if kk <= MAXLines then txtTAB[r] := Relations[kk, UserTab];
				     end;
			  end else stopdomain := true;
		    end
	until (r=10) or (id = false);
        if not(id) then begin {
			for k := 1 to 6 do write(CTT,(txtTAB[k]):2); writeln(CTT);
			}
			write(CTT,'                               ');
			if blockchar = '-' then write(CTT,'-------') else
			write(CTT,'=======');
			write(CTT,'                 ');
			write(act,' ----------------');
			  k := INVENT-1; repeat k := k+1; write (act, Actors[j-1, k])
				   until (k = 20) or (Actors[j, k] < 0);
			writeln(act);
			tb := txtTAB[tabpos];

			kk := 2;
			for k := 1 to tb do begin
			   if k = txtTAB[kk] then begin
			      if k = tb then begin
				 if (k - 1 <= TABS_MAX) and (tT[k - 1] = 1) then
				    write(CTT, '  |+')
				 else
				    write(CTT, '   +')
			      end else begin
				 if (k - 1 <= TABS_MAX) and (tT[k - 1] = 1) then
				    write(CTT, '  ||')
				 else
				    write(CTT, '   |')
			      end;
			      kk := kk + 1
			   end else begin
			      if (k - 1 <= TABS_MAX) and (tT[k - 1] = 1) then
				 write(CTT, '  | ')
			      else
				 write(CTT, '    ')
			   end
			end;
			k := 140 - (43 + tb*4);
			{
			if startdomain then write(CTT,'/') else write(CTT,'\');
			}
			if k > tabpos*3 then
			repeat k := k-1; write(CTT,blockchar)
			until k = tabpos*3;
			if startdomain then write(CTT,'\') else write(CTT,'/');
			writeln(CTT);
			  if txt[j,r] = ' ' then  { only in case of end of embedding }
			  begin
			    txtTAB[r] := Relations[j, UserTab];
			    for k := r to 10 do txtTAB[k] := 0;
			  end;
			end;
  end;
     { writeln('WritePhrases: CTT tabs ok');
     }

   VERBLESS := true;
   NOMPRED := false;
   i := 0;
   repeat
      i := i + 1;
      if Clauses[j, i, CR_FUN] in PredSet then
	 VERBLESS := false
      else if Clauses[j, i, CR_FUN] in CopuSet then
	 NOMPRED := true;
      assert(i < Linecode)
   until Clauses[j, i + 1, CR_PTY] = Linecode;
   NOMPRED := NOMPRED and VERBLESS;
   CLT[j, verbless] := VERBLESS;
   CLT[j, nompred] := NOMPRED;
  i:= 0;
  repeat i := i+1; read(ct4,ch);
	 if (ch = ' ') and ( i > 1) then
				 begin write(cl4,'0'); if VERBLESS then write(vblcl, '0'); end
				 else begin write(cl4, ch); if VERBLESS then write(vblcl,ch); end;
				 write(CTT, ch)          { text with tabs }
  until i = 10; write(cl4,' '); write(CTT,' '); if VERBLESS then write(vblcl,' ');
  {alan}
  write(cl4, {phrases[j, PR_CONJ],} phrases[j, PR_VERB], phrases[j, PR_VS]);
  if VERBLESS then write(vblcl, {phrases[j, PR_CONJ],} phrases[j, PR_VERB], phrases[j, PR_VS]);
  write(CTT, { phrases[j, PR_LABEL],} phrases[j, PR_PNG]);

  WriteClConnLabel(CTT, j);
  write(CTT, ' ');
  if PSP then for i := 1 to 11 do begin read(constit,ch); write(act,ch);
				  end;
  for i := 1 to 8 do begin write(CTT, txt[j,i]);
			   write(act, txt[j,i]);
                     end;
  WritePargrPart(CTT, partxt[j], 6);
  write(CTT, j:3,' ');

  if Relations[j, TabNum] > -1 then
  begin
        write(CTT, (Relations[j, TabNum]):2);
	write(CTT,subtypes[j,1], subtypes[j,2]);
								 { from subtypes ? }

  end
  else begin write(CTT,'?  ');
       end;

      write(CTT, '  ');
      tb := Relations[j, UserTab];
      k := 2;
      if tb > 0 then
	 for i := 1 to tb do begin		{ mark Quot sections }
	    if (k <= SUBPAR_MAX) and (i = txtTAB[k]) then begin
	       if (k - 1 <= TABS_MAX) and (tT[k - 1] = 1) then
		  write(CTT, '  ||')
	       else
		  write(CTT, '   |');
	       k := k + 1
	    end else begin
	       if (i - 1 <= TABS_MAX) and (tT[i - 1] = 1) then
		  write(CTT, '  | ')
	       else
		  write(CTT, '    ')
	    end
	 end;
   {alan}
   i := 0;
   repeat
      i := i + 1;
      write(cl4, Clauses[j, i, CR_PTY]: 3, ':');
      if VERBLESS then
	 write(vblcl, Clauses[j, i, CR_PTY]: 3, ':');
      if PSP then begin
	 k := Clauses[j, i, CR_FUN];
	 write(cl4, ParseLabel4(k), ' ');
	 if VERBLESS then
	    write(vblcl, ParseLabel4(k), ' ')
      end;
      if (Clauses[j, i, CR_PTY] = 5) or (Clauses[j, i, CR_PTY] = 6) and (i < 3) then begin
	 write(cl4, ' ', phrases[j, Clauses[j, i, CR_REC]]);
	 if VERBLESS then
	    write(vblcl, ' ', phrases[j, Clauses[j, i, CR_REC]])
      end else begin
	 write(cl4, '      ');
	 if VERBLESS then
	    write(vblcl, '      ')
      end;
      assert(i < Linecode)
   until Clauses[j, i + 1, CR_PTY] = Linecode;
      { writeln (' CTT line started1');
      }
   (* TODO: Kijken naar rep
   if Interactive and (1 < j) and (j <= StopLine) and (Relations[j, RelLine] > 0) then
      argumentation(j, j - Relations[j, RelLine], Arguments.list[i], rep);
      *)
(* writeln(' CTT line started2') *)
	write(cl4, 99);
        kk := 0;
        repeat read(ct4,ch); write(CTT,ch);write(cl4,ch); if VERBLESS then write(vblcl, ch);
	       kk := kk +1                                              { write ct4 TEXT }
        until eoln(ct4);
	if kk > LongestLine then LongestLine := kk;
	if PSP then
	while not eoln(constit) do begin read(constit,ch); write(act,ch);
				   end;
  writeln(CTT);
  readln(ct4);
  if PSP then readln(constit); writeln(act);
  writeln(cl4);
  if VERBLESS then writeln(vblcl, ch);
  { writeln (' CTT line finished');
  }
end;

    {  writeln('WritePhrases: END ok'); }

end;


function LowerCase(c: char): char;
var
   t: packed array [ord('A')..ord('Z')] of char;
begin
   if (c < 'A') or ('Z' < c) then
      LowerCase := c
   else begin
      t := 'abvdefghiyklmnopqrstujwxcz';
      LowerCase := t[ord(c)]
   end
end;


procedure ReverseCTT;
const
    verseIndex = 10;
    PngIndex = 15;
    ClLabIndex = 30;
    TxtTyIndex = 39;
    PrgIndex   = 45;
    LNrIndex   = 49;
    TabIndex   = 54;

type textline = array [1..LineLength] of char;

var SHORT, WORD,
    InterLine : boolean;
    p,q,r,
    StartTxt,
    versind : integer;
    ln,ln1  : textline;
    ch      : char;
    marker  : boolean;
begin
   open(CTTrev, PericopeName + '.CTT.rev', 'unknown');
   rewrite(CTTrev);
   writeln(' Longest Line in CTT[text] = ',LongestLine:4,' characters');
   {  LongestLine := 150;  }
   writeln(' FULL labeling? [y/n]'); repeat read(ch) until ch in ['n','y','j'];
   if ch = 'n' then SHORT := true else SHORT := false;
   WORD := false;
   writeln(' Do you need a preparation other than for WordPerfect?  [ diff. reversal of Hebrew sections] ');
   repeat read(ch) until ch in ['n','y','j'];
	  if ch = 'n' then WORD := false else WORD := true;

   for p := 1 to LineLength do ln1[p] := ' ';
   reset(CTT);
   versind := 1; StartTxt := TabIndex;
     while not eof(CTT) do
     begin for p := 1 to LineLength do ln1[p] := ' ';
           p := 0;
           marker := false; { versind := 1; }
	   StartTxt := TabIndex; InterLine := false;
	   while not eoln(CTT) do                                     { read line }
	   begin
	     read(CTT,ch); p := p+1; ln[p] := ch;
		if (ch in ['+', '[', '='] ) and (StartTxt <= TabIndex)
		then begin StartTxt := p; if ch in ['=', '+'] then InterLine := true
					  else InterLine := false;
		     end;
		if ch = ',' then versind := p+1;
		if (ln[p] = ' ') and ( p > TabIndex)
		then begin
		       if (ln[p-1] in ['K', 'M', 'N', 'P', 'Y' ]) then
		       case ln[p-1] of 'K' : ln[p-1] :='k';
		                       'M' : ln[p-1] :='m';
		                       'N' : ln[p-1] :='n';
			               'P' : ln[p-1] :='p';
				       'Y' : ln[p-1] :='y';
		       end;

		     end;
		if (p > TabIndex) and (ln[p] = '-') and (not(marker))
		then p := p-1;
		if (p > TabIndex) and (ln[p] = '+') and (ln[p-1] = ' ')
		then marker := true;
	   end;
	   p := p+1; ln[p] := ' ';
	   readln(CTT);
								    { prepare Hebrew Text }
           for q := 1 to TabIndex do ln1[q] := ln[q];
	   q := TabIndex-1; r := TabIndex-1;
	   repeat q := q +1; r := r+1;
		  if ln[q] = '(' then ln1[r] := ')'
			else
		  if ln[q] = ')' then ln1[r] := '('
			else
		  if ln[q] = '[' then
			begin ln1[r] := ']'; r := r+1; ln1[r] := '}';
			      if WORD then begin ln1[r-1] := '['; ln1[r] := '{'; end;
			end else
	          if ln[q] = '<' then
		        begin if ((ln[q+3] = '>') and (ln[q+4] = ']')) or
				 ((ln[q+3] = '>') and (ln[q+4] = '<') and (ln[q+8] = ']'))
		              then begin if ln1[r-1] <> '<' then
			                 begin if WORD then ln1[r] := '}'
						       else ln1[r] := '{'; r := r+1;
					 end;  if WORD then ln1[r] := '<'
						       else ln1[r] := '>';
                                         if not(WORD) then
					 begin
					  ch := ln[q+1]; ln[q+1] := ln[q+2]; ln[q+2] := ch;
					 end;
					 repeat  q := q+1; r := r+1; ln1[r] := ln[q]
					 until ln[q+1] in [ ']' , '<'];
					 if ln[q+1] = ']' then
					 begin  q := q +1; r := r +1;
					       if WORD then
					       begin
						 ln1[r] := ']'; ln1[r-1] := '>';
					       end else
					       begin
					       ln1[r] := '['; ln1[r-1] := '<';
					       end;
					 end else begin if WORD then ln1[r] := '>'
								else ln1[r] := '<';
						  end;
				   end
		              else ln1[r] := ln[q]
			end else
		  if ln[q] = ']' then
			begin ln1[r] := '{'; r := r+1; ln1[r] := '[';
			      if WORD then begin ln1[r-1] := '}'; ln1[r] := ']'; end;
			end else
                  if ln[q] = '.' then
			begin
                        ln1[r] := ln[q];
			q := q+1;     { skip space after '.' }
			end else
                  ln1[r] := ln[q]
           until (q >= p) or (q>=LineLength);

	   if marker then begin
			   r := 0; repeat r := r +1
				   until (ln1[r] in ['/','\']) or (r = LineLength);
			   if ln1[r] in ['/','\']
			   then r := r-4;
			  end;
	   q := r+1;
	   if not (WORD) then                                          { WP format }
	   begin
	      repeat q := q-1; ch := ln1[q];                           { write Hebrew text }
			    write(CTTrev, ch )
	      until q<= TabIndex+1;
	   end else                                                    { WORD format }
	   begin
	     if InterLine then
	     begin for q := p downto TabIndex+1 do write(CTTrev, ln[q]);
	     end else
	     begin
	     {q := StartTxt-1; write(CTTrev, StartTxt:2);
		     repeat q := q +1; write(CTTrev, LowerCase(ln1[q]))
		     until q = r; writeln(CTTrev);
             }
	     q := r+1;
	     while q > StartTxt do
	     begin
	       repeat q := q -1 until (ln1[q] = ']') or (q < StartTxt);    {EndOfPhr}
	       if q > StartTxt then
	       begin
	       write(CTTrev,'[');
	       repeat q := q -1 until (ln1[q] = '}') or (q < StartTxt);    {EndOfHebrew}
	       repeat q := q +1; write(CTTrev, ln1[q])
	       until ln1[q+1] = ']';
	       repeat q := q -1 until ln1[q] = '}';    {EndOfHebrew}
	       write(CTTrev,'{');
	       repeat q := q -1;write(CTTrev, LowerCase(ln1[q]))
	       until ln1[q-1] = '{';                   {BeginOfPhr}
	       write(CTTrev,'}] ');
	       end;
	     end;
             q := StartTxt; repeat q := q -1; write(CTTrev, ln[q])
		     until q = TabIndex+1;
	     end;
	   end;
								       { write labels }
	   if not(SHORT) then
	   for q := LNrIndex+1   to TabIndex do write(CTTrev, ln1[q]); { tabs }
	   for q := PrgIndex+1   to LNrIndex do write(CTTrev, ln1[q]); { lineNr }
	   if not(SHORT) then
	   for q := TxtTyIndex+1 to PrgIndex do write(CTTrev, ln1[q]); { paragrNr }
	   for q := ClLabIndex+1 to TxtTyIndex do write(CTTrev, ln1[q]); { TxtType  }
	   if not(SHORT) then
	   for q := PngIndex+1   to ClLabIndex do write(CTTrev, ln1[q]); { ClLabels }
	   if SHORT then
	   for q := PngIndex+1   to ClLabIndex-9 do write(CTTrev, ln1[q]); { ClLabels }
	   for q := verseIndex+1 to PngIndex+1 do write(CTTrev, ln1[q]); { PNG verb }
	   if not(SHORT) then
	   for q := 1 to verseIndex do write(CTTrev,ln1[q]);             { chap-vers}
	   if SHORT then
	   begin if not(marker) then
	     for q := versind to verseIndex do write(CTTrev,ln1[q])      { chap-vers}
	     else begin
		    for q := versind+1 to verseIndex do write(CTTrev,ln1[q]);
		    write(CTTrev,'.');
		  end;
	   end;
	   writeln(CTTrev);
     end;
   close(CTTrev);
   writeln('the text is written to ',PericopeName + '.CTT.rev');

end;

procedure CalculatePattern(PARGR, n1, n2 : integer);
var col, l,
    PNG,       i : integer;
    emptycol     : boolean;
begin
  emptycol := true;
  col := INVENT-1;
  for i := INVENT to HIT do
      begin APattern[PARGR, i] := -1;
            for l := 1 to 10 do APatlex[PARGR, i,l] := ' ';
      end;
  repeat col := col +1;
     PNG := 0;
     for l := n1 to n2 do
     begin
       if Actors[l, col] >  0 then
      begin emptycol := false;
       PNG := Actors[l, Actors[l, col]];
       if APattern[PARGR, col] < PNG then APattern[PARGR, col] := PNG; {fill in highest value}
       if ActLex[l,col,1] <> ' ' then
       APatlex[PARGR, col] := ActLex[l,col];
	   { for i := 1 to 5 do write(APatlex[PARGR, col,i]);  }
      end;
     end
  until (emptycol) or (col = HIT);
  APattern[PARGR, PARstart] := n1;      { starting line of paragr }
end;

procedure CalculateActors(number: integer);
var bl1, nl, Act, Pargr,
    LowestTab, diff,
    dgroup, mgroup, yy, zz,
    actpos, i,previ, x,y : integer;
    answer : char;
    id, posit, newquot,
    idact, idlex, idconst : boolean;
     xx, kol, Pos : integer;
     dLex,mLex,Lex : phrlex;

  function EmbedPar(xx, num : integer):  boolean;
  { identifies start of pargr; skips embedded parts }
  var id : boolean;
       x : integer;
  begin id := false;
    x := 0;
    repeat x := x +1; if (partxt[xx, x+1] = ' ') and
			 (partxt[num, x+1] > '0')
		      then id := true;
    until (id) or (x = 9);
    EmbedPar := id;
  end;

  function SamePar(xx, num : integer):  boolean;
  { part of same paragraph; skips embedded parts }
  var id : boolean;
       x : integer;
  begin id := true;
    x := 0;
    repeat x := x +1; if partxt[xx, x] <> partxt[num, x]
		      then id := false
    until (not(id)) or (x = 10);
    SamePar := id;
  end;

  function  insertQuotAct(Act, Phrparse : integer): boolean;
  var x, dq, mq  : integer;
      id         : boolean;
  begin
    dq := Act; mq := Phrparse;
    if MAXQuotAct = 0 then
    begin MAXQuotAct := 1; QuotAct[1,1] := dq;
          id := false;	   QuotAct[1,2] := mq;
    end else
    begin
      x := 0; id := false;
      repeat
         x := x +1; if (QuotAct[x, 1] = dq) and (QuotAct[x, 2] = mq)
		    then id := true
      until (id) or (x=MAXQuotAct);
      if not(id) then
      begin MAXQuotAct := MAXQuotAct +1;
	    QuotAct[MAXQuotAct, 1] := dq;
	    QuotAct[MAXQuotAct, 2] := mq;
      end;
    end;
    insertQuotAct := not(id);
  end;

  function  SearchQuotAct(nl, pl, dgroup, Act: integer; Lex : phrlex; var yy, zz: integer) : boolean;
  var x,y        : integer;
      phr,prevl  : integer;
      answer     : char;
      id,dom     : boolean;
  begin
    id := false;
    if MAXQuotAct > 0 then
    begin
    write  (' Search in the preceding domain.');
    write  (' Can you tell what Phrase ',dgroup:3,': ', Lex);
    WritePNG(Act, output); writeln(' refers to?');
    dom := true; prevl := pl;
    repeat pl := pl-1;                                   { SEARCH in lines of preceding domain }
	   y := 0; repeat y := y+1 until partxt[pl,y] = ' ';
		   if not (partxt[nl, y] = '0') then dom := false;
		   writeln('domain line', pl:3,':',dom);
	   phr := 0;
	   repeat phr := phr + 1;
	     x := 0;
	     repeat x := x +1;
		    if (QuotAct[x, 1] = Act) and (Clauses[pl , phr, CR_FUN] = QuotAct[x,2])
		    then id := true
             until (x = MAXQuotAct) or (id=true)
	   until (Clauses[ pl, phr, CR_FUN] < Appo) or (id=true);
	   if id then
	   begin
	   writeln(' Does',Act,' refer to Line',pl:4,' phrase:', phr:3,' ?');
	   repeat read(answer) until answer in ['n','y'];
	   if answer = 'n' then id := false else
	      begin
		yy := pl; zz := phr;
		Clauses[nl, dgroup, CR_PHRDIS] := yy-nl;   {dist.to ref. line}
		Clauses[nl, dgroup, CR_PHRNUM] := zz;   { ref. phrasenr}
		write  (' Phrase',dgroup:3,' refers to Phrase');
		write(zz:3,' in Line',yy:4);
	      end;
	   end
    until (pl = nl-5) or (id = true) or (dom = false);
    if (id=false) {and (dom=true)} then                { not found in lines of preceding domain }
    begin
      writeln(' sqa Any suggestion?   [ y / n ]');
      repeat read (answer) until answer in ['y', 'n'];
	if answer = 'y' then
	  begin writeln(' Which Line?');
	        repeat read(yy) until (yy>0) and (yy< (nl+1));
	        writeln(' Which Phrase?');
	        repeat read(zz) until (zz>0) and (zz< (Linecode+1));
		write  (' Phrase',dgroup:3,' refers to Phrase');
		write(zz:3,' in Line',yy:4);
		write(' TextType: '); for x := 1 to 8 do write(txt[yy,x]);
		writeln;
		Clauses[nl, dgroup, CR_PHRDIS] := yy-nl;   {dist.to ref. line}
		Clauses[nl, dgroup, CR_PHRNUM] := zz;   { ref. phrasenr}
                id := true;
		if yy < prevl then
		begin
		if insertQuotAct(Act,Clauses[yy, zz, CR_FUN]) then
		writeln('NewPattern:', Act:4, ' <<',(Clauses[yy, zz, CR_FUN]):5);
		end;
          end;
    end;
    if id then begin { yy := pl; zz := phr; }
		     writeln(' found by SearchQuotAct:', (Clauses[nl, dgroup, CR_PHRDIS]):4,' =dist');
		     writeln(' found by SearchQuotAct:', (Clauses[nl, dgroup, CR_PHRNUM]):4,' =phrs');
	       end;
    end;
    SearchQuotAct := id;
  end;

begin                                                           {  CalculateActors }
  id := false;
  i := 1; bl1 := 0; Pargr := 0;
  actpos := 0; LowestTab := 25; previ:= 1;
                                                                { test one line only }
     if number > 1 then						{ find pargr num, block, actpos}
     repeat i := i+1; id := true;
        {for x := 1 to 8 do if txt[i, x] <> txt[i-1, x]
			then id := false;
			}
	             if ParMark(i)        {new segment or paragr. atom!}
			then id := false;
        if not(id) then
	   begin LowestTab:= 25; Pargr := Pargr +1;
                 Actors[previ, PARNUM] := Pargr;                { = line number in APattern }
                 CalculatePattern(Pargr, previ, i-1);
		 previ := i;
	   end;
	if Relations[i, UserTab] < LowestTab then LowestTab := Relations[i, UserTab]
     until i = number; { writeln(' Pargr num',Pargr:3);
		       }

     if (not(id)) or (number=1) then                            { this line starts new paragr.}
     begin
       nl := number;
	 x := 10;
	 while (x > 1) and (txt[nl, x] = ' ') do
	    x := x - 1;
	 if txt[nl, x] = ' ' then
	    txt[nl, x] := '?';
	 newquot := txt[nl, x] = 'Q';
       y := 2; actpos := INVENT-1;
       repeat y := y+1; Pos := 0; Lex := '   . ';
          if (y = 3) and (Actors[nl, 1] > Actors[nl, 3])
          then begin Actors[nl, 3] := Actors[nl, 1];            { PNGpred in PNGSubj }
	       end;
	       Act := Actors[nl,y];
	       if Act > 0 then
		   begin
		     Lex := ActLex[nl,y];
		     if (CorrectAct) and (Act > 100) and (nl > 1) and (Act <> 300)
				     {and (y > 3)} and (not(ExistRefInfo)) {PNG known} then
		       begin
		          dgroup := 0; repeat dgroup :=dgroup +1
			    until (Clauses[nl, dgroup, CR_PHRACT] = y) or {col in arr}
			          (Clauses[nl, dgroup, CR_SFXACT] = y) or {sfx in arr}
				  (dgroup >= 17) or
				  (dgroup > Linecode);
                                  if dgroup > Linecode
				  then begin dgroup := 0;
				    {  writeln(' cannot find dgroup');
				    }
				       end;
		        if (newquot) and (SearchQuotAct(number, nl, dgroup, Act, Lex, yy,zz)) then
			 begin
				   Clauses[nl, dgroup, CR_PHRDIS] := yy-nl;   {dist.to ref. line}
			           Clauses[nl, dgroup, CR_PHRNUM] := zz;   { ref. phrasenr}
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRDIS]):4,' =dist');
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRNUM]):4,' =phrs');
				     { with Q a change to 1th/2nd person from <S>,<O>,<S>}
			 end else
			 begin
			 write  (' I am curious what Phrase ',dgroup:3,': ', Lex);
			 WritePNG(Act, output);
			 writeln(' refers to.');
			 writeln('  cur Any suggestion?   [ y / n ]');
			     repeat read (answer) until answer in ['y', 'n'];
			     if answer = 'y' then
			     begin writeln(' Which Line?');
				   repeat read(yy) until (yy>0) and (yy< (nl+1));
				     writeln(' Which Phrase?');
				   repeat read(zz) until (zz>0) and (zz< (Linecode+1));
				     write  (' Phrase',dgroup:3,' refers to Phrase');
				     write(zz:3,' in Line',yy:4);
				     write(' TextType: '); for xx := 1 to 8 do write(txt[yy,xx]);
				     writeln;
				   Clauses[nl, dgroup, CR_PHRDIS] := yy-nl;   {dist.to ref. line}
			           Clauses[nl, dgroup, CR_PHRNUM] := zz;   { ref. phrasenr}
		     writeln(' your suggestion:', (Clauses[nl, dgroup, CR_PHRDIS]):4,' =dist');
		     writeln(' your suggestion:', (Clauses[nl, dgroup, CR_PHRNUM]):4,' =phrs');
			     end;
                         end;
			end;
		     { if sfx or pron ask for ref!                       }
	             actpos := actpos +1;
		       Actors[nl, actpos] := y;    { store the column = constit type }
		       ActLex[nl, actpos] := Lex;  { store the lexeme again }
	           end
       until y = INVENT-1;
       { SCREEN
       writeln(' new pargr, actpos:', actpos:3);
       }
     end else                                                 { SEARCH in same paragraph }

     begin
       for x := HIT to LOWTAB do Actors[i, x] := -1;            { empty act pattern info }
       actpos := INVENT-1;
       bl1 := number; repeat bl1 := bl1-1;
			if SamePar(bl1, number)                 { gaps are allowed }
			then
			begin
			   kol := INVENT-1;
		           repeat kol := kol +1; if (Actors[bl1, kol] > 0) and (kol > actpos)
					         then actpos := kol
                           until kol = HIT-1;
                        end
		      until (bl1 =1) or (EmbedPar(bl1, number) = true);   { actual pargr + gaps }
				   { or (subtypes[bl1,2] in ['N', '#' ]); actual pargr, no gaps }
		      Pargr := Actors[bl1, PARNUM] +1;
		{	writeln(' start pargr in:',bl1:4, 'Maxactpos =',actpos:5, '#:',Pargr:3);
		}

        nl := number;                     {    writeln('  nl:', nl:3,' actpos:',actpos:3); }
        y:= 1;                            {    writeln(' bl1:',bl1:3);}
	if Actors[nl, y] > 0 then y := 2  {start from <S> to verb.fin.} else
				  y := 1; {start from <nom.P>         }
	  repeat y := y+1; Pos := 0; Lex := '   . '; dLex := '   . ';
	       idact := false; idlex := false; idconst := false;
	       if (y = 3) and (Actors[nl, 1] > Actors[nl, 3])
	       then begin Actors[nl, 3] := Actors[nl, 1];  { PNGpred in PNGSubj }
		      dgroup := 0; repeat dgroup :=dgroup +1
				   until (Clauses[nl, dgroup, CR_PHRACT] = 1);
					  Clauses[nl, dgroup, CR_PHRACT]:= 3;
		    end;
	       Act := Actors[nl,y];
	       if Act > 0 then
	       begin
		 Lex := ActLex[nl,y]; if (y = 3) then dLex := ActLex[nl,1];
		 Pos := y;
		 posit := false;   dgroup := 0; repeat dgroup :=dgroup +1
						until (Clauses[nl, dgroup, CR_PHRACT] = y) or {col in arr}
						      (Clauses[nl, dgroup, CR_SFXACT] = y) or {sfx in arr}
						      (dgroup >= 17) or
						      (dgroup > Linecode);
						      if dgroup > Linecode
						      then begin dgroup := 0;
							{ writeln(' cannot find dgroup');
							  SCREEN  }
                                                           end;
		 if ExistRefInfo then
		 begin
		    mgroup := Clauses[nl, dgroup, CR_PHRNUM];
		    xx := nl + Clauses[nl, dgroup, CR_PHRDIS];  {nl + (-dist) = motherline}
		    kol := INVENT-1;
		    repeat kol := kol +1;
		    until (kol = 24) or (Actors[xx, kol] = Pos);
		    if Actors[xx, kol] = Pos then posit := true;
		 end else
		 begin
		 xx := nl;yy := 0; zz := 0;
                    repeat xx := xx -1;
		    if SamePar(xx, nl) then
		    begin
		       kol := INVENT-1;
		       repeat kol := kol +1;
			 if Actors[xx, kol] > 0 then
			 begin diff := 0;
	                   idact := false; idlex := false; idconst := false;

			   if Actors[xx, Actors[xx, kol]] = Act    { same PNG }
			   then idact := true;
			   diff := Actors[xx, Actors[xx, kol]] - Act;
			   if diff in [2, 3, 12, 200, 300, (200-2), (300-2), 302, 301 ] then idact := true else
			   begin
			      diff := Act - Actors[xx, Actors[xx, kol]];
			      if diff in [2, 3, 12, 200, 300, (200-2), (300-2), 302, 301 ] then idact := true;
                           end;
			   if Actors[xx,kol] = Pos                 { same constit type }
			   then idconst := true;
			   if (Actors[xx, kol] = 3) and (Pos = 4)  { Subj2}
			   then idconst := true;
			   if (Lex[1] <> ' ') and (ActLex[xx, kol] = Lex) { same lexeme }
			   then idlex := true;
			   if (idact and idconst and idlex) then posit := true else
			   if (idact and idconst) and (Lex[1] = ' ') then posit := true else
			   if (idact and idconst) and
			      (Act > 100) and (Act < 300) then posit := true else
			   if (idact and idlex  ) then posit := true else
			   if (idconst and idlex) then posit := true else
			   if (idlex            ) then posit := true else
			   if (idact) and (Pos = Cmpsfx) then posit := true else
			   if (idact) and (Pos = Subjsfx) then posit := true else
			   if (idact) and (Pos = Objsfx) then posit := true else
			   if (idact) and (Pos = Subject) then posit := true;

		         if posit then
		          begin
					mgroup := 0;
					repeat mgroup := mgroup +1
					until (Clauses[xx, mgroup, CR_PHRACT] = Actors[xx, kol]) or
					      (Clauses[xx, mgroup, CR_SFXACT] = Actors[xx, kol]) or
					      (mgroup >= 17) or
					      (mgroup > Linecode);
					      if mgroup > Linecode then mgroup := 0
					      else mLex := ActLex[xx,kol];
					      if (Actors[xx,kol] = 3) and (mLex[1] = ' ')
					      then mLex:= ActLex[xx,1];
					      {column in Actors }
					{Clauses[nl, dgroup, CR_PHRDIS] := xx-nl;  dist.to ref. line}
					{Clauses[nl, dgroup, CR_PHRNUM] := mgroup;  ref. phrasenr}
                               if (CorrectAct) and (mgroup > 0) then
			       begin write('LINE',nl:4,', Phrase',dgroup:3,' : Does ');
				     if (y=3) and (Lex[1] = ' ') then write(dLex,' {') else
								      write(Lex,' {');
			             WritePNG(Act, output); write('} refer back to phrase');
			             write(mgroup:3,' [',mLex);
			             WritePNG(Actors[xx, Actors[xx, kol]], output);
			             write('] in line',xx:4,' ?'); writeln(' [ y / n / L / S(top correcting)]');
				     answer := 'n';
				     if idlex then answer := 'y' else
				     {if (Lex[1] <> ' ') and (not(idlex)) then answer := 'n' else
				     }
			             repeat read (answer) until answer in ['y', 'n', 'L', 'S'];
			             if answer = 'S' then CorrectAct := false else
			             if answer = 'n' then posit := false else
				     if answer = 'y' then
					begin posit := true;
					end else
				     if answer = 'L' then
					begin writeln(' Which Line?');
					      repeat read(yy) until (yy>0) and (yy< (nl+1));
					      writeln(' Which Phrase?');
					      repeat read(zz) until (zz>0) and (zz< (nl+1));
					      write  (' Phrase',dgroup:3,' refers to Phrase');
					      writeln(zz:3,' in Line',yy:4);
					      xx := yy; {line of ref.}
					      mgroup := zz; { phrase in line}
					      posit := true;
					end;
                               end;

					{ Clauses[nl, group, CR_PHRDIS] := MIline (xx) }
					{ Clauses[nl, group, CR_PHRNUM] := MIact  (phrasenum)}
                           end;
		         end
                       until (kol = 24) or (posit = true);
                    end
		    until (xx <= bl1) or (posit = true) or (xx=1);
			  {(Relations[xx, UserTab] < Relations[nl, UserTab])}
		 end;
		       if posit then
			  begin
			     Actors[nl, kol] := Pos;
			     ActLex[nl, kol] := Lex;
                             if not(ExistRefInfo) then
			     begin
			       Clauses[nl, dgroup, CR_PHRDIS] := xx-nl;   {dist.to ref. line}
			       Clauses[nl, dgroup, CR_PHRNUM] := mgroup;  { ref. phrasenr}
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRDIS]):4,' =dist');
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRNUM]):4,' =phrs');
			     end;
			  end else
			  begin
			    if (CorrectAct) and (Act > 100) {PNG known} and (Act <> 300)  and
			    not(ExistRefInfo) then
			   begin             { if Q domain: SearchQuotAct }
			    if (xx > 1) and
			    (SearchQuotAct(nl, xx+1, dgroup, Act, Lex, yy,zz)) then
			    begin
			      Clauses[nl, dgroup, CR_PHRDIS] := yy-nl;   {dist.to ref. line}
		              Clauses[nl, dgroup, CR_PHRNUM] := zz;   { ref. phrasenr}
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRDIS]):4,' =dist');
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRNUM]):4,' =phrs');
			       posit := true;
			       actpos := actpos +1; Actors[nl, actpos] := Pos;
						    ActLex[nl, actpos] := Lex;
			    end;
                           end;
			  end;

			  if (not(posit)) and (not(ExistRefInfo)) then
			    begin
			       write(' I do not know what Phrase',dgroup:3,': ', Lex);
			       WritePNG(Act, output); writeln(' refers to.');
			       writeln(' unk Any suggestion?   [ y / n ]');
			         repeat read (answer) until answer in ['y', 'n'];
				 if answer = 'y' then
					begin writeln(' Which Line?');
					      repeat read(yy) until (yy>0) and (yy< (nl+1));
					      writeln(' Which Phrase?');
					      repeat read(zz) until (zz>0) and (zz< (nl+1));
					      write  (' Phrase',dgroup:3,' refers to Phrase');
					      write(zz:3,' in Line',yy:4);
					      write(' TextType: ');
					      for xx := 1 to 8 do write(txt[yy,xx]);
					      writeln;
			                  Clauses[nl, dgroup, CR_PHRDIS] := yy-nl;   {dist.to ref. line}
			                  Clauses[nl, dgroup, CR_PHRNUM] := zz;  { ref. phrasenr}
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRDIS]):4,' =dist');
		     writeln(' present in CalculateAc:', (Clauses[nl, dgroup, CR_PHRNUM]):4,' =phrs');

			                   actpos := actpos +1; Actors[nl, actpos] := Pos;
						                ActLex[nl, actpos] := Lex;
					end;
			    end;

	       end
	  until y = INVENT-1;
   end;
end;   {  of CalculateActors }


procedure TestPattern(number: integer);
{ search what block of text has same or similar actors as the new clause }
var i,j, l, Hit, blocknum, Act, role,
    pargr,
    MAXHit, bl, linenum : integer;
    id, idlex       : boolean;
    Lex             : phrlex;
begin
  { first, test: new actors in comparison to current set? }
  { dep on new subject, verbal tense, etc. }

  for i := 1 to number-1 do
  if Actors[i, PARNUM] > 0 then               { textblock number }
  begin
    pargr := Actors[i, PARNUM];
    l := 0;
    j := INVENT-1; id := false; Hit := 0;
    Act := 0;  role := 0;
    repeat l := l+1;
      if Act <> Actors[number,l] then
      begin Act := Actors[number,l];          { actor in actual line }
	    Lex := ActLex[number,l];
        if Act > 100 then { at least Person should be known }
        begin id := false; j := INVENT-1;
	      idlex := false;
	    role := role+ 1;  { number of actors/persons in the clause }
	    repeat j := j+1;
	      if Act = APattern[pargr, j ] then id := true;
	      if Lex = APatlex [pargr, j ] then idlex := true
	    until (APattern[pargr, j] < 1) or (id = true) or (idlex = true);
	    if id then Hit := Hit +1;
        end
      end
    until l = Cmpsfx;                     { col 10 }

    Actors[i, HIT] := Hit;
  end;

  MAXHit := 0; bl := 0; blocknum := 0;
  for i := 1 to number-1 do     { last hit is the best (?) }
  begin if Actors[i, PARNUM] > 0 then
     begin bl := Actors[i, PARNUM];
	if (Actors[i, HIT] >= role) and (Actors[i, LOWTAB] < Actors[number-1,LOWTAB]) then
        begin blocknum := bl; linenum := APattern[bl, PARstart]; { starting line of paragr }
        end;
     end;
  end;
  if blocknum > 0 then
  begin
    write(' Pattern of Actors fits the Pattern of text block:');
    write( blocknum:3,' Actors: ');
      for i := INVENT to PARstart-1 do
	  begin if APattern[blocknum, i] > 100
		then begin WritePNG(APattern[blocknum, i], output);
			   for j := 1 to 5 do write(APatlex[blocknum, i, j]);
		     end;
          end; writeln;
    write(' (starts at line:',linenum:5,'; lowesttab:',(Actors[linenum,LOWTAB]):3,' )');
    write(' lowesttab of actual block:',(Actors[number-1,LOWTAB]):3,' )');
    writeln;
  end;
end;


procedure PrintCAtm(n: integer; var ct: text; w: integer);
(* Writes the current clause atom from ct to standard output as line
   number n, truncated to a width of w *)
const
   TEXT_OFFSET = 43;			(* start position of CT *)
var
   c: char;
   i: integer;
begin
   write('[', n:3, ']', Relations[n, UserTab]:3, ' ');
   write(subtypes[n, 1], subtypes[n, 2], ' ');
   for i := 1 to LABEL_LENGTH + 1 do begin
      read(ct, c);
      write(c)
   end;
   write(phrases[n, PR_PNG], ' ');
   write('<', phrases[n, PR_LABEL], '>', ' ');
   write(phrases[n, PR_CLAB], ' ');
   i := TEXT_OFFSET;
   while not eoln(ct) and (i < w) do begin
      read(ct, c);
      write(c);
      i := i + 1
   end;
   readln(ct)
end;


procedure DisplayCAtms(n: integer; var ct: text; w: integer);
(* Writes the current clause atom from ct to standard output as line
   number n, marked by an arrow and followed by EXTRA_LINES clause
   atoms of context. The display is truncated to a width of w *)
const
   EXTRA_LINES = 3;
var
   i: integer;
begin
   Print23Line(w);
   PrintCAtm(n, ct, w);
   writeln(' <<===');
   Print23Line(w);
   i := 1;
   while (i <= EXTRA_LINES) and (n + i <= MAXLines) do begin
      PrintCAtm(n + i, ct, w);
      writeln;
      i := i + 1
   end;
   Print23Line(w)
end;


procedure LineOnScreen(all, number: integer);
const
   COLS_LARGE	= 132;	(* #columns in a large terminal window *)
   COLS_NORMAL	= 80;	(* #columns in a standard terminal window *)
   LEFT_SIDE	= 56;	(* #columns on the left half of the screen *)
   ROWS_NORMAL	= 25;	(* #rows in a standard terminal window *)
var q,r,c, tb,
    tabpos,
    printrows,
    cols, rows : integer;
    blockchar, ch: char;
    id         : boolean;

begin
   reset(ct4);
   q := 1;
   if not GetWindowSize(cols, rows) then begin
      cols := COLS_LARGE;
      rows := cols * ROWS_NORMAL div COLS_NORMAL;
      writeln('Failed to read the window size.');
      writeln('Assuming a ', cols: 1, 'x', rows: 1, ' window.')
   end;
   rows := rows - 29;
   if (rows < 1) or (number <= rows) then
      printrows := 1
   else
      printrows := number - rows;
   if rows < 1 then begin
      writeln(' window too small!!');
      writeln(' please enlarge your window up to a minimum of 30 lines.')
   end;

  write(' '); for r := 1 to cols-2 do write('_'); writeln;
  write('  TEXT.ref PNGvb ClType CConLab  Domain Pargr');
  write(' TAB xy LINE | - - - - - - TEXT of CLAUSE - - - - - - - - - - - - - '); writeln;
  write(' '); for r := 1 to cols-2 do write('_'); writeln;
  writeln;

  for q := 1 to number-1 do
  begin id := true;
	tabpos := 0;
	if q > 1 then
	   begin r := 0; blockchar := '=';
		 repeat r := r+1;
		 if txt[q-1,r] <> txt[q,r]
		 then begin id := false;
			    tabpos := r;
			    if ((txt[q-1,r] = ' ') and (txt[q,r] = 'N'))
			    or ((txt[q-1,r] = 'N') and (txt[q,r] = ' '))
			    or ((txt[q-1,r] = ' ') and (txt[q,r] = 'D'))
			    or ((txt[q-1,r] = 'D') and (txt[q,r] = ' '))
			    then blockchar := '-'
			    else blockchar := '=';
                      end
                 until (r=10) or (id = false);
	   end;
	if all > 0 then
	begin
	    if q >= printrows then begin
	       if not id then begin
	       (* for r := 1 to 6 do
		     write(txtTAB[r]: 2);
		  writeln;
	       *)
		  write('                 ======          .......      ');
		  write('            ');
		  tb := txtTAB[tabpos];
		  for r := 1 to tb do
		     write('.   ');
		  for r := cols - (LEFT_SIDE + tb * 4) downto 3 * tabpos do
		     write(blockchar);
		  writeln
	       end
	    end;
	      for r := 1 to 11 do                                            { TEXT }
		  begin read(ct4,ch);
	                if q >= printrows then write(ch);
		  end;
	      if q >= printrows then
	      begin write(phrases[q,PR_PNG],' ');
	      WriteClConnLabel(output, q);
	      write('  ');
	        for r := 1 to 7 do write(txt[q,r]);                          { text type }
	      WritePargrPart(output, partxt[q], 6);
	      write((Relations[q,UserTab]):3,' ', subtypes[q,1],subtypes[q,2],' ');
	      write('[',q:3,']');
				                                             { Line numbers, etc.}
              end;

	      tb := Relations[q,UserTab];
	      if q >= printrows then                                         { INDENT }
	        if tb > 0 then for r := 1 to tb do write('.   ');
		c := tb*4; c := c+55;
	      while not(eoln(ct4)) do
	      begin read(ct4,ch);c := c +1;
	              if (q >= printrows) and
			 (c <= (cols-10)) then write(ch);
	      end;
	      readln(ct4);
	        if q >= printrows then
		begin while c < (cols-10) do
		      begin c := c +1; write(' ');
		      end;
		      write('[',q:3,']');
	              writeln;
                end;
        end else readln(ct4);
  end;
  DisplayCAtms(number, ct4, cols)
end;

procedure adjusttabs( line2, line1 : integer);
var p, q,
    extra,
    diff    : integer;
begin
  diff := -1;
  if Relations[line2, UserTab] < Relations[line1, UserTab]  { in case of downward conn. }
  then extra := 2 else extra := 0;
  q    := -1;
  p := line1;
  repeat p := p+1;
    if Relations[p, UserTab] <= Relations[line2, UserTab]
    then q:= Relations[line2, UserTab] - Relations[p, UserTab];
	 if diff < q then diff := q
  until p = line2-1;
  if diff = 0 then diff := 1;
  diff := diff + extra;
  { writeln(' DIFF:',diff:5);}
  if diff > -1 then
  begin
  p := line1;
  repeat p := p+1;
    Relations[p, UserTab] := Relations[p, UserTab] +diff
  until p = line2-1;
  end;
end;

procedure TestTabs;                                     { tests: non used levels of identations? }
type presT = array [ 0.. TABS_MAX ] of integer;
var x,y,z,
    p1, p2,
    maxtab,
    emptytab
	  : integer;
    presenttabs : presT;
    missingTab  : boolean;

begin
  for x := 0 to TABS_MAX do presenttabs[x] := 0;
  x := 0;
  repeat x := x +1;
    emptytab := 0; missingTab := false;
    maxtab := 0;
    p1 := x; { write('line p1 =',p1:3);
	     }
    if (x < StopLine) and (Relations[p1, UserTab] < Relations[p1+1, UserTab]) then
    begin
       p2 := p1;
       emptytab := 0; missingTab := false;
                      maxtab := 0;
                      for y := 1 to TABS_MAX do presenttabs[y] := 0;
	  repeat p2 := p2 +1;
	       if Relations[p2, UserTab] <= TABS_MAX then
		  presenttabs[Relations[p2, UserTab]] := 1                    { has been used }
	       else
		  message('syn04types: clause atom ' , p2:1, ': tab overflow');
	       maxtab := max(Relations[p2, UserTab], maxtab)
	  until (Relations[p2, UserTab] < Relations[p2-1, UserTab]) or      { first line with lower tab}
		   (p2 = StopLine);
	           {   write(' read to line p2:',p2:3,' maxtab:',maxtab:4);
		   }
             z := p2;
	     repeat z := z-1;
		if Relations[z, UserTab] <= TABS_MAX then
		   presenttabs[Relations[z, UserTab]] := 1
	     until (z=1) or (Relations[z, UserTab] <= Relations[p2, UserTab]+1); {nearest prec. lower tab}
		   { writeln(' control backwards unto line:',z:4);
		   }
             if p2 > z then
	     begin
	         y := Relations[p2, UserTab];
		  { write(' from  line:',z:5,' lowest tab =',(Relations[p2, UserTab]):4);
	            writeln('until line:',p2:5,' highesttab =',maxtab:4);
		  }
	         repeat y := y+1;
		    if (y <maxtab) and (presenttabs[y] = 0) then
		       begin emptytab := y; missingTab := true;
			  write( ' section line',z:4,' to line',p2:4);
			  write(' emptytab=',y:5);
		       end
	         until y >= maxtab;
		 if missingTab then
		 begin
		    for y := z+1 to p2 do
			if Relations[y, UserTab] > emptytab
			then Relations[y, UserTab] := Relations[y, UserTab]-1;
			writeln(' Empty Tabs have been removed');
                    x := x-1;    { test again }
		    {writeln(' new x =:',x:4);
		    }
		 end;
	     end
    end
  until x >= StopLine;
  if missingTab = false then writeln(' no missing levels of indentation found');
end;


procedure registerarguments
   (var f: text; d: integer; var L: CandListType; k: integer);
(* Write the connection and its argumentation to the argumentation
   report. *)
var
   c: char;
   i: integer;
begin
   with L do
      for i := 1 to size do
	 with list[i] do begin
	    write(f, d:3, ' ', mam:3, ' ', sub);
	    if i <> k then
	       c := '.'
	    else
	       if Relations[d, UserTab] = Relations[mam, UserTab] then
		  c := '='
	       else
		  c := '+';
	    write(f, ' ', c, ' ', score:8:5, ' ');
	    WriteArgon(f, arg)
	 end
end;


procedure FindCandidates(d: integer; var L: CandListType);
(* Fill the candidates list with candidates for daughter d *)
var
   C: CandType;
   i: integer;		(* index of first/last daughter *)
   m: integer;		(* mother *)
   t: integer;		(* tab position *)
   x: integer;		(* extra distance from daughters *)
   stop: boolean;
begin
   i := 1;
   if Relations[d, ClCodes + 2 * i - 1] < 0 then
      x := Relations[d, ClCodes + 2 * i - 1]
   else
      x := 0;
   m := d - 1 + x;
   t := TABS_MAX + 1;
   stop := false;
   while (m >= 1) and not stop do begin
      if (Relations[m, UserTab] <= t) and (subtypes[m, 2] <> 'e') then begin
	 C.mam := m;
	 C.typ := CT_Unkn;
	 CandList_Add(L, C);
	 t := Relations[m, UserTab] - 1;
	 stop := (t < 0) or (subtypes[m, 2] = '\')
      end;
      m := m - 1
   end;
   i := Relations[d, MaxCodes];
   if Relations[d, ClCodes + 2 * i - 1] > 0 then
      x := Relations[d, ClCodes + 2 * i - 1]
   else
      x := 0;
   m := d + 1 + x;
   t := TABS_MAX + 1;
   stop := false;
   while (m <= MAXLines) and not stop do begin
      if (Relations[m, UserTab] <= t) and (subtypes[m, 2] <> 'e') then begin
	 C.mam := m;
	 C.typ := CT_Unkn;
	 CandList_Add(L, C);
	 t := Relations[m, UserTab] - 1;
	 stop := (t < 0) or (subtypes[m, 2] <> '\')
      end;
      m := m + 1
   end
end;


procedure Cand_Eval(var C: CandType; d: integer);
const
   MAX_TRIES = 3;
var
   n: integer;
   t: integer;
begin
   n := 0;
   t := 0;
   with C do
      while (n < MAX_TRIES) and (typ <> t) do begin
	 t := typ;
	 argumentation(d, C);
	 Cand_SetSub(C, d);
	 typ := ClauseType(d, sub[1], CR_FUN);
	 n := n + 1
      end;
   assert(n < MAX_TRIES);
   ScoreCand(d, C)
end;


procedure CandList_Eval(var L: CandListType; d: integer);
var
   i: integer;
begin
   with L do
      for i := 1 to size do
	 Cand_Eval(list[i], d)
end;


procedure DisplayPrompt(var C: CandType);
begin
   writeln;
   with C do
      writeln(' PROPOSAL: best candidate for a connection is line:',
	       C.mam:4, ' ', C.sub);
   writeln;
   writeln (' Enter Instruction                [go back?                Enter "B" + line number ]');
   writeln (' ^n : dep.on LINE n               [undo previous decision? Enter "U" ]');
   writeln (' /n : paral. LINE n               [stop the analysis?      Enter "S" ]');
   writeln (' if the proposal is OK, do <ENTER>                                    ');
end;


procedure CandList_Extend(var L: CandListType; d, m: integer);
(* Add the unreachable downward clause atoms up to m to the list of
   candidates L for daughter d *)
var
   C: CandType;
   i: integer;
begin
   for i := d + 2 to m do
      if CandList_FindMam(L, i) = 0 then begin
	 C.mam := i;
	 C.typ := CT_Unkn;
	 Cand_Eval(C, d);
	 CandList_Add(candidates, C)
      end;
   CandList_Sort(L)
end;


function Command_DirectionOK(var C: CommandType; d: integer): boolean;
begin
   with C do
      if (((sub[2] <> '\') and (d > num)) or
	  ((sub[2]  = '\') and (d < num)))
      then
	 Command_DirectionOK := true
      else begin
	 writeln('Error: instructions ''', sub, ''' do not allow ',
		 'clause atom ', num:1, ' as mother');
	 Command_DirectionOK := false
      end
end;


function UserSelection(d: integer;
   var L: CandListType; var C: CommandType): integer;
(* Return the index in L of the winning candidate for daughter d,
   chosen by the user. In C the parameters of the connection from the
   command issued by the user are returned. *)
var
   r: integer;	(* result *)
   m: integer;	(* mother *)
   i: integer;
   happy: boolean;
begin
   r := 0;
   C.cmd := ' ';
   while (r = 0) and (C.cmd <> 'T') do begin
      DisplayArgon(L.list[1].arg);
      for i := 1 to L.size do
	 printscore(d, L.list[i]);
      DisplayPrompt(L.list[1]);
      happy := false;
      while not happy do begin
	 C.num := L.list[1].mam;
	 if not TestCommand(d, C) then
	    writeln(' Your instructions are incorrect. Please try again.')
	 else begin
	    happy := true;
	    if C.cmd in ['B', 'U', 'S', 'T'] then begin
	       r := C.num;
	       SubType_Merge(C.sub, L.list[1].sub);
	       C.ccr := C.ccr or (C.sub[2] = '\')
	    end else begin
	       m := C.num;
	       r := CandList_FindMam(L, m);
	       if r = 0 then 
		  if (m <= d) or (MAXLines < m) then  begin
		     writeln('Clause atom ', m: 1, ' is not available');
		     happy := false
		  end else begin
		     writeln('Extending list of candidates. Please review.');
		     CandList_Extend(L, d, m)
		  end
	       else begin
		  SubType_Merge(C.sub, L.list[r].sub);
		  C.ccr := C.ccr or (C.sub[2] = '\');
		  happy := Command_DirectionOK(C, d)
	       end
	    end
	 end
      end
   end;
   UserSelection := r
end;


procedure IncrementTab(c: integer);
var
   d: integer;	(* daughter *)
   i: integer;
begin
   for i := 1 to Relations[c, MaxCodes] do begin
      d := c + Relations[c, ClCodes + 2 * i - 1];
      if d <> Relations[c, UserMam] then
	 IncrementTab(c + Relations[c, ClCodes + 2 * i - 1])
   end;
   Relations[c, UserTab] := Relations[c, UserTab] + 1
end;


function Pending(c: integer): boolean;
(* Return whether defective clause atom [c] does not yet have a clause
   atom relation that continues the clause *)
var
   found: boolean;
   i: integer;
begin
   i := 0;
   found := false;
   while not found and (i < Relations[c, MaxCodes]) do begin
      found := Relations[c, ClCodes + 2 * i + 1] > 1;
      i := i + 1
   end;
   Pending := not found
end;


procedure SetEmbedding(d, m: integer);
(* Set instruction 'e' if necessary *)
begin
   if (m > 1) and Pending(m) and not RelaClause(d) and
      (subtypes[m - 1, 2] = '.') and (subtypes[d - 1, 2] = '.')
   then
      subtypes[d - 1, 2] := 'e'
end;


procedure ShiftDaughters(m: integer; below: boolean);
var
   d: integer;		(* daughter *)
   i: integer;
begin
   if below then begin
      i := Relations[m, MaxCodes];
      while i > 0 do begin
	 d := m + Relations[m, ClCodes + 2 * i - 1];
	 if (d > m) and (d <> Relations[m, UserMam]) then
	    IncrementTab(d);
	 i := i - 1
      end
   end else begin
      i := 1;
      while i <= Relations[m, MaxCodes] do begin
	 d := m + Relations[m, ClCodes + 2 * i - 1];
	 if (d < m) and (d <> Relations[m, UserMam]) then
	    IncrementTab(d);
	 i := i + 1
      end
   end
end;


procedure ChangeTab(c, t: integer);
(* Set clause atom c at tab t *)
var
   d: integer;	(* daughter *)
   i: integer;
   l: integer;	(* level *)
begin
   l := t;
   for i := 1 to Relations[c, MaxCodes] do begin
      d := c + Relations[c, ClCodes + 2 * i - 1];
      if (d < c) and (d <> Relations[c, UserMam]) then begin
	 if Relations[d, UserTab] <> Relations[c, UserTab] then
	    l := l + 1;
	 ChangeTab(d, l)
      end
   end;
   l := t;
   for i := Relations[c, MaxCodes] downto 1 do begin
      d := c + Relations[c, ClCodes + 2 * i - 1];
      if (d > c) and (d <> Relations[c, UserMam]) then begin
	 if Relations[d, UserTab] <> Relations[c, UserTab] then
	    l := l + 1;
	 ChangeTab(d, l)
      end
   end;
   Relations[c, UserTab] := t
end;


procedure ConnectDaughter(d, m: integer; ccr: boolean);
begin
   Relations[d, UserMam] := m;
   if Relations[d, UserTab] <> Relations[m, UserTab] then
      ShiftDaughters(m, m < d);
   if not ccr and (m + 1 < d) and (subtypes[m, 1] = 'd') then
      SetEmbedding(d, m);
   AddRelation(Relations, m, d - m, CAR_UNKNOWN);
   (* txt[] and txtTAB[] are taken care of later *)
end;


function AbsoluteTab(c, t: integer; ccr: boolean): integer;
(* Set clause atom c at tab t and return its mother *)
var
   m: integer;	(* mother *)
begin
   m := FindMother(Relations, c, t);
   ChangeTab(c, t);
   ConnectDaughter(c, m, ccr);
   AbsoluteTab := m
end;


function NegativeTab(c, t: integer; ccr: boolean): integer;
(* Make clause atom c dependent from the mother at tab t and return
   this mother *)
var
   m: integer;	(* mother *)
begin
   m := FindMother(Relations, c, t);
   ChangeTab(c, t + 1);
   ConnectDaughter(c, m, ccr);
   NegativeTab := m
end;


procedure RelativeTab(d, m, delta: integer; ccr: boolean);
(* Connect daughter d to mother m with a tab difference of delta *)
begin
   assert(d > 1);
   if Relations[m, UserTab] < 0 then
      ChangeTab(d, Relations[d - 1, UserTab] + delta + 1)
   else
      ChangeTab(d, Relations[m, UserTab] + delta);
   ConnectDaughter(d, m, ccr)
end;


procedure CancelDecision(c: integer);
begin
   ClearCARC(Relations, c);
   PopRelation(Relations, c);
   PargrClear(partxt[c]);
   Relations[c, AutoMam] := -1;
   Relations[c, UserMam] := Relations[c, RelLine];
   Relations[c, UserTab] := Relations[c, TabNum];
   Relations[c, ClauseT] := CT_Unkn;
   TtyClear(txt, c);
   SetClauseLabel(c);
   subtypes[c, 1] := '.';
   subtypes[c, 2] := '.'
end;


function GoBack(c, b: integer): integer;
(* Undo all decisions from clause atom c up to clause atom b.
   Note that c > b. Return the new current clause atom. *)
const
   QUESTION = 'This is a long way back. Are you sure?';
   WAY_BACK = 8;
var
   r: integer;	(* result *)
   i: integer;
begin
   r := c;
   if (b <= 1) or (c < b) or (Relations[b, UserMam] = -1) then
      writeln('Cannot go back to line ', b:1)
   else if (c - b >= WAY_BACK) and not YesNoQuestion(QUESTION) then
      writeln('All right. Not going back.')
   else begin
      writeln('Back to line ', b:1);
      for i := c - 1 downto b do
	 CancelDecision(i);
      r := b
   end;
   GoBack := r - 1
end;


procedure ConnectLines(starttext, stoptext : integer);  { begin line; end line; for editing }
var letter,ch : char;
    p,m,n,mm,
    mothernum,px,
    diftab,
    winner,
    OldTab: integer;
    stop      : boolean;
    command: CommandType;

begin
  if (starttext = 0) and (stoptext = 0)
  then  begin Editor := false;
              Relations[1, UserTab] := 0;
	      partxt[1,1] := '1';
              stop := false;
              if StopLine > 1 then p := StopLine
              else begin p := 1; txt[1,1] := '?'; ty := 1;
				 if phrases[1, PR_VT] = T_WAYQ then txt[1,1] := 'N' else
				 if phrases[p, PR_VT] = T_IMPF then txt[1,1] := 'D' else
				 if phrases[p, PR_VT] = T_IMPV then txt[1,1] := 'Q';
				 txtTAB[1] := 0;
                   end;
              CalculateActors(1);
        end
  else  begin Editor := true;
	      p:= starttext;
        end;

  diftab := 0; px := 0;

  {LineOnScreen(0,1); }

  repeat
     if Editor then begin  writeln('         ============== EDIT ==============    ');
			   p := stoptext-1;
			   writeln;
			   SOFAR:= 0;   {implies: full recalculation codes }
                           for n := 1 to TxtLength do
	                   for mm := ClCodes to MaxCodes do
	                   Relations[n,mm] := 0;
     end;

	p := p+1;
	if ty > 0 then
	begin
	txt[p,ty] := txt[p-1,ty];
	if (txt[p,ty] in ['D', '?']) and (phrases[p, PR_VT] = T_WAYQ)    {cf. 2871/2903}
	then txt[p,ty] := 'N';
	if (txt[p,ty] = '?') and (phrases[p, PR_VT] = T_IMPF)
	then txt[p,ty] := 'D';
	if (txt[p,ty] = '?') and (phrases[p, PR_VT] = T_IMPV)
	then txt[p,ty] := 'D';
	end;

	LineOnScreen(1,p);
	    if Editor then
		   begin OldTab := -1; n := 0;
		      write(' which LINE needs a change of TAB ? ');
		      write(' to Stop or to change to another Text Block, type: "s" or "c" ');
		      writeln;
		      repeat n := 0;
			 repeat read(ch);
			    if ch <> ' ' then
			    begin
			    if Digit(ch) then
			       begin
			         n := 0;
				 repeat if Digit(ch) then n := n*10 + (ord(ch) - ord('0') );
				        if eoln then ch := ' ' else read(ch)
				 until not Digit(ch);
			       end;
                            end
                         until eoln;
                            if n > 0 then px := n
			    else px := 0;

		         if px = 0 then
			      begin px := stoptext;
			            p  := 0;
		              end
                         else if px = 1 then
			      writeln('editing of line 1 is not allowed')
		         else if px < starttext then
			      writeln ('not <',starttext:4)
		         else if px > stoptext then
			      writeln ('not >',stoptext:4)
		      until (px >= starttext) and (px <= stoptext);
			 if p <> 0 then
			 begin
                           p := px;
                           write(' previously indicated MOTHER clause:',(Relations[p, UserMam]):4);
			   subtypes[p, 1] := '.'; subtypes[p, 2] := '.';
			   Relations[p,ClConstRel] := CCR_None;
			   OldTab := Relations[p, UserTab];
			   writeln(' OldTab:',OldTab:3);
			   SetClauseLabel(p);
			   writeln;
			 end else p := stoptext;
     end;	(* if Editor *)

      if not ( (Editor) and (p = stoptext) ) then begin
	 CandList_Clear(candidates);
	 FindCandidates(p, candidates);
	 CandList_Eval(candidates, p);
	 CandList_Sort(candidates);
	 (* TODO: handle 0 candidates and 'N' elegantly *)
	 Relations[p, AutoMam] := candidates.list[1].mam;
	 if not Interactive then
	    winner := 1
	 else
	    winner := UserSelection(p, candidates, command);
	 assert(Interactive);
	 if command.cmd in ['B', 'U', 'S', 'T'] then
	    mothernum := winner
	 else
	    mothernum := candidates.list[winner].mam;

	 case command.cmd of
	    'T': winner := CandList_FindMam(candidates,
			AbsoluteTab(p, mothernum, command.ccr));
	    '-': winner := CandList_FindMam(candidates,
			NegativeTab(p, Relations[p - 1, UserTab] - 1,
			   command.ccr));
	    '/': RelativeTab(p, mothernum, 0, command.ccr);
	    '^': RelativeTab(p, mothernum, 1, command.ccr);
	    '=': RelativeTab(p, p - 1, 0, command.ccr);
	    '+': RelativeTab(p, p - 1, 1, command.ccr);
	    ' ': RelativeTab(p, mothernum,
			ord(not candidates.list[winner].paral), command.ccr);
	    'B': p := GoBack(p, mothernum);
	    'U': p := GoBack(p, p - 1);
	    'S':
	       begin
		  p := p - 1;
		  stop := true
	       end
	 end;
	 if not (command.cmd in ['B', 'U', 'S']) then begin
	    subtypes[p] := command.sub;
	    candidates.list[winner].sub := command.sub;
	    registerarguments(ArgReport, p, candidates, winner);
	    if ClauseConstituentRelation(p, candidates.list[winner]) or command.ccr then
	       EstablishCCR(ClLst, p, candidates.list[winner]);
	    phrases[p, PR_CLAB] := CType2Label(candidates.list[winner].typ);
	    SetTextType(Relations, p);
	    SetParNum(Relations, p);
	 end;

          {adjusttabs next lines in case of Editor}
	  if (Editor) and (OldTab > -1) then
	  begin
	    m := p;
	    diftab :=Relations[p, UserTab]- OldTab;
	    if (Relations[m+1, UserTab] > OldTab) and (diftab <> 0)
	    then begin repeat m := m+1
		       until (Relations[m, UserTab] <= OldTab)
			  or (m = MAXLines) or (m= StopLine);
			  m := m-1;
		   writeln(' diftab =', diftab);
	           writeln(' Shall I adapt the Tabs of the next lines [until line',m:4, '] ?   y / n ');
                   repeat read(letter) until letter in ['y', 'n'];
		   if letter = 'y' then
		   begin m := p;
		     repeat m := m+1;
			if Relations[m, UserTab] > OldTab
			then Relations[m, UserTab] := Relations[m, UserTab] + diftab
		     until (Relations[m, UserTab] <= OldTab)
			   or (m=StopLine) or (m= MAXLines);
		   end;
                 end;
		 TestTabs;
	  end;

	if Relations[p, AutoMam] <> Relations[p, UserMam] then begin
	   DisAgree := DisAgree + 1;
	   writeln('Number of disagreements: ', DisAgree:1);
	   writeln(rep,' Number of DISAGREEMENTS:',DisAgree:5)
	end;

	page;
     end (* if not (Editor and (p = stoptext)) *)
  until ( (Editor = true ) and (p >= stoptext)) or
	( (Editor = false) and
	  ( (p >= MAXLines) or (stop) )  );
  if not Editor then
     StopLine := p
end;   { end of ConnectLines }


procedure EditLines;
var firstline, lastline : integer;
begin
  writeln(' the last line you have provided with a TAB is:', (StopLine-1):5);
  repeat writeln(' What is the FIRST line of the textblock to be edited?');
         read(firstline); if firstline < 1 then
			  writeln(' not < 1 !!');
			  if firstline > StopLine-1 then
			  begin writeln(' not beyond last tab given:',(StopLine-1):4);
				firstline := StopLine -15;
				if firstline < 1 then firstline := 1;
			  end
  until firstline > 0;
  repeat writeln(' What is the  LAST line of the textblock to be edited?');
	 writeln(' the maximum is 25 lines; so MAX last line =',(firstline+24):4);
         read( lastline); if lastline > (firstline + 24) then
		       begin
			  writeln(' not >',(firstline+24):4,' !!');
			  lastline := firstline+24;
			  if lastline > StopLine then
			  writeln(' not beyond last tab given:',StopLine:4);
		       end
		       else if lastline <= firstline then
		       begin
			  writeln(' not <',(firstline+1):4,' !!');
			  lastline := firstline + 24;
                       end
  until  lastline <= (firstline+24);
  if lastline > MAXLines then lastline := MAXLines;
  if lastline > StopLine then lastline := StopLine-1;
  ConnectLines(firstline, lastline);
  Editor := false;
end;


procedure RefreshArrays;
var
   p, q, r: integer;
begin
   for p := 1 to MAX_CTYPES + 1 do
      for q := 1 to MAX_CTYPES + 1 do
	 clauseCM[p,q] := 0;
   for p := 0 to MAX_WORDS do
      for q := -1 to 15 do
	 ko[p, q] := -1;
   for p := 1 to TxtLength do begin
      subtypes[p, 1] := '.';
      subtypes[p, 2] := '.';
      for q := 0 to PR_LABEL do
	 phrases[p, q] := L_EMPTY;
      for q := 1 to Linecode do
	 for r := 1 to 13 do
	    Clauses[p, q, r] := 0;
      for q := Vpred to LOWTAB do begin
	 Actors[p, q] := -1;
	 ActLex[p, q] := '   .    . '
      end;
      for q := PR_NP1 to PR_NP6 do
	 LexList_Clear(clauselex[p, q]);
      TtyClear(txt, p);
      PargrClear(partxt[p])
   end;
   RelationsClear(Relations);
   for p := 1 to 10 do
      txtTAB[p] := 0;
   for p := 1 to TxtLength do
      for q := INVENT to PARstart do
	 PhrLexClear(APatlex[p, q])
end;


procedure newClauseconnsort;
begin
   writeln(cnsort ,'#!/bin/sh');
   writeln(cnsort ,'name=$1');
   writeln(cnsort ,'sort +5 -o $name.rep.sort $name.rep');
end;
procedure newClausetypesort;
begin
   writeln(clsort ,'#!/bin/sh');
   writeln(clsort ,'name=$1');
   writeln(clsort ,'sort -o $name.cla.sort $name.typ.asc');
end;
procedure newCTTsort;
begin
   writeln(ctsort ,'#!/bin/sh');
   writeln(ctsort ,'name=$1');
   writeln(ctsort ,'sort +2 -o $name.CTT.sort $name.CTT');
end;
procedure newCL4sort;
begin
   writeln(cl4sort ,'#!/bin/sh');
   writeln(cl4sort ,'name=$1');
 {  writeln(cl4sort ,'sort +1 -o $name.cl4.sort $name.cl4');
 }
   writeln(cl4sort ,'hebsort +1 $name.cl4');
   writeln(cl4sort ,'mv $name.cl4 $name.cl4.sort');
end;


procedure WritePrintCommand(s: StringType; m: real);
const
   Lines = 44;	(* printable lines on A4 in landscape *)
begin
   write(' lp -o length=', round(Lines / m):1);
   write(' -y landscape,magnify=', m:4:2);
   writeln(' ', s)
end;


procedure advice;
begin
   write  (' Proposal of textual hierarchy is stored on file  ');
   writeln(PericopeName,'.CTT ');

   write  (' Inventory of clause types is stored on file  ');
   writeln(PericopeName,'.typ.asc ');
   write  (' Resulting clause connections are stored on file  ');
   writeln(PericopeName,'.PX      ');
   write  (' Frequency of clause connections is stored on file  ');
   writeln(PericopeName,'.clfreq  ');
   write  (' Inventory of user-made tabs is stored on file  ');
   writeln(PericopeName,'.usertab ');
   write  (' Data file with list of clause types: ClTypesList ');
   writeln;
   write  (' Data file with list of clause connections arguments: ArgumentsList ');
   writeln;
   newClausetypesort;
   writeln;
   writeln(' for SORTING do:');
   writeln(' sh Clausetypesort ',PericopeName);
   writeln(' more ',PericopeName,'.cla.sort ');
   newClauseconnsort;
   writeln;
   writeln(' sh Clauseconnsort ',PericopeName);
   writeln(' more ',PericopeName,'.rep.sort ');
   writeln;
   writeln(' sh CTTsort ',PericopeName);
   writeln(' more ',PericopeName,'.CTT.sort ');
   newCTTsort;
   writeln;
   writeln(' sh CL4sort ',PericopeName);
   writeln(' more ',PericopeName,'.cl4.sort ');
   newCL4sort;
   writeln;
   writeln(' for PRINTING do:');
   WritePrintCommand(PericopeName + '.clfreq', 0.7);
   writeln;
   WritePrintCommand(PericopeName + '.typ.asc', 0.6);
   writeln;
   WritePrintCommand(PericopeName + '.CTT', 0.8);
   writeln;
   WritePrintCommand(PericopeName + '.cl4', 0.8);
   writeln;
   WritePrintCommand('ClFreqTot', 0.7);
   writeln;
end;


procedure RenumberClauses(var r: RelRec; n: integer);
(* Turn absolute clause numbers into relative ones *)
var
   C: array [1..TxtLength] of integer;	(* clause *)
   S: array [1..TxtLength] of integer;	(* sentence *)
   i: integer;
begin
   for i := 1 to TxtLength do begin
      C[i] := 0;
      S[i] := 0
   end;
   for i := 1 to n do begin
      if C[r[i, ClauseNr]] = 0 then begin
	 S[r[i, SentenceNr]] := S[r[i, SentenceNr]] + 1;
	 C[r[i, ClauseNr]] := S[r[i, SentenceNr]]
      end;
      r[i, ClauseNr] := C[r[i, ClauseNr]]
   end
end;


procedure AutoSession;
(* Automatically adding clause connections to the usertab *)
begin
   writeln('Automatically calculating clause connections');
   writeln('Automatic production of clause connections is as yet unreliable');
   pcexit(1)
end;


procedure EditSession;
(* Interactively editing a complete usertab *)
var
   editing: boolean;
begin
   writeln('Interactively editing clause connections');
   editing := true;
   while editing do begin
      writeln;
      writeln(' Do you want to EDIT clause connections? y/n  ');
      if ReadAnswer(['y', 'n'])  = 'y' then
	 EditLines
      else
	 editing := false
   end
end;


procedure TabSession;
(* Interactively adding clause connections to the usertab *)
var
   editing: boolean;
begin
   writeln('Interactively adding clause connections');
   editing := true;
   while editing do begin
      ConnectLines(0, 0);
      writeln;
      writeln(' Do you want to EDIT clause connections? y/n  ');
      if ReadAnswer(['y', 'n'])  = 'n' then
	 editing := false
      else begin
	 EditLines;
	 editing := StopLine < MAXLines
      end
   end
end;


procedure PhaseOne;
begin
   writeln(' PHASE 1: Reading grammatical and lexical data from Lists');
   askfiles;
   RefreshArrays;
   ReadClauseTypesList;
   ReadArgList(ArgListFile, ArgList);
   writeln('Read ', MAXArguTypes:1, ' arguments from ArgumentList');
   ReadQuotAct;
   ReadCjVbList(Vll, CjVbList);
   ReadCodesList(CodesLst, CodLST, CodVal);
   ReadClauseTotRelations;
   writeln
end;


procedure PhaseTwo;
var
   x: integer;
begin
   writeln(' PHASE 2: Reading grammatical and lexical data from Text File');
   writeln('    +     Calculating grammatical data: ClauseTypes ');
   reset(ct4);
   x := 0;
   while not eof(ps4) do begin
      x := x + 1;
      order := true;
      ReadLine
   end;
   writeln;
   ReadUserTabs(Relations, StopLine);
   AssignMothers(Relations, StopLine);
   writeln(StopLine: 3, ' clause connections have been read from file "usertab". ');
   SOFAR := StopLine;
   if StopLine > NumberOfLines then begin
      writeln('Error: ', PericopeName + '.usertab', ' has too many lines (', StopLine: 1, ').');
      writeln('There are ', NumberOfLines: 1, ' clause atoms in the text.');
      pcexit(1)
   end;
   writeln;
   if ExistRefInfo and CorrectAct then
      for x := 2 to StopLine do
	 CalculateActors(x);
   ExistRefInfo := false;
   writeln
end;


procedure PhaseThree;
(* Determines which of the four modes is run *)
begin
   write(' PHASE 3: ');
   if StopLine < NumberOfLines then	(* produce usertab *)
      if Interactive then
	 TabSession
      else
         AutoSession
   else					(* apply usertab *)
      if Interactive then
	 EditSession
      else
         writeln('Applying ', PericopeName + '.usertab', '.');
   writeln
end;


procedure PhaseFour;
var
   answer: char;
begin
   AssignMothers(Relations, StopLine);
   AssignClauseNumbers(Relations, StopLine);
   CreateClauses(Relations, StopLine);
   AssignCodes(Relations, StopLine);
   AssignTypes(Relations, StopLine);
   AssignSentenceNumbers(Relations, StopLine);
   AssignTextTypes(Relations, StopLine);
   RenumberClauses(Relations, StopLine);
   writeln(' PHASE 4: Storing new data on file');
   if not Interactive then
      answer := 'y'
   else begin
      writeln;
      writeln(' save your new version of ', PericopeName, '.CTT ? ');
      writeln('  and your new version of ', PericopeName, '.usertab ?  y/n');
      writeln(' "y(es)" means: your production will be saved !!');
      answer := ReadAnswer(['y', 'n'])
   end;
   if answer = 'y' then begin
      TestTabs;
      printpx;
      WriteUserTabs(answer);
      RelFrequencies;
      WriteCompareClauseTypes;
      WritePhrasePositions(tp4, PosLabList, phrases, StopLine);
      WritePhrases;
      WriteQuotACT
   end
end;


#ifdef DEBUG
procedure dumpActors(var a: Actorstype; r0, r1, k0, k1: integer);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpActors(&Actors, 1, NumberOfLines, 1, 27) *)
var
   i, j: integer;
begin
   for i := r0 to r1 do begin
      write(i:3, ':');
      for j := k0 to k1 do
	 write(' ', a[i, j]:3);
      writeln
   end
end;


procedure dumpClauses(var r: Clauserec; t, n: integer);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpClauses(&Clauses, 7, 2) *)
const
   OFFSET = 5;
var
   i, j: integer;
begin
   writeln('Clause record[', t:1, ',i,', n:1, ']');
   for i := t - OFFSET to t + OFFSET do
      if (1 <= i) and (i <= TxtLength) then begin
	 if i = t then
	    write('>')
	 else
	    write(' ');
	 write(i:3, ':');
	 for j := 1 to Linecode do
	    write(r[i, j, n]:4);
	 writeln
      end
end;


procedure dumpRelations(var a: RelRec; r0, r1, k0, k1: integer);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpRelations(&Relations, 1, NumberOfLines, -7, 5) *)
var
   i, j: integer;
begin
   for i := r0 to r1 do begin
      write(i:3, ':');
      for j := k0 to k1 do
	 write(' ', a[i, j]:4);
      writeln
   end
end;


procedure dumpphrases(var p: phraserec; r0, r1, k0, k1: integer);
(* debug procedure, not called in program *)
(* e.g. dbx> call dumpphrases(&phrases, 1, NumberOfLines, 0, 33) *)
var
   i, j: integer;
begin
   for i := r0 to r1 do begin
      write(i:3, ':');
      for j := k0 to k1 do
	 write(' ', p[i, j]);
      writeln
   end
end;
#endif	/* DEBUG */


procedure Initialise;
(* All initialisation that is not a simple variable assignment *)
begin
   Interactive := not ArgTest('-n');
   PNG_Letters[KO_GN] := 'FM-';
   PNG_Letters[KO_NU] := 'SDP';
   PNG_Letters[KO_PS] := '123';
   PhrPos_Labels(PosLabList);
   (* For backward compatibility, add the obsolete parsing labels to
      the sets, so that they are recognised. *)
   CmplSet := CmplSet + [IrpC] + [FrnC];
   FrntSet := FrntSet + [FrnA, FrnC, FrnO, FrnS];
   ObjcSet := ObjcSet + [IrpO] + [FrnO];
   PreCSet := PreCSet + [IrpP] + [PtSp];
   SubSSet := SubSSet + [IrpS] + [FrnS];
   SubjSet := SubjSet + SubSSet;
   LS_NMCP :=  LS_Code(SP_SUBS, -5);
   LS_AFAD :=  LS_Code(SP_ADVB, -4);
   LS_CJAD :=  LS_Code(SP_ADVB, -3);
   LS_FOCP :=  LS_Code(SP_ADVB, -2);
   LS_QUES :=  LS_Code(SP_INRG, -2);
   LS_QUOT :=  LS_Code(SP_VERB, -1)
end;


begin
   ClauseNb := 0;
   CorrectAct := false;
   DisAgree := 0;
   Editor := false;
   ExistRefInfo := false;
   LastSentenceNb := 0;
   MAXCjLex := 0;
   MAXClTypes := 0;
   MAXLines := 0;
   MAXQuotAct := 0;
   NOustabs := true;
   NumberOfLines := 0;
   SOFAR := 0;
   SentenceNb := 0;
   StopLine := 0;

   Initialise;
   PhaseOne;
   PhaseTwo;
   PhaseThree;
   PhaseFour;

   if Interactive then begin
      writeln(' do you want a reversed version of ', PericopeName, '.CTT ?  y/n');
      if ReadAnswer(['y', 'n']) = 'y' then
	 ReverseCTT
   end;
   writeln(' number of lines in text ', PericopeName, ' :', MAXLines);
   writeln(' number of disagreements in clause hierarchy:', DisAgree);
   advice;
   if PSP then
      WriteActors;

   close(clsort);
   close(cnsort);
   close(ctsort);
   close(cl4sort);
   close(tp4);
   close(act);
   close(CTT);
   close(rep);
   close(ustabs);
   close(clfreq);
   close(ArgListFile);
   close(Qa);
   close(cl4);
   close(vblcl);
   close(ClLst);
   close(hierarch)
end.
