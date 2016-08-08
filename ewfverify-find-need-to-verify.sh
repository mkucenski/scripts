#!/bin/bash

BASEDIR="$1"
LOGDIR="$2"

# Find all .E01 files within <BASEDIR> for which there is no record of SUCCESS or
# FAILURE in <LOGDIR/ewfverify.log>. Execute <ewfverify-all.sh> for each such
# directory.

ERR=0
LOG="$LOGDIR/ewfverify.log"

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for IMAGE in `find "$BASEDIR" -type f -iname "*.e01"`; do
	NAME=$(basename "$IMAGE")
	IMAGEDIR=$(cd $(dirname "$IMAGE"); pwd)

	# NOTE: This assumes .E01 filesnames are unique across the directory space
	#       you're searching.

	RESULT=$(grep "$NAME" "$LOG" | egrep "\((SUCCESS|FAILURE)\)")
	if [ -z "$RESULT" ]; then
		echo "Executing <ewfverify-all.sh> on <$IMAGEDIR>..."
		$(dirname "$0")/ewfverify-all.sh "$IMAGEDIR" "$LOGDIR"
	else
		echo "Found previous result for <$IMAGE>!"
	fi
done

exit $ERR

