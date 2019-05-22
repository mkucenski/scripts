#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

# The purpose of this script is to link files, but rename them with their MD5 hash and the existing file extension.
# This can be used with something like 'find ./ -type f -exec <script> {} ./uniq \;' to save all unique files in one
# directory for analysis.

FILE="$1"
DEST="$2"
EXT="$3"
if [ $# -eq 0 ]; then
	USAGE "FILE" "DEST" "EXT" && exit $COMMON_ERROR
fi
if [ -z "$EXT" ]; then
	EXT="$(GET_EXTENSION "$FILE")"
fi

RV=$COMMON_SUCCESS

if [ -e "$FILE" ]; then
	HASH="$(md5 -r "$FILE" | gsed -r 's/([^[:space:]]+).*/\1/')"
	mkdir -p "$DEST"
	echo "$FILE -> $DEST/$HASH.$EXT"
	ln "$FILE" "$DEST/$HASH.$EXT"
else
	ERROR "File <$FILE> does not exist!" "$0"
fi

exit $RV

