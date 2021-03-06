#!/usr/bin/env bash

BASEDIR="./"

A="no changes added to commit"
B="On branch master"
C="Your branch is up-to-date"
D="nothing to commit, working tree clean"
E="nothing to commit, working directory clean"
F="to update what will be committed"
G="to include in what will be committed"
H="to discard changes in working directory"
I="nothing added to commit but untracked files present"

clear
find "$BASEDIR" -type d -depth 1 -print0 |
while IFS= read -r -d $'\0' DIR; do
	echo -n "$DIR: "
	pushd "$DIR" > /dev/null
	# git status --short 2>/dev/null | egrep -vi "$A|$B|$C|$D|$E|$F|$G|$H|$I" | egrep -vi "^$"
	git remote get-url origin
	popd > /dev/null
done


