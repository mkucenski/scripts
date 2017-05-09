#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

# Find all .E01 files within BASEDIR and execute <ewfverify> on each.

BASEDIR="$1"
LOGFILE="$2"
if [ $# -lt 1 ]; then
	USAGE "BASEDIR" "LOGFILE (optional)" && exit 0
fi

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for IMAGE in $(find "$BASEDIR" -type f -iname "*.E01"); do
	DEBUG "IMAGE: $IMAGE" "$0"
	FULL_IMAGE_PATH="$(cd $(dirname "$IMAGE"); pwd)/$(basename "$IMAGE")"
	RESULT=$(${BASH_SOURCE%/*}/ewfverify.sh "$IMAGE")
	if [ $RESULT -ge 0 ]; then	
		INFO "SUCCESS: $FULL_IMAGE_PATH" "$LOGFILE"
	else
		INFO "FAILURE: $FULL_IMAGE_PATH" "$LOGFILE"
	fi
done

