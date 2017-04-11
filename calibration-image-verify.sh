#!/bin/bash

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"

LOG="$LOGDIR/$SERIAL-calibration.log"

BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

date "+%Y%m%d" | tee -a "$LOG"
echo "Verifying Calibration Drive ($DEVICE)..." | tee -a "$LOG"
echo "Device: $DEVICE" | tee -a "$LOG"
echo "Block Size: $BS" | tee -a "$LOG"
echo | tee -a "$LOG"

EXPECTED_MD5=$($(dirname "$0")/calibration-image-find-md5.sh "$LOG")
if [ -n "$EXPECTED_MD5" ]; then
	echo "Reading from device ($DEVICE)..." | tee -a "$LOG"
	DEVICE_MD5=$($(dirname "$0")/diskmd5.sh "$DEVICE" "$BS")
	if [ -n "$DEVICE_MD5" ]; then
		echo "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" | tee -a "$LOG"
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
	echo "ERROR($(basename "$0")): Unable to find expected MD5!" | tee -a "$LOG"
fi

exit 1

