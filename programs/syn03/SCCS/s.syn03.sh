h00562
s 00010/00009/00065
d D 1.2 03/11/13 15:04:13 const 2 1
c Removed hard-coded path name.
e
s 00074/00000/00000
d D 1.1 99/02/16 14:14:34 const 1 0
c date and time created 99/02/16 14:14:34 by const
e
u
U
f e 0
f m dapro/syn03/syn03.sh
t
T
I 1
#!/bin/sh

D 2
#ident "%Z%%M% %I% %G%"
E 2
I 2
#ident %W% %E%
E 2

I 2
BASEDIR=%BASEDIR%
NAME=`basename $0`

E 2
auxiliary="lexcond morfcond phrset"
language=hebrew
D 2
name=`basename $0`
root=/projects/grammar
E 2

err() {
D 2
   echo "${name}: $1" 1>&2
E 2
I 2
   echo "${NAME}: $1" 1>&2
E 2
   exit 1
}

usage() {
D 2
   echo "usage: $name [-l language]" 1>&2
E 2
I 2
   echo "usage: $NAME [-l language]" 1>&2
E 2
   exit 1
}


while getopts l: c
do
   case $c in
      l)
	 language=$OPTARG ;;
      \?)
	 usage ;;
   esac
done
shift `expr $OPTIND - 1`

test $# -eq 0 || usage

test -f synnr || err "synnr missing"

set `wc synnr`

test $1 -eq 1 -a $2 -eq 2 || err "synnr corrupt"

if [ `awk '{print $1}' synnr` -ne 2 ] ; then
D 2
   err "wrong stage, run $name after syn02"
E 2
I 2
   err "wrong stage, run $NAME after syn02"
E 2
fi

text=`awk '{print $2}' synnr`

test -f $text.ps2 || err "$text.ps2 missing"

test -f $text.ct || err "$text.ct missing"

echo "Language is $language"

set -e

for f in $auxiliary ; do
   if [ ! -f $f ] ; then
D 2
      echo "Using default $f from $root/lib/$language"
      cp -p $root/lib/$language/$f .
E 2
I 2
      echo "Using default $f from $BASEDIR/lib/$language"
      cp -p $BASEDIR/lib/$language/$f .
E 2
   fi
done

test -f $text.phd || touch $text.phd

if [ -f $text.npd ] ; then
   n0=`cat $text.phd | wc -l`
   n1=`cat $text.npd | wc -l`
   if [ $n1 -gt $n0 ] ; then
      echo "Using the new phrase divisions"
      mv $text.npd $text.phd
   fi
fi

set +e

D 2
$root/bin/${name}x
E 2
I 2
$BASEDIR/bin/${NAME}x
E 2
E 1
