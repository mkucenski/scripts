#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE="$1"
DEST="$2"
if [ $# -ne 2 ]; then
	USAGE "FILE" "DEST" && exit $COMMON_ERROR
fi

# [file].xlsx:$office$*2007*20*128*16*d13e91007439a2fbe62b96c790d4e243*8b2ee1b9ea360e13d75dec51d9c5fe44*6cb9a97be306019f1f1d2bb7bfa987f2122e6d48

RV=$COMMON_SUCCESS

JTR="$HOME/Development/GitHub/magnumripper/JohnTheRipper/run/office2john.py"
RESULT="$("$JTR" "$FILE")"
HASH="$(echo "$RESULT" | grep '\$office\$' | gsed -r 's/.*(\$office\$.*)/\1/')"
if [ -n "$HASH" ]; then
	echo "$HASH" | tee "$DEST/$(STRIP_EXTENSION "$(basename "$FILE")").hash"
else
	echo "$RESULT"
fi

exit $RV

