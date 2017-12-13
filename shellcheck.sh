#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

if [ $# -eq 0 ]; then
	USAGE "FILE(S)" && exit 1
fi

for X in "$@"; do
	CHECKFILE="$(STRIP_EXTENSION "$X")-shellcheck.txt"
	shellcheck "$X" > "$CHECKFILE"
	if [ ! -s "$CHECKFILE" ]; then
		# empty file; zero issues
		rm "$CHECKFILE"
	else
		echo "$CHECKFILE"
	fi
done

