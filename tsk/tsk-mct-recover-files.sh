#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCT="$4"
LOGFILE="$5"
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" "DEST" "MCT" "LOGFILE" && exit 1
fi

while read LINE; do
	if [ -n "$LINE" ]; then
		"${BASH_SOURCE%/*}/tsk-mct-recover-files_worker.sh" "$IMAGE" "$OFFSET" "$DEST" "$LINE" "$LOGFILE"
	else
		ERROR "Read invalid line!" "$0" && exit 1
	fi
done < "$MCT"

