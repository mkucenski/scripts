#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "FILE" "DOSHA1" && exit 1
fi

if [ -n "$FILE" ]; then
	MD5=$(openssl dgst -md5 -r /dev/stdin | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
	SHA1="0000000000000000000000000000000000000000"
	if [ "$DOSHA1" != "0" ]; then
		SHA1=$(openssl dgst -sha1 -r /dev/stdin | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
	fi
	FILE=$(echo "$FILE" | $SEDCMD -r 's/\/\//\//g; s/\//\\/g')
	echo "$MD5 $SHA1 $FILE"
else
	ERROR "Invalid File ($FILE)!" "$0" && exit 1
fi

