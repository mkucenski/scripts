#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

CSV="$1"
REGEX_FILE="$2"
if [ $# -eq 0 ]; then
	USAGE "CSV" "REGEX_FILE" && exit 1
fi

head -n 1 "$CSV"
egrep -i -f "$REGEX_FILE" "$CSV"

