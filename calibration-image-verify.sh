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

BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

INFO "Verifying Calibration Drive ($DEVICE)..." "$LOGFILE"
INFO "Device: $DEVICE" "$LOGFILE"
INFO "Block Size: $BS" "$LOGFILE"
INFO "$LOGFILE"

EXPECTED_MD5=$(${BASH_SOURCE%/*}/calibration-image-find-md5.sh "$LOGFILE")
if [ -n "$EXPECTED_MD5" ]; then
<<<<<<< HEAD
	INFO "Reading from device ($DEVICE)..." "$LOGFILE"
	DEVICE_MD5=$($(dirname "$0")/diskmd5.sh "$DEVICE" "$BS")
=======
	LOG "Reading from device ($DEVICE)..." "$LOGFILE"
	DEVICE_MD5=$(${BASH_SOURCE%/*}/diskmd5.sh "$DEVICE" "$BS")
>>>>>>> fb6ba51526ac4bf01710eb1ebfc0daa0a88f6063
	if [ -n "$DEVICE_MD5" ]; then
		INFO "$DEVICE_MD5 - MD5 Reported by Device ($DEVICE)" "$LOGFILE"
		INFO "$EXPECTED_MD5 - MD5 expected from pattern generation" "$LOGFILE"
		if [ "$DEVICE_MD5" == "$EXPECTED_MD5" ]; then
			INFO "Match!" "$LOGFILE"
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

