#!/bin/bash

# Usage Example: ls * | xargs -L 1 -I {} ./copy-renameFile.sh {} ".kung" ".foo"
#                (will replace '.kung' in all files with '.foo' and *copy* the
#                 old file to the new name)

FILE=$1
REPL=$2
WITH=$3

NEW=`echo "$FILE" | gsed -r "s/$REPL/$WITH/g"`
echo "$NEW"

if [ "$FILE" != "$NEW" ]
then
	echo "Copying:" "$FILE" "$NEW"
	cp "$FILE" "$NEW"
fi

