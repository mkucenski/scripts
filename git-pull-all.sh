#!/bin/bash

BASEDIR="./"

# Find all .E01 files within BASEDIR and execute <ewfverify> on each. Log all results
# to <LOGDIR/ewfverify.log> as well as individual results in each image directory.

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for DIR in `find "$BASEDIR" -type d -depth 1`; do
	echo "$DIR:"
	pushd "$DIR" > /dev/null
	git pull | egrep -vi "^$"
	popd > /dev/null
done

