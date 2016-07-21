#!/bin/bash

# Extract the overall size of a device using 'diskutil'

DEVICE="$1"

SECTORS=`diskutil info $DEVICE | grep "Total Size:" | gsed -r 's/.+\(exactly ([[:digit:]]+) 512-Byte-Units\)/\1/'`
SECTOR_SIZE=512
SIZE=$(expr $SECTORS \* $SECTOR_SIZE)

echo $SIZE

