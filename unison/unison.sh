#!/bin/bash
. "${BASH_SOURCE%/*}/unison-include.sh" || exit 1

ROOT1="$1"
ROOT2="$2"
if [ $# -eq 0 ]; then
	USAGE "ROOT1" "ROOT2" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

if [ -e "$ROOT1" ]; then
	if [ ! -e "$ROOT2" ]; then
		mkdir -p "$ROOT2"
	fi
	if [ -e "$ROOT2" ]; then
		INFO "--- $ROOT1 <-> $ROOT2 ---"
		RESULT=$(execUnison "$ROOT1" "$ROOT2")
		if [ $? -ne 0 ]; then
			ERROR "$RESULT ($?)" "$0"
			RV=$((RV+$?))
		else
			INFO "Success!"
		fi
	else
		ERROR "<$ROOT2> Not Available!" "$0"
		RV=$COMMON_ERROR
	fi
else
	ERROR "<$ROOT1> Not Available!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

