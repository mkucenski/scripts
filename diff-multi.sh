#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

if [ $# -eq 0 ]; then
	USAGE "FILES..." && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

for ARG1 in "$@"; do
	for ARG2 in "$@"; do
		if [ "$ARG1" != "$ARG2" ]; then
			RESULT=$(diff -q "$ARG1" "$ARG2" | grep "differ")
			if [ -n "$RESULT" ]; then
				echo "$ARG1 <-> $ARG2"
				diff -ywi --suppress-common-lines "$ARG1" "$ARG2" | less
				# diff -wi "$ARG1" "$ARG2"
				echo; echo
			fi
		fi
	done
done

exit $RV

