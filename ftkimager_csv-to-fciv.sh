#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

CSV="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "CSV" "DOSHA1" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit $COMMON_ERROR)
TMPCSV=$(mktemp -t $(basename "$0") || exit $COMMON_ERROR)

if [ -e "$CSV" ]; then
	INFO "$(dos2unix -n "$CSV" "$TMPCSV" 2>&1)"

	INFO "Parsing individual lines into fciv format ($TMP)..."
	while read -r LINE; do
		REGEX="^.*[.+].+[[:space:]]+[[:digit:]]+[[:space:]]+.*[[:space:]]+[a-z0-9]{32}[[:space:]]+[a-z0-9]{40}.*$"
		SED="^.*\[.+\]\\\\(.+)[[:space:]]+[[:digit:]]+[[:space:]]+.*[[:space:]]+([a-z0-9]{32})[[:space:]]+([a-z0-9]{40}).*$"
		FILE=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\1/")
		MD5=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\2/")

		if [ -n "$MD5" ]; then
			if [ "$DOSHA1" != "0" ]; then
				SHA1=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\3/")
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
	ERROR "Unable to find file!" "$0"
	RV=$COMMON_ERROR
fi

rm "$TMP"
rm "$TMPCSV"

exit $RV

