#!/usr/bin/env bash

SRCROOT="$1"
DESTROOT="$2"

if [ -e "$SRCROOT" ]; then
	find "$SRCROOT" -type f -exec `dirname "$0"`/copy-verify.sh {} "$DESTROOT" \; | tee "$DESTROOT/`basename $0` `date +%d-%b-%Y-%H%M`.log"
else
	echo "ERROR: <$SRCROOT> does not exist!"
fi

exit 0
