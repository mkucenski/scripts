#!/bin/sh
# $1 Device to be wiped

DEVICE=$1
BLOCKSIZE=8192

echo "Writing 0's..."
dccidd bs=$BLOCKSIZE hash=none sizeprobe=of of=$DEVICE pattern=00
echo ""

echo "Verifying..."
xxd -a $DEVICE

