#!/bin/sh

UNAME=`uname`

DATE=`date`
DATEREGEX="^(...) (...) (.?.) ((..):(..):(..)) (...) (....)"

AWKCMD=awk
SEDCMD=sed

# FreeBSD uses modified names for GNU versions of awk/sed
if [ "$UNAME" = "FreeBSD" ];
then
   AWKCMD=gawk
   SEDCMD=gsed
fi

THRESHOLD=15
SORT=1
TIMERANGE="*"
SUMMARYONLY=0
OUTDELIM=","
YEAR=`echo $DATE | $SEDCMD -r "s/$DATEREGEX/\9/"`
FILE=/dev/stdin

while getopts "d:hnr:st:y:" OPTION
do
   case $OPTION in
      d) THRESHOLD="$OPTARG"
         ;;
      n) SORT=0
         ;;
      r) TIMERANGE="$OPTARG"
         ;;
      s) SUMMARYONLY=1
         ;;
      t) OUTDELIM="$OPTARG"
         ;;
      y) YEAR="$OPTARG"
         ;;
      *h) echo "usage: fwhistory.sh [-dnsty] [file]"
         echo "       d : threshold value (min.)"
         echo "       n : do not sort incoming data (can speed processing large, previously sorted data sets)"
         echo "       r : time range xxxx-yyyy 24hr (defaults to all times)"
         echo "       s : display summary only"
         echo "       t : field separator (defaults to a comma)"
         echo "       y : firewall data year (defaults to current year)"
         echo "       file : file to process (defaults to stdin)"
         exit 1
         ;;
   esac
done
shift $(($OPTIND - 1))

if [ -n "$1" ]
then
   FILE="$1"
fi

DELIM="\|"
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
s/$DELIM/$OUTDELIM/g"

SORTARGS="-t $OUTDELIM -k 1,2M -k 2,3n -k 3,4n -k 4,5n -k 5,6n"
AWKARGS="--field-separator "$OUTDELIM" --file `dirname $0`/helpers/fwhistory.awk --assign year=$YEAR --assign threshold=$THRESHOLD --assign delim=$OUTDELIM --assign summaryOnly=$SUMMARYONLY --assign timeRange=$TIMERANGE"

if [ $SORT = 1 ]
then
   cat "$FILE" | egrep "$INTERNETREGEX" | $SEDCMD -r "$SED" | sort $SORTARGS | $AWKCMD $AWKARGS
else
   cat "$FILE" | egrep "$INTERNETREGEX" | $SEDCMD -r "$SED" | $AWKCMD $AWKARGS
fi

