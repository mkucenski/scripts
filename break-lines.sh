#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

COUNT="$1"
DELIM="$2"
FILE="$3"
if [ $# -eq 0 ]; then
	USAGE "COUNT" "DELIM" "FILE" && exit 1
fi

for IT in $(seq 1 $COUNT); do
	cut -d "$DELIM" -f $IT "$FILE" | sort -u
done
