#!/bin/bash
. $(dirname "$0")/common-include.sh

CSV="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "CSV" "DOSHA1" && exit 0
fi

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit 1)
TMPCSV=$(mktemp -t $(basename "$0") || exit 1)
dos2unix -n "$CSV" "$TMPCSV"

if [ -e "$CSV" ]; then
	$(dirname "$0")/fciv.sh

	while read -r LINE; do
		REGEX="^.*[AD1].+[[:space:]]+[[:digit:]]+[[:space:]]+.*[[:space:]]+[a-z0-9]{32}[[:space:]]+[a-z0-9]{40}.*$"
		SED="^.*\[AD1\](.+)[[:space:]]+[[:digit:]]+[[:space:]]+.*[[:space:]]+([a-z0-9]{32})[[:space:]]+([a-z0-9]{40}).*$"
		FILE=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\.\1/")
		MD5=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\2/")

		if [ -n "$MD5" ]; then
			if [ "$DOSHA1" != "0" ]; then
				SHA1=$(echo "$LINE" | egrep "$REGEX" | $SEDCMD -r "s/$SED/\3/")
			else
				SHA1="0000000000000000000000000000000000000000"
			fi
			echo "$MD5 $SHA1 $FILE" | tee -a "$TMP" > /dev/stderr
		fi
	done < "$TMPCSV"

	sort --key=$KEY "$TMP"
else
	echo "Error! Unable to find file!" > /dev/stderr
fi

rm "$TMP"
rm "$TMPCSV"

