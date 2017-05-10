#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh
. ${BASH_SOURCE%/*}/unison/unison-sync-inc.sh

SRC="$1"
DST="$2"
if [ $# -eq 0 ]; then
	USAGE "SRC" "DST" && exit 0
fi

if [ -e "$SRC" ]; then
	if [ -e "$DST" ]; then
		ERR=0
		INFO "--- $SRC -> $DST ---"
		RESULT=$(execUnison2 "$SRC" "$DST")
		ERR=$(expr $ERR + $?)
		if [ $ERR -ne 0 ]; then
			ERROR "$RESULT ($ERR)" "$0"
		else
			INFO "Success!"
		fi
	else
		ERROR "<$DSTBASEDIR> Not Available!" "$0"
	fi
else
	ERROR "<$SRCDIR> Not Available!" "$0"
fi

