#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

# Run whois records consistently store the results in a specific directory

SITE="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SITE" "DESTDIR" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

DEST="$DESTDIR/$SITE-whois.txt"
if [ ! -e "$DEST" ]; then
	touch "$DEST"
fi

if [ -e "$DEST" ]; then
	START "$0" "$DEST"
	INFO "$SITE -> $DEST"
	LOG "Whois Query for: $SITE" "$DEST"

	whois "$SITE" | egrep -v "^$" | egrep -v "^#" >> "$DEST"
	RV=$?

	END "$0" "$DEST"
else
	ERROR "Unable to create destination file!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

