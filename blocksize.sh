#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# The goal of this script is simply to find the largest blocksize (bs=) that can be used and still cover the entire disk.
DEVICE="$1"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" && exit 1
fi

SECTORS=$(${BASH_SOURCE%/*}/disksectors.sh "$DEVICE")
if [ $SECTORS -lt 0 ]; then
	ERROR "Unable to read disk sectors!" "$0" && exit 1
fi
SECTOR_SIZE=512
SIZE=$(($SECTORS * $SECTOR_SIZE))

BS=$SECTOR_SIZE
MAX=$((1024 * 64))
TEST=$BS
while [ 1 ]; do
	if [ $TEST -le $MAX ]; then
		TEST=$(($TEST + $SECTOR_SIZE))
		if [ $(($SIZE % $TEST)) -eq 0 ]; then
			BS=$TEST
		fi
	else
		break;
	fi
done

echo $BS | tee /dev/stderr

