#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

CSV="$1"
COLUMNS="$2"
ROWS="$3"
DELIM="$4"
if [ $# -eq 0 ]; then
	USAGE "CSV" "COLUMNS" "ROWS" "DELIM" && exit 1
fi

for IT in $(seq 1 $COLUMNS); do
	echo "---------- Column $IT ----------"
	cat "$CSV" | cut -d "$DELIM" -f "$IT" | head -n "$ROWS"
	echo
done


