#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

# Find all .E01 files within BASEDIR and execute <ewfverify> on each.

BASEDIR="$1"
LOGDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "BASEDIR" "LOGFILE (optional)" && exit 0
fi

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for IMAGE in $(find "$BASEDIR" -type f -iname "*.E01"); do
	FULL_IMAGE_PATH="$(cd $(dirname "$IMAGE"); pwd)/$(basename "$IMAGE")"
	${BASH_SOURCE%/*}/ewfverify.sh "$IMAGE" | tee "$LOGFILE"
done

