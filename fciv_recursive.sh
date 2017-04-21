#!/bin/bash

DIR="$1"
DOSHA1="$2"

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit 1)

if [ -e "$DIR" ]; then
	$(dirname "$0")/fciv.sh 
	find "$DIR" -type f -exec $(dirname "$0")/fciv_worker.sh {} $DOSHA1 \; | tee -a "$TMP" > /dev/stderr
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find ($DIR)!" "$0"
fi
