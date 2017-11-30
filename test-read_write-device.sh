#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Arguments
DEVICE="$1"

# Init
I=0
MAX=1024
while [ $I -lt 12 ]; do
	MAX=$(($MAX * 2))
	I=$(($I + 1))
done
SIZE=$(($MAX * 10))
FILE=$(MKTEMP "$0")
echo "Device=$DEVICE, Max BS=$MAX, Sample Size=$SIZE, File=$FILE"

# Test Read
BS=1024
while [ $BS -le $MAX ]; do
	echo "Testing read w/bs=$BS"
	COUNT=$(($SIZE / $BS))
	dd if="$DEVICE" of="$FILE" bs=$BS count=$COUNT 2>&1 | egrep -v "records (in|out)"
	BS=$(($BS * 2))
done

echo

# Test Write
BS=1024
while [ $BS -le $MAX ]; do
	echo "Testing write w/bs=$BS"
	COUNT=$(($SIZE / $BS))
	dd if="$FILE" of="$DEVICE" bs=$BS count=$COUNT 2>&1 | egrep -v "records (in|out)"
	BS=$(($BS * 2))
done

# Cleanup
rm $FILE

