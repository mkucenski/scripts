#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

FILE=$1
REPL=$2
WITH=$3
if [ $# -ne 3 ]; then
	USAGE "FILE" "REPLACE" "WITH"
	USAGE_EXAMPLE "ls * | xargs -L 1 -I {} $(basename "$0") {} \".kung\" \".foo\" (will replace '.kung' in all files with '.foo' and *copy* the old file to the new name)"
	exit 0
fi

NEW=$(echo "$FILE" | $SEDCMD -r "s/$REPL/$WITH/g")
echo "$NEW"

if [ "$FILE" != "$NEW" ]
then
	echo "Copying:" "$FILE" "$NEW"
	cp "$FILE" "$NEW"
fi

