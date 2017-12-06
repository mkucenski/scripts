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

COUNT=1024
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")
SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
SECTOR_SIZE=512
SIZE=$(($SECTORS * $SECTOR_SIZE))
BLOCKS=$(($SIZE / $BS))

INFO "Verifying device wipe status ($DEVICE)..." "$LOGFILE"
INFO "" "$LOGFILE"
 
INFO "Verifying first $(($BS * $COUNT))-bytes of ($DEVICE) using (bs=$BS)..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS count=$COUNT | xxd -a)
INFO "$RESULTS" "$LOGFILE"
INFO "" "$LOGFILE"
 
INFO "Verifying middle $(($BS * $COUNT))-bytes of ($DEVICE) using (bs=$BS, skip=$(($BLOCKS / 2 - $COUNT / 2)))..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS skip=$(($BLOCKS / 2 - $COUNT / 2)) count=$COUNT | xxd -a)
INFO "$RESULTS" "$LOGFILE"
INFO "" "$LOGFILE"

INFO "Verifying last $(($BS * $COUNT))-bytes of ($DEVICE) using (bs=$BS, skip=$(($BLOCKS - $COUNT)))..." "$LOGFILE"
RESULTS=$(dd if="$DEVICE" bs=$BS skip=$(($BLOCKS - $COUNT)) count=$COUNT | xxd -a)
INFO "$RESULTS" "$LOGFILE"

END "$0" "$LOGFILE"

