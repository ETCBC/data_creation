# Creates up-to-date versions of $C.at, $C.ps2, $C.ct4.p, and $C.PX for
# every chapter of Mesa with a $C.ps5 under SCCS in synvar/analyse.

ANALYSE=/projects/synvar/analyse

sccs -d $ANALYSE get Mesa.an

for s in $ANALYSE/SCCS/s.Mesa[0-9]*.ps5
do
   C=`expr $s : '.*SCCS/s\.\(.*\)\.ps5$'`
   test $C.PX.corr -nt $s || sccs -d $ANALYSE get -G $C.PX.corr $C.ps5
   make C=$C
done

# Note that make(1S) will always rebuild $C.ct4.p with books of more
# than one chapter, because it depends on $(PARSECLAUSES_RW), which
# will be updated by the next chapter.
