#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

FILE="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "FILE" "DOSHA1" && exit 0
fi

RV=$COMMON_SUCCESS

if [ -n "$FILE" ]; then
	MD5=$(openssl dgst -md5 -r /dev/stdin | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
	RV=$((RV+$?))
	SHA1="0000000000000000000000000000000000000000"
	if [ "$DOSHA1" != "0" ]; then
		SHA1=$(openssl dgst -sha1 -r /dev/stdin | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
		RV=$((RV+$?))
	fi
	FILE=$(echo "$FILE" | $SEDCMD -r 's/\/\//\//g; s/\//\\/g')
	echo "$MD5 $SHA1 $FILE"
else
	ERROR "Invalid File ($FILE)!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

