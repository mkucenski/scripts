#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DELIM="$1"
if [ $# -eq 0 ]; then
	USAGE "DELIM" && exit 1
fi

# cat /dev/stdin | gsed -r ':a;/^[[:space:]]+/{N;s/\n//;ba}'
cat /dev/stdin | gsed -r '/^[[:space:]]+.+$/{x;G;s/\n//};h'
