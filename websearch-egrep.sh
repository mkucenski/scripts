#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SEARCH_FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "SEARCH_FILE" && exit 1
fi

for REGEX in ${BASH_SOURCE%/*}/regex/*_search.regex; do
	egrep -i -f "$REGEX" "$SEARCH_FILE"
done

