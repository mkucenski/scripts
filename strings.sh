#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "FILE" && exit 0
fi

TMP=$(mktemp -t $(basename "$0") || exit 1)

gstrings -f -t x "$FILE" > "$TMP"
gstrings -f -t x -e l "$FILE" >> "$TMP"
gsort -n "$TMP"

rm "$TMP"

