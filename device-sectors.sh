#!/bin/bash

# Description: This script returns the device sector count.
DEVICE="$1"

SECTORS=`diskutil info $DEVICE | egrep "(Disk|Total) Size:" | gsed -r 's/.+\(exactly ([[:digit:]]+) 512-Byte-Units\)/\1/'`
#SECTOR_SIZE=512
#SIZE=$(expr $SECTORS \* $SECTOR_SIZE)

echo $SECTORS

