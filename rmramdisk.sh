#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Can be device (/dev/disk8) or mountpoint
IDENTIFIER="$1"
if [ $# -eq 0 ]; then
	USAGE "IDENTIFIER (device or mount point)" && exit 1
fi

UNAME=$(uname)
if [ "$UNAME" = "Darwin" ]; then
	RESULTS=$(hdiutil detach "$IDENTIFIER")
	if [ $RESULTS ]; then
	else
		ERROR "Unable to detach RAM device via <hdiutil detach>!" "$0" && exit 1
	fi
else
	ERROR "Undefined OS, unable to create ram disk!" "$0" && exit 1
fi

