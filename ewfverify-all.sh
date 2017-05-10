#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

BASEDIR="$1"
LOGDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "BASEDIR" "LOGDIR" && exit 0
fi

# Find all .E01 files within BASEDIR and execute <ewfverify> on each. Log all results
# to <LOGDIR/ewfverify.log> as well as individual results in each image directory.

ERR=0
DATE=$(date "+%Y%m%d")
LOGALL="$LOGDIR/ewfverify.log"

# Store version information for ewfverify
VER=$(ewfverify -V | head -n 1)

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for IMAGE in `find "$BASEDIR" -type f -iname "*.e01"`; do
	NAME=$(basename "$IMAGE")
	IMAGEDIR=$(cd $(dirname "$IMAGE"); pwd)
	FULLIMAGE="$IMAGEDIR/$NAME"
	LOG="$IMAGEDIR/ewfverify-$NAME.log"

	echo "BEGIN: $DATE" >> "$LOG"
	echo "$VER" >> "$LOG"
	echo "" >> "$LOG"
	echo "Image: $FULLIMAGE" | tee -a "$LOG"

	RESULT=$(ewfverify -q "$IMAGE" | grep -v "^$")

	# Output full results to individual log file
	echo "$RESULT" >> "$LOG"

	VERIFY=$(echo "$RESULT" | egrep "ewfverify: (SUCCESS|FAILURE)" | $SEDCMD -r 's/ewfverify: (.+)/\1/')
	if [ $VERIFY == "SUCCESS" ]; then
		ERR=1
	elif [ $VERIFY == "FAILURE" ]; then
		ERR=0
	else
		VERIFY="UNKNOWN"
	fi
	echo "$VERIFY"

	# Output summarized result to primary log file
	echo "$DATE: ($VERIFY) $FULLIMAGE" >> "$LOGALL"

	echo "END: $DATE" >> "$LOG"
	echo "" >> "$LOG"
done

exit $ERR

