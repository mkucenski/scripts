#!/bin/bash

BASEDIR="./"

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for DIR in `find "$BASEDIR" -type d -depth 1`; do
	echo "$DIR:"
	pushd "$DIR" > /dev/null
	git push | egrep -vi "^$"
	git pull | egrep -vi "^$"
	popd > /dev/null
done

