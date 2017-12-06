#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

if [ $# -eq 0 ]; then
	USAGE "FILES..." && exit 1
fi

for ARG1 in "$@"; do
	for ARG2 in "$@"; do
		if [ "$ARG1" != "$ARG2" ]; then
			RESULT=$(diff -q "$ARG1" "$ARG2" | grep "differ")
			if [ -n "$RESULT" ]; then
				echo "$ARG1 <-> $ARG2"
				diff -ywi -W 260 --suppress-common-lines "$ARG1" "$ARG2"
				# diff -wi "$ARG1" "$ARG2"
				echo; echo
			fi
		fi
	done
done

