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

	# TODO Need a more robust way to handle each of the given options

	# 1. Finds any $SECURE entry that references the given SID (this could be an access restriction or an access granted).
	# SECIDS="$(grep "$SID" "$SECURE2CSV" | cut -d "," -f 3)"

	# 2. Finds only $SECURE entries for which the owner (column 5) matches the given SID
	# SECIDS="$(cut -d "," -f 3,5 "$SECURE2CSV" | grep "$SID" | cut -d "," -f 1)"

	# 3. Finds only $SECURE entries for which other access control entries list the given SID (this could also be an access restriction or an access granted).
	SECIDS="$(cut -d "," -f 3,24 "$SECURE2CSV" | grep "$SID" | cut -d "," -f 1)"

	# TODO the 4th way to get file associations is via the recycle.bin which lists the SID directly in the path

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

		# 1.
		# gunzip -c "$MCT_GZ" | egrep "$REGEX" | gzip -c > "$NAME $SID.mct.gz"

		# 2.
		# gunzip -c "$MCT_GZ" | egrep "$REGEX" | gzip -c > "$NAME $SID Ownership.mct.gz"

		# 3.
		gunzip -c "$MCT_GZ" | egrep "$REGEX" | gzip -c > "$NAME $SID Potential Access.mct.gz"

		# 4.
		# TODO

		SECIDS=""
	fi
done

