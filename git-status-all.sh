#!/bin/bash

BASEDIR="./"

# Find all .E01 files within BASEDIR and execute <ewfverify> on each. Log all results
# to <LOGDIR/ewfverify.log> as well as individual results in each image directory.

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

A="no changes added to commit"
B="On branch master"
C="Your branch is up-to-date"
D="nothing to commit, working tree clean"
E="^$"
F="to update what will be committed"
G="to include in what will be committed"
H="to discard changes in working directory"

for DIR in `find "$BASEDIR" -type d -depth 1`; do
	echo "$DIR:"
	pushd "$DIR" > /dev/null
	git status | egrep -v "$A|$B|$C|$D|$E|$F|$G|$H"
	popd > /dev/null
done

