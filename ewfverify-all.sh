#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Find all .E01 files within BASEDIR and execute <ewfverify> on each.

BASEDIR="$1"
ALL_LOGFILE="$2"
if [ $# -eq 0 ]; then
	USAGE "BASEDIR" "ALL_LOGFILE (optional)" && exit 1
fi

RV=0
START "$0" "$ALL_LOGFILE" "$*"

find "$BASEDIR" -type f -iname "*.E01" -print0 | 
while IFS= read -r -d $'\0' FOUND_IMAGE; do
	FULL_FOUND_IMAGE_PATH="$(cd "$(dirname "$FOUND_IMAGE")"; pwd)/$(basename "$FOUND_IMAGE")"
	INFO "Image: $FULL_FOUND_IMAGE_PATH"
	RESULT=$("${BASH_SOURCE%/*}/ewfverify.sh" "$FOUND_IMAGE")
	SUCCESS=$(echo "$RESULT" | grep "Successfully Verified!")
	if [ -n "$SUCCESS" ]; then
		INFO "SUCCESS! ($FULL_FOUND_IMAGE_PATH)" "$ALL_LOGFILE"
	else
		ERROR "$FULL_FOUND_IMAGE_PATH" "$0" "$ALL_LOGFILE" && RV=1
	fi
done

END "$0" "$ALL_LOGFILE"
exit $RV

