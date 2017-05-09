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

PASSES=2
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

INFO "Starting SSD/Flash wipe on device ($DEVICE)..." "$LOGFILE"

for PASS in `seq 1 $PASSES`; do
	INFO "Zero-Pass ($PASS/$PASSES)..." "$LOGFILE"
	$(dirname "$0")/wipe-disk.sh "$DEVICE" "$LOGFILE"
done

INFO "Completed wiping device ($DEVICE)!" "$LOGFILE"

$(dirname "$0")/wipe-verify-full.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"
