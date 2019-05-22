#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

DESTDIR="$1"
if [ $# -eq 0 ]; then
	USAGE "DESTDIR" && exit 1
fi

if [ -d "$DESTDIR" ]; then
	DEST="$DESTDIR/$(hostname -s) $(DATETIME).bz2"
	dump -L0af - / | bzip2 -c > "$DEST"
else
	ERROR "Invalid Destination Directory!" "$0" && exit 1
fi

# extract via: cd "$NEWDST" &&  bunzip2 -c "$DEST" | restore -r -f 

