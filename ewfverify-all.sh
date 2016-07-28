#!/bin/bash

BASEDIR="$1"
LOGDIR="$2"

# Find all .E01 files within BASEDIR and execute <ewfverify> on each. Log all results
# to <LOGDIR/ewfverify.log> as well as individual results in each image directory.

LOGALL="$LOGDIR/ewfverify.log"

VER=$(ewfverify -V | grep -v "^$")
echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOGALL"
echo "$VER" >> "$LOGALL"
echo "" >> "$LOGALL"

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for IMAGE in `find "$BASEDIR" -type f -iname "*.e01"`; do
	NAME=$(basename "$IMAGE")
	IMAGEDIR=$(cd $(dirname "$IMAGE"); pwd)
	LOG="$IMAGEDIR/ewfverify-$NAME.log"

	echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
	echo "$VER" >> "$LOG"
	echo "" >> "$LOG"
	echo "Image: $IMAGEDIR/$NAME" | tee -a "$LOGALL" "$LOG"

	ewfverify -q "$IMAGE" 2>&1 | grep -v "^$" | tee -a "$LOGALL" "$LOG"

	echo "END: `date \"+%Y%m%d\"`" >> "$LOG"
	echo "" >> "$LOG"
done

echo "END: `date \"+%Y%m%d\"`" >> "$LOGALL"
echo "" >> "$LOGALL"

