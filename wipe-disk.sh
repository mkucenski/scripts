#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"
if [ $# -ne 3 ]; then
	USAGE "DEVICE" "SERIALNUM" "LOGDIR" && exit 0
fi

LOGFILE="$LOGDIR/$SERIALNUM-wipe.log"
START "$0" "$LOGFILE"

COUNT=1024
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

LOG "Wiping device ($DEVICE)..." "$LOGFILE"

OS=`uname`
if [ $OS = "Darwin" ]; then

	LOG "Using MacOSX (diskutil secureErase)..." "$LOGFILE"
	RESULTS=$(diskutil secureErase 0 "$DEVICE" 2>&1)
	LOG "$RESULTS" "$LOGFILE"

else

	if [$OS = "FreeBSD" ]; then

		MODEL=`camcontrol identify "$DEVICE" | grep 'device model' | $SEDCMD -r 's/^device model[[:space:]]+(.*)$/\1/'`
		SERIAL=`camcontrol identify "$DEVICE" | grep 'serial number' | $SEDCMD -r 's/^serial number[[:space:]]+(.*)$/\1/'`
		LOG "FreeBSD 'camcontrol' reported model: '$MODEL', serial number: '$SERIAL'..." "$LOGFILE"

	fi

	LOG "Using dd (/dev/zero)..." "$LOGFILE"
	RESULTS=$(dd if=/dev/zero of="$DEVICE" bs=$BS)
	LOG "$RESULT" "$LOGFILE"

fi

LOG "Completed wiping device ($DEVICE)!" "$LOGFILE"

$(dirname "$0")/wipe-verify.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"
