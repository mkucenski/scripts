#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# The purpose of this script is to copy files, but rename them with their MD5 hash and the existing file extension.
# This can be used with something like 'find ./ -type f -exec <script> {} ./uniq \;' to save all unique files in one
# directory for analysis.

FILE="$1"
DEST="$2"
if [ $# -ne 2 ]; then
	USAGE "FILE" "DEST" && exit 1
fi

if [ -e "$FILE" ]; then
	HASH="$(md5 -r "$FILE" | gsed -r 's/([^[:space:]]+).*/\1/')"
	mkdir -p "$DEST"
	cp -v "$FILE" "$DEST/$HASH.$(SAVE_EXTENSION "$FILE")"
else
	ERROR "File <$FILE> does not exist!" "$0" && exit 1
fi

