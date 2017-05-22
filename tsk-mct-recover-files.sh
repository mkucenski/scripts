#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

IMAGE="$1"
OFFSET="$2"
DEST="$3"
LOGFILE="$4"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "LOGFILE" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

while read LINE; do
	if [ -n "$LINE" ]; then
		${BASH_SOURCE%/*}/tsk-mct-recover-files_worker.sh "$IMAGE" "$OFFSET" "$DEST" "$LINE" "$LOGFILE"
		RV=$((RV+$?))
	else
		ERROR "Read invalid line!" "$0"
		RV=$COMMON_ERROR
	fi
done

exit $RV

