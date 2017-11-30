#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Can be device (/dev/disk8) or mountpoint
IDENTIFIER="$1"
if [ $# -eq 0 ]; then
	USAGE "IDENTIFIER (device or mount point)" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

UNAME=$(uname)
if [ "$UNAME" = "Darwin" ]; then
	RESULTS=$(hdiutil detach "$IDENTIFIER")
	if [ $RESULTS ]; then
	else
		ERROR "Unable to detach RAM device via <hdiutil detach>!" "$0"
		RV=$COMMON_ERROR
	fi
else
	ERROR "Undefined OS, unable to create ram disk!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

