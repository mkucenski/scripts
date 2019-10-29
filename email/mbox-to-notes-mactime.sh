#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

if [ $# -eq 0 ]; then
	USAGE "MBOX(S)" && exit 1
fi

for MBOX in $@; do
	DATE="$(egrep -h "^Date:" "$MBOX" | head -n 1 | gsed -r 's/^Date://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//; s/ \+[[:digit:]]+$//; s/^[[:alpha:]]+, //')"
	SUBJECT="$(egrep -h "^Subject:" "$MBOX" | head -n 1 | gsed -r 's/^Subject://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	FROM="$(egrep -h "^From:" "$MBOX" | head -n 1 | gsed -r 's/^From://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	TO="$(egrep -h "^To:" "$MBOX" | head -n 1 | gsed -r 's/^To://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	CC="$(egrep -h "^Cc:" "$MBOX" | head -n 1 | gsed -r 's/^Cc://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	MESSAGEID="$(egrep -h "^Message-Id:" "$MBOX" | head -n 1 | gsed -r 's/^Message-Id://; s/"//g; s/^[[:space:]]+//; s/[\r\n[:space:]]+$//')"
	echo "\"$DATE\",\"$SUBJECT\",\"$FROM\",\"$TO\",\"$CC\",\"$MESSAGEID\""
done

