#!/bin/bash

DEVICE="$1"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" && exit 1
fi

SIZE=-1
SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
if [ $SECTORS -gt 0 ]; then
	SECTOR_SIZE=512
	SIZE=$(($SECTORS * $SECTOR_SIZE))
	echo $SIZE
else
	ERROR "Error getting disk sectors!" "$0" && exit 1
fi

