#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

TMP1=$(MKTEMP "$0" || exit 1)
TMP2=$(MKTEMP "$0" || exit 1)

while true; do
	LIST1=$(diskutil list)
	LIST2="$LIST1"
	while [ "$LIST1" == "$LIST2" ]; do
		# echo "Sleeping..."
		echo -n "."
		sleep 3
		LIST2=$(diskutil list)
	done
	echo

	if [ "$LIST1" != "$LIST2" ]; then
		echo "$LIST1" > "$TMP1"
		echo "$LIST2" > "$TMP2"
		diff --side-by-side --ignore-all-space --suppress-common-lines "$TMP1" "$TMP2"
	fi
done

rm "$TMP1"
rm "$TMP2"

