#!/usr/bin/env bash

DELIM="\t"
OUTDELIM=","
FIELD="[^$DELIM]*$DELIM"
DNAMEREGEX=`cat ~/Scripts/helpers/domainName.regex`

pasco -d "$1" > .pasco.tmp

INDEXFILE=`head .pasco.tmp | grep "History File:" | gsed -r 's/History File: (.+) Version: .+/\1/;s/\//\\\\\//g'`
INDEXVERSION=`head .pasco.tmp | grep "History File:" | gsed -r "s/History File: .+ Version: (.+)/\1/"`
USERID=`echo $INDEXFILE | gsed -r 's/.+Documents and Settings\\\\\/([^\\\\\/]+)\\\\\/.+/\1/'`

TYPE="^(URL|REDR|LEAK)$DELIM"
URL="(Visited: [^@]+@|Cookie:[^@]+@|userdata:[^@]+@|:[[:digit:]]+: [^@]+@|)([^$DELIM]+)$DELIM"
MTIME="([[:digit:]]{2}\/[[:digit:]]{2}\/[[:digit:]]{4} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2})?$DELIM"
ATIME=$MTIME
FILENAME="([^$DELIM]+)?$DELIM"
DIRECTORY="([^$DELIM]+)?$DELIM"
HTTPHEADERS="(.*)?$"

SED="s/$TYPE$URL$MTIME$ATIME$FILENAME$DIRECTORY$HTTPHEADERS/\1$DELIM\2$DELIM\"\3\"$DELIM\4$DELIM\5$DELIM\"\6\"$DELIM\"\7\"$DELIM\"\8\"$DELIM\"$INDEXFILE\"$DELIM$INDEXVERSION$DELIM\"$USERID\"/"
SUBTYPESED="s/($FIELD):?([^: $DELIM]*)[^$DELIM]*$DELIM/\1\2$DELIM/"
URLSED="s/$FIELD$FIELD(http|https|ftp|file):\/\/\/?($DNAMEREGEX)[^$DELIM]*.*/&$DELIM\2/"
#TIMESED="s/([[:digit:]]{2}\/[[:digit:]]{2}\/[[:digit:]]{4}) ([[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2})/\1$OUTDELIM\2/g"
DELIMSED="s/$DELIM/$OUTDELIM/g"

echo "TYPE"$OUTDELIM$OUTDELIM"URL"$OUTDELIM"MODIFIED"$OUTDELIM"ACCESSED"$OUTDELIM"FILENAME"$OUTDELIM"DIRECTORY"$OUTDELIM"HEADERS"$OUTDELIM"INDEX FILE"$OUTDELIM"INDEX FILE VERSION"$OUTDELIM"USER"
cat .pasco.tmp | grep -v "^TYPE" | grep -v "^History File:" | gsed -r "$SED;$SUBTYPESED;$URLSED;$DELIMSED"
rm .pasco.tmp










# pasco "$1" > .pasco.tmp
# INDEXFILE=`head .pasco.tmp | grep "History File:" | gsed -r 's/History File: (.+) Version: .+/\1/;s/\//\\\\\//g'`
# INDEXVERSION=`head .pasco.tmp | grep "History File:" | gsed -r "s/History File: .+ Version: (.+)/\1/"`
# USERID=`echo $INDEXFILE | gsed -r 's/.+Documents and Settings\\\\\/([^\\\\\/]+)\\\\\/.+/\1/'`

# FILEINFOSED="s/^($TYPE$DELIM$URL$DELIM.*)/\1$DELIM$INDEXFILE$DELIM$INDEXVERSION/"

# DATETIMESED="s/(..\/..\/....) (..:..:..)/\1$DELIM\2/g"
# ADDSED="s/.*/&$DELIM$INDEXFILE$DELIM$INDEXVERSION$DELIM$USERID/"
# DNAMESED="s/.*(http|https|ftp):\/\/\/?($DNAMEREGEX).*/&$DELIM\2/"

# echo "TYPE"$OUTDELIM"URL"$OUTDELIM"MODIFIED DATE"$OUTDELIM"MODIFIED TIME"$OUTDELIM"ACCESS DATE"$OUTDELIM"ACCESS TIME"$OUTDELIM"FILENAME"$OUTDELIM"DIRECTORY"$OUTDELIM"HTTP HEADERS"$OUTDELIM"USERID"$OUTDELIM"INDEX FILE"$OUTDELIM"INDEX VERSION"$OUTDELIM"DOMAIN"

# cat .pasco.tmp | grep -v "History File:" | grep -v "^TYPE" | gsed -r "$DATETIMESED;$ADDSED;$DNAMESED;s/$DELIM/$OUTDELIM/g"
# rm .pasco.tmp

# pasco "$1" | gsed -r -f ~/Scripts/helpers/pasco.sed
# pasco -t \\ "$1" | gsed -r -f ~/Scripts/helpers/pasco.sed
# echo `head -n 4 .pasco.tmp`
# sort -t \\ +2 -3 .pasco.tmp | gsed 's/\\/\t/g'

