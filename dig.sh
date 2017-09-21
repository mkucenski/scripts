#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

# Run dig/nslookup records consistently and store the results in a specific directory

SITE="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SITE" "DESTDIR" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

DEST="$DESTDIR/$SITE-dig.txt"
if [ ! -e "$DEST" ]; then
	mkdir -p "$DESTDIR"
	touch "$DEST"
fi

if [ -e "$DEST" ]; then
	START "$0" "$DEST" "$*"
	INFO "$SITE -> $DEST"
	LOG "Dig Query for: $SITE" "$DEST"

	dig "$SITE" ANY | tee -a "$DEST"
	RV=$((RV+$?))

	END "$0" "$DEST"
else
	ERROR "Unable to create destination file!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

