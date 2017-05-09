#!/bin/bash

DEVICE="$1"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" && exit 0
fi

SIZE=-1
SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
if [ $SECTORS -gt 0 ]; then
	SECTOR_SIZE=512
	SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
	echo $SIZE
	exit 0
else
	ERROR "Error getting disk sectors!" "$0"
fi

exit 1
