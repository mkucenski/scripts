#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Run whois records consistently store the results in a specific directory

SITE="$1"
SERVER="$2"
DESTDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "SITE" "SERVER" "DESTDIR" && exit 1
fi
if [ -z "$DESTDIR" ]; then
	DESTDIR="./"
fi

DEST="$DESTDIR/$SITE-whois.txt"
if [ ! -e "$DEST" ]; then
	mkdir -p "$DESTDIR"
	touch "$DEST"
fi

if [ -e "$DEST" ]; then
	START "$0" "$DEST" "$*"
	INFO "$SITE -> $DEST"
	LOG "Whois Query for: $SITE" "$DEST"

	whois -h "$SERVER" "$SITE" | egrep -v "^$" | egrep -v "^#" | tee -a "$DEST"

	END "$0" "$DEST"
else
	ERROR "Unable to create destination file!" "$0" && exit 1
fi

