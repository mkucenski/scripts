#!/usr/bin/env bash

# Quick script to verify whether the first X and last X bytes of a device have been wiped.

DEVICE="$1"
BS="$2"
COUNT="$3"

echo "Block Size=$BS"
SIZE=$(${BASH_SOURCE%/*}/disksize.sh "$DEVICE")
echo "Disk Size=$SIZE"
BLOCKS=$(($SIZE / $BS))
echo "Blocks=$BLOCKS"

echo "Reading first $COUNT block(s) of ($DEVICE) using (bs=$BS)..."
dd if="$DEVICE" bs=$BS count=$COUNT | xxd -a
echo ""

SKIP=$(($BLOCKS - $COUNT))
echo "Reading last $COUNT block(s) (skipping $(($SKIP * $BS)) bytes) of ($DEVICE) using (bs=$BS)..."
dd if="$DEVICE" bs=$BS skip=$SKIP | xxd -a

