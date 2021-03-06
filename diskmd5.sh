#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEVICE="$1"
BS="$2"
if [ $# -eq 0 ]; then
	USAGE "DEVICE" "BLOCK SIZE (optional)" && exit 1
fi

if [ $# == 1 ]; then
	BS=$(${BASH_SOURCE%/*}/blocksize.sh "$DEVICE")
fi

DEVICE_MD5=`dd bs=$BS if="$DEVICE" | openssl md5 | tr "[:lower:]" "[:upper:]" | $SEDCMD -r 's/\(STDIN\)= //'`
if [ -n "$DEVICE_MD5" ]; then
	echo "$DEVICE_MD5"
else
	ERROR "Error reading MD5 from device!" "$0" && exit 1
fi

