#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

LOGFILE="$1"
if [ $# -ne 1 ]; then
	USAGE "LOGFILE" && exit 0
fi

EXPECTED_MD5=$(grep "MD5 Expected from Pattern Generation" "$LOGFILE" | tail -n 1 | $SEDCMD -r 's/([a-fA-F0-9]+) - MD5 Expected from Pattern Generation/\1/')
if [ -n "$EXPECTED_MD5" ]; then
	echo "$EXPECTED_MD5"
	exit 0
else
	ERROR "Unable to find expected MD5!" "$0" "$LOGFILE"
fi

exit 1

