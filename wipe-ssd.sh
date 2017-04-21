#!/bin/bash
. $(dirname "$0")/common-include.sh

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE"

PASSES=2
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

LOG "Starting SSD/Flash wipe on device ($DEVICE)..." "$LOGFILE"

for PASS in `seq 1 $PASSES`; do
	LOG "Zero-Pass ($PASS/$PASSES)..." "$LOGFILE"
	$(dirname "$0")/wipe-disk.sh "$DEVICE" "$LOGFILE"
done

LOG "Completed wiping device ($DEVICE)!" "$LOGFILE"

$(dirname "$0")/wipe-verify-full.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"
