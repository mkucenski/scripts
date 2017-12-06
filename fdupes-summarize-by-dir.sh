#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DIR="$1"
if [ $# -eq 0 ]; then
	USAGE "DIR" && exit 1
fi

for DIR in $(find ./ -type d -depth 1 -not -name ".*" | sort); do
	RESULT="$(fdupes --recurse --nohidden --noempty --summarize "$DIR" 2>/dev/null | egrep -v "^$")"
  	if [ "$RESULT" != "No duplicates found." ]; then
		echo "$DIR: $RESULT"
	fi
done

