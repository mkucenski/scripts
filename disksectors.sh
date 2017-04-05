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
		echo "ERROR($(basename "$0")): Unable to read disk size via diskutil!" > /dev/stderr
	fi
else
	echo "ERROR($0): Undefined OS, unable to gather disk size!" > /dev/stderr
fi

exit 1
