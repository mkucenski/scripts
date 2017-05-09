#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"
if [ $# -ne 3 ]; then
	USAGE "DEVICE" "SERIALNUM" "LOGDIR" && exit 0
fi

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE"

COUNT=1024
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

LOG "Wiping device ($DEVICE)..." "$LOGFILE"

LOG "Using dd (/dev/zero)..." "$LOGFILE"
RESULTS=$(dd if=/dev/zero of="$DEVICE" bs=$BS)
LOG "$RESULT" "$LOGFILE"

LOG "Completed wiping device ($DEVICE)!" "$LOGFILE"

${BASH_SOURCE%/*}/wipe-verify.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"
