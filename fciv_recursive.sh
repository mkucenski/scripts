#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

DIR="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "DIR" "DOSHA1" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit $COMMON_ERROR)

if [ -e "$DIR" ]; then
	${BASH_SOURCE%/*}/fciv.sh 
	for FILE in $(find "$DIR" -type f); do
		${BASH_SOURCE%/*}/fciv_worker.sh "$FILE" $DOSHA1 \; >> "$TMP"
		RV=$((RV+$?))
	done
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find ($DIR)!" "$0"
	RV=$COMMON_ERROR
fi

rm "$TMP"

exit $RV

