#!/bin/bash
. $(dirname "$0")/common-include.sh

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "SERIALNUM" "LOGDIR" && exit 0
fi

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE"

COUNT=1024
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")
SECTORS=$($(dirname "$0")/disksectors.sh "$DEVICE")
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BLOCKS=$(expr $SIZE / $BS)

LOG "Verifying entire wiped device ($DEVICE) using (bs=$BS)..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS | xxd -a)
LOG "$RESULTS" "$LOGFILE"

END "$0" "$LOGFILE"
