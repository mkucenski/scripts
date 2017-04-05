#!/bin/bash

# The goal of this script is simply to find the largest blocksize (bs=) that can be used and still cover the entire disk.

DEVICE="$1"

SECTORS=$($(dirname "$0")/disksectors.sh "$DEVICE")
if [ $SECTORS -lt 0 ]; then
	echo "ERROR($(basename "$0")): Unable to read disk sectors!" > /dev/stderr
	exit 1
fi
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)

BS=$SECTOR_SIZE
MAX=$(expr 1024 \* 64)
TEST=$BS
while [ 1 ]; do
	if [ $TEST -le $MAX ]; then
		TEST=$(expr $TEST + $SECTOR_SIZE)
		if [ $(expr $SIZE % $TEST) -eq 0 ]; then
			BS=$TEST
		fi
	else
		break;
	fi
done

echo $BS

