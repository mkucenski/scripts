#!/bin/bash
. $(dirname "$0")/common-include.sh

# Usage Example: ls * | xargs -L 1 -I {} ./move-renameFile.sh {} ".kung" ".foo"
#                (will replace '.kung' in all files with '.foo' and *move* the
#                 old file to the new name)

FILE=$1
REPL=$2
WITH=$3

NEW=$(echo "$FILE" | $SEDCMD -r "s/$REPL/$WITH/g")
echo "$NEW"

if [ "$FILE" != "$NEW" ]
then
	echo "Moving:" "$FILE" "$NEW"
	mv "$FILE" "$NEW"
fi

