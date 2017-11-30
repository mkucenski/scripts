#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE1="$1"
FILE2="$2"
if [ $# -eq 0 ]; then
	USAGE "FILE1" "FILE2" && exit 1
fi

if [ -e "$FILE1" ]; then
	if [ -e "$FILE2" ]; then
		TMP1=$(MKTEMP "$0" || exit 1)
		TMP2=$(MKTEMP "$0" || exit 1)

		INFO "Isolating MD5 values..."
		HEADER1="//"
		HEADER2="// Open File Checksum Integrity Verifier version 1.0."
		HEADER3="		MD5				SHA-1"
		HEADER4="-------------------------------------------------------------------------"
		$SEDCMD -r "s/$HEADER1//; s/$HEADER2//; s/$HEADER3//; s/$HEADER4//; s/[[:space:]]+.+//" "$FILE1" | sort -u > "$TMP1"
		$SEDCMD -r "s/$HEADER1//; s/$HEADER2//; s/$HEADER3//; s/$HEADER4//; s/[[:space:]]+.+//" "$FILE2" | sort -u > "$TMP2"

		INFO "Comparing and sorting for unique/different MD5 values..."
		UNIQ_HASHES=$(MKTEMP "$0" || exit 1)
		diff -wi --suppress-common-lines "$TMP1" "$TMP2" | egrep "(<|>)" | gsed -r 's/[<>][[:space:]]+//g' | sort -u > "$UNIQ_HASHES"

		INFO "Searching original files for unique/different MD5 values..."
		grep -i -f "$UNIQ_HASHES" "$FILE1" > "$TMP1"
		grep -i -f "$UNIQ_HASHES" "$FILE2" > "$TMP2"

		INFO "Comparing unique/different MD5 values from each file..."
		diff -wi --suppress-common-lines "$TMP1" "$TMP2"

		rm "$TMP1"
		rm "$TMP2"
		rm "$UNIQ_HASHES"
	else
		ERROR "Invalid second file ($FILE2)!" "$0" && exit 1
	fi
else
	ERROR "Invalid first file ($FILE1)!" "$0" && exit 1
fi

