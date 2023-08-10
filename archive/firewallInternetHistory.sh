#!/bin/sh

DELIM="\|"
OUTDELIM="|"
LOGFILENAME="(.+):"
DATETIME="(...) (..) (..):(..):(..)\...."
NEWDATETIME="(...$DELIM..$DELIM..$DELIM..$DELIM..)"
SOURCEIP=" src=([^\/]+)\/([^ ]+) "
DESTIP=" dst=([^\/]+)\/([^ ]+) "
URL=" arg=([^ ]+) "

#DNAMEREGEX=`cat ~/Scripts/helpers/domainName.regex`
DNAMEREGEX="\b(\w((\w|-){0,61}\w)?\.)*\w((\w|-){0,61}\w)?\b"
INTERNETREGEX="^($LOGFILENAME)?$DATETIME.*$SOURCEIP.*$DESTIP.*$URL.*$"
NEWINTERNETREGEX="^$NEWDATETIME.*$SOURCEIP.*$DESTIP.*$URL.*$"

SED="s/^($LOGFILENAME)?$DATETIME/\3$DELIM\4$DELIM\5$DELIM\6$DELIM\7/;\
s/$NEWINTERNETREGEX/\1$DELIM\2$DELIM\3$DELIM\4$DELIM\5$DELIM\6/;\
s/((http|https|file|ftp):\/\/\/?($DNAMEREGEX))/\3$DELIM\1/;\
s/$DELIM/$DELIM/g"

echo "MONTH"$OUTDELIM"DAY"$OUTDELIM"HOUR"$OUTDELIM"MIN"$OUTDELIM"SEC"$OUTDELIM"SRC IP"$OUTDELIM"SRC PORT"$OUTDELIM"DEST IP"$OUTDELIM"DEST PORT"$OUTDELIM"DOMAIN"$OUTDELIM"URL"$OUTDELIM"MINDIFF"

if [ -z "$1" ];
then
   echo "No year given, assuming 2005"
   YEAR=2005
else
   YEAR=$1
   echo "Given year: $YEAR"
fi

cat /dev/stdin | egrep "$INTERNETREGEX" | sed -r "$SED" | sort -t $OUTDELIM -k 1,2M -k 2,3n -k 3,4n -k 4,5n -k 5,6n | awk --field-separator "$OUTDELIM" --file firewallInternetHistory.awk --assign year=$YEAR --assign threshold=15

