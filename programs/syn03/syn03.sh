#!/bin/sh

#ident @(#)dapro/syn03/syn03.sh	1.2 03/11/13

BASEDIR=%BASEDIR%
NAME=`basename $0`

auxiliary="lexcond morfcond phrset"
language=hebrew

err() {
   echo "${NAME}: $1" 1>&2
   exit 1
}

usage() {
   echo "usage: $NAME [-l language]" 1>&2
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
   err "wrong stage, run $NAME after syn02"
fi

text=`awk '{print $2}' synnr`

test -f $text.ps2 || err "$text.ps2 missing"

test -f $text.ct || err "$text.ct missing"

echo "Language is $language"

set -e

for f in $auxiliary ; do
   if [ ! -f $f ] ; then
      echo "Using default $f from $BASEDIR/lib/$language"
      cp -p $BASEDIR/lib/$language/$f .
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

$BASEDIR/bin/${NAME}x
