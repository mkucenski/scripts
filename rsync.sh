#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh
. ${BASH_SOURCE%/*}/unison/unison-sync-inc.sh

SRCDIR="$1"
DSTBASEDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SRCDIR" "DSTBASEDIR" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

if [ -e "$SRCDIR" ]; then
	if [ -e "$DSTBASEDIR" ]; then
		INFO "--- $SRCDIR -> $DSTBASEDIR ---"
		RESULT=$(execRsync2 "$SRCDIR" "$DSTBASEDIR")
		if [ $? -ne 0 ]; then
			ERROR "$RESULT ($?)" "$0"
			RV=$COMMON_ERROR
		else
			INFO "Success!"
		fi
	else
		ERROR "<$DSTBASEDIR> Not Available!" "$0"
		RV=$COMMON_ERROR
	fi
else
	ERROR "<$SRCDIR> Not Available!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

