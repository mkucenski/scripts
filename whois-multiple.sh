#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Run whois records consistently store the results in a specific directory

IP_FILE="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "IP_FILE" "DESTDIR" && exit 1
fi
if [ -z "$DESTDIR" ]; then
	DESTDIR="./"
fi

while read -r LINE; do
	"${BASH_SOURCE%/*}/whois.sh" "$LINE" "$DESTDIR"
done < "$IP_FILE"

