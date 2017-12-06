#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE=$1
REPL=$2
WITH=$3
if [ $# -eq 0 ]; then
	USAGE "FILE" "REPLACE" "WITH"
	USAGE_EXAMPLE "ls * | xargs -L 1 -I {} $(basename "$0") {} \".kung\" \".foo\" (will replace '.kung' in all files with '.foo' and *move* the old file to the new name)"
	exit 1
fi

NEW=$(echo "$FILE" | $SEDCMD -r "s/$REPL/$WITH/g")
echo "$NEW"

if [ "$FILE" != "$NEW" ]; then
	echo "Moving:" "$FILE" "$NEW"
	mv "$FILE" "$NEW"
fi

