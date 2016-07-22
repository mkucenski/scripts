#!/bin/sh
# [-a] Four pass wipe (Zeros, Ones, Random, Zeros)
# /dev/xxx Device to be wiped

if [ "$1" = "-a" ]; then
	DEVICE=$2
else
	DEVICE=$1
fi

DD=dcfldd
BLOCKSIZE=8192

echo "Wiping $DEVICE: `date`"

echo "Writing 0's..."
$DD bs=$BLOCKSIZE sizeprobe=of of=$DEVICE pattern=00
echo ""

if [ "$1" = "-a" ]; then
	echo "Writing 1's..."
	$DD bs=$BLOCKSIZE sizeprobe=of of=$DEVICE pattern=ff
	echo ""

	echo "Writing random..."
	$DD bs=$BLOCKSIZE sizeprobe=of of=$DEVICE if=/dev/random
	echo ""

	echo "Writing 0's..."
	$DD bs=$BLOCKSIZE sizeprobe=of of=$DEVICE pattern=00
	echo ""
fi

echo "Verifying..."
$DD bs=$BLOCKSIZE sizeprobe=if if=$DEVICE | xxd -a

echo "Finished wiping $DEVICE: `date`"

