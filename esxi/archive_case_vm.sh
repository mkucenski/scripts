#!/bin/ash

VMDIR="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	echo "Usage: $(basename "$0") <VMDIR> <DESTDIR>" && exit 0
fi

DATE=$(date "+%Y%m%d")
FCIV="$(dirname "$0")/fciv_esxi.sh"
ARCHIVE="$DESTDIR/$(basename "$VMDIR") ($DATE).tar.bz2"

echo "Executing MD5 on all VM files..."
"$FCIV" "$VMDIR"/* | tee "$VMDIR/fciv.md5"

echo "Archiving all VM files..."
tar cjvf "$ARCHIVE" "$VMDIR"

echo "Executing MD5 on archive file..."
"$FCIV" "$ARCHIVE" | tee "$ARCHIVE.md5"

