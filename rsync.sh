#!/bin/bash

SRCDIR="$1"
DSTBASEDIR="$2"

. $(dirname "$0")/unison/unison-sync-inc.sh

if [ -e "$SRCDIR" ]; then
	if [ -e "$DSTBASEDIR" ]; then
		execRsync2 "$SRCDIR" "$DSTBASEDIR"
	else
		echo "<$DSTBASEDIR> Not Available!"
	fi
else
	echo "<$SRCDIR> Not Available!"
fi

