#!/bin/bash
. $(dirname "$0")/common-include.sh

IMAGE="$1"
OFFSET="$2"
DEST="$3"
MCTENTRY="$4"

if [ -n "$MCTENTRY" ]; then
	REGEX="^[^|]+\|[^|]+\|[^|]+\|r[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+$"
	SED="^([^|]+)\|([^|]+)\|([^|]+)\|(r[^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)$"
	FILE=$(echo "$MCTENTRY" | grep -v "\$FILE_NAME" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\2/")
	INODE=$(echo "$MCTENTRY" | grep -v "\$FILE_NAME" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\3/" | egrep "[[:digit:]]+-128-[[:digit:]]+" | $SEDCMD -r "s/([[:digit:]]+)-128-[[:digit:]]/\1/")
	if [ -n "$FILE" ]; then
		if [ -n "$INODE" ]; then
			mkdir -p "$DEST/$(dirname "$FILE")"
			icat -o $OFFSET "$IMAGE" $INODE > "$DEST/$FILE"
			echo "$FILE"
		fi
	fi
else
	ERROR "Invalid mactime entry!" "$0"
fi

