#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

DESTDIR="$1"
if [ $# -eq 0 ]; then
	USAGE "DESTDIR" && exit 1
fi

if [ -d "$DESTDIR" ]; then
	HOSTNAME=$(hostname -s)
	TIMESTAMP=$(DATETIME)
	DESTPREFIX="$DESTDIR/$HOSTNAME $TIMESTAMP"

	dump -L0af - / | bzip2 -c > "$DESTPREFIX dump.bz2"
	pkg prime-list > "$DESTPREFIX pkgs.txt""
	tar cjvf "$DESTPREFIX.tar.bz2" "/boot/loader.conf" /boot/loader.conf.local" "/etc" "/usr/local/etc"
else
	ERROR "Invalid Destination Directory!" "$0" && exit 1
fi

# extract via: cd "$NEWDST" &&  bunzip2 -c "$DEST" | restore -r -f 

