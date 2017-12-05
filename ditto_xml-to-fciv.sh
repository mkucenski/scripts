#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

XML="$1"
if [ $# -eq 0 ]; then
	USAGE "XML" && exit 1
fi

KEY="1.75"
TMP=$(MKTEMP "$0" || exit 1)

if [ -e "$XML" ]; then
	${BASH_SOURCE%/*}/fciv.sh
	grep "^<entry>" "$XML" | grep "<md5>" | $SEDCMD -r 's/^.+<name>(.+)<\/name>.+<md5>(.+)<\/md5>.+$/\2 0000000000000000000000000000000000000000 \1/; s/\//\\/g;' >> "$TMP"
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find Ditto XML file ($XML)!" "$0" && exit 1
fi

rm "$TMP"

