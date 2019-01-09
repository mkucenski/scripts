#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SEARCH_REGEX="$1"
EXCLUDE_REGEX="$2"
if [ $# -eq 0 ]; then
	USAGE "SEARCH_REGEX" "EXCLUDE_REGEX" && exit 1
fi

egrep -i -f "$SEARCH_REGEX" < /dev/stdin | egrep -v -i -f "$EXCLUDE_REGEX"

