#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

# Find all .E01 files within BASEDIR and execute <ewfverify> on each.

BASEDIR="$1"
ALL_LOGFILE="$2"
if [ $# -eq 0 ]; then
	USAGE "BASEDIR" "ALL_LOGFILE (optional)" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS
START "$0" "$ALL_LOGFILE" "$*"

# Adjust field separators for for loop to support whitespace in filenames
IFS=$(echo -en "\n\b")

for FOUND_IMAGE in $(find "$BASEDIR" -type f -iname "*.E01"); do
	FULL_FOUND_IMAGE_PATH="$(cd $(dirname "$FOUND_IMAGE"); pwd)/$(basename "$FOUND_IMAGE")"
	INFO "Image: $FULL_FOUND_IMAGE_PATH"
	RESULT=$(${BASH_SOURCE%/*}/ewfverify.sh "$FOUND_IMAGE")
	SUCCESS=$(echo "$RESULT" | grep "Successfully Verified!")
	if [ -n "$SUCCESS" ]; then
		if [ -n "$ALL_LOGFILE" ]; then
			INFO "SUCCESS! ($FULL_FOUND_IMAGE_PATH)" "$ALL_LOGFILE"
		else
			INFO "SUCCESS! ($FULL_FOUND_IMAGE_PATH)"
		fi
	else
		if [ -n "$ALL_LOGFILE" ]; then
			ERROR "$FULL_FOUND_IMAGE_PATH" "$0" "$ALL_LOGFILE"
		else
			ERROR "$FULL_FOUND_IMAGE_PATH" "$0"
		fi
		RV=$COMMON_ERROR
	fi
done

END "$0" "$ALL_LOGFILE"
exit $RV

