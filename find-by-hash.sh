#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# The purpose of this script is to find files based on their MD5 hash value.
# This can be used in conjunction with 'copy-as-hash.sh' to go back and
# identify the original file(s); albeit slowly since it has to re-hash
# every file...

HASH="$1"
DIR="$2"
if [ $# -ne 2 ]; then
	USAGE "HASH" "DIR" && exit 1
fi

for FILE in $(find "$DIR" -type f); do
	FILE_HASH="$(md5 -r "$FILE" | gsed -r 's/([^[:space:]]+).*/\1/')"
	if [ "$HASH" == "$FILE_HASH" ]; then
		echo "Found: $FILE"
	fi
done

