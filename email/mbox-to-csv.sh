#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

if [ $# -eq 0 ]; then
	USAGE "MBOX(S)"
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION "This is a simple script to parse basic headers out of text-based email files (e.g. mbox format containing a single email) and output them in CSV format for quick review/analysis."
	USAGE_EXAMPLE "$(basename "$0") mbox1 mbox2 mbox3 ..."
	exit 1
fi

echo "Date, Subject, From, To, CC, MessageID"
for MBOX in $@; do
	DATE="$(egrep -h "^Date:" "$MBOX" | head -n 1 | gsed -r 's/^Date://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//; s/ \+[[:digit:]]+$//; s/^[[:alpha:]]+, //')"
	SUBJECT="$(egrep -h "^Subject:" "$MBOX" | head -n 1 | gsed -r 's/^Subject://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	FROM="$(egrep -h "^From:" "$MBOX" | head -n 1 | gsed -r 's/^From://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	TO="$(egrep -h "^To:" "$MBOX" | head -n 1 | gsed -r 's/^To://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	CC="$(egrep -h "^Cc:" "$MBOX" | head -n 1 | gsed -r 's/^Cc://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	MESSAGEID="$(egrep -h "^Message-Id:" "$MBOX" | head -n 1 | gsed -r 's/^Message-Id://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"

	echo "\"$DATE\",\"$SUBJECT\",\"$FROM\",\"$TO\",\"$CC\",\"$MESSAGEID\""
done

