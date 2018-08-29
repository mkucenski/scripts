#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

CSV="$1"
REGEX_FILE="$2"
DESTDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "CSV" "REGEX_FILE" && exit 1
fi

OUTPUT="$DESTDIR/$(basename "$CSV")"
EXEC_CMD "head -n 1 \"$CSV\" > \"$OUTPUT\""
EXEC_CMD "egrep -i -f \"$REGEX_FILE\" \"$CSV\" >> \"$OUTPUT\""

