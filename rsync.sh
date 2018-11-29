#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SRCDIR="$1"
DSTBASEDIR="$2"

if [ $# -eq 0 ]; then
	USAGE "SRCDIR" "DSTBASEDIR" && exit 1
fi

function NORMALIZEDIR() {
	# rsync operates differently depending on whether the source has a trailing '/';
	# this function normalizes directory names to not include the trailing '/'
	DIR="$(dirname "$1")/$(basename "$1")"
	echo "$DIR"
}

_SRCDIR="$(NORMALIZEDIR "$SRCDIR")"
_DSTBASEDIR="$(NORMALIZEDIR "$DSTBASEDIR")"

if [ -e "$_SRCDIR" ]; then
	if [ -e "$_DSTBASEDIR" ]; then
		INFO "--- $_SRCDIR -> $_DSTBASEDIR ---"
		rsync -av --exclude='.git/' --exclude='.DS_Store' "$_SRCDIR" "$_DSTBASEDIR/"
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

