#!/bin/bash

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"

LOG="$LOGDIR/$SERIAL-calibration.log"

SECTORS=`diskutil info $DEVICE | grep "Total Size:" | gsed -r 's/.+\(exactly ([[:digit:]]+) 512-Byte-Units\)/\1/'`
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

date "+%Y%m%d" | tee -a "$LOG"

echo "Writing Calibration Pattern ($DEVICE)..." | tee -a "$LOG"

echo "Device: $DEVICE" | tee -a "$LOG"
echo "512-byte Sectors: $SECTORS" | tee -a "$LOG"
echo "Disk Size: $SIZE" | tee -a "$LOG"
echo "Block Size: $BS" | tee -a "$LOG"

PATTERN="The quick brown fox jumps over the lazy dog!"

echo "" | tee -a "$LOG"
echo "Writing pattern to device ($DEVICE)..." | tee -a "$LOG"
yes $PATTERN | dd bs=$BS of="$DEVICE" 2>> "$LOG"

echo "" | tee -a "$LOG"

