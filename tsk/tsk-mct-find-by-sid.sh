#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

SECURE2CSV="$1"
MCT_GZ="$2"; shift; shift
if [ $# -eq 0 ]; then
	USAGE "SECURE2CSV" "MCT.GZ" "SIDs..." && exit 1
fi

NAME="$(echo "$MCT_GZ" | $SEDCMD -r 's/\.mct\.gz$//')"
INFO "$NAME:"

for SID in $@; do
	INFO "$SID:"

	# SECIDS="$(grep "$SID" "$SECURE2CSV" | cut -d "," -f 3)"
	SECIDS="$(cut -d "," -f 3,5 "$SECURE2CSV" | grep "$SID" | cut -d "," -f 1)"
	# SECIDS="$(cut -d "," -f 3,24 "$SECURE2CSV" | grep "$SID" | cut -d "," -f 1)"

	if [ -n "$SECIDS" ]; then
		FIRST=""
		REGEX="^[^|]*\|[^|]+\|[^|]+\|[^|]*\|("
		for SECID in $SECIDS; do
			if [ -z "$FIRST" ]; then
				REGEX+="$SECID"
				FIRST="NO"
			else
				REGEX+="|$SECID"
			fi
		done
		REGEX+=")\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$"

		# gunzip -c "$MCT_GZ" | egrep "$REGEX" | gzip -c > "$NAME $SID.mct.gz"
		gunzip -c "$MCT_GZ" | egrep "$REGEX" | gzip -c > "$NAME $SID Ownership.mct.gz"
		# gunzip -c "$MCT_GZ" | egrep "$REGEX" | gzip -c > "$NAME $SID Potential Access.mct.gz"

		SECIDS=""
	fi
done

