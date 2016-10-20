#!/bin/bash

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"
NOTE="$4"

LOG="$LOGDIR/$SERIAL-calibration.log"

SECTORS=`diskutil info $DEVICE | egrep "(Disk|Total) Size:" | gsed -r 's/.+\(exactly ([[:digit:]]+) 512-Byte-Units\)/\1/'`
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

date "+%Y%m%d" | tee -a "$LOG"

echo "$NOTE" | tee -a "$LOG"

echo "Reading from device ($DEVICE)..." | tee -a "$LOG"
DEVICE_MD5=`dd bs=$BS if="$DEVICE" 2>> "$LOG" | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" | tee -a "$LOG"

echo "" | tee -a "$LOG"

