#!/bin/bash

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"

LOG="$3/$SERIALNUM-wipe.log"

COUNT=1024
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")
SECTORS=$($(dirname "$0")/device-sectors.sh "$DEVICE")
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BLOCKS=$(expr $SIZE / $BS)

echo
date "+%Y%m%d" >> "$LOG"

echo "Verifying entire wiped device ($DEVICE) using (bs=$BS)..." | tee -a "$LOG"
dd if="$DEVICE" bs=$BS 2>> "$LOG" | xxd -a | tee -a "$LOG"

date "+%Y%m%d" >> "$LOG"

