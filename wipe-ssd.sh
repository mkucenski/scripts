#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "SERIALNUM" "LOGDIR" && exit 1
fi

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE" "$*"

PASSES=2
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

INFO "Starting SSD/Flash wipe on device ($DEVICE)..." "$LOGFILE"

for PASS in `seq 1 $PASSES`; do
	INFO "Zero-Pass ($PASS/$PASSES)..." "$LOGFILE"
	${BASH_SOURCE%/*}/wipe-disk_worker.sh "$DEVICE" "$LOGFILE"
done

INFO "Completed wiping device ($DEVICE)!" "$LOGFILE"

${BASH_SOURCE%/*}/wipe-verify-full.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"

