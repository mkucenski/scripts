#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

BASEDIR="$1"
if [ $# -eq 0 ]; then
	USAGE "BASEDIR" && exit 1
fi

find "$BASEDIR" -type d -depth 1 -not -name ".*" -print0 | sort |
while IFS= read -r -d $'\0' DIR; do
	RESULT="$(fdupes --recurse --nohidden --noempty --summarize "$DIR" 2>/dev/null | egrep -v "^$")"
  	if [ "$RESULT" != "No duplicates found." ]; then
		echo "$DIR: $RESULT"
	fi
done

