#!/bin/bash
. $(dirname "$0")/common-include.sh
. $(dirname "$0")/unison/unison-sync-inc.sh

SRCDIR="$1"
DSTBASEDIR="$2"

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

