#!/bin/bash

DIR="$1"
KEY="1.75"

if [ -e "$DIR" ]; then
	$(dirname "$0")/fciv.sh
	find "$DIR" -type f -exec $(dirname "$0")/fciv_worker.sh {} \; | sort --key=$KEY
else
	echo "Error! Unable to find <$DIR>!" > /dev/stderr
fi
