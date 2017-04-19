#!/bin/bash
. $(dirname "$0")/common-include.sh

XML="$1"

KEY="1.75"
TMP=$(mktemp -t $(basename "$0") || exit 1)

if [ -e "$XML" ]; then
	$(dirname "$0")/fciv.sh
	grep "^<entry>" "$XML" | grep "<md5>" | $SEDCMD -r 's/^.+<name>(.+)<\/name>.+<md5>(.+)<\/md5>.+$/\2 0000000000000000000000000000000000000000 .\\\\\1/; s/\//\\/g' | tee -a "$TMP" > /dev/stderr
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find Ditto XML file ($XML)!" "$0"
fi
