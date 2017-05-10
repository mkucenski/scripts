#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "FILE" && exit 0
fi

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit 1)

if [ -e "$FILE" ]; then
	BACKUP=$(mktemp "$(dirname "$FILE")/$(basename "$FILE").XXXXXX")
	INFO "Making backup copy of original file... ($BACKUP)"
	cp "$FILE" "$BACKUP"

	INFO "Re-sorting and cleaning ($FILE) based on key ($KEY)..."
	$SEDCMD -r 's/\/\//\//g; s/\//\\/g; s/[~@%$]/_/g' "$FILE" | sort --key=$KEY > "$TMP"
	mv "$TMP" "$FILE"
else
	ERROR "Unable to find ($FILE)!" "$0"
fi

if [ -e "$TMP" ]; then
	rm "$TMP"
fi

