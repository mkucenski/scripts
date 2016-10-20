#!/bin/bash

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"

LOG="$3/$SERIALNUM-wipe.log"

COUNT=1024
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

date "+%Y%m%d" >> "$LOG"
echo "Wiping device ($DEVICE)..." | tee -a "$LOG"

OS=`uname`
if [ $OS = "Darwin" ]; then
	echo "Using MacOSX (diskutil secureErase)..." | tee -a "$LOG"
	diskutil secureErase 0 "$DEVICE" 2>&1 | tee -a "$LOG"
else
	echo "Using dd (/dev/zero)..." | tee -a "$LOG"
	dd if=/dev/zero of="$DEVICE" bs=$BS 2>&1 | tee -a "$LOG"
fi

date "+%Y%m%d" >> "$LOG"

$(dirname "$0")/verify-wipe-disk.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

