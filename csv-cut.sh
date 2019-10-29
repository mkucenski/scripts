#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

CSV="$1"
DELIM="$2"
COLUMN="$3"
if [ $# -eq 0 ]; then
	USAGE "CSV" "DELIM" "COLUMN(S)" && exit 1
fi

csvquote -d "$DELIM" "$CSV" | cut -d "$DELIM" -f "$COLUMN" | csvquote -d "$DELIM" -u

