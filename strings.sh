#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "FILE" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

TMP=$(MKTEMP "$0" || exit $COMMON_ERROR)

gstrings -f -t x "$FILE" > "$TMP"
gstrings -f -t x -e l "$FILE" >> "$TMP"
gsort -n "$TMP"

rm "$TMP"

exit $RV

