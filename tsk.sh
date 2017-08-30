#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1
. ${BASH_SOURCE%/*}/tsk-include.sh || exit 1

CMD="$1"
IMAGE="$2"
OFFSET="$3"
if [ -z "$OFFSET" ]; then OFFSET=0; fi
INODE="$4"
OPTS="$5"
LOGFILE="$(STRIP_EXTENSION "$IMAGE")-tsk.log"
if [ $# -eq 0 ]; then
	USAGE "CMD" "IMAGE" "OFFSET" "INODE" "\"OPTS\" (optional)" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS
START "$0" "$LOGFILE" "$*"

LOG "$CMD -o $OFFSET \"$IMAGE\" $INODE" "$LOGFILE"
"$CMD" $(if [ -n "$OPTS" ]; then echo "$OPTS"; fi) -o $OFFSET "$IMAGE" $INODE | tee -a "$LOGFILE"
RV=$((RV+$?))

END "$0" "$LOGFILE"
exit $RV


