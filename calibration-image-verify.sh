#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"
if [ $# -ne 3 ]; then
	USAGE "DEVICE" "SERIAL" "LOGDIR" && exit 0
fi

LOGFILE="$LOGDIR/$SERIAL-calibration.log"
START "$0" "$LOGFILE"

BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

LOG "Verifying Calibration Drive ($DEVICE)..." "$LOGFILE"
LOG "Device: $DEVICE" "$LOGFILE"
LOG "Block Size: $BS" "$LOGFILE"
LOG "$LOGFILE"

EXPECTED_MD5=$($(dirname "$0")/calibration-image-find-md5.sh "$LOGFILE")
if [ -n "$EXPECTED_MD5" ]; then
	LOG "Reading from device ($DEVICE)..." "$LOGFILE"
	DEVICE_MD5=$($(dirname "$0")/diskmd5.sh "$DEVICE" "$BS")
	if [ -n "$DEVICE_MD5" ]; then
		LOG "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" "$LOGFILE"
		LOG "$EXPECTED_MD5 - MD5 expected from pattern generation" "$LOGFILE"
		if [ "$DEVICE_MD5" == "$EXPECTED_MD5" ]; then
			LOG "Match!" "$LOGFILE"
		fi
		END "$0" "$LOGFILE"
		exit 0
	else
		ERROR "Unable to read MD5 from device!" "$0" "$LOGFILE"
	fi
else
	ERROR "Unable to find expected MD5!" "$0" "$LOGFILE"
fi

END "$0" "$LOGFILE"
exit 1

