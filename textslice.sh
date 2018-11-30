#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

COUNT=$1
ITERATION=$2
if [ $# -eq 0 ]; then
	USAGE "COUNT" "ITERATION" "< (STDIN)" && exit 1
fi

head -n $((ITERATION * COUNT)) < /dev/stdin | tail -n "$COUNT"

