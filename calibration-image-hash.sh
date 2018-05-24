#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "SERIAL" "LOGDIR" && exit 1
fi

LOGFILE="$LOGDIR/$SERIAL-calibration.log"
START "$0" "$LOGFILE" "$*"
  
SECTORS=$("${BASH_SOURCE%/*}/disksectors.sh" "$DEVICE")
if [ "$SECTORS" -lt 0 ]; then
	ERROR"Unable to read disk sectors!" "$0" "$LOGFILE" && exit 1
fi

SECTOR_SIZE=512
SIZE=$((SECTORS * SECTOR_SIZE))
BS=$("${BASH_SOURCE%/*}/blocksize.sh" "$DEVICE")
COUNT=$((SIZE / BS))

INFO "Hashing Calibration Drive ($DEVICE)..." "$LOGFILE"
INFO "Device: $DEVICE" "$LOGFILE"
INFO "512-byte Sectors: $SECTORS" "$LOGFILE"
INFO "Disk Size: $SIZE" "$LOGFILE"
INFO "Block Size: $BS" "$LOGFILE"
INFO "Block Count: $COUNT" "$LOGFILE"
INFO "" "$LOGFILE"

INFO "Reading from device ($DEVICE)..." "$LOGFILE"
DEVICE_MD5=$("${BASH_SOURCE%/*}/diskmd5.sh" "$DEVICE" "$BS")
if [ -n "$DEVICE_MD5" ]; then
	INFO "$DEVICE_MD5 - MD5 read from device ($DEVICE)" "$LOGFILE"
else
	ERROR "Unable to read MD5 from device!" "$0" "$LOGFILE" && exit 1
fi

END "$0" "$LOGFILE"

