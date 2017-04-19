#!/bin/bash
. $(dirname "$0")/common-include.sh

XML="$1"

KEY="1.75"

if [ -e "$XML" ]; then
	$(dirname "$0")/fciv.sh
	grep "^<entry>" "$XML" | grep "<md5>" | $SEDCMD -r 's/^.+<name>(.+)<\/name>.+<md5>(.+)<\/md5>.+$/\2 0000000000000000000000000000000000000000 .\\\\\1/; s/\//\\/g' | sort --key=$KEY
else
	ERROR "Unable to find Ditto XML file ($XML)!" "$0"
fi
