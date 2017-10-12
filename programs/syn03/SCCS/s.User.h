h29812
s 00044/00000/00000
d D 1.1 99/02/16 14:13:47 const 1 0
c date and time created 99/02/16 14:13:47 by const
e
u
U
f e 0
f m dapro/syn03/User.h
t
T
I 1
#ifndef	USER_H
#define	USER_H

#include	<Atom.h>
#include	<Division.h>
#include	<Verse.h>

(* ident "%Z%%M% %I% %G%" *)

function  User_Action:char;
(* Returns 'c' for construct, 'd' for delete or 'r' for retry phrase
** pattern.
*)
extern;

procedure User_BadPhrase(d0, d1: DivisionType; p: PatternType);
(* Returns the bad phrase pattern in [p] and truncates [d1] to leave a
** list with correct phrase patterns. The remaining patterns of [d0]
** are joined to form one pattern.
** When it returns:
**    -- length(d0) = length(d1) + 1
**    -- the last elements of d0 and d1 are current.
*)
extern;

function  User_Confirmation(s: SurfaceType; d0, d1: DivisionType):boolean;
extern;

function  User_Continue:boolean;
extern;

procedure User_Init;
extern;

function  User_Interactive:boolean;
extern;

procedure User_MakePhrase(s: SurfaceType; d0, d1: DivisionType; p: PatternType);
(* Returns in [p] a new pattern that will be the successor of the last
** pattern in [d1].
*)
extern;

#endif	(* not USER_H *)
E 1
