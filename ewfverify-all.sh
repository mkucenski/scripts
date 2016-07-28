#!/bin/bash

BASEDIR="$1"
LOGDIR="$2"
LOGALL="$LOGDIR/ewfverify.log"

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for X in `find "$BASEDIR" -type f -iname "*.e01"`; do
	PWD=`dirname "$X"`
	NAME=`basename "$X"`
	LOG="$PWD/ewfverify-$NAME.log"

	echo "BEGIN: `date \"+%Y%m%d\"`" | tee -a "$LOGALL" >> "$LOG"
	echo "Image: $X" | tee -a "$LOGALL" "$LOG"

	ewfverify -q "$X" 2>&1 | grep -v "" | tee -a "$LOGALL" "$LOG"

	echo "END: `date \"+%Y%m%d\"`" | tee -a "$LOGALL" >> "$LOG"
	echo "" | tee -a "$LOGALL" >> "$LOG"
done

