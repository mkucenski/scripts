#!/bin/bash
. $(dirname "$0")/common-include.sh

DEVICE="$1"
BS="$2"

DEVICE_MD5=`dd bs=$BS if="$DEVICE" | openssl md5 | tr a-z A-Z | $SEDCMD -r 's/\(STDIN\)= //'`
if [ -n "$DEVICE_MD5" ]; then
	echo "$DEVICE_MD5"
	exit 0
else
	ERROR "Error reading MD5 from device!" "$0"
fi

exit 1
