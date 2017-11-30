#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

LOGFILE="$1"
if [ $# -eq 0 ]; then
	USAGE "LOGFILE" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

EXPECTED_MD5=$(grep "MD5 Expected from Pattern Generation" "$LOGFILE" | tail -n 1 | $SEDCMD -r 's/([a-fA-F0-9]+) - MD5 Expected from Pattern Generation/\1/')
if [ -n "$EXPECTED_MD5" ]; then
	echo "$EXPECTED_MD5"
else
	ERROR "Unable to find expected MD5!" "$0" "$LOGFILE"
	RV=$COMMON_ERROR
fi

exit $RV

