#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# The idea here is to generate a baseline of the given command output, then periodically
# re-run the command and compare the results--any differences are reported. Useful for
# watching 'lsof' or other to see what a process is doing. 

CMD="$1"
FREQ="$2"
if [ $# -eq 0 ]; then
	USAGE "CMD" "FREQ" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

BASE_TMP="$(MKTEMP "$0")"
eval "$CMD 2>/dev/null" > "$BASE_TMP"
LAST_MD5=$(openssl dgst -md5 -r "$BASE_TMP" | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
clear; echo "Every $FREQ.0s: $CMD"; echo

NEW_TMP="$(MKTEMP "$0")"
DIFF="$(MKTEMP "$0")"
while true; do
	eval "$CMD 2>/dev/null" > "$NEW_TMP"
	NEW_MD5=$(openssl dgst -md5 -r "$NEW_TMP" | $SEDCMD -r 's/([^[:space:]]+).*/\1/')
	if [ "$LAST_MD5" != "$NEW_MD5" ]; then
		clear; echo "Every $FREQ.0s: $CMD"; echo
		diff -ywi --suppress-common-lines -W 260 "$BASE_TMP" "$NEW_TMP" >> "$DIFF"
		tail -n 50 "$DIFF"
		LAST_MD5="$NEW_MD5"
	fi

	sleep $FREQ
done

rm "$BASE_TMP" "$NEW_TMP" "$DIFF"

exit $RV

