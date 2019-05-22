#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

# $1 = source directory of files
# $2 = destination root directory

SRC="$(FULL_PATH "$1")"
DST="$2"

for FILE in $(find "$SRC" -type f); do
	MIME="$(file --mime --separator ";" "$FILE" | gsed -r 's/^([^;]+); ([^;]+); [^;]+$/\2/')"
	EXT="$(file --extension --separator ";" "$FILE" | gsed -r 's/.*;[[:space:]]+([^\/:]+).*/\1/')"
	echo "$FILE -> $DST/$MIME/$(basename "$FILE").$EXT"
	${BASH_SOURCE%/*}/sort-link-by-mime-type_link.sh "$FILE" "$MIME" "$EXT" "$DST"
done

