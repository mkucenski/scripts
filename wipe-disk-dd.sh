#!/bin/bash
. $(dirname "$0")/common-include.sh

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE"

COUNT=1024
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

LOG "Wiping device ($DEVICE)..." "$LOGFILE"

LOG "Using dd (/dev/zero)..." "$LOGFILE"
RESULTS=$(dd if=/dev/zero of="$DEVICE" bs=$BS)
LOG "$RESULT" "$LOGFILE"

LOG "Completed wiping device ($DEVICE)!" "$LOGFILE"

$(dirname "$0")/wipe-verify.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"
