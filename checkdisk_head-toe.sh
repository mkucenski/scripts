#!/bin/bash

# Quick script to verify whether the first X and last X bytes of a device have been wiped.

DEVICE="$1"
COUNT="$2"

BS=$($(dirname "$0")/blocksize.sh "$DEVICE")
SIZE=$($(dirname "$0")/disksize.sh "$DEVICE")
BLOCKS=$(expr $SIZE \/ $BS)

echo "Reading first $COUNT blocks of ($DEVICE) using (bs=$BS)..."
dd if="$DEVICE" bs=$BS count=$COUNT 2> /dev/null | xxd -a
echo ""
echo "Reading last $COUNT blocks of ($DEVICE) using (bs=$BS)..."
dd if="$DEVICE" bs=$BS skip=$(expr $BLOCKS - $COUNT) 2> /dev/null| xxd -a

