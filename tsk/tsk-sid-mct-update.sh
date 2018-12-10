#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

SECID_SID_CSV="$1"
MCT_GZ="$2"

if [ $# -eq 0 ]; then
	USAGE "SECID_SID_CSV" "MCT.GZ" && exit 1
fi
IFS=$(echo -en "\n\b")

SID_LIST="$(MKTEMP "$0" || exit 1)"
cat "$SECID_SID_CSV" | cut -d "," -f 2 | gsed -r 's/[[:space:]]+//g;' | sort -u | egrep -v "^(0|SID|S-1-5-18|S-1-5-32-544)$" > "$SID_LIST"

NAME="$(echo "$MCT_GZ" | gsed -r 's/\.mct\.gz$//')"

while read -r SID; do
	REGEX="$(MKTEMP "$0.regex" || exit 1)"
	MCT="$NAME-$SID.mct.gz"

	echo -n "$SID:"
	for SECID in $(grep -i "$SID" "$SECID_SID_CSV" | cut -d "," -f 1); do
		echo -n " $SECID"
		echo "^[^|]*\|[^|]+\|[^|]+\|[^|]*\|$SECID\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$" >> "$REGEX"
	done
	gunzip -c "$MCT_GZ" | egrep -f "$REGEX" | gsed -r "s/^([^|]*\|[^|]+\|[^|]+\|[^|]*)\|[^|]*\|([^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*)$/\1|$SID|\2/" | gzip -c > "$MCT"
	echo

	rm "$REGEX"
done < "$SID_LIST"

rm "$SID_LIST"

