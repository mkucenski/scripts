#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh
. ${BASH_SOURCE%/*}/unison/unison-sync-inc.sh

SRCDIR="$1"
DSTBASEDIR="$2"
if [ $# -ne 2 ]; then
	USAGE "SRCDIR" "DSTBASEDIR" && exit 0
fi

if [ -e "$SRCDIR" ]; then
	if [ -e "$DSTBASEDIR" ]; then
		ERR=0
		echo "--- $SRCDIR -> $DSTBASEDIR ---"
		RESULT=$(execRsync2 "$SRCDIR" "$DSTBASEDIR")
		ERR=$(expr $ERR + $?)
		if [ $ERR -ne 0 ]; then
			echo "execRsync: $RESULT ($ERR)" > /dev/stderr
		else
			echo "Success!"
		fi
	else
		echo "<$DSTBASEDIR> Not Available!"
	fi
else
	echo "<$SRCDIR> Not Available!"
fi

