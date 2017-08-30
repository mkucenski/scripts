#!/usr/local/bin/bash
. ${BASH_SOURCE%/*}/../common-include.sh || exit 1

DESTDIR="$1"
if [ $# -eq 0 ]; then
	USAGE "DESTDIR" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS
if [ -d "$DESTDIR" ]; then
	DEST="$DESTDIR/$(hostname -s) $(DATETIME).bz2"
	dump -L0af - / | bzip2 -c > "$DEST"
	RV=$((RV+$?))
else
	ERROR "Invalid Destination Directory!" "$0"
fi

exit $RV

# extract via: cd "$NEWDST" &&  bunzip2 -c "$DEST" | restore -r -f 

