#!/bin/bash
. $(dirname "$0")/common-include.sh

FILE="$1"
DOSHA1="$2"

if [ -n "$FILE" ]; then
	MD5=$(openssl dgst -md5 -r /dev/stdin | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
	SHA1="0000000000000000000000000000000000000000"
	if [ "$DOSHA1" != "0" ]; then
		SHA1=$(openssl dgst -sha1 -r /dev/stdin | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
	fi
	FILE=$(echo "$FILE" | $SEDCMD -r 's/\/\//\//g; s/\//\\/g')
	echo "$MD5 $SHA1 $FILE"
else
	ERROR "Invalid File ($FILE)!" "$0"
fi

