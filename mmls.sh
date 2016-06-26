#!/bin/sh

mmlsRegex=`cat ~/Scripts/mmls.regex`

if [ -z $1 ];
then
   cat /dev/stdin | egrep "[[:digit:]]{2}:" | /usr/local/bin/sed -r "s/$mmlsRegex/of=\"\1.\4.dd\" bs=512 skip=\2 count=\3/"
else
   cat $1 | egrep "[[:digit:]]{2}:" | /usr/local/bin/sed -r "s/$mmlsRegex/of=\"\1.\4.dd\" bs=512 skip=\2 count=\3/"
fi
