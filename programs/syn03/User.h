#ifndef	USER_H
#define	USER_H

#include	<Atom.h>
#include	<Division.h>
#include	<Verse.h>

(* ident "@(#)dapro/syn03/User.h 1.1 02/16/99" *)

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
