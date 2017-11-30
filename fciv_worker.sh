#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "FILE" "DOSHA1" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

if [ -f "$FILE" ]; then
	MD5=$(openssl dgst -md5 -r "$FILE" | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
	RV=$((RV+$?))
	SHA1="0000000000000000000000000000000000000000"
	if [ "$DOSHA1" != "0" ]; then
		SHA1=$(openssl dgst -sha1 -r "$FILE" | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
		RV=$((RV+$?))
	fi
	FILE=$(echo "$FILE" | $SEDCMD -r 's/\/\//\//g; s/\//\\/g')
	echo "$MD5 $SHA1 $FILE"
else
	ERROR "Invalid File ($FILE)!" "$0"
	RV=$COMMON_ERROR
fi

exit $RV

