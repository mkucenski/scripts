#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
SERIAL="$2"
LOGDIR="$3"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "SERIAL" "LOGDIR" && exit 1
fi

LOGFILE="$LOGDIR/$SERIAL-calibration.log"
START "$0" "$LOGFILE" "$*"

BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

INFO "Verifying Calibration Drive ($DEVICE)..." "$LOGFILE"
INFO "Device: $DEVICE" "$LOGFILE"
INFO "Block Size: $BS" "$LOGFILE"
INFO "$LOGFILE"

EXPECTED_MD5=$(${BASH_SOURCE%/*}/calibration-image-find-md5.sh "$LOGFILE")
if [ -n "$EXPECTED_MD5" ]; then
	INFO "Reading from device ($DEVICE)..." "$LOGFILE"
	DEVICE_MD5=$(${BASH_SOURCE%/*}/diskmd5.sh "$DEVICE" "$BS")
	if [ -n "$DEVICE_MD5" ]; then
		INFO "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" "$LOGFILE"
		INFO "$EXPECTED_MD5 - MD5 expected from pattern generation" "$LOGFILE"
		if [ "$DEVICE_MD5" == "$EXPECTED_MD5" ]; then
			INFO "Match!" "$LOGFILE"
		fi
	else
		ERROR "Unable to read MD5 from device!" "$0" "$LOGFILE" && exit 1
	fi
else
	ERROR "Unable to find expected MD5!" "$0" "$LOGFILE" && exit 1
fi

END "$0" "$LOGFILE"

