#!/bin/bash

# Description: This script returns the device sector count.
DEVICE="$1"

SECTORS=-1
UNAME=`uname`
if [ "$UNAME" = "Darwin" ]; then
	SECTORS=`diskutil info $DEVICE | egrep "(Disk|Total) Size:" | gsed -r 's/.+\(exactly ([[:digit:]]+) 512-Byte-Units\)/\1/'`
	if [ -n $SECTORS ]; then
		echo $SECTORS
		exit 0
	else
		ERROR "Unable to read disk size via diskutil!" "$0"
	fi
else
	ERROR "Undefined OS, unable to gather disk size!" "$0"
fi

exit 1
