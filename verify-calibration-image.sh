#!/bin/bash

# diskutil info [disk] -> sectors

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"

LOG="$LOGDIR/$SERIAL-calibration.log"

BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

date "+%Y%m%d" | tee -a "$LOG"
echo "Verifying Calibration Drive ($DEVICE)..." | tee -a "$LOG"
echo "Device: $DEVICE" | tee -a "$LOG"
echo "Block Size: $BS" | tee -a "$LOG"
echo "" | tee -a "$LOG"

echo "Reading from device ($DEVICE)..." | tee -a "$LOG"
DEVICE_MD5=`dd bs=$BS if="$DEVICE" 2>> "$LOG" | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" | tee -a "$LOG"
# DEVICE_SHA1=`dd bs=$BS if="$DEVICE" 2>> "$LOG" | openssl sha1 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
# echo "$DEVICE_SHA1 - SHA1 Reported by Device ($DEVICE)" | tee -a "$LOG"
echo "" | tee -a "$LOG"

