# Makes the ct(5) files produced by at2ps(1) suitable for syn03(1),
# parseclauses(1) and pxdump(1).

#ident "@(#)q2pro/at2ps/ctcor.sed	1.4 13/12/08"

s/  / . /g
/^IIKON05,18/s/ JSLX N> / JSLX_N> /
/^ EZE 48,16/s/ XMC XMC / XMC_XMC /
/^ JER 38,16/s/ >T >CR / >T_>CR /
/^ JER 39,12/s/ KJ >M / KJ_>M /
/^ JER 51,03/s/ JDRK JDRK / JDRK_JDRK /
/^ RUTH03,12/s/ KJ >M / KJ_>M /
