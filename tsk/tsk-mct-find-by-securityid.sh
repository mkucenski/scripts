#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1

MCT_GZ=$1; shift
if [ $# -eq 0 ]; then
	USAGE "MCT.GZ" "SECIDs..." && exit 1
fi

FIRST=""
REGEX="^[^|]*\|[^|]+\|[^|]+\|[^|]*\|("
for SECID in $@; do
	if [ -z "$FIRST" ]; then
		REGEX+="$SECID"
		FIRST="NO"
	else
		REGEX+="|$SECID"
	fi
done
REGEX+=")\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$"

gunzip -c "$MCT_GZ" | egrep "$REGEX"

