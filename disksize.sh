#!/bin/bash

DEVICE="$1"

SIZE=-1
SECTORS=$($(dirname "$0")/disksectors.sh "$DEVICE")
if [ $SECTORS -gt 0 ]; then
	SECTOR_SIZE=512
	SIZE=$(expr $SECTORS \* $SECTOR_SIZE)
	echo $SIZE
	exit 0
else
	ERROR "Error getting disk sectors!" "$0"
fi

exit 1
