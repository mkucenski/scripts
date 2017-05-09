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
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")
SECTORS=$($(dirname "$0")/disksectors.sh "$DEVICE")
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BLOCKS=$(expr $SIZE / $BS)

INFO "Verifying device wipe status ($DEVICE)..." "$LOGFILE"
INFO "" "$LOGFILE"
 
INFO "Verifying first $(expr $BS \* $COUNT)-bytes of ($DEVICE) using (bs=$BS)..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS count=$COUNT | xxd -a)
INFO "$RESULTS" "$LOGFILE"
INFO "" "$LOGFILE"
 
INFO "Verifying middle $(expr $BS \* $COUNT)-bytes of ($DEVICE) using (bs=$BS, skip=$(expr $BLOCKS / 2 - $COUNT / 2))..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS skip=$(expr $BLOCKS / 2 - $COUNT / 2) count=$COUNT | xxd -a)
INFO "$RESULTS" "$LOGFILE"
INFO "" "$LOGFILE"

INFO "Verifying last $(expr $BS \* $COUNT)-bytes of ($DEVICE) using (bs=$BS, skip=$(expr $BLOCKS - $COUNT))..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS skip=$(expr $BLOCKS - $COUNT) count=$COUNT | xxd -a)
INFO "$RESULTS" "$LOGFILE"

END "$0" "$LOGFILE"
