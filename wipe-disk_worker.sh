#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
LOGFILE="$3"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "LOGFILE" && exit 1
fi

BS=$("${BASH_SOURCE%/*}/blocksize.sh" "$DEVICE")

OS="$(uname)"
if [ "$OS" = "Darwin" ]; then

	INFO "Using MacOSX (diskutil secureErase)..." "$LOGFILE"
	RESULTS=$(diskutil secureErase 0 "$DEVICE" 2>&1)
	INFO "$RESULTS" "$LOGFILE"

else

	INFO "Using dd (/dev/zero)..." "$LOGFILE"
	RESULT=$(dd if=/dev/zero of="$DEVICE" bs="$BS")
	INFO "$RESULT" "$LOGFILE"

fi

