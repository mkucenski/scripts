#!/bin/bash

DEVICE="$1"
LOG="$2"

COUNT=1024
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

date "+%Y%m%d" >> "$LOG"
echo "Wiping device ($DEVICE)..." | tee -a "$LOG"
diskutil secureErase 0 "$DEVICE" 2>&1 | tee -a "$LOG"

echo "Verifying first $(expr $BS \* $COUNT)-bytes of ($DEVICE) using (bs=$BS)..."
dd if="$DEVICE" bs=$BS count=$COUNT 2>> "$LOG" | xxd -a | tee -a "$LOG"
date "+%Y%m%d" >> "$LOG"

