#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh
. ${BASH_SOURCE%/*}/unison/unison-sync-inc.sh

SRCDIR="$1"
DSTBASEDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SRCDIR" "DSTBASEDIR" && exit 0
fi

if [ -e "$SRCDIR" ]; then
	if [ -e "$DSTBASEDIR" ]; then
		ERR=0
		INFO "--- $SRCDIR -> $DSTBASEDIR ---"
		RESULT=$(execRsync2 "$SRCDIR" "$DSTBASEDIR")
		ERR=$(expr $ERR + $?)
		if [ $ERR -ne 0 ]; then
			ERROR "$RESULT ($ERR)" "$0" > /dev/stderr
		else
			INFO "Success!"
		fi
	else
		ERROR "<$DSTBASEDIR> Not Available!" "$0"
	fi
else
	ERROR "<$SRCDIR> Not Available!" "$0"
fi

