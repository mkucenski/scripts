#!/bin/ash

VMDIR="$1"
if [ $# -eq 0 ]; then
	echo "Usage: $(basename "$0") <VMDIR>" && exit 0
fi

HDDStore="/vmfs/volumes/HDDStore/$(basename "$VMDIR")"
LINK="$VMDIR/HDDStore"

if [ -e "$HDDStore" ]; then
	if [ ! -e "$LINK" ]; then
		ln -s "$HDDStore" "$LINK"
		echo "$LINK -> $HDDStore"
	else
		echo "<$LINK> already exists!"
	fi
else
	echo "HDDStore for <$(basename "$VMDIR")> does not exist!"
fi

