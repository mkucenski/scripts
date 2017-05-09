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
BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")

INFO "Wiping device ($DEVICE)..." "$LOGFILE"

OS=`uname`
if [ $OS = "Darwin" ]; then

	INFO "Using MacOSX (diskutil secureErase)..." "$LOGFILE"
	RESULTS=$(diskutil secureErase 0 "$DEVICE" 2>&1)
	INFO "$RESULTS" "$LOGFILE"

else

	if [$OS = "FreeBSD" ]; then

		MODEL=`camcontrol identify "$DEVICE" | grep 'device model' | $SEDCMD -r 's/^device model[[:space:]]+(.*)$/\1/'`
		SERIAL=`camcontrol identify "$DEVICE" | grep 'serial number' | $SEDCMD -r 's/^serial number[[:space:]]+(.*)$/\1/'`
		INFO "FreeBSD 'camcontrol' reported model: '$MODEL', serial number: '$SERIAL'..." "$LOGFILE"

	fi

	INFO "Using dd (/dev/zero)..." "$LOGFILE"
	RESULTS=$(dd if=/dev/zero of="$DEVICE" bs=$BS)
	INFO "$RESULT" "$LOGFILE"

fi

INFO "Completed wiping device ($DEVICE)!" "$LOGFILE"

${BASH_SOURCE%/*}/wipe-verify.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

END "$0" "$LOGFILE"
