#!/bin/bash

TMP1=$(mktemp -t $(basename "$0"))
TMP2=$(mktemp -t $(basename "$0"))

LIST1=$(diskutil list)
LIST2="$LIST1"
while [ "$LIST1" == "$LIST2" ]; do
	echo "Sleeping..."
	sleep 3
	LIST2=$(diskutil list)
done

if [ "$LIST1" != "$LIST2" ]; then
	echo "$LIST1" > "$TMP1"
	echo "$LIST2" > "$TMP2"
	diff --side-by-side --ignore-all-space --suppress-common-lines "$TMP1" "$TMP2"
fi

rm "$TMP1"
rm "$TMP2"

