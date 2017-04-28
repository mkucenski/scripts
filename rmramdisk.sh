#!/bin/bash
. $(dirname "$0")/common-include.sh

# Can be device (/dev/disk8) or mountpoint
IDENTIFIER="$1"
if [ $# -eq 0 ]; then
	USAGE "IDENTIFIER (device or mount point)" && exit 0
fi

UNAME=$(uname)
if [ "$UNAME" = "Darwin" ]; then
	RV=$(hdiutil detach "$IDENTIFIER")
	if [ $RV ]; then
		exit 0
	else
		ERROR "Unable to detach RAM device via <hdiutil detach>!" "$0"
	fi
else
	ERROR "Undefined OS, unable to create ram disk!" "$0"
fi

exit 1

