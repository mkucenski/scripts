#!/bin/bash

FILE1="$1"
FILE2="$2"

if [ -e "$FILE1" ]; then
	if [ -e "$FILE2" ]; then
		TMP1=$(mktemp)
		TMP2=$(mktemp)
		HEADER1="//"
		HEADER2="// Open File Checksum Integrity Verifier version 1.0."
		HEADER3="		MD5				SHA-1"
		HEADER4="-------------------------------------------------------------------------"
		gsed -r 's/$HEADER1//; s/$HEADER2//; s/$HEADER3//; s/$HEADER4//; s/[[:space:]]+.+//' "$FILE1" | sort -u > "$TMP1"
		gsed -r 's/$HEADER1//; s/$HEADER2//; s/$HEADER3//; s/$HEADER4//; s/[[:space:]]+.+//' "$FILE2" | sort -u > "$TMP2"
		diff -wiy --suppress-common-lines "$TMP1" "$TMP2"
	else
		echo "Error! Invalid second file!" > /dev/stderr
	fi
else
	echo "Error! Invalid first file!" > /dev/stderr
fi
