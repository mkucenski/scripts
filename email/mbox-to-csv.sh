#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

EML="$1"
if [ $# -eq 0 ]; then
	USAGE "EML" && exit 1
fi

DATE="$(egrep -h "^Date:" "$EML" | head -n 1 | gsed -r 's/^Date://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//; s/ \+[[:digit:]]+$//; s/^[[:alpha:]]+, //')"
SUBJECT="$(egrep -h "^Subject:" "$EML" | head -n 1 | gsed -r 's/^Subject://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
FROM="$(egrep -h "^From:" "$EML" | head -n 1 | gsed -r 's/^From://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
TO="$(egrep -h "^To:" "$EML" | head -n 1 | gsed -r 's/^To://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
CC="$(egrep -h "^Cc:" "$EML" | head -n 1 | gsed -r 's/^Cc://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
MESSAGEID="$(egrep -h "^Message-Id:" "$EML" | head -n 1 | gsed -r 's/^Message-Id://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"

echo "\"$DATE\",\"$SUBJECT\",\"$FROM\",\"$TO\",\"$CC\",\"$MESSAGEID\""
