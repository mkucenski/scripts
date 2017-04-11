#!/bin/bash

DEVICE="$1"
SERIALNUM="$2"
LOGDIR="$3"

LOG="$3/$SERIALNUM-wipe.log"

COUNT=1024
BS=$($(dirname "$0")/blocksize.sh "$DEVICE")

echo
date "+%Y%m%d" >> "$LOG"
echo "Wiping device ($DEVICE)..." | tee -a "$LOG"

OS=`uname`
if [ $OS = "Darwin" ]; then

	echo "Using MacOSX (diskutil secureErase)..." | tee -a "$LOG"
	diskutil secureErase 0 "$DEVICE" 2>&1 | tee -a "$LOG"

else

	if [$OS = "FreeBSD" ]; then

		MODEL=`camcontrol identify "$DEVICE" | grep 'device model' | gsed -r 's/^device model[[:space:]]+(.*)$/\1/'`
		SERIAL=`camcontrol identify "$DEVICE" | grep 'serial number' | gsed -r 's/^serial number[[:space:]]+(.*)$/\1/'`
		echo "FreeBSD 'camcontrol' reported model: '$MODEL', serial number: '$SERIAL'..." | tee -a "$LOG"

	fi

	echo "Using dd (/dev/zero)..." | tee -a "$LOG"
	dd if=/dev/zero of="$DEVICE" bs=$BS tee -a "$LOG"

fi

echo "Completed wiping device ($DEVICE)!"
date "+%Y%m%d" >> "$LOG"

$(dirname "$0")/wipe-verify.sh "$DEVICE" "$SERIALNUM" "$LOGDIR"

