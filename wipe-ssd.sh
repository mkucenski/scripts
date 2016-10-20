#!/bin/bash

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"

LOG="$3/$SERIALNUM-wipe.log"

PASSES=2
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

date "+%Y%m%d" >> "$LOG"
echo "Starting SSD/Flash wipe on device ($DEVICE)..." | tee -a "$LOG"

for PASS in `seq 1 $PASSES`; do
	echo "Zero-Pass ($PASS/$PASSES)..." | tee -a "$LOG"
	$(dirname "$0")/wipe-disk.sh "$DEVICE" "$LOG"
done

echo "Verifying entire wiped device ($DEVICE) using (bs=$BS)..." | tee -a "$LOG"
dd if="$DEVICE" bs=$BS 2>> "$LOG" | xxd -a | tee -a "$LOG"

echo "Completed wiping device ($DEVICE)!"
date "+%Y%m%d" >> "$LOG"

