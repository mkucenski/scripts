#!/bin/bash
. $(dirname "$0")/common-include.sh
. $(dirname "$0")/tsk-include.sh

if [ $# -eq 0 ]; then
	echo "Usage: $0 <IMAGE> <OFFSET> <DEST> <MCT Entry"
	exit
fi

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCTENTRY="$4"

if [ -n "$MCTENTRY" ]; then
	FILE=$(_tsk_mct_file "$MCTENTRY")
	INODE=$(_tsk_mct_inode "$MCTENTRY")
	if [ -n "$FILE" ]; then
		if [ -n "$INODE" ]; then
			mkdir -p "$DEST/$(dirname "$FILE")"
			icat -o $OFFSET "$IMAGE" $INODE > "$DEST/$FILE"
			echo "$FILE"
		fi
	fi
else
	ERROR "Invalid mactime entry!" "$0"
fi

