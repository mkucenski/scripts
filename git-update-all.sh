#!/usr/bin/env bash

BASEDIR="./"

find "$BASEDIR" -type d -depth 1 -print0 |
while IFS= read -r -d $'\0' DIR; do
	echo "$DIR:"
	pushd "$DIR" > /dev/null
	git push | egrep -vi "^$"
	git pull | egrep -vi "^$"
	popd > /dev/null
done

