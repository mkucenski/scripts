#!/bin/bash

CMD="$1"
FREQ="$2"

BASE_TMP="$(mktemp)"
eval "$CMD 2>/dev/null" > "$BASE_TMP"
LAST_MD5=$(md5sum "$BASE_TMP" | sed -r 's/([^[:space:]]+).*/\1/')
clear; echo "Every $FREQ.0s: $CMD"; echo

NEW_TMP="$(mktemp)"
DIFF="$(mktemp)"
while true; do
	eval "$CMD 2>/dev/null" > "$NEW_TMP"
	NEW_MD5=$(md5sum "$NEW_TMP" | sed -r 's/([^[:space:]]+).*/\1/')
	if [ "$LAST_MD5" != "$NEW_MD5" ]; then
		clear; echo "Every $FREQ.0s: $CMD"; echo
		diff -ywi --suppress-common-lines -W 86 "$BASE_TMP" "$NEW_TMP" >> "$DIFF"
	  	tail -n 32 "$DIFF"
		LAST_MD5="$NEW_MD5"
	fi

	sleep $FREQ
done

rm "$BASE_TMP" "$NEW_TMP" "$DIFF"

