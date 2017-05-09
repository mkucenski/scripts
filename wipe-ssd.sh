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
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

INFO "Starting SSD/Flash wipe on device ($DEVICE)..." "$LOGFILE"

for PASS in `seq 1 $PASSES`; do
<<<<<<< HEAD
	INFO "Zero-Pass ($PASS/$PASSES)..." "$LOGFILE"
	$(dirname "$0")/wipe-disk.sh "$DEVICE" "$LOGFILE"
=======
	LOG "Zero-Pass ($PASS/$PASSES)..." "$LOGFILE"
	${BASH_SOURCE%/*}/wipe-disk.sh "$DEVICE" "$LOGFILE"
>>>>>>> fb6ba51526ac4bf01710eb1ebfc0daa0a88f6063
done

INFO "Completed wiping device ($DEVICE)!" "$LOGFILE"

${BASH_SOURCE%/*}/wipe-verify-full.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"
