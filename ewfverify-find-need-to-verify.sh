#!/usr/bin/env bash

BASEDIR="$1"
LOGDIR="$2"

# Find all .E01 files within <BASEDIR> for which there is no record of SUCCESS or
# FAILURE in <LOGDIR/ewfverify.log>. Execute <ewfverify-all.sh> for each such
# directory.

LOG="$LOGDIR/ewfverify.log"

find "$BASEDIR" -type f -iname "*.E01" -print0 | 
while IFS= read -r -d $'\0' IMAGE; do
	NAME=$(basename "$IMAGE")
	IMAGEDIR=$(cd "$(dirname "$IMAGE")"; pwd)

	# NOTE: This assumes .E01 filesnames are unique across the directory space
	#       you're searching.

	RESULT=$(grep "$NAME" "$LOG" | egrep "\((SUCCESS|FAILURE)\)")
	if [ -z "$RESULT" ]; then
		echo "Executing <ewfverify-all.sh> on <$IMAGEDIR>..."
		"$(dirname "$0")/ewfverify-all.sh" "$IMAGEDIR" "$LOGDIR"
	else
		echo "Found previous result ($RESULT) for <$IMAGE>!"
	fi
done

