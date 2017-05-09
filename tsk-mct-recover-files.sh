#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

IMAGE="$1"
OFFSET="$2"
DEST="$3"
LOGFILE="$4"
if [ $# -ne 4 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "LOGFILE" && exit 0
fi

while read LINE; do
	if [ -n "$LINE" ]; then
		${BASH_SOURCE%/*}/tsk-mct-recover-files_worker.sh "$IMAGE" "$OFFSET" "$DEST" "$LINE" "$LOGFILE"
	else
		ERROR "Read invalid line!" "$0"
	fi
done

