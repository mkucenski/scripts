#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

XML="$1"
if [ $# -eq 0 ]; then
	USAGE "XML" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

KEY="1.75"
TMP=$(MKTEMP "$0" || exit $COMMON_ERROR)

if [ -e "$XML" ]; then
	${BASH_SOURCE%/*}/fciv.sh
	grep "^<entry>" "$XML" | grep "<md5>" | $SEDCMD -r 's/^.+<name>(.+)<\/name>.+<md5>(.+)<\/md5>.+$/\2 0000000000000000000000000000000000000000 \1/; s/\//\\/g;' >> "$TMP"
	sort --key=$KEY "$TMP"
else
	ERROR "Unable to find Ditto XML file ($XML)!" "$0"
	RV=$COMMON_ERROR
fi

rm "$TMP"

exit $RV

