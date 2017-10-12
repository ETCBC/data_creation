h21336
s 00004/00004/00008
d D 1.4 13/12/08 11:59:17 const 4 3
c QRJ W-L> KTJB: Use . for empty surface, in accordance with pxdump(1)
e
s 00006/00006/00006
d D 1.3 09/07/27 15:04:41 const 3 2
c Pattern for Ru 3:12 needs more context.
e
s 00003/00002/00009
d D 1.2 07/04/04 11:05:22 const 2 1
c parseclauses(1) did not like the " - " for QRJ W-L> KTJB.
e
s 00011/00000/00000
d D 1.1 06/09/15 12:24:36 const 1 0
c date and time created 06/09/15 12:24:36 by const
e
u
U
f e 0
f m q2pro/at2ps/ctcor.sed
t
T
I 1
D 2
# Makes the ct(5) files produced by at2ps(1) suitable for syn03(1).
E 2
I 2
D 4
# Makes the ct(5) files produced by at2ps(1) suitable for syn03(1) and
# parseclauses(1).
E 4
I 4
# Makes the ct(5) files produced by at2ps(1) suitable for syn03(1),
# parseclauses(1) and pxdump(1).
E 4
E 2

D 4
#ident %W% %E%
E 4
I 4
#ident "%W% %E%"
E 4

D 2
s/  / - /g
E 2
I 2
D 4
s/  / Q /g
E 4
I 4
s/  / . /g
E 4
E 2
D 3
/^IIKON05,18/s/JSLX N>/JSLX_N>/
/^ EZE 48,16/s/XMC XMC/XMC_XMC/
/^ JER 38,16/s/>T >CR/>T_>CR/
/^ JER 39,12/s/KJ >M/KJ_>M/
/^ JER 51,03/s/JDRK JDRK/JDRK_JDRK/
/^ RUTH03,12/s/KJ >M/KJ_>M/
E 3
I 3
/^IIKON05,18/s/ JSLX N> / JSLX_N> /
/^ EZE 48,16/s/ XMC XMC / XMC_XMC /
/^ JER 38,16/s/ >T >CR / >T_>CR /
/^ JER 39,12/s/ KJ >M / KJ_>M /
/^ JER 51,03/s/ JDRK JDRK / JDRK_JDRK /
/^ RUTH03,12/s/ KJ >M / KJ_>M /
E 3
E 1
