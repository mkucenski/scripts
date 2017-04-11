#!/bin/bash

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"
TESTMODE="$4"

LOG="$LOGDIR/$SERIAL-calibration.log"
  
if [ -n "$TESTMODE" ]; then
	echo "WARNING($(basename "$0")): Test mode enabled, results will not be written to / read from disk!" | tee -a "$LOG"
fi

SECTORS=$($(dirname "$0")/disksectors.sh "$DEVICE")
if [ $SECTORS -lt 0 ]; then
	echo "ERROR($(basename "$0")): Unable to read disk sectors!" | tee -a "$LOG"
	exit 1
fi

SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")
COUNT=$(expr $SIZE / $BS)
PATTERN="The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick brown fox jumps over the lazy dog! The quick br... "
PATTERN_LEN=$(expr ${#PATTERN} + 1)

date "+%Y%m%d" | tee -a "$LOG"
echo "Building Calibration Drive ($DEVICE)..." | tee -a "$LOG"
echo "Device: $DEVICE" | tee -a "$LOG"
echo "512-byte Sectors: $SECTORS" | tee -a "$LOG"
echo "Disk Size: $SIZE" | tee -a "$LOG"
echo "Block Size: $BS" | tee -a "$LOG"
echo "Block Count: $COUNT" | tee -a "$LOG"
echo "Pattern: '$PATTERN'"
echo "Pattern Bytes: $PATTERN_LEN"
echo | tee -a "$LOG"

echo "Building expected MD5..." | tee -a "$LOG"
EXPECTED_MD5=`yes "$PATTERN" | dd ibs=$PATTERN_LEN obs=$BS count=$(expr $SIZE / $PATTERN_LEN) | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
echo "$EXPECTED_MD5 - MD5 expected from pattern generation" | tee -a "$LOG"
echo | tee -a "$LOG"

if [ -z "$TESTMODE" ]; then
	echo "Writing calibration pattern to device ($DEVICE)..." | tee -a "$LOG"
	yes $PATTERN | dd bs=$BS of="$DEVICE"
	echo | tee -a "$LOG"

	echo "Reading from device ($DEVICE)..." | tee -a "$LOG"
	DEVICE_MD5=$($(dirname "$0")/diskmd5.sh "$DEVICE" "$BS")
	if [ -n "$DEVICE_MD5" ]; then
		echo "$DEVICE_MD5 - MD5 read from device ($DEVICE)" | tee -a "$LOG"
		echo "$EXPECTED_MD5 - MD5 expected from pattern generation" | tee -a "$LOG"
		if [ "$DEVICE_MD5" == "$EXPECTED_MD5" ]; then
			echo "Match!" | tee -a "$LOG"
		fi
		echo | tee -a "$LOG"
		exit 0
	else
		echo "ERROR($(basename "$0")): Unable to read MD5 from device!" | tee -a "$LOG"
	fi
else
	echo "WARNING($(basename "$0")): Test mode enabled, results not written to / read from disk!" | tee -a "$LOG"
fi

exit 1
