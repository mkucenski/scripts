#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh
. ${BASH_SOURCE%/*}/tsk-include.sh

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCTENTRY="$4"
LOGFILE="$5"
if [ $# -ne 5 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "MCTENTRY" "LOGFILE" && exit 0
fi

if [ -n "$MCTENTRY" ]; then
	FILE=$(_tsk_mct_file "$MCTENTRY")
	INODE=$(_tsk_mct_inode "$MCTENTRY")
	if [ -n "$FILE" ]; then
		if [ -n "$INODE" ]; then
			mkdir -p "$DEST/$(dirname "$FILE")"
			icat -o $OFFSET "$IMAGE" $INODE 2> >(tee -a "$LOGFILE" >2&) > "$DEST/$FILE"
			echo "$FILE"
		fi
	fi
else
	ERROR "Invalid mactime entry!" "$0"
fi

