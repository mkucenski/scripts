#!/bin/bash

# diskutil info [disk] -> sectors

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"

LOG="$LOGDIR/$SERIAL-calibration.log"

SECTORS=`diskutil info $DEVICE | grep "Total Size:" | gsed -r 's/.+\(exactly ([[:digit:]]+) 512-Byte-Units\)/\1/'`
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)

BS=2
MAXBS=16384
TEST=$BS
while [ $(expr $SIZE % $TEST) -eq 0 ]; do
	BS=$TEST
	TEST=$(expr $TEST \* 2)
done
if [ $BS -gt $MAXBS ]; then
	BS=$MAXBS
fi

COUNT=$(expr $SIZE / $BS)

PATTERN="The quick brown fox jumps over the lazy dog!"

date "+%Y%m%d" | tee -a "$LOG"

echo "Building Calibration Drive ($DEVICE)..." | tee -a "$LOG"

echo "Device: $DEVICE" | tee -a "$LOG"
echo "512-byte Sectors: $SECTORS" | tee -a "$LOG"
echo "Disk Size: $SIZE" | tee -a "$LOG"
echo "Block Size: $BS" | tee -a "$LOG"
echo "Block Count: $COUNT" | tee -a "$LOG"
echo "Pattern: '$PATTERN'"

echo "" | tee -a "$LOG"
echo "Building expected MD5..." | tee -a "$LOG"
EXPECTED_MD5=`yes "$PATTERN" | dd bs=$BS count=$COUNT 2>> "$LOG" | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$EXPECTED_MD5 - MD5 Expected from Pattern Generation" | tee -a "$LOG"
#EXPECTED_SHA1=`yes "$PATTERN" | dd bs=$BS count=$COUNT 2>> "$LOG" | openssl sha1 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
#echo "$EXPECTED_SHA1 - SHA1 Expected from Pattern Generation" | tee -a "$LOG"

echo "" | tee -a "$LOG"
echo "Writing pattern to device ($DEVICE)..." | tee -a "$LOG"
yes "$PATTERN" | dd bs=$BS of="$DEVICE" 2>> "$LOG"

echo "" | tee -a "$LOG"
echo "Reading from device ($DEVICE)..." | tee -a "$LOG"
DEVICE_MD5=`dd bs=$BS if="$DEVICE" 2>> "$LOG" | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" | tee -a "$LOG"
#DEVICE_SHA1=`dd bs=$BS if="$DEVICE" 2>> "$LOG" | openssl sha1 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
#echo "$DEVICE_SHA1 - SHA1 Reported by Device ($DEVICE)" | tee -a "$LOG"

echo "" | tee -a "$LOG"
echo "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" | tee -a "$LOG"
echo "$EXPECTED_MD5 - MD5 Expected from Pattern Generation" | tee -a "$LOG"
#echo "$EXPECTED_SHA1 - SHA1 Expected from Pattern Generation" | tee -a "$LOG"

echo "" | tee -a "$LOG"

