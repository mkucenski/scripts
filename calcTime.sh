#!/bin/sh

UNAME=`uname`

DATE=`date`
DATEREGEX="^(...) (...) (.?.) ((..):(..):(..)) (...) (....)"

AWKCMD=awk
SEDCMD=sed

# MacOSX uses modified names for GNU versions of awk/sed
if [ "$UNAME" = "Darwin" ]; then
   AWKCMD=gawk
   SEDCMD=gsed
fi

# FreeBSD uses modified names for GNU versions of awk/sed
if [ "$UNAME" = "FreeBSD" ]; then
   AWKCMD=gawk
   SEDCMD=gsed
fi

THRESHOLD=10
SORT=1
TIMERANGE="*"
YEAR=`echo $DATE | $SEDCMD -r "s/$DATEREGEX/\9/"`
FILE=/dev/stdin
TZ=UTC0

while getopts "d:hnr:y:z:" OPTION; do
   case $OPTION in
      d) THRESHOLD="$OPTARG"
         ;;
      n) SORT=0
         ;;
      r) TIMERANGE="$OPTARG"
         ;;
      y) YEAR="$OPTARG"
         ;;
      z) TZ="$OPTARG"
         ;;
      *h) echo "usage: calcTime.sh [-dnryz] [file]"
          echo "       d : threshold value (min.)"
          echo "       n : do not sort incoming data (can speed processing large, previously sorted data sets)"
          echo "       r : time range xxxx-yyyy 24hr (defaults to all times)"
          echo "       y : firewall data year (defaults to current year)"
          echo "       z : timezone (defaults to UTC0) (e.g. EST5EDT)"
          echo "       file : file to process (defaults to stdin)" exit 1
          ;;
   esac
done
shift $(($OPTIND - 1))

if [ -n "$1" ]; then
   FILE="$1"
fi

export TZ

DELIM="|"

# Remove the quoted log strings to avoid problems with embedded delimiters.  Don't need that data anyway to calculate time.
SEDARGS="s/\"[^\"]*\"//g"

# Data needs to be sorted so that the differences in time are counted correctly.
SORTARGS="-t $DELIM -k 14n"

AWKARGS="--field-separator "$DELIM" --file `dirname $0`/helpers/calcTime.awk --assign year=$YEAR --assign threshold=$THRESHOLD --assign timeRange=$TIMERANGE"

# TODO Mactime format stores times in UTC format.  May need to accept a parameter to put the time back in a more friendly zone
#TZ=EST5EDT
#export TZ

if [ $SORT = 1 ]
then
   cat "$FILE" | $SEDCMD -r $SEDARGS | sort $SORTARGS | $AWKCMD $AWKARGS
else
   cat "$FILE" | $SEDCMD -r $SEDARGS | $AWKCMD $AWKARGS
fi

