#!/bin/bash

LOG="$2"
PASSES=2

BS=$($(dirname "$0")/blocksize.sh "$1")

date "+%Y%m%d" >> "$LOG"
echo "Starting SSD/Flash wipe on device ($1)..." | tee -a "$LOG"

for PASS in `seq 1 $PASSES`; do
	echo "Zero-Pass ($PASS/$PASSES)..." | tee -a "$LOG"
	diskutil secureErase 0 "$1" 2>&1 | tee -a "$LOG"
done

echo "Verifying wiped device ($1) using (bs=$BS)..." | tee -a "$LOG"
dd if="$1" bs=$BS 2>> "$LOG" | xxd -a | tee -a "$LOG"

echo "Completed wiping device ($1)!"
date "+%Y%m%d" >> "$LOG"

