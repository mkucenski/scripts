#!/bin/bash

# The goal of this script is simply to find the largest blocksize (bs=) that can be used and still cover the entire disk.

DEVICE="$1"

SECTORS=`diskutil info $DEVICE | grep "Total Size:" | gsed -r 's/.+\(exactly ([[:digit:]]+) 512-Byte-Units\)/\1/'`
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)

BS=2
MAXBS=16384
TEST=$BS
while [ $(expr $SIZE % $TEST) -eq 0 ]; do
	BS=$TEST
	TEST=$(expr $TEST \* 2)
done
if [ $BS -gt $MAXBS ]; then
	BS=$MAXBS
fi

COUNT=$(expr $SIZE / $BS)

echo $BS

