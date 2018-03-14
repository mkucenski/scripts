#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

FILE=$1
REPL=$2
WITH=$3
if [ $# -eq 0 ]; then
	USAGE "FILE" "REPLACE" "WITH"
	USAGE_EXAMPLE "ls * | xargs -L 1 -I {} $(basename "$0") {} \".kung\" \".foo\" (will replace '.kung' in all files with '.foo' and *move* the old file to the new name)"
	exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

NEW=$(echo "$FILE" | $SEDCMD -r "s/$REPL/$WITH/g")
echo "$NEW"

if [ "$FILE" != "$NEW" ]; then
	echo "Moving:" "$FILE" "$NEW"
	ln -s "$FILE" "$NEW"
	RV=$((RV+$?))
fi

exit $RV

