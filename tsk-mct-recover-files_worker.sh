#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCTENTRY="$4"
LOGFILE="$5"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "MCTENTRY" "LOGFILE" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

if [ -n "$MCTENTRY" ]; then
	FILE=$(_tsk_mct_file "$MCTENTRY")
	INODE=$(_tsk_mct_inode "$MCTENTRY")
	INFO "Extracting: $FILE ($INODE)..."
	if [ -n "$FILE" ]; then
		if [ -n "$INODE" ]; then
			mkdir -p "$DEST/$(dirname "$FILE")"
			icat -o $OFFSET "$IMAGE" $INODE 2> >(tee -a "$LOGFILE" >2&) > "$DEST/$FILE"
			RV=$((RV+$?))
		fi
	fi
else
	ERROR "Invalid mactime entry!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

