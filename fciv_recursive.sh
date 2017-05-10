#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

DIR="$1"
DOSHA1="$2"
if [ $# -eq 0 ]; then
	USAGE "DIR" "DOSHA1" && exit 0
fi

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit 1)

if [ -e "$DIR" ]; then
	${BASH_SOURCE%/*}/fciv.sh 
	find "$DIR" -type f -exec ${BASH_SOURCE%/*}/fciv_worker.sh {} $DOSHA1 \; >> "$TMP"
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find ($DIR)!" "$0"
fi

rm "$TMP"
