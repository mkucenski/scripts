#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

MESSAGE="$1"
TITLE="$2"
SUBTITLE="$3"
if [ $# -eq 0 ]; then
	USAGE "MESSAGE" "TITLE" "SUBTITLE" && exit 1
fi

osascript ${BASH_SOURCE%/*}/notification.scpt "$MESSAGE" "$TITLE" "$SUBTITLE"

