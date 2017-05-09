#!/bin/bash

SED=${BASH_SOURCE%/*}/sed/html_ascii_encoding.sed
cat /dev/stdin | gsed -f "$SED" | gsed -f "$SED" | gsed -f "$SED"

exit 0

PASSES="$1"

if [ -z "$PASSES" ]; then
	PASSES=3
fi

# Running this loop multiple times, should gradually convert all HTML-encoded ASCII back to readable ASCII

for PASS in `seq 1 $PASSES`; do
	# TODO... how do I operate multiple passes against the sed file from STDIN
done

