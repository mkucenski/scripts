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
SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BLOCKS=$(expr $SIZE / $BS)

LOG "Verifying device wipe status ($DEVICE)..." "$LOGFILE"
LOG "" "$LOGFILE"
 
LOG "Verifying first $(expr $BS \* $COUNT)-bytes of ($DEVICE) using (bs=$BS)..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS count=$COUNT | xxd -a)
LOG "$RESULTS" "$LOGFILE"
LOG "" "$LOGFILE"
 
LOG "Verifying middle $(expr $BS \* $COUNT)-bytes of ($DEVICE) using (bs=$BS, skip=$(expr $BLOCKS / 2 - $COUNT / 2))..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS skip=$(expr $BLOCKS / 2 - $COUNT / 2) count=$COUNT | xxd -a)
LOG "$RESULTS" "$LOGFILE"
LOG "" "$LOGFILE"

LOG "Verifying last $(expr $BS \* $COUNT)-bytes of ($DEVICE) using (bs=$BS, skip=$(expr $BLOCKS - $COUNT))..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS skip=$(expr $BLOCKS - $COUNT) count=$COUNT | xxd -a)
LOG "$RESULTS" "$LOGFILE"

END "$0" "$LOGFILE"
