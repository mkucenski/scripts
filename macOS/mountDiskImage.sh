#!/bin/bash

IMAGE="$1"
MNT="$2"

if [ -e "$IMAGE" ]; then
	ewfmount "$IMAGE" "$MNT"
	hdiutil attach -readonly -imagekey diskimage-class=CRawDiskImage "$MNT/ewf1"
else
	echo "Error! Image file does not exist!" > /dev/stderr
fi

