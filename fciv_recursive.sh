#!/bin/bash

DIR="$1"
DOSHA1="$2"

KEY="1.75"

if [ -e "$DIR" ]; then
	$(dirname "$0")/fciv.sh 
	TMP=$(mktemp -t $(basename "$0") || exit 1)
	find "$DIR" -type f -exec $(dirname "$0")/fciv_worker.sh {} $DOSHA1 \; > "$TMP"
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find ($DIR)!" "$0"
fi
