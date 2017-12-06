#!/usr/bin/env bash

WTMP="$1"
SRC="$2"

cat $WTMP | while read X; do
	DATESTR=`echo "$X" | gsed -r 's/(........................)[[:space:]]+.*/\1/'`
	ENTRY=`echo "$X" | gsed -r 's/(........................)[[:space:]]+(.*)/\2/' | gsed -r 's/[[:space:]]+/ /g'`
	EPOCHDATE=$(${BASH_SOURCE%/*}/date-to-epoch.sh "$DATESTR")
	echo "0|$SRC: $ENTRY|0|----------|0|0|0|$EPOCHDATE|$EPOCHDATE|$EPOCHDATE|$EPOCHDATE"
done


