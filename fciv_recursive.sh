#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

DIR="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "DIR" "DOSHA1" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

KEY="1.75"
TMP=$(MKTEMP "$0" || exit $COMMON_ERROR)
INFO_ERR "Temp: $TMP"

if [ -e "$DIR" ]; then
	${BASH_SOURCE%/*}/fciv.sh 
	find "$DIR" -type f -exec ${BASH_SOURCE%/*}/fciv_worker.sh "{}" $DOSHA1 >> "$TMP" \;
	# for FILE in $(find "$DIR" -type f); do
	# 	${BASH_SOURCE%/*}/fciv_worker.sh "$FILE" $DOSHA1 >> "$TMP"
	# 	RV=$((RV+$?))
	# done
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find ($DIR)!" "$0"
	RV=$COMMON_ERROR
fi

rm "$TMP"

exit $RV

