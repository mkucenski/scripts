#!/bin/bash
. $(dirname "$0")/common-include.sh

IMAGE="$1"
OFFSET="$2"
DEST="$3"

while read LINE; do
	if [ -n "$LINE" ]; then
		$(dirname "$0")/tsk-mct-recover-files_worker.sh "$IMAGE" "$OFFSET" "$DEST" "$LINE"
	else
		ERROR "Read invalid line!" "$0"
	fi
done

