#!/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1
. ${BASH_SOURCE%/*}/unison-inc.sh || exit 1

SRC="$1"
DST="$2"
if [ $# -eq 0 ]; then
	USAGE "SRC" "DST" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

if [ -e "$SRC" ]; then
	if [ ! -e "$DST" ]; then
		mkdir -p "$DST"
	fi
	if [ -e "$DST" ]; then
		INFO "--- $SRC -> $DST ---"
		RESULT=$(execUnison2 "$SRC" "$DST")
		if [ $? -ne 0 ]; then
			ERROR "$RESULT ($?)" "$0"
			RV=$((RV+$?))
		else
			INFO "Success!"
		fi
	else
		ERROR "<$DST> Not Available!" "$0"
		RV=$COMMON_ERROR
	fi
else
	ERROR "<$SRC> Not Available!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV
