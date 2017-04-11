#!/bin/bash

LOG="$1"

EXPECTED_MD5=`grep "MD5 Expected from Pattern Generation" "$LOG" | tail -n 1 | gsed -r 's/([a-fA-F0-9]+) - MD5 Expected from Pattern Generation/\1/'`
if [ -n "$EXPECTED_MD5" ]; then
	echo "$EXPECTED_MD5"
	exit 0
else
	echo "ERROR($(basename "$0")): Unable to find expected MD5!" | tee -a "$LOG"
fi

exit 1

