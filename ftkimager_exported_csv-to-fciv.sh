#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

CSV="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "CSV" "DOSHA1" && exit 1
fi

KEY="1.75"
TMP=$(MKTEMP "$0" || exit 1)
TMPCSV=$(MKTEMP "$0" || exit 1)

if [ -e "$CSV" ]; then
	INFO $(dos2unix -n "$CSV" "$TMPCSV" 2>&1)

	INFO "Parsing individual lines into fciv format ($TMP)..."
	while read -r LINE; do
		REGEX="^\"[a-z0-9]{32}\",\"[a-z0-9]{40}\",\".*\[.+\]\\\.*\""
		SED="^\"([a-z0-9]{32})\",\"([a-z0-9]{40})\",\".*\[.+\]\\\(.*)\""
		FILE=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\3/")
		MD5=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\1/")

		if [ -n "$MD5" ]; then
			if [ "$DOSHA1" != "0" ]; then
				SHA1=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\2/")
			else
				SHA1="0000000000000000000000000000000000000000"
			fi
			echo "$MD5 $SHA1 $FILE" >> "$TMP"
		fi
	done < "$TMPCSV"

	INFO "Sorting based on filename/path ($KEY)..."
	${BASH_SOURCE%/*}/fciv.sh
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find file!" "$0" && exit 1
fi

rm "$TMP"
rm "$TMPCSV"

