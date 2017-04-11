#!/bin/bash

DEVICE="$1"
BS="$2"

DEVICE_MD5=`dd bs=$BS if="$DEVICE" | openssl md5 | tr a-z A-Z | gsed -r 's/\(STDIN\)= //'`
if [ -n "$DEVICE_MD5" ]; then
	echo "$DEVICE_MD5"
	exit 0
else
	echo "ERROR($(basename "$0")): Error reading MD5 from device!"
fi

exit 1
