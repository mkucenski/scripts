#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/unison/unison-include.sh" || exit 1

SRCDIR="$1"
DSTBASEDIR="$2"

if [ $# -eq 0 ]; then
	USAGE "SRCDIR" "DSTBASEDIR" && exit 1
fi

if [ -e "$SRCDIR" ]; then
	if [ -e "$DSTBASEDIR" ]; then
		INFO "--- $SRCDIR -> $DSTBASEDIR ---"
		execRsync "$SRCDIR" "$DSTBASEDIR"
		if [ $? -ne 0 ]; then
			ERROR "execRsync ($?)" "$0" && exit 1
		else
			INFO "Success!"
		fi
	else
		ERROR "<$DSTBASEDIR> Not Available!" "$0" && exit 1
	fi
else
	ERROR "<$SRCDIR> Not Available!" "$0" && exit 1
fi

