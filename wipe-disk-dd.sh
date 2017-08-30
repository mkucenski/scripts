#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "SERIALNUM" "LOGDIR" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE" "$*"

COUNT=1024
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

INFO "Wiping device ($DEVICE)..." "$LOGFILE"

INFO "Using dd (/dev/zero)..." "$LOGFILE"
RESULTS=$(dd if=/dev/zero of="$DEVICE" bs=$BS)
RV=$?
INFO "$RESULT" "$LOGFILE"

INFO "Completed wiping device ($DEVICE)!" "$LOGFILE"

${BASH_SOURCE%/*}/wipe-verify.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"

exit $RV

