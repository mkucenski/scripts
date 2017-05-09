#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

# Can be device (/dev/disk8) or mountpoint
IDENTIFIER="$1"
if [ $# -ne 1 ]; then
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

